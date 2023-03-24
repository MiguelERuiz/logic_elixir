defmodule Template do
  # import VarBuilder
  import Core
  # require Core

  defcore pred(X) do
    X = 5
    @(IO.puts({:var, "X"}))
  end

  defcore append(Xs, Ys, Zs) do
    choice do
      Xs = []
      Ys = Zs
    else
      Xs = [X | XX]
      Zs = [X | ZZ]
      append(XX, Ys, ZZ)
    end
  end
end
