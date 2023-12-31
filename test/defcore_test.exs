defmodule DefcoreTest do
  # , async: true
  use ExUnit.Case
  doctest LogicElixir.Defcore

  import Template

  setup_all do
    LogicElixir.VarBuilder.start_link()
    :ok
  end

  test "Checks pred" do
    assert pred().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred1" do
    assert pred1({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 5}}]
    assert pred1({:ground, 5}).(%{}) |> Enum.into([]) == [%{}]
    assert pred1({:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred2" do
    assert pred2({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 5}, "Y" => {:ground, 6}}
           ]

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
    assert pred6({:var, "X"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}},
             %{"X" => {:ground, 2}}
           ]

    assert pred6({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert pred6({:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred6({:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred7" do
    assert pred7({:var, "X"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 3}},
             %{"X" => {:ground, 4}},
             %{"X" => {:ground, 5}}
           ]

    assert pred7({:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred7({:ground, 4}).(%{}) |> Enum.into([]) == [%{}]
    assert pred7({:ground, 5}).(%{}) |> Enum.into([]) == [%{}]
    assert pred7({:ground, 6}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred8" do
    assert pred8({:var, "X"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}},
             %{"X" => {:ground, 2}},
             %{"X" => {:ground, 3}},
             %{"X" => {:ground, 4}},
             %{"X" => {:ground, 5}}
           ]

    assert pred8({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert pred8({:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred8({:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred8({:ground, 4}).(%{}) |> Enum.into([]) == [%{}]
    assert pred8({:ground, 5}).(%{}) |> Enum.into([]) == [%{}]
    assert pred8({:ground, 6}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred9" do
    assert pred9({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 3}},
             %{"X" => {:ground, 2}, "Y" => {:ground, 3}}
           ]

    assert pred9({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]
    assert pred9({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]

    assert pred9({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}},
             %{"X" => {:ground, 2}}
           ]

    assert pred9({:ground, 1}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred9({:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred9({:ground, 3}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred9({:ground, 1}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred9({:ground, 2}, {:ground, 1}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred10" do
    assert pred10({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 3}},
             %{"X" => {:ground, 2}, "Y" => {:ground, 4}}
           ]

    assert pred10({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]
    assert pred10({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 4}}]
    assert pred10({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred10({:var, "X"}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 2}}]
    assert pred10({:ground, 1}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred10({:ground, 2}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{}]
    assert pred10({:ground, 3}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred10({:ground, 1}, {:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred10({:ground, 2}, {:ground, 1}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred11" do
    assert pred11().(%{}) |> Enum.into([]) == []
  end

  test "Checks pred12" do
    assert pred12({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 5}}]
    assert pred12({:ground, 5}).(%{}) |> Enum.into([]) == [%{}]
    assert pred12({:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred13" do
    assert pred13().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred14" do
    assert pred14({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 7}}]
    assert pred14({:ground, 7}).(%{}) |> Enum.into([]) == [%{}]
    assert pred14({:ground, 5}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred15" do
    assert pred15({:var, "Z"}).(%{}) |> Enum.into([]) == [%{"Z" => {:ground, 7}}]
    assert pred15({:ground, 7}).(%{}) |> Enum.into([]) == [%{}]
    assert pred15({:ground, 5}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred16" do
    assert pred16({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 2}}
           ]

    assert pred16({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 2}}]
    assert pred16({:var, "X"}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred16({:ground, 1}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred16({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == []
    assert pred16({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred17" do
    assert pred17({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{}]
    assert pred17({:ground, 1}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred17({:ground, 1}, {:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred18" do
    assert pred18({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 3}},
             %{"X" => {:ground, 2}, "Y" => {:ground, 4}}
           ]

    assert pred18({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 3}}]
    assert pred18({:ground, 2}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 4}}]
    assert pred18({:var, "X"}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred18({:var, "X"}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 2}}]
    assert pred18({:ground, 1}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred18({:ground, 2}, {:ground, 4}).(%{}) |> Enum.into([]) == [%{}]
    assert pred18({:ground, 7}, {:ground, 8}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred19" do
    assert pred19({:var, "X"}).(%{}) |> Enum.into([]) != []
    assert pred19({:ground, {1, 2}}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred20" do
    assert pred20({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, [2]}}]
    assert pred20({:ground, [2]}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred21" do
    assert pred21({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, [2, 4]}}]
    assert pred21({:ground, [2, 4]}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred22" do
    assert pred22({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, [2, 4, 6]}}]
    assert pred22({:ground, [2, 4, 6]}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred23" do
    assert pred23({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, []}}
           ]
  end

  test "Checks pred24" do
    assert pred24({:var, "X"}, {:var, "Y"}, {:var, "Z"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 2}, "Z" => {:ground, [3]}}
           ]
  end

  test "Checks pred25" do
    assert pred25({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, {1, 2, 3}}}]
    assert pred25({:ground, {1, 2, 3}}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred26" do
    assert pred26({:var, "X"}, {:var, "Y"}, {:var, "Z"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 2}, "Z" => {:ground, 3}}
           ]

    assert pred26({:ground, 1}, {:var, "Y"}, {:var, "Z"}).(%{}) |> Enum.into([]) == [
             %{"Y" => {:ground, 2}, "Z" => {:ground, 3}}
           ]

    assert pred26({:var, "X"}, {:ground, 2}, {:var, "Z"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Z" => {:ground, 3}}
           ]

    assert pred26({:var, "X"}, {:var, "Y"}, {:ground, 3}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 2}}
           ]

    assert pred26({:ground, 1}, {:ground, 2}, {:var, "Z"}).(%{}) |> Enum.into([]) == [
             %{"Z" => {:ground, 3}}
           ]

    assert pred26({:ground, 1}, {:var, "Y"}, {:ground, 3}).(%{}) |> Enum.into([]) == [
             %{"Y" => {:ground, 2}}
           ]

    assert pred26({:var, "X"}, {:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}}
           ]

    assert pred26({:ground, 1}, {:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred26({:ground, 2}, {:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred27" do
    assert pred27().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred28" do
    assert pred28().(%{}) |> Enum.into([]) == []
  end

  test "Checks pred30" do
    assert pred30({:ground, 1}).(%{}) |> Enum.into([]) == []
    assert pred30({:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred30({:ground, 3}).(%{}) |> Enum.into([]) == [%{}]

    assert catch_throw(pred30({:var, "X"}).(%{}) |> Enum.into([])) ==
             "#{"X"} is not instantiated"
  end

  test "Checks pred31" do
    assert pred31().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred32" do
    assert pred32({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred32({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert pred32({:ground, [1]}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred33" do
    assert pred33({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, [1, 2]}}]
    assert pred33({:ground, [1, 2]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred33({:ground, []}).(%{}) |> Enum.into([]) == []
    assert pred33({:ground, [1]}).(%{}) |> Enum.into([]) == []
    assert pred33({:ground, [2, 3]}).(%{}) |> Enum.into([]) == []
    assert pred33({:ground, [2, 3, 4]}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred34" do
    assert pred34({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, [1, 2, 3]}}
           ]

    assert pred34({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"Y" => {:ground, [1, 2, 3]}}
           ]

    assert pred34({:var, "X"}, {:ground, [1, 2, 3]}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}}
           ]

    assert pred34({:ground, 1}, {:ground, [1, 2, 3]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred34({:ground, 5}, {:var, "Y"}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred35" do
    assert pred35({:var, "X"}).(%{}) |> Enum.into([]) != []
    assert pred35({:ground, []}).(%{}) |> Enum.into([]) == []
    assert pred35({:ground, [1]}).(%{}) |> Enum.into([]) == []
    assert pred35({:ground, [1, 2]}).(%{}) |> Enum.into([]) == []
    assert pred35({:ground, [1, 2, 3]}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred36" do
    assert pred36({:var, "X"}, {:var, "Y"}, {:var, "Z"}, {:var, "T"}).(%{}) |> Enum.into([]) != []

    assert pred36({:var, "X"}, {:ground, 3}, {:ground, 4}, {:ground, 5}).(%{}) |> Enum.into([]) ==
             [%{"X" => {:ground, [3, 4, 5]}}]

    assert pred36({:ground, [3, 4, 5]}, {:var, "Y"}, {:var, "Z"}, {:var, "T"}).(%{})
           |> Enum.into([]) == [%{"Y" => {:ground, 3}, "Z" => {:ground, 4}, "T" => {:ground, 5}}]
  end

  test "Checks pred37" do
    assert pred37({:var, "X"}).(%{}) |> Enum.into([]) != []
    assert pred37({:ground, [1]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred37({:ground, 1}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred38" do
    assert pred38({:var, "X"}).(%{}) |> Enum.into([]) != []
    assert pred38([{:var, "X"}, {:ground, 2} | {:ground, []}]).(%{}) |> Enum.into([]) != []
    assert pred38([{:ground, 2}, {:var, "X"} | {:ground, []}]).(%{}) |> Enum.into([]) != []
    assert pred38({:ground, [1, 2]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred38({:ground, [1]}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred39" do
    assert pred39().(%{}) |> Enum.into([]) == []
  end

  test "Checks pred40" do
    assert pred40({:var, "X"}).(%{}) |> Enum.into([]) != []
    assert pred40({:ground, []}).(%{}) |> Enum.into([]) == [%{}]
    assert pred40({:ground, [1]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred40({:ground, [1, 2]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred40({:ground, [1, 2, 3]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred40([{:var, "X"} | {:ground, []}]).(%{}) |> Enum.into([]) != []
    assert pred40([{:var, "X"}, {:var, "Y"} | {:ground, []}]).(%{}) |> Enum.into([]) != []
    assert pred40([{:var, "X"}, {:var, "X"} | {:ground, []}]).(%{}) |> Enum.into([]) != []
    assert pred40([{:var, "X"}, {:ground, 2} | {:ground, []}]).(%{}) |> Enum.into([]) != []

    assert pred40([{:var, "X"}, {:var, "Y"}, {:var, "Z"} | {:ground, []}]).(%{}) |> Enum.into([]) !=
             []
  end

  test "Checks pred41" do
    assert pred41().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks pred42" do
    assert pred42({:ground, []}).(%{}) |> Enum.into([]) == [%{}]
    assert pred42({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, []}}]
    assert pred42({:ground, [1]}).(%{}) |> Enum.into([]) == []
    assert pred42({:ground, 1}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred43" do
    assert pred43({:var, "X"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}},
             %{"X" => {:ground, 2}},
             %{"X" => {:ground, 3}},
             %{"X" => {:ground, 4}},
             %{"X" => {:ground, 5}}
           ]

    assert pred43({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert pred43({:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred43({:ground, 3}).(%{}) |> Enum.into([]) == [%{}]
    assert pred43({:ground, 4}).(%{}) |> Enum.into([]) == [%{}]
    assert pred43({:ground, 5}).(%{}) |> Enum.into([]) == [%{}]
    assert pred43({:ground, 6}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred44" do
    assert pred44({:var, "X"}, {:var, "Y"}, {:var, "Z"}, {:var, "T"}).(%{}) |> Enum.into([]) != []

    assert pred44({:var, "X"}, {:ground, 1}, {:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([]) ==
             [%{"X" => {:ground, [1, 2 | 3]}}]

    assert pred44({:var, "X"}, {:ground, 1}, {:ground, 2}, {:ground, []}).(%{}) |> Enum.into([]) ==
             [%{"X" => {:ground, [1, 2]}}]

    assert pred44({:ground, [1, 2]}, {:var, "Y"}, {:var, "Z"}, {:var, "T"}).(%{}) |> Enum.into([]) ==
             [%{"Y" => {:ground, 1}, "Z" => {:ground, 2}, "T" => {:ground, []}}]

    assert pred44({:ground, [1]}, {:var, "Y"}, {:var, "Z"}, {:var, "T"}).(%{}) |> Enum.into([]) ==
             []
  end

  test "Checks pred45" do
    assert pred45({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, {7, 8}}}]
    assert pred45({:ground, {7, 8}}).(%{}) |> Enum.into([]) == [%{}]
    assert pred45({:ground, {3, 4}}).(%{}) |> Enum.into([]) == []
    assert pred45({:ground, 1}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred46" do
    assert pred46({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, [5]}}]
    assert pred46({:ground, [5]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred46({:ground, 5}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred47" do
    assert pred47({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, [5, 7]}}]
    assert pred47({:ground, [5, 7]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred47({:ground, {5, 7}}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred48" do
    assert pred48({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, [5, 7, 9]}}]
    assert pred48({:ground, [5, 7, 9]}).(%{}) |> Enum.into([]) == [%{}]
    assert pred48({:ground, {5, 7, 9}}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred49" do
    assert pred49({:var, "X"}, {:var, "Y"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, 1}, "Y" => {:ground, 2}}
           ]

    assert pred49({:ground, 1}, {:var, "Y"}).(%{}) |> Enum.into([]) == [%{"Y" => {:ground, 2}}]
    assert pred49({:var, "X"}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred49({:ground, 1}, {:ground, 2}).(%{}) |> Enum.into([]) == [%{}]
    assert pred49({:ground, 3}, {:ground, 2}).(%{}) |> Enum.into([]) == []
    assert pred49({:ground, 1}, {:ground, 7}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred50" do
    assert pred50({:var, "X"}).(%{}) |> Enum.into([]) == [%{"X" => {:ground, 1}}]
    assert pred50({:ground, 1}).(%{}) |> Enum.into([]) == [%{}]
    assert pred50({:ground, 5}).(%{}) |> Enum.into([]) == []
  end

  test "Checks pred51" do
    assert pred51().(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks is_ordered" do
    assert is_ordered({:ground, []}).(%{}) |> Enum.into([]) == [%{}]
    assert is_ordered({:ground, [1]}).(%{}) |> Enum.into([]) == [%{}]
    assert is_ordered({:ground, [1, 2]}).(%{}) |> Enum.into([]) == [%{}]
    assert is_ordered({:ground, [1, 3]}).(%{}) |> Enum.into([]) == [%{}]
    assert is_ordered({:ground, [1, 2, 3]}).(%{}) |> Enum.into([]) == [%{}]
    assert is_ordered({:ground, [1, 3, 2]}).(%{}) |> Enum.into([]) == []
    assert is_ordered({:ground, 1..100 |> Enum.to_list()}).(%{}) |> Enum.into([]) == [%{}]
  end

  test "Checks append" do
    assert append({:ground, []}, {:ground, [1]}, {:var, "X"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, [1]}}
           ]

    assert append({:ground, [1, 2]}, {:ground, [3]}, {:var, "X"}).(%{}) |> Enum.into([]) ==
             [%{"X" => {:ground, [1, 2, 3]}}]

    assert append({:ground, [1]}, {:ground, []}, {:var, "X"}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, [1]}}
           ]

    assert append({:var, "X"}, {:ground, []}, {:ground, [1]}).(%{}) |> Enum.into([]) == [
             %{"X" => {:ground, [1]}}
           ]
  end
end
