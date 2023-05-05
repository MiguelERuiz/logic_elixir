defmodule Unification do
  @moduledoc """
    Documentation for Unification module
  """
  require Logger

  #########
  # Types #
  #########

  # TODO add map() as part of t() definition
  @type t :: logic_var() | tuple_term() | [t()]
  @type logic_var :: {:var, String.t()}
  @type tuple_term :: ground_term() | tuple()
  @type ground_term :: {:ground, term()}

  # theta could be either a map to keep the substitutions or
  # :unmatch atom to represent ⊥ symbol
  @type theta :: %{String.t() => t()} | :unmatch

  # vars_set is a MapSet of terms of LogicElixir.t() type
  @type vars_set :: MapSet.t(logic_var())

  ##########
  # Guards #
  ##########

  defguardp is_tuple_term(t) when is_tuple(t) and (elem(t, 0) != :ground or is_tuple(elem(t, 1)))
  defguardp is_list_term(t) when is_list(t) or (is_tuple(t) and (elem(t, 0) == :ground and is_list(elem(t, 1))))
  defguardp belongs_to(theta, t) when is_map_key(theta, t)

  #############
  # Functions #
  #############

  @spec unify(t(), t(), theta()) :: theta()
  # [ExTerm] rule
  def unify({:ground, t}, {:ground, t}, theta), do: theta

  # [ExTermFail] Rule
  def unify({:ground, _}, {:ground, _}, _theta), do: :unmatch

  # [Id] Rule
  def unify({:var, x}, {:var, x}, theta), do: theta

  # [Var1] Rule
  def unify({:var, x}, t, theta) when belongs_to(theta, x) do
    unify(theta[x], t, theta)
  end

  # [Var2] and [Occurs-check] Rules
  def unify({:var, x}, t, theta) when not belongs_to(theta, x) do
    if x in vars(theta, t) do
      # [Occurs-check]
      :unmatch
    else
      # [Var2]
      unify_variable(x, t, theta)
    end
  end

  # [Orient] Rule
  def unify(t1, {:var, _x} = t2, theta) do
    unify(t2, t1, theta)
  end

  # [Tuple] Rule
  def unify(t1, t2, theta) when is_tuple_term(t1) and is_tuple_term(t2) do
    c1 = components_of(t1)
    c2 = components_of(t2)
    unify(c1, c2, theta)
  end

  # [List] Rule
  def unify([], [], theta), do: theta

  # # This does not seem to be the best solution
  def unify([{:var, x} | rest], [], theta) do
    case unify({:var, x}, [], theta) do
      :unmatch -> :unmatch
      theta1 -> unify(rest, [], theta1)
    end
  end

  def unify([], [{:var, x} | rest], theta), do: unify([{:var, x} | rest], [], theta)
  # # End this does not seem to be the best solution

  def unify([h1 | t1], [h2 | t2], theta) do
    case unify(h1, h2, theta) do
      :unmatch -> :unmatch
      theta1 -> unify(t1, t2, theta1)
    end
  end

  def unify(t1, t2, theta) when is_list_term(t1) and is_list_term(t2) do
    c1 = components_of_list(t1)
    c2 = components_of_list(t2)
    case {c1, c2} do
      {[], [_|_]} -> :unmatch
      {[_|_], []} -> :unmatch
      {c1, c2} -> unify(c1, c2, theta)
    end
  end

  # [Clash] Rule
  def unify(_t1, _t2, _theta), do: :unmatch

  #####################
  # Private Functions #
  #####################

  @spec vars(theta(), t()) :: vars_set()
  defp vars(_theta, {:ground, _}), do: MapSet.new()

  defp vars(theta, {:var, x}) do
    case Map.fetch(theta, x) do
      {:ok, subt} -> vars(theta, subt)
      :error -> MapSet.new([x])
    end
  end

  defp vars(theta, t) when is_tuple(t) do
    c = components_of(t)
    vars(theta, c)
  end

  defp vars(theta, t) when is_list(t) do
    Enum.reduce(t, MapSet.new(), fn tx, acc -> MapSet.union(vars(theta, tx), acc) end)
  end

  @spec unify_variable(String.t(), t(), %{String.t() => t()}) :: %{String.t() => t()}
  defp unify_variable(x, t, theta) do
    apply_subtitutions(Map.put(theta, x, t))
  end

  @spec apply_subtitutions(%{String.t() => t()}) :: %{String.t() => t()}
  defp apply_subtitutions(theta),
    do: :maps.map(fn _, v -> apply_subtitution(theta, v) end, theta)

  @spec apply_subtitution(%{String.t() => t()}, t()) :: t()
  defp apply_subtitution(theta, {:var, x}) when belongs_to(theta, x), do: theta[x]
  defp apply_subtitution(_theta, {:var, x}), do: {:var, x}
  defp apply_subtitution(_theta, {:ground, t}), do: {:ground, t}

  defp apply_subtitution(theta, t) when is_tuple_term(t) do
    c = components_of(t)
    c1 = apply_subtitution(theta, c)

    case c1 do
      {:ground, l} -> {:ground, List.to_tuple(l)}
      _ -> List.to_tuple(c1)
    end
  end

  defp apply_subtitution(theta, t) when is_list(t) do
    all_grounds(Enum.map(t, &apply_subtitution(theta, &1)))
  end

  @spec components_of(tuple()) :: [term()]
  defp components_of({:ground, t}), do: Tuple.to_list(t) |> Enum.map(&{:ground, &1})
  defp components_of(t) when is_tuple(t), do: Tuple.to_list(t)

  @spec components_of_list(list() | ground_term()) :: [term()]
  defp components_of_list({:ground, t}), do: t |> Enum.map(&{:ground, &1})
  defp components_of_list(t) when is_list(t), do: t

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
