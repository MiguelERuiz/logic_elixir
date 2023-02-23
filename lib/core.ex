defmodule Core do
  @moduledoc """
  Documentation for Core module.
  """
  import Unification, only: [unify: 3]
  require Logger

  # TODO investigate the way of making VarBuilder.start_link automatically

  #########
  # Types #
  #########

  # delta is a map that relates Logic vars with Elixir terms
  # TODO add delta type

  #? Should must be add types for AST nodes??

  ##########
  # Guards #
  ##########

  defguard is_literal(t) when is_binary(t) or is_integer(t) or is_list(t) or is_tuple(t)

  #############
  # Functions #
  #############

  def tr_def({:defcore, _metadata, [predicate_name_node, [do: do_block]]}) do
    {predicate_name, [], predicate_args} = predicate_name_node

    goals = case do_block do
      {:__block__, [], do_stmts} -> do_stmts
      _ -> [do_block]
    end

    logic_vars = Enum.map(predicate_args, fn {:__aliases__, _metadata, [logic_var]} -> logic_var end)

    {t_list, x_list, x_list_values} = case predicate_args do
      [] -> {[], [], []}
      _ ->
        {
          Enum.map(1..length(predicate_args), fn t -> String.to_atom("t#{t}") |> Macro.unique_var(__MODULE__) end),
          Enum.map(1..length(predicate_args), fn x -> String.to_atom("x#{x}") |> Macro.unique_var(__MODULE__) end),
          Enum.map(1..length(predicate_args), fn _ -> VarBuilder.gen_var end)
        }
    end
    x_list_map = Enum.zip(x_list, x_list_values) |> Enum.into(%{})

    vars_goals = goals |> vars() |> Enum.filter(fn arg -> not :lists.member(arg, predicate_args) end)

    {y_list, y_list_values} = case vars_goals do
      [] -> {[], []}
      _ ->
        {
          1..length(vars_goals) |> Enum.map(fn y -> String.to_atom("y#{y}") |> Macro.unique_var(__MODULE__) end),
          1..length(vars_goals) |> Enum.map(fn _ -> VarBuilder.gen_var end)
        }
    end
    y_list_map = Enum.zip(y_list, y_list_values) |> Enum.into(%{})

    delta = Enum.zip(logic_vars, x_list) |> Enum.into(%{})

    quote do
      def unquote({predicate_name, [], t_list}) do
        unquote({:__block__, [], x_list_map |> Enum.map(fn {k, v} -> {:=, [], [k, v]} end)})
        unquote({:__block__, [], y_list_map |> Enum.map(fn {k, v} -> {:=, [], [k, v]} end)})
        fn th1 ->
          th2 = Map.merge(th1, Map.new(unquote(Enum.zip(x_list, t_list))))
          (unquote(tr_goals(delta, goals))).(th2)
            |> Stream.map(&Map.drop(&1, unquote(List.flatten([x_list, y_list]))))
        end
      end
    end
  end

  def tr_goals(_delta, []) do
    quote do
      fn th -> [th] end
    end
  end

  def tr_goals(delta, [goal|goals]) do
    quote do
      fn th1 ->
        (unquote(tr_goal(delta, goal))).(th1)
          |> Stream.flat_map(fn th2 -> (unquote(tr_goals(delta, goals))).(th2) end)
      end
    end
  end

  def tr_goal(delta, {predicate_name, [], args}) do
    fn th ->
      tr_term_args = Enum.map(args, fn arg -> tr_term(delta, th, arg) end)
      quote do
        unquote({predicate_name, [], [tr_term_args]}).(th)
      end
    end
  end

  def tr_goal(delta, {:=, [], [t1, t2]}) do
    th = Macro.unique_var(:th, __MODULE__)
    term1 = tr_term(delta, th, t1)
    term2 = tr_term(delta, th, t2)
    quote do
      fn unquote(th) ->
        unify_gen(th, unquote(term1), unquote(term2))
      end
    end
  end

  # TODO complete
  def tr_goal(_delta, {:choice, [], [_do_block]}) do
    fn th ->
      [] |> Stream.flat_map(fn f -> f.(th) end)
    end
  end

  # TODO improve
  def tr_term(_delta, _x, lit) when is_integer(lit), do: {:ground, lit}
  def tr_term(delta, _x, {:__aliases__, _metadata, [logic_var]}) do
    {:var, delta[logic_var]}
  end

  def p1 do
    quote do
      defcore pred1(X) do
        X = 5
      end
    end
  end

  def p2 do
    quote do
      defcore pred2(X, Y) do
        X = 5
        Y = 6
      end
    end
  end

  def p3 do
    quote do
      defcore pred3(X, Y) do
        X = Z
        Y = Z
      end
    end
  end

  def p4 do
    quote do
      defcore pred4(X) do
        Z = X
      end
    end
  end

  def p5 do
    quote do
      defcore pred5() do
        Z = 1
      end
    end
  end

  #####################
  # Private Functions #
  #####################

  defp unify_gen(theta, t1, t2) do
    case unify(t1, t2, theta) do
      :unmatch -> []
      theta2 -> theta2
    end
  end

  defp vars(goals) do
    goals
    |> Enum.map(fn {_operator, _metadata, arguments} -> arguments end)
    |> :lists.flatten()
    |> Enum.filter(fn arg -> is_logic_variable?(arg) end)
    |> Enum.uniq()
  end

  defp is_logic_variable?({:__aliases__, _metadata, [logic_variable]}) when is_atom(logic_variable), do: true
  defp is_logic_variable?(_), do: false
end
