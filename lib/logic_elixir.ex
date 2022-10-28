defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

  #########
  # Types #
  #########

  # TODO add map() as part of t() definition
  @type t :: {:ground, term()} | {t()} | [t()] | atom()

  # sigma could be either a map to keep the substitutions or
  # :unmatch atom to represent ⊥ symbol
  @type sigma :: %{t() => t()} | :unmatch

  #############
  # Functions #
  #############

defguard is_tuple_term(t) when is_tuple(t) and (elem(t, 0) != :ground or is_tuple(elem(t, 1)))

def components_of({:ground, t}) do
  Tuple.to_list(t)
end
def components_of(t) do
  Tuple.to_list(t)
end

  @spec unify(t(), t(), sigma()) :: sigma()
  # [ExTerm] rule
  def unify({:ground, t}, {:ground, t}, sigma), do: sigma

  # [ExTermFail] Rule
  def unify({:ground, _}, {:ground, _}, _sigma), do: :unmatch

  # [Var1] [Var2] Rules
  def unify(t1, t2, sigma) when is_atom(t1), do: unify_variable(t1, t2, sigma)

  # [Id] Rule
  def unify(t, t, sigma) when is_atom(t), do: sigma

  # [Tuple] Rule
  # TODO not a valid implementation
  def unify(t1, t2, sigma) when is_tuple_term(t1) and is_tuple_term(t2) do
    c1 = components_of(t1)
    c2 = components_of(t2)
  end

  # [List] Rule
  # TODO not a valid implementation
  def unify(t, t, sigma) when is_list(t), do: sigma

  # [Clash] Rule
  def unify(_t1, _t2, _sigma), do: :unmatch

  # TODO faltan:
  # Occurs-check
  # Orient

  #####################
  # Private Functions #
  #####################

  @spec unify_variable(t(), t(), sigma()) :: sigma()
  defp unify_variable(t1, t2, sigma) when is_atom(t1) do
    case Map.fetch(sigma, t1) do
      {:ok, subt} -> unify(subt, t2, sigma)
      :error -> Map.put(sigma, t1, t2)
    end
  end

  defp unify_variable(t1, t2, sigma) when is_atom(t2) do
    case Map.fetch(sigma, t2) do
      {:ok, subt} -> unify(t1, subt, sigma)
      :error -> Map.put(sigma, t2, t1)
    end
  end
end
