defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

  require Logger

  #########
  # Types #
  #########

  # TODO add map() as part of t() definition
  @type t :: logic_var() | tuple_term() | [t()]
  @type logic_var :: {:var, String.t()}
  @type tuple_term :: {:ground, term()} | tuple()

  # sigma could be either a map to keep the substitutions or
  # :unmatch atom to represent ⊥ symbol
  @type sigma :: %{String.t() => t()} | :unmatch

  # vars_set is a MapSet of terms of LogicElixir.t() type
  @type vars_set :: MapSet.t(logic_var())

  ##########
  # Guards #
  ##########

  defguardp is_tuple_term(t) when is_tuple(t) and (elem(t, 0) != :ground or is_tuple(elem(t, 1)))
  defguardp belongs_to(sigma, t) when is_map_key(sigma, t)

  #############
  # Functions #
  #############

  @spec unify(t(), t(), sigma()) :: sigma()
  # [ExTerm] rule
  def unify({:ground, t}, {:ground, t}, sigma), do: sigma

  # [ExTermFail] Rule
  def unify({:ground, _}, {:ground, _}, _sigma), do: :unmatch

  # [Id] Rule
  def unify({:var, x}, {:var, x}, sigma), do: sigma

  # [Var1] Rule
  def unify({:var, x}, t, sigma) when belongs_to(sigma, x) do
    unify(sigma[x], t, sigma)
  end

  # [Var2] and [Occurs-check] Rules
  def unify({:var, x}, t, sigma) when not belongs_to(sigma, x) do
    if x in vars(sigma, t) do
      # [Occurs-check]
      :unmatch
    else
      # [Var2]
      unify_variable(x, t, sigma)
    end
  end

  # [Orient] Rule
  def unify(t1, {:var, _x} = t2, sigma) do
    unify(t2, t1, sigma)
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
  defp vars(_sigma, {:ground, _}), do: MapSet.new()

  defp vars(sigma, {:var, x}) do
    case Map.fetch(sigma, x) do
      {:ok, subt} -> vars(sigma, subt)
      :error -> MapSet.new([x])
    end
  end

  defp vars(sigma, t) when is_tuple(t) do
    c = components_of(t)
    vars(sigma, c)
  end

  defp vars(sigma, t) when is_list(t) do
    Enum.reduce(t, MapSet.new(), fn tx, acc -> MapSet.union(vars(sigma, tx), acc) end)
  end

  @spec unify_variable(String.t(), t(), %{String.t() => t()}) :: %{String.t() => t()}
  defp unify_variable(x, t, sigma) do
    apply_subtitutions(Map.put(sigma, x, t))
  end

  @spec apply_subtitutions(%{String.t() => t()}) :: %{String.t() => t()}
  defp apply_subtitutions(sigma),
    do: :maps.map(fn _, v -> apply_subtitution(sigma, v) end, sigma)

  @spec apply_subtitution(%{String.t() => t()}, t()) :: t()
  defp apply_subtitution(sigma, {:var, x}) when belongs_to(sigma, x), do: sigma[x]
  defp apply_subtitution(_sigma, {:var, x}), do: {:var, x}
  defp apply_subtitution(_sigma, {:ground, t}), do: {:ground, t}

  defp apply_subtitution(sigma, t) when is_tuple_term(t) do
    c = components_of(t)
    c1 = apply_subtitution(sigma, c)

    case c1 do
      {:ground, l} -> {:ground, List.to_tuple(l)}
      _ -> List.to_tuple(c1)
    end
  end

  defp apply_subtitution(sigma, t) when is_list(t) do
    all_grounds(Enum.map(t, &apply_subtitution(sigma, &1)))
  end

  @spec components_of(tuple()) :: [term()]
  defp components_of({:ground, t}), do: Tuple.to_list(t)
  defp components_of(t) when is_tuple(t), do: Tuple.to_list(t)

  @spec all_grounds([t()]) :: {:ground, [term()]} | [t()]
  defp all_grounds(t) do
    case Enum.all?(t, fn tx -> is_ground_term?(tx) end) do
      true -> {:ground, Enum.map(t, fn {:ground, tx} -> tx end)}
      false -> t
    end
  end

  @spec is_ground_term?(t()) :: boolean()
  defp is_ground_term?({:ground, _t}), do: true
  defp is_ground_term?(_), do: false
end
