defmodule Core do
  @moduledoc """
  Documentation for Core module.
  """
  import Unification, only: [unify: 3]
  require Logger

  #########
  # Types #
  #########

  # delta is a map that relates Logic vars with Elixir terms
  # TODO add delta type

  ##########
  # Guards #
  ##########

  ##########
  # Macros #
  ##########

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro defcore(pred_name, do: do_block) do
    tr_def(pred_name, do_block)
  end

  #############
  # Functions #
  #############

  def tr_def({:defcore, _metadata, [predicate_name_node, [do: do_block]]}) do
    tr_def(predicate_name_node, do_block)
  end

  def tr_def(predicate_name_node, do_block) do
    {predicate_name, _metadata, predicate_args} = predicate_name_node

    goals =
      case do_block do
        {:__block__, _metadata, do_stmts} -> do_stmts
        _ -> [do_block]
      end

    logic_vars =
      Enum.map(predicate_args, fn {:__aliases__, _metadata, [logic_var]} -> logic_var end)

    {t_list, x_list} =
      case predicate_args do
        [] ->
          {[], []}

        _ ->
          {
            Enum.map(1..length(predicate_args), fn t ->
              String.to_atom("t#{t}") |> Macro.unique_var(__MODULE__)
            end),
            Enum.map(1..length(predicate_args), fn x ->
              String.to_atom("x#{x}") |> Macro.unique_var(__MODULE__)
            end)
          }
      end

    vars_goals = goals |> vars() |> Enum.filter(fn var -> not Enum.member?(logic_vars, var) end)

    y_list =
      case vars_goals do
        [] ->
          []

        _ ->
          1..length(vars_goals)
          |> Enum.map(fn y -> String.to_atom("y#{y}") |> Macro.unique_var(__MODULE__) end)
      end

    delta_keys = List.flatten([logic_vars, vars_goals])
    delta_values = List.flatten([x_list, y_list])
    delta = Enum.zip(delta_keys, delta_values) |> Enum.into(%{})

    quote do
      def unquote({predicate_name, [], t_list}) do
        unquote(
          {:__block__, [],
           x_list |> Enum.map(fn x -> quote do: unquote(x) = VarBuilder.gen_var() end)}
        )

        unquote(
          {:__block__, [],
           y_list |> Enum.map(fn y -> quote do: unquote(y) = VarBuilder.gen_var() end)}
        )

        fn th1 ->
          th2 = Map.merge(th1, Map.new(unquote(Enum.zip(x_list, t_list))))

          unquote(tr_goals(delta, goals)).(th2)
          |> Stream.map(&Map.drop(&1, unquote(List.flatten([x_list, y_list]))))
        end
      end
    end
  end

  ###########
  #  Goals  #
  ###########

  def tr_goals(_delta, []) do
    quote do
      fn th -> [th] end
    end
  end

  def tr_goals(delta, [goal | goals]) do
    quote do
      fn th1 ->
        unquote(tr_goal(delta, goal)).(th1)
        |> Stream.flat_map(fn th2 -> unquote(tr_goals(delta, goals)).(th2) end)
      end
    end
  end

  def tr_goal(delta, {:=, _metadata, [t1, t2]}) do
    th = Macro.unique_var(:th, __MODULE__)
    term1 = tr_term(delta, th, t1)
    term2 = tr_term(delta, th, t2)

    quote do
      fn unquote(th) ->
        unify_gen(unquote(th), unquote(term1), unquote(term2))
      end
    end
  end

  def tr_goal(delta, {:choice, _metadata, [choice_block]}) do
    th = Macro.unique_var(:th, __MODULE__)

    quote do
      fn unquote(th) ->
        unquote(
          choice_block
          |> Enum.map(fn
            {_choice_op, {:__block__, _metadata, goal}} -> tr_goals(delta, goal)
            {_choice_op, goal} -> tr_goals(delta, [goal])
          end)
        )
        |> Stream.flat_map(fn f -> f.(unquote(th)) end)
      end
    end
  end

  def tr_goal(delta, {:@, _metadata, [at_arguments]}) do
    th = Macro.unique_var(:th, __MODULE__)

    quote do
      fn unquote(th) ->
        check_b(unquote(th), groundify(unquote(th), unquote(tr_term(delta, th, at_arguments))))
      end
    end
  end

  def tr_goal(delta, {predicate_name, _metadata, args}) do
    th = Macro.unique_var(:th, __MODULE__)
    tr_term_args = Enum.map(args, fn arg -> tr_term(delta, th, arg) end)

    quote do
      fn unquote(th) ->
        unquote({predicate_name, [], tr_term_args}).(unquote(th))
      end
    end
  end

  ###########
  #  Terms  #
  ###########

  def tr_term(delta, _x, {:__aliases__, _metadata, [logic_var]}), do: {:var, delta[logic_var]}

  # This matches tuples of size != 2. Issue the command "h Kernel.SpecialForms.{}"
  def tr_term(delta, x, {:{}, _metadata, elements}) do
    list = elements |> Enum.map(fn tx -> tr_term(delta, x, tx) end)
    Macro.escape(TermBuilder.build_tuple(list))
  end

  def tr_term(delta, x, {function_name, _metadata, arguments}) do
    x_args =
      case arguments do
        [] ->
          %{}

        _ ->
          1..length(arguments)
          |> Enum.map(fn x ->
            String.to_atom("x#{x}") |> Macro.unique_var(__MODULE__)
          end)
          |> Enum.zip(arguments)
          |> Enum.into(%{})
      end

    xs = x_args |> Map.keys

    quote do
      unquote(
        {:__block__, [],
         x_args
         |> Enum.map(fn {xx, tx} ->
           quote do: unquote(xx) = groundify(unquote(x), unquote(tr_term(delta, x, tx)))
         end)}
      )

      unquote({:ground, {function_name, [], xs}})
    end
  end

  def tr_term(_delta, _x, []), do: {:ground, []}

  def tr_term(delta, x, [{:|, _metadata, [t, sublist]}]) do
    head = tr_term(delta, x, t)
    tail = tr_term(delta, x, sublist)
    quote do: TermBuilder.build_list(unquote(head), unquote(tail))
  end

  def tr_term(delta, x, [h | t]) do
    head = tr_term(delta, x, h)
    tail = tr_term(delta, x, t)
    quote do: TermBuilder.build_list(unquote(head), unquote(tail))
  end

  # This matches tuples with size == 2
  def tr_term(delta, x, tuple) when is_tuple(tuple) do
    list = tuple |> Tuple.to_list |> Enum.map(fn tx -> tr_term(delta, x, tx) end)
    quote do: unquote(TermBuilder.build_tuple(list))
  end

  def tr_term(_delta, _x, lit), do: {:ground, lit}

  ###############################
  #  Public auxiliar functions  #
  ###############################

  def unify_gen(theta, t1, t2) do
    case unify(t1, t2, theta) do
      :unmatch -> []
      theta2 -> [theta2]
    end
  end

  def check_b(_, false), do: []
  def check_b(_, nil), do: []
  def check_b(theta, _), do: [theta]

  def groundify(_theta, {:ground, t}), do: t

  def groundify(theta, {:var, x}) when is_map_key(theta, x) do
    case theta[x] do
      {:ground, t} -> t
      _ -> throw("#{inspect(theta[x])} is not bound to a fully instatiated term")
    end
  end

  def groundify(_theta, {:var, x}) do
    throw("#{x} is not instantiated")
  end

  def groundify(theta, t) when is_tuple(t) do
    t
    |> Tuple.to_list
    |> Enum.map(&groundify(theta, &1))
    |> List.to_tuple
  end

  def groundify(theta, [t1 | t2]) do
    [groundify(theta, t1) | groundify(theta, t2)]
  end

  #####################
  # Private Functions #
  #####################

  defp vars(goals) when is_list(goals) do
    goals
    |> Enum.map(fn goal -> vars_in_goal(goal) end)
    |> List.flatten
    |> Enum.filter(fn arg -> is_logic_variable?(arg) end)
    |> Enum.map(fn {:__aliases__, _metadata, [logic_variable]} -> logic_variable end)
    |> Enum.uniq
  end

  defp vars_in_goal({:=, _metadata, [t1, t2]}) do
    terms1 = flat_terms(t1)
    terms2 = flat_terms(t2)
    [terms1, terms2]
  end

  defp vars_in_goal({:choice, _metadata, [choice_block]}), do: choice_vars(choice_block)

  defp vars_in_goal({:__block__, _metadata, block}) do
    block |> Enum.map(fn goal -> vars_in_goal(goal) end)
  end

  defp vars_in_goal({:@, _metadata, at_arguments}), do: flat_at_terms(at_arguments)

  defp vars_in_goal({_predicate_name, _metadata, arguments}), do: flat_terms(arguments)

  defp vars_in_goal(_), do: []

  defp flat_terms({:__aliases__, _metadata, [logic_variable]} = term)
       when is_atom(logic_variable),
       do: term

  defp flat_terms(terms) when is_tuple(terms), do: Tuple.to_list(terms)
  defp flat_terms([{:|, _metadata, terms}]), do: flat_pipe_terms(terms)
  defp flat_terms(terms), do: terms

  defp flat_at_terms([{:___aliases__, _metadata, [logic_variable]} = term])
       when is_atom(logic_variable),
       do: term

  defp flat_at_terms([{_operator, _metadata, op_arguments}]), do: op_arguments
  defp flat_at_terms(_), do: []

  defp flat_pipe_terms([t1, t2]) do
    ts =
      case t2 do
        [] -> []
        [{:|, _metadata, terms}] -> flat_pipe_terms(terms)
        _ -> t2
      end

    [t1, ts]
  end

  defp choice_vars([{:do, do_block} | rest]) do
    do_block_vars = vars_in_goal(do_block)

    result =
      case rest do
        [] ->
          [do_block_vars]

        _ ->
          rest_block_vars =
            rest
            |> Enum.map(fn {:else, extra_else_block} ->
              vars_in_goal(extra_else_block)
            end)

          [do_block_vars, rest_block_vars]
      end

    result
  end

  defp is_logic_variable?({:__aliases__, _metadata, [logic_variable]})
       when is_atom(logic_variable),
       do: true

  defp is_logic_variable?(_), do: false
end
