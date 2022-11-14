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
      Logger.info("[Var2] case")
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
  def unify([], [], sigma) do
    Logger.info("[List] empty lists")
    sigma
  end

  def unify([h1 | t1], [h2 | t2], sigma) do
    Logger.info("[List] non empty lists")
    Logger.info("h1: #{inspect(h1)}  t1: #{inspect(t1)}")
    Logger.info("h2: #{inspect(h2)}  t2: #{inspect(t2)}")
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
    # Logger.info("[vars] c: #{inspect(c)}")
    vars(sigma, c)
  end
  def vars(sigma, t) when is_list(t) do
    List.foldr(t, MapSet.new(), fn tx, acc -> MapSet.union(vars(sigma, tx), acc) end)
  end
  def vars(sigma, t) do
    case Map.fetch(sigma, t) do
      {:ok, subt} -> vars(sigma, subt)
      :error -> MapSet.new([t])
    end
  end

  @spec unify_variable(String.t(), t(), sigma()) :: sigma()
  defp unify_variable(x, {:ground, t2}, sigma) do
    Logger.info("[Unify Exterm] t1: #{inspect(x)} t2: #{inspect({:ground, t2})} sigma: #{inspect(sigma)}")
    case Map.fetch(sigma, x) do
      {:ok, _subt} ->
        # Logger.info("[Unify Exterm] Map.fetch(sigma, t1) -> #{inspect(subt)}")
        sigma
      :error -> apply_subtitutions(Map.put(sigma, x, {:ground, t2}))
    end
  end

  defp unify_variable(x, t, sigma) do
    Logger.info("[Unify Variable] x: #{inspect(x)} t: #{inspect(t)} sigma: #{inspect(sigma)}")
    case Map.fetch(sigma, x) do
      {:ok, _subt} ->
        sigma
      :error ->
        apply_subtitutions(Map.put(sigma, x, t))
    end
  end

  @spec apply_subtitutions(sigma()) :: sigma()
  def apply_subtitutions(sigma), do: :maps.from_list(Enum.map(sigma, fn {k, v} -> {k, apply_subtitution(sigma, v)} end))

  @spec apply_subtitution(sigma(), t()) :: t()
  def apply_subtitution(sigma, {:var, x}) when belongs_to(sigma, x), do: sigma[x]
  def apply_subtitution(_sigma, {:var, x}), do: {:var, x}
  def apply_subtitution(_sigma, {:ground, t}), do: {:ground, t}
  def apply_subtitution(sigma, t) when is_tuple_term(t) do
    c = components_of(t)
    c1 = apply_subtitution(sigma, c)
    List.to_tuple(c1)
  end
  def apply_subtitution(sigma, t) when is_list(t) do
    # Enum.map(t, fn tx -> apply_subtitution(sigma, tx) end)
    List.foldr(t, [], fn tx, acc -> [apply_subtitution(sigma, tx)|acc] end)
  end

  @spec components_of(tuple()) :: [term()]
  defp components_of({:ground, t}), do: Tuple.to_list(t)
  defp components_of(t) when is_tuple(t), do: Tuple.to_list(t)
end
