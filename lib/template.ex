defmodule Template do
  use Core

  defcore pred() do
  end

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
      X = 3
    else
      X = 4
    else
      X = 5
    end
  end

  defcore pred8(X) do
    choice do
      pred6(X)
    else
      pred7(X)
    end
  end

  defcore pred9(X, Y) do
    choice do
      X = 1
    else
      X = 2
    end

    Y = 3
  end

  defcore pred10(X, Y) do
    choice do
      X = 1
      Y = 3
    else
      X = 2
      Y = 4
    end
  end

  defcore pred11() do
    pred1(1)
  end

  defcore pred12(X) do
    pred1(X)
  end

  defcore pred13() do
    pred1(X)
  end

  def f(x, y), do: x + y

  defcore pred14(X) do
    X = f(3, 4)
  end

  defcore pred15(Z) do
    X = 3
    Y = 4
    Z = f(X, Y)
  end

  defcore pred16(X, Y) do
    {X, Y} = {1, 2}
  end

  defcore pred17(X, Y) do
    {Z, T} = {X, Y}
  end

  defcore pred18(X, Y) do
    choice do
      {X, Y} = {1, 3}
    else
      {X, Y} = {2, 4}
    end
  end

  defcore pred19(X) do
    X = {Y, Z}
  end

  defcore pred20(Xs) do
    Xs = [2 | []]
  end

  defcore pred21(Xs) do
    Xs = [2 | [4]]
  end

  defcore pred22(Xs) do
    Xs = [2 | [4 | [6]]]
  end

  defcore pred23(Xs, Ys) do
    [Xs | Ys] = [1 | []]
  end

  defcore pred24(Xs, Ys, Zs) do
    [Xs | [Ys | Zs]] = [1, 2, 3]
  end

  defcore pred25(X) do
    X = {1, 2, 3}
  end

  defcore pred26(X, Y, Z) do
    [X, Y, Z] = [1, 2, 3]
  end

  defcore pred27() do
    [X, Y, Z] = [1, 2, 3]
  end

  defcore pred28() do
    [X, Y, Z, T] = [1, 2, 3]
  end

  defcore pred29(X) do
    X = [[1, 2, 3]]
  end

  defcore pred30(X) do
    @(X >= 2)
  end

  defcore pred31() do
    X = 3
    @(X > 2)
  end

  defcore pred32(X) do
    [X] = [1 | []]
  end

  defcore pred33(X) do
    X = [1 | [2 | []]]
  end

  defcore pred34(X, Y) do
    X = 1
    Y = [X | [2 | [3 | []]]]
  end

  defcore pred35(X) do
    X = [Y | [Z | [T]]]
  end

  defcore pred36(X, Y, Z, T) do
    X = [Y | [Z | [T]]]
  end

  defcore pred37(Xs) do
    Xs = [X | []]
  end

  defcore pred38(Xs) do
    Xs = [X | [Y]]
  end

  defcore pred39() do
    [1, 2] = [X]
  end

  defcore pred40(X) do
    choice do
      X = []
    else
      X = [Y | []]
    else
      X = [Y | [Z]]
    else
      X = [Y | [Z | [T]]]
    end
  end

  defcore pred401(X) do
    choice do
      X = []
    else
      X = [Y | []]
    else
      X = [Y | [Z]]
    else
      X = [Y | [Z | T]]
    end
  end

  defcore pred41() do
    1 = 1
  end

  defcore pred42(X) do
    X = []
  end

  defcore pred43(X) do
    choice do
      X = 1
    else
      X = 2
    else
      X = 3
    else
      X = 4
    else
      X = 5
    end
  end

  defcore pred44(X, Y, Z, T) do
    # [Y | [Z | T]] must be converted into [{:var, y1} | [{:var, y2} | {:var, y3}]]
    X = [Y | [Z | T]]
  end

  defcore pred45(X) do
    X = {7, 8}
  end

  defcore pred46(X) do
    X = [5]
  end

  defcore pred47(X) do
    X = [5, 7]
  end

  defcore pred48(X) do
    X = [5, 7, 9]
  end

  defcore pred49(X, Y) do
    [X | Y] = [1 | 2]
  end

  defcore is_ordered(Xs) do
    choice do
      Xs = []
    else
      Xs = [X | []]
    else
      Xs = [X | [Y | Ys]]
      @(X <= Y)
      is_ordered([Y | Ys])
    end
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
