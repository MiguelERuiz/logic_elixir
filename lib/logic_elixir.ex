defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

  # TODO add map() as part of t() definition
  # ? Las variables lógicas las representamos con átomos??
  @type t :: {:ground, term()} | {t()} | list(t()) | atom()

  # el :unmatch sirve para representar el simbolo ⊥
  @type sigma :: list(tuple()) | :unmatch

  @spec unify(t(), t(), sigma()) :: sigma()
  # [ExTerm] rule
  def unify({:ground, t}, {:ground, t}, sigma) do
    sigma
  end

  # [ExTermFail] Rule
  def unify({:ground, t1}, {:ground, t2}, _sigma) when t1 != t2 do
    :unmatch
  end

  # [Id] Rule
  def unify(t, t, sigma) do
    sigma
  end

  def unify(t1, t1, sigma) when is_tuple(t1) do
    sigma
  end

  def unify([], [], sigma) do
    sigma
  end

  def unify([head1 | tail1], [head2 | tail2], sigma) do
    # probably it's not okay
    unify(tail1, tail2, [{head1, head2} | sigma])
  end

  # [Clash] Rule
  def unify(_t1, _t2, _sigma) do
    :unmatch
  end

  # TODO faltan:
  # Var1
  # Var2
  # Occurs-check
  # Orient
end
