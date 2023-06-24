defmodule LogicElixir.TermBuilder do
  def build_tuple(terms) do
    if Enum.all?(terms, &match?({:ground, _}, &1)) do
      {:ground,
       terms
       |> Enum.map(fn {:ground, t} -> t end)
       |> List.to_tuple()}
    else
      List.to_tuple(terms)
    end
  end

  def build_list({:ground, h}, {:ground, t}), do: {:ground, [h | t]}

  def build_list(h, t), do: [h | t]
end
