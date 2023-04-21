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


  # (CompileError) The call Elixir.Template.f({'ground', 3}, {'ground', 4}) will never return
  # since it differs in the 1st and 2nd argument from the sucess type arguments (number(), number())

  def f(x, y), do: x + y

  # defcore pred141() do
  #   f(3, 4)
  # end

  # (CompileError) Invalid call groundify(th, {'var', y1})
  defcore pred14(Z) do
    X = 3
    Y = 4
    Z = f(X, Y)
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

  defcore cosa(Xs, Ys, Zs) do
    Xs = [2 | 4]
  end

  # (CompileError) invalid call build_tuple(var: x1, var: x2)
  defcore pred16(X, Y) do
    {X, Y} = {1, 2}
  end

  # (CompileError) invalid call build_tuple(var: y1, var: y2)
  # defcore pred17(X, Y) do
  #   {Z, T} = {X, Y}
  # end

  # (CompileError)  invalid call build_tuple(var: x1, var: x2)
  # defcore pred18(X, Y) do
  #   choice do
  #     {X, Y} = {1, 3}
  #   else
  #     {X, Y} = {2, 4}
  #   end
  # end

  defcore pred19() do
    pred1(X)
  end

  # (CompileError) invalid call build_tuple(var: y1, var: y2)
  # defcore pred20(X) do
  #   X = {Y, Z}
  # end

  # defcore pred21(X) do
  #   X = [1, 2, 3]
  # end

  # (CompileError) invalid call build_list({:var, x1}, build_list({:var, x2}, build_list({:var, x3}, [])))
  # defcore pred22(X, Y, Z) do
  #   [X, Y, Z] = [1, 2, 3]
  # end

  # (CompileError) invalid call build_list({:var, y1}, build_list({:var, y2}, build_list({:var, y3}, [])))
  # defcore pred23() do
  #   [X, Y, Z] = [1, 2, 3]
  # end

  # (CompileError) invalid call build_list({:var, y1}, build_list({:var, y2}, build_list({:var, y3}, build_list({:var, y4}, []))))
  # defcore pred24() do
  #   [X, Y, Z, T] = [1, 2, 3]
  # end

  # (CompileError) invalid call build_list(build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, []))), [])
  # defcore pred25(X) do
  #   X = [[1, 2, 3]]
  # end

  # (CompileError) invalid call check_b(th, groundify(
#     th,
#     (
#       (
#         x1 = groundify(th, {:ground, 3})
#         x2 = groundify(th, {:ground, 4})
#       )

#       {:ground, g(x1, x2)}
#     )
#   )
# )
  # defcore pred26() do
  #   @(g(3, 4))
  # end

  defcore pred29(X) do
    X = [1 | []]
  end

  defcore pred30(X) do
    X = [1 | [2]]
  end

  # (CompileError) invalid call groundify(th, {:ground, 2})
  # defcore pred31(X) do
  #   X = [1 | [2 | []]]
  # end

  # (CompileError) invalid call groundify(th, {:ground, 2})
  # defcore pred32(X, Y) do
  #   X = 1
  #   Y = [X | [2 | [3 |[]]]]
  # end

  # (CompileError) invalid call groundify(th, {:var, nil})
  # defcore is_ordered(Xs) do
  #   choice do
  #     Xs = []
  #   else
  #     Xs = [X | []]
  #   else
  #     Xs = [X | [Y | [Ys]]]
  #     @(X <= Y)
  #     is_ordered([Y | [Ys]])
  #   end
  # end

  # (CompileError) invalid call groundify(th, {:var, x3})
  # defcore pred33(X, Y, Z, T) do
  #   X = [Y | [Z | [T]]]
  # end
end
