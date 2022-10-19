defmodule LogicElixirTest do
  use ExUnit.Case
  doctest LogicElixir

  test "greets the world" do
    assert LogicElixir.hello() == :world
  end
end
