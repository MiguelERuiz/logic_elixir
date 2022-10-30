defmodule LogicElixirTest do
  use ExUnit.Case
  doctest LogicElixir

  test "Verifies [ExTerm] rule" do
    assert LogicElixir.unify({:ground, 3}, {:ground, 3}, %{}) == %{}
    assert LogicElixir.unify({:ground, :a}, {:ground, :a}, %{}) == %{}
    assert LogicElixir.unify({:ground, "hello"}, {:ground, "hello"}, %{}) == %{}
    assert LogicElixir.unify({:ground, true}, {:ground, true}, %{}) == %{}
    assert LogicElixir.unify({:ground, false}, {:ground, false}, %{}) == %{}
  end

  test "Verifies [ExTermFail] rule" do
    assert LogicElixir.unify({:ground, 3}, {:ground, 5}, %{}) == :unmatch
    assert LogicElixir.unify({:ground, :a}, {:ground, :b}, %{}) == :unmatch
  end

  test "Verifies [Id] rule" do
    assert LogicElixir.unify(X, X, %{}) == %{}
    assert LogicElixir.unify(Y, Y, %{}) == %{}
    assert LogicElixir.unify(Z, Z, %{}) == %{}
  end

  test "Verifies [Var1], [Var2] and [Orient] rules" do
    assert LogicElixir.unify(X, Y, %{}) == %{'Elixir.X': Y}
    assert LogicElixir.unify(Y, X, %{}) == %{'Elixir.Y': X}
    assert LogicElixir.unify(X, {:ground, 3}, %{}) == %{'Elixir.X': 3}
    assert LogicElixir.unify({:ground, 3}, X, %{}) == %{'Elixir.X': 3}
    # assert LogicElixir.unify({X, X}, {:ground, {5, 5}}, %{}) == %{'Elixir.X': 5}
  end

  test "Verifies [List] rule" do
    assert LogicElixir.unify([], [], %{}) == %{}
    assert LogicElixir.unify([{:ground, 1}, {:ground, 2}, {:ground, 3}], [X, Y, Z], %{}) == %{'Elixir.X': 1, 'Elixir.Y': 2, 'Elixir.Z': 3}
  end

  test "Verifies [Clash] rule" do
    assert LogicElixir.unify(:a, 3, %{}) == :unmatch
    assert LogicElixir.unify(:a, :a, %{}) == :unmatch
    assert LogicElixir.unify({X, Y}, {:ground, 3}, %{}) == :unmatch
  end
end
