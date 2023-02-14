defmodule Core do
  @moduledoc """
  Documentation for Core module.
  """
  import Unification, only: [unify: 3]
  # import Core.Choice
  require Logger

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

  def tr_def({:defcore, _metadata, [predicate_name_node, [do: {:__block__, [], goals}]]}) do
    {predicate_name, [], predicate_args} = predicate_name_node
    logic_vars = Enum.map(predicate_args, fn {:__aliases__, _metadata, [logic_var]} -> logic_var end)
    t_list = Enum.map(predicate_args, fn _ -> VarBuilder.gen_var end)
    x_list = Enum.map(predicate_args, fn _ -> VarBuilder.gen_var end)
    delta = Enum.zip(logic_vars, x_list) |> Enum.into(%{})

    quote do
      def unquote({predicate_name, [], t_list}) do
        # TODO the number of x-variables must be the number of arguments
        unquote({:=, [], [{:x, [], Elixir}, VarBuilder.gen_var]})
        # TODO the number of y-variables must be the difference between vars(G) and arguments
        fn th1 ->
          th2 = Map.merge(th1, Map.new(unquote(Enum.zip(x_list, t_list))))
          (unquote(tr_goals(delta, goals))).(th2)
            # TODO complete with y_list when got it
            |> Stream.map(&Map.drop(&1, List.flatten([x_list])))
        end
      end
    end
  end

  def tr_goals(_delta, []), do: fn th -> [th] end
  def tr_goals(delta, [goal|goals]) do
    Logger.info("[tr_goal] outside lambda function")
    fn th1 ->
      Logger.info("[tr_goal] inside lambda function")
      (tr_goal(delta, goal)).(th1)
        |> Stream.flat_map(fn th2 -> (tr_goals(delta, goals)).(th2) end)
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

  def tr_goal(delta, {:=, [], [t1, t2]} = goal) do
    Logger.info("tr_goal")
    Logger.info(goal |> Macro.to_string)
    fn th ->
      unify_gen(th, tr_term(delta, th, t1), tr_term(delta, th, t2))
    end
  end

  # TODO complete
  def tr_goal(_delta, {:choice, [], [_do_block]}) do
    fn th ->
      [] |> Stream.flat_map(fn f -> f.(th) end)
    end
  end

  def tr_goal(_delta, goal) do
    Logger.error("ERROR tr_goal")
    Logger.error(goal |> Macro.to_string)
  end

  # TODO improve
  def tr_term(_delta, _x, lit) when is_literal(lit), do: {:ground, lit}
  def tr_term(delta, _x, logic_var) do
    {:var, delta[logic_var]}
  end

  def foo do
    quote do
      defcore pred(X, Y) do
        X = 5
        Y = 2
      end
    end
  end

  def bar do
    quote do
      def pred(x, y) do
        a = 1
        b = 2
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
end
