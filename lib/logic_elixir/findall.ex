defmodule LogicElixir.Findall do
  @moduledoc """
  Module that provides `LogicElixir.Findall.findall/2` macro.
  """

  alias LogicElixir.Defcore
  alias LogicElixir.VarBuilder
  require Logger

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

  defmacro findall(term, do: block) do
    tr_findall(term, block)
  end

  #####################
  # Private Functions #
  #####################

  defp tr_findall(term, do_block) do
    Logger.warn "tr_findall/2"
    Logger.info "term = #{inspect(term)}"
    # Logger.info "do_block = #{inspect(do_block)}"
    goals =
      case do_block do
        {:__block__, _metadata, do_stmts} -> do_stmts
        _ -> [do_block]
      end

    # Logger.info "goals = #{inspect(goals)}"

    vars_goals = goals |> Defcore.vars()

    # Logger.info "vars_goals = #{inspect(vars_goals)}"

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

    ast = quote do
      unquote(
          {:__block__, [],
           x_list |> Enum.map(fn x -> quote do: unquote(x) = VarBuilder.gen_var() end)}
        )

      unquote(Defcore.tr_goals(delta, goals)).(%{})
        |> Stream.map(
            fn unquote(sol) ->
              unquote(t) = unquote(Defcore.tr_term(delta, sol, term))
              Defcore.groundify(unquote(sol), unquote(t))
            end
        )
    end

    # ast |> Macro.to_string |> IO.puts

    ast
  end
end
