defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

  # TODO add map() as part of t() definition
  # ? Las variables lógicas las representamos con átomos??
  @type t :: {:ground, term()} | {t()} | list(t()) | atom()

  @type sigma :: list(tuple()) | :unmatch # el :unmatch sirve para representar el simbolo ⊥

  @spec unify(t(), t(), sigma()) :: sigma()
  def unify({:ground, t}, {:ground, t}, sigma) do # [ExTerm] rule
    sigma
  end

  def unify({:ground, t1}, {:ground, t2}, _sigma) when t1 != t2 do # [ExTermFail] Rule
    :unmatch
  end

  def unify(t, t, sigma) do # [Id] Rule
    sigma
  end

  def unify(t1, t1, sigma) when is_tuple(t1) do
    sigma
  end

  def unify([], [], sigma) do
    sigma
  end
  def unify([head1|tail1], [head2|tail2], sigma) do
    unify(tail1, tail2, [{head1, head2}|sigma]) # probably it's not okay
  end

  def unify(_t1, _t2, _sigma) do # [Clash] Rule
    :unmatch
  end

  # TODO faltan:
  # Var1
  # Var2
  # Occurs-check
  # Orient
end
