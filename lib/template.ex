defmodule Template do
  import Core

  defcore pred1(X) do
    X = 5
  end

  defcore pred2(X, Y) do
    X = 5
    Y = 6
  end

  defcore pred3(X, Y) do
    X = Z
    Y = Z
  end

  defcore pred4(X) do
    Z = X
  end

  defcore pred5() do
    Z = 1
  end

  defcore pred6(X) do
    choice do
      X = 1
    else
      X = 2
    end
  end

  defcore pred7(X) do
    choice do
      X = 1
    else
      X = 2
    else
      X = 3
    end
  end

  defcore pred8(X, Y) do
    choice do
      X = 1
    else
      X = 2
    end
    Y = 3
  end

  defcore pred9(X, Y) do
    choice do
      X = 1
      Y = 3
    else
      X = 2
      Y = 4
    end
  end

  defcore pred10(X) do
    X = [X1 | X2]
  end

  defcore pred11() do
    X = [X1 | X2]
  end

  defcore pred12() do
    pred1(1)
  end

  defcore pred13(X) do
    pred1(X)
  end
end
