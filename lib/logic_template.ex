defmodule LogicTemplate do
  use LogicElixir

  # TODO now we are not going to support predicates with different number of args
  # defpred likes(:tim, :rugby, 30)

  defpred person(:sussie)

  defpred person(:mike)

  defpred person(:john)

  defpred person(:paul)

  defpred person(:mary)

  defpred animal(:gladys)

  defpred likes(:sussie, :pizza)

  defpred likes(:sussie, :sushi)

  defpred likes(:mike, :football)

  defpred age(:john, 50)

  defpred age(:paul, 30)

  defpred age(:mary, 20)

  defpred father_of(:john, :paul)

  defpred father_of(:john, :mary)

  defpred boils(:water, 100)

  defpred sunny()

  defpred water_wets()

  defpred is_funny(:painting)

  defpred is_funny(:hiking)

  defpred pizza_lover(X) do
    likes(X, :pizza)
  end

  defpred number(X) do
    @(is_number(X))
  end
  # TODO improve predicate. Take in mind other examples
  defpred siblings(X, Y) do
    person(X)
    person(Y)
    person(Z)
    father_of(Z, X)
    father_of(Z, Y)
  end

  # TODO support this predicate
  # defpred append([], Ys, Ys)

  # defpred append([X|Xs], Ys, [X|Zs]) do
  #   append(Xs, Ys, Zs)
  # end
end
