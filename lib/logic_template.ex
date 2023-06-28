defmodule LogicTemplate do
  use LogicElixir

  # TODO now we are not going to support predicates with different number of args
  # defpred likes(:tim, :rugby, 30)

  #############
  #   Facts   #
  #############

  defpred person(:sussie)

  defpred person(:mike)

  defpred person(:john)

  defpred person(:paul)

  defpred person(:mary)

  defpred animal(:bucky)

  defpred animal(:gladys)

  defpred likes(:sussie, :pizza)

  defpred likes(:bucky, :pizza)

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

  #############
  #   Rules   #
  #############

  defpred pizza_lover(X) do
    person(X)
    likes(X, :pizza)
  end

  defpred number(X) do
    @(is_number(X))
  end

  defpred siblings(X, Y) do
    father_of(Z, X)
    father_of(Z, Y)
  end

  defpred append([], Ys, Ys)

  defpred append([X|Xs], Ys, [X|Zs]) do
    append(Xs, Ys, Zs)
  end

  defpred is_ordered([])

  defpred is_ordered([X | []])

  defpred is_ordered([X | [Y | Ys]]) do
    @(X <= Y)
    is_ordered([Y | Ys])
  end
end
