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

  #############
  # Functions #
  #############

  # TODO convert tr_def/1 into tr_def/2
  # Example
  # defmacro defcore(pred_name, [do: do_block]) do
  #   tr_def(pred_name, do_block)
  # end
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
    # x_map = Enum.zip(logic_vars, x_list) |> Enum.into(%{})
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
    # y_map = Enum.zip(vars_goals, y_list) |> Enum.into(%{})
    #! FIX delta since it must receive also y_list
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

  def tr_goal(delta, {:choice, [], [choice_block]}) do
    # Logger.info("CHOICE BLOCK: #{inspect(choice_block)}")
    th = Macro.unique_var(:th, __MODULE__)
    goals = choice_goals(delta, choice_block)
    quote do
      fn unquote(th) ->
        unquote(goals) |> Stream.flat_map(fn f -> f.(th) end)
      end
    end
  end

  # TODO test it
  def tr_goal(delta, {predicate_name, [], args}) do
    fn th ->
      tr_term_args = Enum.map(args, fn arg -> tr_term(delta, th, arg) end)
      quote do
        unquote({predicate_name, [], [tr_term_args]}).(th)
      end
    end
  end


  # TODO improve
  def tr_term(_delta, _x, lit) when is_integer(lit) or is_binary(lit) or is_boolean(lit), do: {:ground, lit}
  def tr_term(delta, _x, {:__aliases__, _metadata, [logic_var]}) do
    {:var, delta[logic_var]}
  end

  #####################
  ##### EXAMPLES ######
  #####################

  # Execution:
  # iex -S mix
  # VarBuilder.start_link
  # Core.p9 |> Core.tr_def |> Macro.to_string |> IO.puts

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

  def p6 do
    quote do
      defcore pred6(X) do
        choice do
          X = 1
        else
          X = 2
        end
      end
    end
  end

  def p7 do
    quote do
      defcore pred7(X) do
        choice do
          X = 1
        else
          X = 2
        else
          X = 3
        end
      end
    end
  end

  def p8 do
    quote do
      defcore pred8(X, Y) do
        choice do
          X = 1
        else
          X = 2
        end
        Y = 3
      end
    end
  end

  def p9 do
    quote do
      defcore pred9(X, Y) do
        choice do
          X = 1
          Y = 3
        else
          X = 2
          Y = 4
        end
      end
    end
  end

  #####################
  # Private Functions #
  #####################

  def unify_gen(theta, t1, t2) do
    case unify(t1, t2, theta) do
      :unmatch -> []
      theta2 -> [theta2]
    end
  end

  defp vars(goals) do
    goals
    |> Enum.map(fn {_operator, _metadata, arguments} -> arguments end)
    |> :lists.flatten()
    |> Enum.filter(fn arg -> is_logic_variable?(arg) end)
    |> Enum.uniq()
  end

  defp choice_goals(delta, [{:do, do_block}, {:else, else_block} | rest]) do
    # Logger.info("DO BLOCK: #{inspect(do_block)}")
    # Logger.info("ELSE BLOCK: #{inspect(else_block)}")
    # Logger.info("REST BLOCK: #{inspect(rest)}")
    do_block_list = case do_block do
      {:__block__, [], do_list} -> do_list
      _ -> [do_block]
    end
    else_block_list = case else_block do
      {:__block__, [], else_list} -> else_list
      _ -> [else_block]
    end
    rest_list = case rest do
      [] -> []
      _ ->
        rest
          |> Enum.map(
              fn {:else, extra_else_block} ->
                case extra_else_block do
                  {:__block__, [], else_list} -> else_list
                  _ -> [extra_else_block]
                end
              end)
          |> :lists.flatten
    end
    [do_block_list, else_block_list, rest_list]
      |> Enum.map(fn goals -> tr_goals(delta, goals) end)
  end

  defp is_logic_variable?({:__aliases__, _metadata, [logic_variable]}) when is_atom(logic_variable), do: true
  defp is_logic_variable?(_), do: false
end
