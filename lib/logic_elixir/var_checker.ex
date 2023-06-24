defmodule LogicElixir.VarChecker do
  def is_logic_variable?({:__aliases__, _metadata, [logic_variable]})
  when is_atom(logic_variable),
  do: true

  def is_logic_variable?(_), do: false
end
