defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

  #########
  # Types #
  #########

  # TODO add map() as part of t() definition
  @type t :: {:ground, term()} | tuple() | [t()] | atom()

  # sigma could be either a map to keep the substitutions or
  # :unmatch atom to represent ⊥ symbol
  @type sigma :: %{atom() => t()} | :unmatch

  ##########
  # Guards #
  ##########

  defguard is_tuple_term(t) when is_tuple(t) and (elem(t, 0) != :ground or is_tuple(elem(t, 1)))

  #############
  # Functions #
  #############

  @spec unify(t(), t(), sigma()) :: sigma()
  # [ExTerm] rule
  def unify({:ground, t}, {:ground, t}, sigma), do: sigma

  # [ExTermFail] Rule
  def unify({:ground, _}, {:ground, _}, _sigma), do: :unmatch

  # [Var1] [Var2] Rules
  def unify(t1, t2, sigma) when is_atom(t1) do
    case is_logic_var?(t1) do
      true -> unify_variable(t1, t2, sigma)
      false -> :unmatch
    end
  end

  # [Id] Rule
  def unify(t, t, sigma) when is_atom(t) do
    case is_logic_var?(t) do
      true -> sigma
      false -> :unmatch
    end
  end

  # [Orient] Rule
  def unify(t1, t2, sigma) when is_atom(t2) do
    case is_logic_var?(t2) do
      true -> unify(t2, t1, sigma)
      false -> :unmatch
    end
  end

  # [Tuple] Rule
  # TODO not a valid implementation
  def unify(t1, t2, sigma) when is_tuple_term(t1) and is_tuple_term(t2) do
    c1 = components_of(t1)
    c2 = components_of(t2)
  end

  # [List] Rule
  # TODO check if its correct
  def unify([h1, t1], [h2, t2], sigma) do
    case unify(h1, h2, sigma) do
      :unmatch -> :unmatch
      sigma1 -> unify(t1, t2, sigma1)
    end
  end

  # [Clash] Rule
  def unify(_t1, _t2, _sigma), do: :unmatch

  # TODO faltan:
  # Occurs-check

  #####################
  # Private Functions #
  #####################

  # TODO Not only unify/3 but make the possible substitutions
  @spec unify_variable(t(), t(), sigma()) :: sigma()
  defp unify_variable(t1, t2, sigma) when is_atom(t1) do
    case Map.fetch(sigma, t1) do
      {:ok, subt} -> unify(subt, t2, sigma)
      :error -> Map.put(sigma, t1, t2)
    end
  end

  @spec components_of(tuple()) :: [term()]
  defp components_of({:ground, t}), do: Tuple.to_list(t)
  defp components_of(t), do: Tuple.to_list(t)

  @spec is_logic_var?(atom()) :: boolean()
  defp is_logic_var?(t) do
    case :erlang.atom_to_binary(t) do
      <<"Elixir.", _::binary>> -> true
      _ -> false
    end
  end
end
