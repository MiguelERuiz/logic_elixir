defmodule LogicTemplate do
  use LogicElixir

  defpred likes(:sussie, :pizza)

  defpred likes(:sussie, :sushi)

  defpred likes(:mike, :football)

  defpred likes(:tim, :rugby, 30)

  defpred age(:john, 50)

  # defpred age(:paul, 30)

  # defpred age(:mary, 20)

  defpred father_of(:john, :paul)

  defpred sunny()

  # defpred father_of(:john, :mary)

  # defpred siblings(X, Y) do
  #   father_of(Z, X)
  #   father_of(Z, Y)
  # end

  # defpred append([], Ys, Ys)

  # defpred append([X|Xs], Ys, [X|Zs]) do
  #   append(Xs, Ys, Zs)
  # end
end
