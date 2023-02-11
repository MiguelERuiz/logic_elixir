defmodule Core do
  @moduledoc """
  Documentation for Core module.
  """
  import Unification, only: [unify: 3]
  # import Core.Choice
  require Logger

  def tr_def({:defcore, _metadata, [predicate_name_node, _do_block_node]}) do
    {predicate_name, [], predicate_args} = predicate_name_node
    arg_list = Enum.map(predicate_args, fn _ -> VarBuilder.gen_var end)
    quote do
      # TODO investigate how this the arguments dynamic
      def unquote(predicate_name)(unquote(Enum.at(arg_list, 0)), unquote(Enum.at(arg_list, 1))) do
        # TODO the number of x-variables must be the number of arguments
        # TODO the number of y-variables must be the difference between vars(G) and arguments
          fn th1 ->
            [th1]
          end
      end
    end
  end

  def foo do
    quote do
      defcore pred(X, Y) do
        X = 5
        Y = 2
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
