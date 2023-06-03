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
    VarBuilder.start_link # TODO Replace by adding supervisor tree on library
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

  def generate_defcore({:defpred, _defpred_metadata, [{pred_name, _metadata, defpred_args}]}) do
    generate_defcore(pred_name, [defpred_args])
  end

  def generate_defcore(pred_name, pred_facts) do
    Logger.info "pred_name: #{inspect(pred_name)}"

    {defcore_args, facts} =
      case pred_facts do
        [[]] -> {[], []}
        [args] -> {1..length(args)
                   |> Enum.map(fn _x -> {:__aliases__, [], [String.to_atom(VarBuilder.gen_var)]} end),
                   args}
        _ -> Logger.info "pred_facts: #{inspect(pred_facts)}"
            {[], []}
      end

    quote do
      defcore unquote(pred_name)(unquote_splicing(defcore_args)) do
        # TODO replace this block with a choice block
        unquote({:__block__, [],
                  facts
                  |> Enum.zip(defcore_args)
                  |> Enum.map(fn {p, arg} -> quote do: unquote(p) = unquote(arg) end)
                })
        # TODO complete with potential goals
      end
    end
  end

  ###############################
  #  Public auxiliar functions  #
  ###############################

  #####################
  # Private Functions #
  #####################
end
