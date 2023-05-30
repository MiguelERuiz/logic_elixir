defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

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

  defmacro defpred({name, _metadata, args}) do
    quote do
      Module.put_attribute(__MODULE__, :definitions, {unquote(name), unquote(args)})
    end
  end

  defmacro __before_compile__(env) do
    definitions = Module.get_attribute(env.module, :definitions)
    grouped_definitions = definitions |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    Logger.info "definitions: #{inspect(definitions)}"
    Logger.info "grouped_definitions: #{inspect(grouped_definitions)}"
    for {name, args} <- definitions |> Enum.group_by(&elem(&1, 0), &elem(&1, 1)) do
      generate_defcore(name, args)
    end
  end

  defmacro __using__(_params) do
    quote do
      import LogicElixir, only: [defpred: 1]
      import Core
      Module.register_attribute(__MODULE__, :definitions, accumulate: true)
      @before_compile LogicElixir
    end
  end

  #############
  # Functions #
  #############

  def generate_defcore(pred_name, pred_facts) do
    case pred_facts do
      # [] -> generate_defcore_magic_body
      [fact] -> generate_defcore_simple_body(pred_name, fact)
      # _ -> generate_defcore_choice_body(pred_name, pred_facts)
      _ -> :ok
    end
  end

  ###############################
  #  Public auxiliar functions  #
  ###############################

  def to_core(t) when is_tuple(t), do: t
  def to_core(lit), do: {:ground, lit}

  #####################
  # Private Functions #
  #####################

  defp generate_defcore_simple_body(pred_name, pred_facts) do
    defcore_args =
      1..length(pred_facts)
      |> Enum.map(fn x -> {:__aliases__, [], [String.to_atom(VarBuilder.gen_var)]} end)

    quote do
      defcore unquote({pred_name, [], defcore_args}) do
        unquote({:__block__, [],
                  pred_facts
                  |> Enum.zip(defcore_args)
                  |> Enum.map(fn {p, arg} -> quote do: unquote(p) = unquote(arg) end)
                })
        # TODO complete with potential patterns
      end
    end
  end
end
