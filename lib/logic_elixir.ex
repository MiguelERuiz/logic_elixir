defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

  require Logger

  #########
  # Types #
  #########

  # TODO add map() as part of t() definition
  @type t :: tuple_term() | [t()] | atom()
  @type tuple_term :: {:ground, term()} | tuple()

  # sigma could be either a map to keep the substitutions or
  # :unmatch atom to represent ⊥ symbol
  @type sigma :: %{atom() => t()} | :unmatch

  @type vars_set :: MapSet.t(t())

  ##########
  # Guards #
  ##########

  defguardp is_tuple_term(t) when is_tuple(t) and (elem(t, 0) != :ground or is_tuple(elem(t, 1)))

  #############
  # Functions #
  #############

  @spec unify(t(), t(), sigma()) :: sigma()
  # [ExTerm] rule
  def unify({:ground, t}, {:ground, t}, sigma), do: sigma

  # [ExTermFail] Rule
  def unify({:ground, _}, {:ground, _}, _sigma), do: :unmatch

  # [Id] Rule
  def unify(t, t, sigma) when is_atom(t) do
    case is_logic_var?(t) do
      true -> sigma
      false -> :unmatch
    end
  end

  # [Var1] [Var2] Rules
  def unify(t1, t2, sigma) when is_atom(t1) do
    Logger.info("[Var] t1: #{inspect(t1)} t2: #{inspect(t2)} sigma: #{inspect(sigma)}")
    case is_logic_var?(t1) do
      true -> unify_variable(t1, t2, sigma)
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
  def unify(t1, t2, sigma) when is_tuple_term(t1) and is_tuple_term(t2) do
    c1 = components_of(t1)
    c2 = components_of(t2)
    unify(c1, c2, sigma)
  end

  # [List] Rule
  def unify([], [], sigma), do: sigma

  def unify([h1 | t1], [h2 | t2], sigma) do
    case unify(h1, h2, sigma) do
      :unmatch -> :unmatch
      sigma1 -> unify(t1, t2, sigma1)
    end
  end

  # [Clash] Rule
  def unify(_t1, _t2, _sigma), do: :unmatch

  #####################
  # Private Functions #
  #####################

  @spec vars(sigma(), t()) :: vars_set()
  def vars(_sigma, {:ground, _}), do: MapSet.new()
  def vars(sigma, t) when is_tuple(t) do
    c = components_of(t)
    Logger.info("[vars] c: #{inspect(c)}")
    vars(sigma, c)
  end
  def vars(sigma, t) when is_list(t) do
    List.foldl(t, MapSet.new(), fn tx, acc -> MapSet.union(vars(sigma, tx), acc) end)
  end
  def vars(sigma, t) do
    case Map.fetch(sigma, t) do
      {:ok, subt} -> vars(sigma, subt)
      :error -> MapSet.new([t])
    end
  end

  # TODO Not only unify/3 but make the possible substitutions (Occurs-check)
  @spec unify_variable(t(), t(), sigma()) :: sigma()
  defp unify_variable(t1, {:ground, t2}, sigma) do
    Logger.info("[Unify Exterm] t1: #{inspect(t1)} t2: #{inspect({:ground, t2})} sigma: #{inspect(sigma)}")
    case Map.fetch(sigma, t1) do
      {:ok, subt} ->
        Logger.info("[Unify Exterm] Map.fetch(sigma, t1) -> #{inspect(subt)}")
        sigma
      :error -> Map.put(sigma, t1, {:ground, t2})
    end
  end

  defp unify_variable(t1, t2, sigma) do
    Logger.info("[Unify Variable] t1: #{inspect(t1)} t2: #{inspect(t2)} sigma: #{inspect(sigma)}")
    Logger.info("vars of t2: #{inspect(vars(sigma, t2))}")
    case Map.fetch(sigma, t1) do
      {:ok, subt} ->
        Logger.info("[Unify Variable] Map.fetch(sigma, t1) -> #{inspect(subt)}")
        sigma
      :error -> Map.put(sigma, t1, t2)
    end
  end

  @spec components_of(tuple()) :: [term()]
  defp components_of({:ground, t}), do: Tuple.to_list(t)
  defp components_of(t) when is_tuple(t), do: Tuple.to_list(t)

  @spec is_logic_var?(atom()) :: boolean()
  defp is_logic_var?(t) do
    case :erlang.atom_to_binary(t) do
      <<"Elixir.", _::binary>> -> true
      _ -> false
    end
  end
end
