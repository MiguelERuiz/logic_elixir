defmodule UnificationTest do
  use ExUnit.Case
  doctest Unification

  import Unification

  test "Verifies [ExTerm] rule" do
    assert unify({:ground, 3}, {:ground, 3}, %{}) == %{}
    assert unify({:ground, :a}, {:ground, :a}, %{}) == %{}
    assert unify({:ground, "hello"}, {:ground, "hello"}, %{}) == %{}
    assert unify({:ground, true}, {:ground, true}, %{}) == %{}
    assert unify({:ground, false}, {:ground, false}, %{}) == %{}
    assert unify({:ground, [1, 2, 3]}, {:ground, [1, 2, 3]}, %{}) == %{}
    assert unify({:ground, {:a, :b, :c}}, {:ground, {:a, :b, :c}}, %{}) == %{}
  end

  test "Verifies [ExTermFail] rule" do
    assert unify({:ground, 3}, {:ground, 5}, %{}) == :unmatch
    assert unify({:ground, :a}, {:ground, :b}, %{}) == :unmatch
    assert unify({:ground, [1, 2, 3]}, {:ground, [4, 5, 6]}, %{}) == :unmatch
    assert unify({:ground, {:a, :b, :c}}, {:ground, {:d, :e, :f}}, %{}) == :unmatch
  end

  test "Verifies [Id] rule" do
    assert unify({:var, "X"}, {:var, "X"}, %{}) == %{}
    assert unify({:var, "Y"}, {:var, "Y"}, %{}) == %{}
    assert unify({:var, "Z"}, {:var, "Z"}, %{}) == %{}
  end

  test "Verifies [Var1], [Var2], [Occurs-check] and [Orient] rules" do
    assert unify({:var, "X"}, {:var, "Y"}, %{}) == %{"X" => {:var, "Y"}}
    assert unify({:var, "Y"}, {:var, "X"}, %{}) == %{"Y" => {:var, "X"}}
    assert unify({:var, "X"}, {:ground, 3}, %{}) == %{"X" => {:ground, 3}}
    assert unify({:ground, 3}, {:var, "X"}, %{}) == %{"X" => {:ground, 3}}

    assert unify({{:var, "X"}, {:var, "X"}}, {{:ground, 5}, {:ground, 5}}, %{}) == %{
             "X" => {:ground, 5}
           }

    assert unify({:var, "X"}, {{:var, "X"}, {:ground, 3}}, %{}) == :unmatch
    assert unify({:var, "X"}, [{:var, "X"}, {:ground, 3}], %{}) == :unmatch

    assert unify({:var, "Y"}, [{:var, "X"}, {:var, "Z"}], %{}) == %{
             "Y" => [{:var, "X"}, {:var, "Z"}]
           }

    assert unify({:var, "X"}, [{:ground, 1}, {:ground, 2}], %{}) == %{"X" => {:ground, [1, 2]}}
  end

  test "Verifies [Tuple] rule" do
    assert unify({{:var, "X"}, {:var, "Y"}}, {{:ground, {1, 2}}, {:ground, {3, 4}}}, %{}) == %{
             "X" => {:ground, {1, 2}},
             "Y" => {:ground, {3, 4}}
           }

    assert unify({{:var, "X"}, {:var, "Y"}}, {{{:ground, 1}, {:ground, 2}}, {{:ground, 3}, {:ground, 4}}}, %{}) == %{
            "X" => {:ground, {1, 2}},
            "Y" => {:ground, {3, 4}}
          }

    assert unify({{:var, "X"}, {:var, "Y"}}, {{:ground, [1, 2]}, {:ground, [3, 4]}}, %{}) == %{
             "X" => {:ground, [1, 2]},
             "Y" => {:ground, [3, 4]}
           }

    assert unify({{:var, "X"}, {:var, "Y"}}, {[{:ground, 1}, {:ground, 2}], [{:ground, 3}, {:ground, 4}]}, %{}) == %{
            "X" => {:ground, [1, 2]},
            "Y" => {:ground, [3, 4]}
          }

    assert unify(
             {{:var, "T"}, {:var, "S"}},
             {{:ground, 1}, [{:var, "X"}, {:var, "Y"}, {:var, "Z"}]},
             %{}
           ) == %{"T" => {:ground, 1}, "S" => [{:var, "X"}, {:var, "Y"}, {:var, "Z"}]}

    assert unify({{:var, "X"}, {:var, "Y"}}, {{:var, "Y"}, {:ground, 5}}, %{}) == %{
             "X" => {:ground, 5},
             "Y" => {:ground, 5}
           }
  end

  test "Verifies [List] rule" do
    assert unify([], [], %{}) == %{}

    assert unify(
             [{:ground, 1}, {:ground, 2}, {:ground, 3}],
             [{:ground, 1}, {:ground, 2}, {:ground, 3}],
             %{}
           ) == %{}

    assert unify(
             [{:ground, 1}, {:ground, 2}, {:ground, 3}],
             [{:var, "X"}, {:var, "Y"}, {:var, "Z"}],
             %{}
           ) == %{"X" => {:ground, 1}, "Y" => {:ground, 2}, "Z" => {:ground, 3}}

    assert unify([{:var, "X"}, {:var, "X"}], [{:ground, 5}, {:ground, 5}], %{}) == %{
             "X" => {:ground, 5}
           }

    assert unify([{:var, "X"}, {:var, "S"}], [{:ground, 5}, {:ground, [{1, 2}, [3], 4]}], %{}) ==
             %{"X" => {:ground, 5}, "S" => {:ground, [{1, 2}, [3], 4]}}

    assert unify([{:var, "Y"}, {:var, "X"}], [{{:var, "X"}, {:ground, 3}}, {:ground, 5}], %{}) ==
             %{"Y" => {:ground, {5, 3}}, "X" => {:ground, 5}}

    assert unify(
             [{:var, "Y"}, {:var, "X"}, {:var, "Z"}],
             [{{:var, "X"}, {:ground, 3}}, {:ground, 5}, {:ground, :a}],
             %{}
           ) == %{"Y" => {:ground, {5, 3}}, "X" => {:ground, 5}, "Z" => {:ground, :a}}

    assert unify(
      [{:ground, 1} | {:var, "T"}], {:ground, [1]}, %{}
    ) == %{"T" => {:ground, []}}

    assert unify(
      [{:ground, 1} | [{:var, "T"}]], {:ground, [1, 2]}, %{}
    ) == %{"T" => {:ground, 2}}

    assert unify(
      [{:ground, 1} | {:var, "T"}], {:ground, [1, 2]}, %{}
    ) == %{"T" => {:ground, [2]}}

    assert unify(
      [{:ground, 1} | [{:var, "T"} | {:var, "X"}]], {:ground, [1, 2]}, %{}
    ) == %{"T" => {:ground, 2}, "X" => {:ground, []}}

    assert unify(
      [{:ground, 1} | [{:var, "T"} | {:var, "X"}]], {:ground, [1, 2, 3]}, %{}
    ) == %{"T" => {:ground, 2}, "X" => {:ground, [3]}}

    assert unify(
      [{:var, "X"} | [{:var, "Y"} | {:var, "Z"}]], {:ground, [1, 2, 3]}, %{}
    ) == %{"X" => {:ground, 1}, "Y" => {:ground, 2}, "Z" => {:ground, [3]}}

    assert unify(
      [{:var, "X"}], [{:var, "Y"} | {:var, "Z"}], %{}
    ) == %{"X" => {:var, "Y"}, "Z" => {:ground, []}}

    assert unify(
      {:var, "X"}, [{:var, "Y"} | {:var, "Z"}], %{}
    ) == %{"X" => [{:var, "Y"} | {:var, "Z"}]}

    assert unify(
      {:var, "Xs"}, [{:var, "X"} | [{:var, "Y"} | {:var, "Ys"}]], %{}
    ) == %{"Xs" => [{:var, "X"} | [{:var, "Y"} | {:var, "Ys"}]]}
  end

  test "Verifies [Clash] rule" do
    assert unify(:a, 3, %{}) == :unmatch

    assert unify(:a, :a, %{}) == :unmatch

    assert unify({{:var, "X"}, {:var, "Y"}}, {:ground, 3}, %{}) == :unmatch

    assert unify(
      [{:ground, 1} | [{:var, "T"}]], {:ground, []}, %{}
    ) == :unmatch

    assert unify(
      {:ground, [1]}, [{:var, "X"} | [{:var, "Y"} | [{:var, "Z"}]]], %{}
    ) == :unmatch

    assert unify(
      {:ground, [1, 2]}, [{:var, "X"} | [{:var, "Y"} | [{:var, "Z"}]]], %{}
    ) == :unmatch

    assert unify(
      [{:ground, 1} | [{:var, "T"}]], {:ground, [1]}, %{}
    ) == :unmatch

    assert unify(
      [{:var, "Xs"}], [{:var, "X"} | [{:var, "Y"} | {:var, "Ys"}]], %{}
    ) == :unmatch

    assert unify(
      [{:var, "Xs"}], {:ground, []}, %{}) == :unmatch
  end
end
