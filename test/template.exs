defmodule Template do
  import Core

  defcore pred(X) do
    X = 5
  end

  defcore pred2(X, Y) do
    X = 5,
    Y = 6
  end

  defcore pred3(X) do
    choice do
      X = 1
    else
      X = 2
    end
  end

  defcore pred4(X, Y) do
    (choice do
      X = 1
    else
      X = 2
    end),
    Y = 3
  end

  defcore pred5(X, Y) do
    X = Z,
    Y = Z
  end

  defcore append(XS, YS, ZS) do
    choice do
      Xs = [],
      Ys = Zs
    else
      Xs = [X|XX],
      Ys = [X|ZZ],
      append(XX, Ys, ZZ)
    end
  end
end
