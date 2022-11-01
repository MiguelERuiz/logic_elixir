defmodule LogicElixirTest do
  use ExUnit.Case
  doctest LogicElixir

  import LogicElixir

  test "Verifies [ExTerm] rule" do
    assert unify({:ground, 3}, {:ground, 3}, %{}) == %{}
    assert unify({:ground, :a}, {:ground, :a}, %{}) == %{}
    assert unify({:ground, "hello"}, {:ground, "hello"}, %{}) == %{}
    assert unify({:ground, true}, {:ground, true}, %{}) == %{}
    assert unify({:ground, false}, {:ground, false}, %{}) == %{}
  end

  test "Verifies [ExTermFail] rule" do
    assert unify({:ground, 3}, {:ground, 5}, %{}) == :unmatch
    assert unify({:ground, :a}, {:ground, :b}, %{}) == :unmatch
  end

  test "Verifies [Id] rule" do
    assert unify(X, X, %{}) == %{}
    assert unify(Y, Y, %{}) == %{}
    assert unify(Z, Z, %{}) == %{}
  end

  test "Verifies [Var1], [Var2], [Occurs-check] and [Orient] rules" do
    assert unify(X, Y, %{}) == %{'Elixir.X': Y}
    assert unify(Y, X, %{}) == %{'Elixir.Y': X}
    assert unify(X, {:ground, 3}, %{}) == %{'Elixir.X': 3}
    assert unify({:ground, 3}, X, %{}) == %{'Elixir.X': 3}
    assert unify({X, X}, {:ground, {5, 5}}, %{}) == %{'Elixir.X': {5, 5}} # ? I don't think this test is correct
  end

  test "Verifies [Tuple] rule" do
    assert unify({{:ground, 1}, {:ground, 2}}, {{:ground, 1}, {:ground, 2}}, %{}) == %{}
    assert unify({X, Y}, {{:ground, 1}, {:ground, 2}}, %{}) == %{'Elixir.X': 1, 'Elixir.Y': 2}
    assert unify({X, Y}, {[{:ground, 1}, {:ground, 2}], [{:ground, 3}, {:ground, 4}]}, %{}) == %{'Elixir.X': [1, 2], 'Elixir.Y': [3, 4]}
    assert unify({T, S}, {{:ground, 1}, [X, Y, Z]}, %{}) == %{'Elixir.T': 1, 'Elixir.S': [X, Y, Z]}
  end

  test "Verifies [List] rule" do
    assert unify([], [], %{}) == %{}
    assert unify([{:ground, 1}, {:ground, 2}, {:ground, 3}], [{:ground, 1}, {:ground, 2}, {:ground, 3}], %{}) == %{}
    assert unify([{:ground, 1}, {:ground, 2}, {:ground, 3}], [X, Y, Z], %{}) == %{'Elixir.X': 1, 'Elixir.Y': 2, 'Elixir.Z': 3}
    assert unify([X, X], [{:ground, 5}, {:ground, 5}], %{}) == %{'Elixir.X': 5}
    assert unify([Y, X, Z], [{:ground, 5}, {Y, {:ground, 3}}, {:ground, :a}], %{}) == %{'Elixir.Y': 5, 'Elixir.X': {5, 3}, 'Elixir.Z': :a}
  end

  test "Verifies [Clash] rule" do
    assert unify(:a, 3, %{}) == :unmatch
    assert unify(:a, :a, %{}) == :unmatch
    assert unify({X, Y}, {:ground, 3}, %{}) == :unmatch
  end
end
