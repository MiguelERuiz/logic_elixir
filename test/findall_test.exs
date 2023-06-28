defmodule FindallTest do
  use ExUnit.Case
  doctest LogicElixir.Findall

  import LogicTemplate
  import LogicElixir.Findall
  import LogicElixir.Defcore

  test "Find all persons" do
    assert (findall X, do: person(X)) |> Enum.into([]) == [
      :mary, :paul, :john, :mike, :sussie
    ]
  end

  test "Find all animals" do
    assert (findall X, do: animal(X)) |> Enum.into([]) == [
      :gladys, :bucky
    ]
  end

  test "Find all tuples {X, Y} that satisfies likes/2 rules" do
    assert (findall {X, Y}, do: likes(X, Y)) |> Enum.into([]) == [
      mike: :football, sussie: :sushi, bucky: :pizza, sussie: :pizza
    ]
  end

  test "Find all tuples {X, Y} that satisfies both person/1 and likes/2 rules" do
    assert (findall {X, Y}, do: (person(X) ; likes(X, Y))) |> Enum.into([]) == [
      mike: :football, sussie: :sushi, sussie: :pizza
    ]
  end

  test "Find all pizza_lovers in the form {:name, X}" do
    assert (findall {:name, X}, do: pizza_lover(X)) |> Enum.into([]) == [
      name: :sussie
    ]
  end

  test "Find all X that satisfies age(X, Y) and their age is greater than 30" do
    assert (findall X, do: (age(X, Y) ; @(Y > 30))) |> Enum.into([]) == [
      :john
    ]
  end

  test "Find all :john's children" do
    assert (findall Child, do: father_of(:john, Child)) |> Enum.into([]) == [
      :mary, :paul
    ]
  end

  test "Find all list that apply append/3 produces an empty list" do
    assert (findall Ys, do: append([], Ys, [])) |> Enum.into([]) == [[]]
  end

  test "Throws an exception when variable in T term are not properly instantiated" do

  end

  test "Find all pair of lists that produces result list [1, 2, 3]" do
    assert (findall {X, Y}, do: append(X, Y, [1, 2, 3])) |> Enum.into([]) == [
      {[1, 2, 3], []},
      {[1, 2], [3]},
      {[1], [2, 3]},
      {[], [1, 2, 3]}
    ]
  end
end
