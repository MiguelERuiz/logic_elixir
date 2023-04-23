defmodule CoreTest do
  use ExUnit.Case
  doctest Core

  import Template

  test "Checks pred1" do
    assert pred1({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 5}}]
    assert pred1({:ground, 5}).(%{}) |> Enum.into([]) == [%{}]
    assert pred1({:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred2" do
    assert pred2({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 5}, "Y" => {:ground, 6}}]
    assert pred2({:ground, 5}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 6}}]
    assert pred2({:var, "X"}, {:ground, 6}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 5}}]
    assert pred2({:ground, 5}, {:ground, 6}).(%{}) |> Enum.into([]) == [%{}]
    assert pred2({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == []
    assert pred2({:ground, 4}, {:var, "Y"}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred3" do
    assert pred3({:ground, 3}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred3({:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([]) == []
    assert pred3({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) != []
    assert pred3({:var, "X"}, {:var, "X"}).(%{}) |> Enum.into([]) != []
  end

  test "Checks pred4" do
    assert pred4({:var, "X"}).(%{}) |> Enum.into([]) == [%{}]
    assert pred4({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred5" do
    assert pred5().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred6" do
    assert pred6({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}, %{"X" => {:ground, 2}}]
    assert pred6({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert pred6({:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred6({:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred7" do
    assert pred7({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}, %{"X" => {:ground, 2}}, %{"X" => {:ground, 3}}]
    assert pred7({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert pred7({:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred7({:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred7({:ground, 4}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred8" do
    assert pred8({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}, "Y" => {:ground, 3}}, %{"X" => {:ground, 2}, "Y" => {:ground, 3}}]
    assert pred8({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]
    assert pred8({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]
    assert pred8({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}, %{"X" => {:ground, 2}}]
    assert pred8({:ground, 1}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred8({:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred8({:ground, 3}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred8({:ground, 1}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred8({:ground, 2}, {:ground, 1}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred9" do
    assert pred9({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}, "Y" => {:ground, 3}}, %{"X" => {:ground, 2}, "Y" => {:ground, 4}}]
    assert pred9({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]
    assert pred9({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 4}}]
    assert pred9({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred9({:var, "X"}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 2}}]
    assert pred9({:ground, 1}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred9({:ground, 2}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{}]
    assert pred9({:ground, 3}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred9({:ground, 1}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred9({:ground, 2}, {:ground, 1}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred10" do
    assert pred10({:var, "X"}).(%{}) |> Enum.into([]) != []
    assert pred10({:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred10({:ground, [1, 2]}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred11" do
    assert pred11().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred12" do
    assert pred12().(%{}) |> Enum.into([]) == []
  end

  test "Checks pred13" do
    assert pred13({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 5}}]
    assert pred13({:ground, 5}).(%{}) |> Enum.into([]) == [%{}]
    assert pred13({:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred14" do
    assert pred14().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred15" do
    assert pred15({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 7}}]
    assert pred15({:ground, 7}).(%{}) |> Enum.into([]) == [%{}]
    assert pred15({:ground, 5}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred16" do
    assert pred16({:var, "Z"}).(%{}) |> Enum.into([]) == [%{"Z" => {:ground, 7}}]
    assert pred16({:ground, 7}).(%{}) |> Enum.into([]) == [%{}]
    assert pred16({:ground, 5}).(%{}) |> Enum.into([]) == []
  end

  # TODO prepare test for pred17*

  # TODO prepare test for append

  test "Checks pred18" do
    assert pred18({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}, "Y" => {:ground, 2}}]
    assert pred18({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 2}}]
    assert pred18({:var, "X"}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred18({:ground, 1}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred18({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == []
    assert pred18({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred19" do
    assert pred19({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{}]
    assert pred19({:ground, 1}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred19({:ground, 1}, {:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred20" do
    assert pred20({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}, "Y" => {:ground, 3}}, %{"X" => {:ground, 2}, "Y" => {:ground, 4}}]
    assert pred20({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]
    assert pred20({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 4}}]
    assert pred20({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred20({:var, "X"}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 2}}]
    assert pred20({:ground, 1}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred20({:ground, 2}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{}]
    assert pred20({:ground, 7}, {:ground, 8}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred21" do
    assert pred21({:var, "X"}).(%{}) |> Enum.into([]) != []
    assert pred21({:ground, {1, 2}}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred23" do
    assert pred23({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, {1, 2, 3}}}]
    assert pred23({:ground, {1, 2, 3}}).(%{}) |> Enum.into([]) == [%{}]
  end

  # TODO test pred24, pred25, pred26, pred27

  test "Checks pred28" do
    assert pred28({:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred28({:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred28({:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert catch_throw(pred28({:var, "X"}).(%{}) |> Enum.into([])) == "#{inspect({:var, "X"})} is not bound to a fully instatiated term"
  end

  test "Checks pred29" do
    assert pred29().(%{}) |> Enum.into([]) == [%{}]
  end
end
