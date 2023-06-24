# LogicElixir

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `logic_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:logic_elixir, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/logic_elixir>.

## Debugging defcore

`defcore` macro generates an Elixir function. This function returns a lambda function that receives an empty substitution - which is %{} - and returns the
following results:

- `[]`, which represents `false` in Prolog.
- `[%{}]`, which represents `true` in Prolog.
- Otherwise, it returns a list with an unique element which contains the possible
substitutions of all the variables.

Since it's possible to want to know the format of the functions themselves, it's
possible to do it with the `Core.trace_defcore` function, which receives the
AST of the defcore function and returns the Elixir function we are going to run.

Below there is an example of how to use it:

```elixir
iex(1)> ast = quote do
...(1)> defcore pred14(X) do
...(1)>     X = f(3, 4)
...(1)>   end
...(1)> end
iex(2)> ast |> Core.trace_defcore
```

Copy the generated function inside a module, for instance Example module. To
run it, just do the following steps:

```elixir
iex(1)> LogicElixir.VarBuilder.start_link # Start the variable generator Agent
iex(2)> Example.pred14({:var, "X"}).(%{}) |> Enum.into([])
[%{"X" => {:ground, 7}}]
iex(3)>
```
