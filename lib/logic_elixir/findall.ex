defmodule LogicElixir.Findall do
  @moduledoc """
  Module that provides `LogicElixir.Findall.findall/2` macro.
  """

  alias LogicElixir.Defcore
  alias LogicElixir.VarBuilder

  #########
  # Types #
  #########

  ##########
  # Guards #
  ##########

  ##########
  # Macros #
  ##########

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__), only: :macros
    end
  end

  defmacro findall(term, into: into_block, do: block) do
    tr_findall(term, block, into_block)
  end

  defmacro findall(term, do: block) do
    tr_findall(term, block)
  end

  #####################
  # Private Functions #
  #####################

  defp tr_findall(term, do_block, into_block \\ nil) do

    goals =
      case do_block do
        {:__block__, _metadata, do_stmts} -> do_stmts
        _ -> [do_block]
      end

    vars_goals = goals |> Defcore.vars()

    x_list =
      case vars_goals do
        [] ->
          []

        _ ->
          1..length(vars_goals)
          |> Enum.map(fn x -> String.to_atom("x#{x}") |> Macro.unique_var(__MODULE__) end)
      end

    delta = Enum.zip(vars_goals, x_list) |> Enum.into(%{})

    sol = Macro.unique_var(:sol, __MODULE__)
    t = Macro.unique_var(:t, __MODULE__)

    quote do
      unquote(
          {:__block__, [],
           x_list |> Enum.map(fn x -> quote do: unquote(x) = VarBuilder.gen_var() end)}
        )

      solutions = unquote(Defcore.tr_goals(delta, goals)).(%{})
        |> Stream.map(
            fn unquote(sol) ->
              unquote(t) = unquote(Defcore.tr_term(delta, sol, term))
              Defcore.groundify(unquote(sol), unquote(t))
            end
        )

      case unquote(into_block) do
        nil -> solutions
        _ -> solutions |> Enum.into(unquote(into_block))
      end
    end
  end
end
