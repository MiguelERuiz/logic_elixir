defmodule DefpredTest do
  use ExUnit.Case
  doctest LogicElixir.Defpred

  import LogicTemplate

  test "Checks person fact" do
    assert person({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :mary}}, %{"X" => {:ground, :paul}}, %{"X" => {:ground, :john}}, %{"X" => {:ground, :mike}}, %{"X" => {:ground, :sussie}}]
    assert person({:ground, :mike}).(%{}) |> Enum.into([]) == [%{}]
    assert person({:ground, :sussie}).(%{}) |> Enum.into([]) == [%{}]
    assert person({:ground, :paul}).(%{}) |> Enum.into([]) == [%{}]
    assert person({:ground, :mary}).(%{}) |> Enum.into([]) == [%{}]
    assert person({:ground, :john}).(%{}) |> Enum.into([]) == [%{}]
    assert person({:ground, :robocop}).(%{}) |> Enum.into([]) == []
  end

  test "Checks animal fact" do
    assert animal({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :gladys}}]
    assert animal({:ground, :gladys}).(%{}) |> Enum.into([]) == [%{}]
    assert animal({:ground, :pluto}).(%{}) |> Enum.into([]) == []
  end

  test "Checks likes fact" do
    assert likes({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :mike}, "Y" => {:ground, :football}}, %{"X" => {:ground, :sussie}, "Y" => {:ground, :sushi}}, %{"X" => {:ground, :sussie}, "Y" => {:ground, :pizza}}]
    assert likes({:ground, :mike}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, :football}}]
    assert likes({:ground, :sussie}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, :sushi}}, %{"Y" => {:ground, :pizza}}]
    assert likes({:var, "X"}, {:ground, :pizza}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :sussie}}]
    assert likes({:var, "X"}, {:ground, :sushi}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :sussie}}]
    assert likes({:var, "X"}, {:ground, :football}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :mike}}]
    assert likes({:ground, :peter}, {:ground, :football}).(%{}) |> Enum.into([]) == []
    assert likes({:ground, :claire}, {:ground, :pizza}).(%{}) |> Enum.into([]) == []
  end

  test "Checks age fact" do
    assert age({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :mary}, "Y" => {:ground, 20}}, %{"X" => {:ground, :paul}, "Y" => {:ground, 30}}, %{"X" => {:ground, :john}, "Y" => {:ground, 50}}]
    assert age({:ground, :john}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 50}}]
    assert age({:ground, :paul}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 30}}]
    assert age({:ground, :mary}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 20}}]
    assert age({:var, "X"}, {:ground, 50}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :john}}]
    assert age({:var, "X"}, {:ground, 30}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :paul}}]
    assert age({:var, "X"}, {:ground, 20}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :mary}}]
    assert age({:ground, :john}, {:ground, 50}).(%{}) |> Enum.into([]) == [%{}]
    assert age({:ground, :paul}, {:ground, 30}).(%{}) |> Enum.into([]) == [%{}]
    assert age({:ground, :mary}, {:ground, 20}).(%{}) |> Enum.into([]) == [%{}]
    assert age({:ground, :thomas}, {:ground, 50}).(%{}) |> Enum.into([]) == []
    assert age({:ground, :sarah}, {:ground, 42}).(%{}) |> Enum.into([]) == []
  end

  test "Checks father_of fact" do
    assert father_of({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :john}, "Y" => {:ground, :mary}}, %{"X" => {:ground, :john}, "Y" => {:ground, :paul}}]
    assert father_of({:ground, :john}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, :mary}}, %{"Y" => {:ground, :paul}}]
    assert father_of({:var, "X"}, {:ground, :paul}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :john}}]
    assert father_of({:var, "X"}, {:ground, :mary}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :john}}]
    assert father_of({:ground, :john}, {:ground, :paul}).(%{}) |> Enum.into([]) == [%{}]
    assert father_of({:ground, :john}, {:ground, :mary}).(%{}) |> Enum.into([]) == [%{}]
    assert father_of({:ground, :rick}, {:ground, :ann}).(%{}) |> Enum.into([]) == []
  end

  test "Checks boils fact" do
    assert boils({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :water}, "Y" => {:ground, 100}}]
    assert boils({:ground, :water}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 100}}]
    assert boils({:var, "X"}, {:ground, 100}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :water}}]
    assert boils({:ground, :water}, {:ground, 100}).(%{}) |> Enum.into([]) == [%{}]
    assert boils({:ground, :oil}, {:ground, 100}).(%{}) |> Enum.into([]) == []
    assert boils({:ground, :water}, {:ground, 1000}).(%{}) |> Enum.into([]) == []
  end

  test "Checks sunny fact" do
    assert sunny().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks water_wets fact" do
    assert water_wets().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks is_funny fact" do
    assert is_funny({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :hiking}}, %{"X" => {:ground, :painting}}]
    assert is_funny({:ground, :painting}).(%{}) |> Enum.into([]) == [%{}]
    assert is_funny({:ground, :hiking}).(%{}) |> Enum.into([]) == [%{}]
    assert is_funny({:ground, :skiing}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pizza_lover predicate" do
    assert pizza_lover({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, :sussie}}]
    assert pizza_lover({:ground, :sussie}).(%{}) |> Enum.into([]) == [%{}]
    assert pizza_lover({:ground, :mike}).(%{}) |> Enum.into([]) == []
    assert pizza_lover({:ground, :mark}).(%{}) |> Enum.into([]) == []
  end

  test "Checks number predicate" do
    assert number({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert number({:ground, -200}).(%{}) |> Enum.into([]) == [%{}]
    assert number({:ground, 1.2345687}).(%{}) |> Enum.into([]) == [%{}]
    assert number({:ground, -432.235854319}).(%{}) |> Enum.into([]) == [%{}]
    assert number({:ground, "33"}).(%{}) |> Enum.into([]) == []
    assert number({:ground, :"33"}).(%{}) |> Enum.into([]) == []
    assert catch_throw(number({:var, "X"}).(%{}) |> Enum.into([])) ==
              "#{inspect({:var, "X"})} is not bound to a fully instatiated term"
  end
end
