defmodule FindallTest do
  use ExUnit.Case
  doctest LogicElixir.Findall

  import LogicTemplate
  import LogicElixir.Findall
  import LogicElixir.Defcore

  test "Find all persons" do
    assert (findall X, do: person(X)) |> Enum.into([]) == [
      :sussie,
      :mike,
      :john,
      :paul,
      :mary
    ]
  end

  test "Find all animals" do
    assert (findall X, do: animal(X)) |> Enum.into([]) == [
      :bucky, :gladys
    ]
  end

  test "Find all tuples {X, Y} that satisfies likes/2 rules" do
    assert (findall {X, Y}, do: likes(X, Y)) |> Enum.into([]) == [
      {:sussie, :pizza},
      {:bucky, :pizza},
      {:sussie, :sushi},
      {:mike, :football}
    ]
  end

  test "Find all tuples {X, Y} that satisfies both person/1 and likes/2 rules" do
    assert (findall {X, Y}, do: (person(X) ; likes(X, Y))) |> Enum.into([]) == [
      {:sussie, :pizza}, {:sussie, :sushi}, {:mike, :football}
    ]
  end

  test "Find all pizza_lovers in the form {:name, X}" do
    assert (findall {:name, X}, do: pizza_lover(X)) |> Enum.into([]) == [
      {:name, :sussie}
    ]
  end

  test "Find all X that satisfies age(X, Y) and their age is greater than 30" do
    assert (findall X, do: (age(X, Y) ; @(Y > 30))) |> Enum.into([]) == [
      :john
    ]
  end

  test "Find all :john's children" do
    assert (findall Child, do: father_of(:john, Child)) |> Enum.into([]) == [
      :paul, :mary
    ]
  end

  test "Find all list that apply append/3 produces an empty list" do
    assert (findall Ys, do: append([], Ys, [])) |> Enum.into([]) == [[]]
  end

  test "Find all pair of lists that produces result list [1, 2, 3]" do
    assert (findall {X, Y}, do: append(X, Y, [1, 2, 3])) |> Enum.into([]) == [
      {[], [1, 2, 3]},
      {[1], [2, 3]},
      {[1, 2], [3]},
      {[1, 2, 3], []}
    ]
  end

  test "Test when there are variables in Term but not in Goals" do
    assert (findall X, do: person(:peter)) |> Enum.into([]) == []

    assert (findall {X, Y}, do: likes(:mike, :flowers)) |> Enum.into([]) == []

    assert catch_throw((findall X, do: person(:mike)) |> Enum.into([])) ==
    "#{"X"} is not instantiated"

    assert catch_throw((findall {X, Y}, do: person(X)) |> Enum.into([])) ==
    "#{"Y"} is not instantiated"
  end
end
