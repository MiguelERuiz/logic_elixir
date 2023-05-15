defmodule Unification do
  @moduledoc """
    Documentation for Unification module
  """
  require Logger
  require IEx


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
    # Logger.warn "[Var2] and [Occurs-check]"
    # Logger.info "{:var, x}: #{inspect({:var, x})}"
    # Logger.info "t: #{inspect(t)}"
    # Logger.info "theta: #{inspect(theta)}"
    # Logger.info "vars(theta, t): #{inspect(vars(theta, t))}"
    # Logger.info "x in vars(theta, t): #{x in vars(theta, t)}"
    if x in vars(theta, t) do
      # Logger.warn "[Occurs-check]"
      :unmatch
    else
      # Logger.warn "[Var2]"
      unify_variable(x, t, theta)
    end
  end

  # [Orient] Rule
  def unify(t1, {:var, _x} = t2, theta) do
    # # Logger.warn("[Orient] rule")
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
      _ -> unify(c1, c2, theta)
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
    # Logger.warn "vars/2 when t is tuple"
    # Logger.info "theta: #{inspect(theta)}"
    # Logger.info "t: #{inspect(t)}"
    c = components_of(t)
    vars(theta, c)
  end

  # defp vars(theta, t) when is_list(t) do
  #   # # Logger.warn "vars/2 when is_list(t)"
  #   # # Logger.info("t: #{inspect(t)}")
  #   Enum.reduce(t, MapSet.new(), fn tx, acc -> MapSet.union(vars(theta, tx), acc) end)
  # end

  defp vars(theta, []) do
    # Logger.warn "vars/2 when t is empty list"
    MapSet.new(theta)
  end

  defp vars(theta, [h|t]) do
    # Logger.warn "vars/2 when t is maybe improper list"
    theta1 = vars(theta, h)
    MapSet.union(theta1, vars(theta1, t))
  end

  @spec unify_variable(String.t(), t(), %{String.t() => t()}) :: %{String.t() => t()}
  defp unify_variable(x, t, theta) do
    # Logger.warn "unify_variable/3: Unifying x with t in theta"
    # Logger.info "x: #{inspect(x)}"
    # Logger.info "t: #{inspect(t)}"
    # Logger.info "theta: #{inspect(theta)}"
    apply_subtitutions(Map.put(theta, x, t))
  end

  @spec apply_subtitutions(%{String.t() => t()}) :: %{String.t() => t()}
  defp apply_subtitutions(theta) do
    # Logger.warn("apply_subtitutions/1")
    # Logger.info("theta: #{inspect(theta)}")
    :maps.map(fn k, v ->
      # Logger.info("k: #{inspect(k)}")
      # Logger.info("v: #{inspect(v)}")
      apply_subtitution(theta, v) end, theta)
  end

  @spec apply_subtitution(%{String.t() => t()}, t()) :: t()
  defp apply_subtitution(theta, {:var, x}) when belongs_to(theta, x) do
    # Logger.warn "apply_subtitution/2: when var belongs to theta"
    # Logger.info "theta[x] : #{inspect(theta[x])}"
    theta[x]
  end
  defp apply_subtitution(_theta, {:var, x}) do
    # Logger.warn "apply_subtitution/2: when var does not belong to theta"
    # Logger.info "{:var, x} : {:var, #{inspect(x)}}"
    {:var, x}
  end
  defp apply_subtitution(_theta, {:ground, t}) do
    # Logger.warn "apply_subtitution/2: when x is a ground term"
    # Logger.info "{:ground, t} : {:ground, #{inspect(t)}}"
    {:ground, t}
  end

  # defp apply_subtitution(theta, t) when is_tuple_term(t) do
  #   # Logger.warn "apply_subtitution/2: when t is a tuple"
  #   # Logger.info "theta: #{inspect(theta)}"
  #   # Logger.info "t: #{inspect(t)}"
  #   c = components_of(t)
  #   # Logger.info "c: #{inspect(c)}"
  #   if c == [var: "X", ground: 3] do
  #     IEx.pry
  #   end
  #   c1 = apply_subtitution(theta, c)
  #   # Logger.info "c1: #{inspect(c1)}"

  #   case c1 do
  #     {:ground, l} -> {:ground, List.to_tuple(l)}
  #     _ -> List.to_tuple(c1)
  #   end
  # end

  defp apply_subtitution(theta, t) when is_tuple_term(t) do
    list = t |> Tuple.to_list |> Enum.map(fn tx -> apply_subtitution(theta, tx) end)
    Core.build_tuple(list)
  end

  # This code still does not work as expected
  # defp apply_subtitution(theta, t) when is_list_term(t) do
  #   # # Logger.info "apply_subtitution/2: when t is a list"
  #   # # Logger.info "t: #{inspect(t)}"
  #   all_grounds(apply_subtitution(theta, t))
  # end

  # @spec apply_subtitution(%{String.t() => t()}, [t()]) :: [t()]
  # defp apply_subtitution(_theta, [], acc), do: acc

  defp apply_subtitution(_theta, []) do
    # Logger.warn "apply_subtitution/2 when t is a empty list"
    []
  end

  defp apply_subtitution(theta, [h|t]) do
    # Logger.warn "apply_subtitution/2: when t is a maybe improper list"
    # Logger.info "[h: #{inspect(h)}  | t: #{inspect(t)}]"
    # Logger.info "theta: #{inspect(theta)}"
    # Logger.info "applying subtitution with head"
    h_result = apply_subtitution(theta, h)
    # Logger.info "applying subtitution with tail"
    t_result = apply_subtitution(theta, t)
    # Logger.info "[h_result: #{inspect(h_result)}  | t_result: #{inspect(t_result)}]"
    all_grounds(Core.build_list(h_result, t_result))
  end

  # defp apply_subtitution(theta, list) do
  #   all_grounds(apply_subtitution(theta, list, []))
  # end

  # defp apply_subtitution(_theta, [], acc), do: Enum.reverse(acc)

  # defp apply_subtitution(theta, [h|t], acc) do
  #   # Logger.warn "apply_subtitution/3 on maybe improper list"
  #   # Logger.info "h: #{inspect(h)}"
  #   # Logger.info "t: #{inspect(t)}"
  #   # Logger.info "theta: #{inspect(theta)}"
  #   # Logger.info "acc: #{inspect(acc)}"
  #   h_result = apply_subtitution(theta, h)
  #   apply_subtitution(theta, t, [h_result|acc])
  # end

  # defp apply_subtitution(theta, t) when is_list_term(t) do
  #   # # # Logger.warn("t: #{inspect(t)}")
  #   # IEx.pry
  #   if is_list(t) do
  #     IEx.pry
  #   end
  #   something = Enum.map(t, fn x ->
  #     # # # Logger.info("apply_subtitution inside a Enum.map")
  #     # # # Logger.info("x: #{inspect(x)}")
  #     # # # Logger.info("theta: #{inspect(theta)}")
  #     apply_subtitution(theta, x)
  #     end
  #   )
  #   # # # Logger.info("something: #{inspect(something)}")
  #   all_grounds(something)
  # end
  # This code still does not work as expected


  @spec components_of(tuple()) :: [term()]
  defp components_of({:ground, t}), do: Tuple.to_list(t) |> Enum.map(&{:ground, &1})
  defp components_of(t) when is_tuple(t), do: Tuple.to_list(t)

  # @spec components_of_list(list() | ground_term()) :: [term()]
  def components_of_list([]), do: []
  def components_of_list({:ground, []}), do: []
  def components_of_list({:ground, [h | t]}), do: [{:ground, h}, {:ground, t}]
  def components_of_list([h | t]), do: [h, t]
  # defp components_of_list({:ground, t}), do: t |> Enum.map(&{:ground, &1})
  # defp components_of_list(t) when is_list(t), do: t

  # @spec all_grounds([t()]) :: {:ground, [term()]} | [t()]
  # defp all_grounds(t) do
  #   case Enum.all?(t, fn tx -> is_ground_term?(tx) end) do
  #     true -> {:ground, Enum.map(t, fn {:ground, tx} -> tx end)}
  #     false -> t
  #   end
  # end

  def all_grounds({:ground, term}) when is_list(term), do: {:ground, term}
  def all_grounds(list) do
    all_grounds(list, list, [])
  end

  def all_grounds([], _list, acc), do: {:ground, Enum.reverse(acc)}
  def all_grounds([h|t], list, acc) do
    case is_ground_term?(h) do
      true ->
        {:ground, term} = h
        all_grounds(t, list, [term | acc])
      false -> list
    end
  end

  @spec is_ground_term?(t()) :: boolean()
  defp is_ground_term?({:ground, _t}), do: true
  defp is_ground_term?(_), do: false
end
