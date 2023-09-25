# LogicElixir

A DSL to write logic programs in Elixir

## Installation

Add `:logic_elixir` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:logic_elixir, "~> 0.1.0"}
  ]
end
```

After that, run `mix deps.get`

## How to use

Declare the `use LogicElixir` expression inside your module, as below:

```elixir
defmodule LogicModule do
  use LogicElixir

  defpred p(5)
end
```

### Supported terms

This version supports a reduced set of Elixir terms and must be used as follows:

```elixir
  LogicElixir.t() :: integer()
                    | atom()
                    | float()
                    | tuple()
                    | [t()]
```

Keep in mind that uppercase atoms such as `X`, `Character`, etc. are used to
represent logic variables.

### Declaring predicates

`LogicElixir` offers `defpred` macro to declare your logic predicates, and
supports both declaring logic facts and rules, as the following examples:

```elixir
defmodule MiddleEarth do
  use LogicElixir

  # Facts
  defpred hobbit(:frodo)
  defpred hobbit(:sam)
  defpred hobbit(:bilbo)

  defpred wizard(:gandalf)
  defpred wizard(:saruman)

  defpred elf(:legolas)

  # Rules

  defpred fellow(X) do
    # To make a disjunction of goals, use `choice` operator
    choice do
      X = :frodo # Unification of LogicElixir terms
    else
      X = :sam
    else
      X = :legolas
    else
      X = :gandalf
    end
  end

  # Predicates to operate with data structures

  defpred append([], Ys, Ys)

  defpred append([X|Xs], Ys, [X|Zs]) do
    append(Xs, Ys, Zs)
  end

  defpred is_ordered([])

  defpred is_ordered([X | []])

  defpred is_ordered([X | [Y | Ys]]) do
    @(X <= Y)               # Elixir expression evaluation with @ operator
    is_ordered([Y | Ys])
  end
end
```

A full repository with examples can be found [here](https://github.com/MiguelERuiz/logic_elixir_examples)

### Querying predicates

`LogicElixir` offers `findall` macro to make queries of your logic predicates.
This macro receives three arguments:

- A `LogicElixir` term
- A `LogicElixir` goal sequence
- An optional `Enumerable` term to get the results of the query

`findall` outputs a Stream with the solution of the query or the result inside
the optional `Enumerable` term. Here there are examples of declaring this macro:

```elixir
  findall Hobbit, do: hobbit(Hobbit) # without optional Enumerable term
  findall X do
    hobbit(X)
    fellow(X)
  end
  findall X, into: [], do: (hobbit(X) ; fellow(X))
  findall Hobbit, into: [], do: hobbit(Hobbit)
```

It's useful to encapsulate this macro inside an Elixir function to get the
results, as the following examples:

```elixir
defmodule MiddleEarth do
  use LogicElixir
  # ...
  def hobbits do
    findall Hobbit, do: hobbit(Hobbit)
  end
end
```

If you open an `iex -S mix` session, you can get the result:

```elixir
  iex(1)> MiddleEarth.hobbits
  #Stream<[
  enum: #Function<60.124013645/2 in Stream.transform/3>,
  funs: [#Function<48.124013645/1 in Stream.map/2>]
  ]>
  iex(2)> MiddleEarth.hobbits |> Enum.take(1)
  [:frodo]
```

Besides, you can declare Elixir functions that receive arguments and use it
inside:

```elixir
defmodule LogicLists do
  use LogicElixir

  defpred append([], Ys, Ys)

  defpred append([X|Xs], Ys, [X|Zs]) do
    append(Xs, Ys, Zs)
  end

  def pairs_of_lists(x) do
    (findall {X, Y}, into: [], do: append(X, Y, x))
  end
end
```

Again, you can test it in your Elixir shell:

```elixir
  iex(1)> LogicLists.pairs_of_lists([1,2,3,4,5])
  [
    {[], [1, 2, 3, 4, 5]},
    {[1], [2, 3, 4, 5]},
    {[1, 2], [3, 4, 5]},
    {[1, 2, 3], [4, 5]},
    {[1, 2, 3, 4], [5]},
    {[1, 2, 3, 4, 5], []}
  ]
```