defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """
  require Logger

  use Application

  #########################
  # Application callbacks #
  #########################

  @impl true
  def start(_type, _args) do
    LogicElixir.Supervisor.start_link(name: LogicElixir.Supervisor)
  end

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

  defmacro defpred({name, _metadata, args}, do: do_block) do
    quote do
      Module.put_attribute(__MODULE__, :definitions, {unquote(name), unquote(args), unquote(do_block)})
    end
  end

  defmacro __before_compile__(env) do
    definitions = Module.get_attribute(env.module, :definitions)
    grouped_defs =  definitions |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    Logger.info "definitions = #{inspect(definitions)}"
    Logger.info "grouped_defs = #{inspect(grouped_defs)}"
    for {name, args} <- grouped_defs do
      generate_defcore(name, args)
    end
  end

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__), only: :macros
      use Core
      # TODO On first `iex -S mix` command, this line is necessary,
      # otherwise application crashes. Probably this is due to
      # VarBuilder's Agent nature.
      VarBuilder.start_link
      Module.register_attribute(__MODULE__, :definitions, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  #############
  # Functions #
  #############

  def generate_defcore({:defpred, _defpred_metadata, [{pred_name, _metadata, defpred_args}]}) do
    generate_defcore(pred_name, [defpred_args])
  end

  def generate_defcore(pred_name, pred_facts) do
    Logger.warn "GENERATE DEFCORE"
    Logger.info "pred_name = #{inspect(pred_name)}"
    Logger.info "pred_facts = #{inspect(pred_facts)}"

    {defcore_args, facts} =
      case pred_facts do
        [[]] -> {[], []}
        [args] -> {gen_vars(args), args}
        _ ->
            [args0 | _] = pred_facts
            {gen_vars(args0), pred_facts}
      end

    quote do
      defcore unquote(pred_name)(unquote_splicing(defcore_args)) do
        # TODO replace this block with a choice block
        unquote(choice_block(facts, defcore_args))
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
  defp choice_block(facts, defcore_args) do
    {:choice, [], [
      [
        do: {:__block__, [],
              facts
              |> Enum.zip(defcore_args)
              |> Enum.map(fn {p, arg} -> quote do: unquote(p) = unquote(arg) end)
        }
      ]
    ]}
  end

  defp gen_vars([]), do: []

  defp gen_vars(args) do
    1..length(args)
    |> Enum.map(fn _x -> {:__aliases__, [], [:"#{VarBuilder.gen_var}"]} end)
  end
end
