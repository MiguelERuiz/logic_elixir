defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """
  require Logger
  require IEx

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

  defmacro defpred(head) do
    {pred_name, args_ast} = Macro.decompose_call(head)
    quote do
      Module.put_attribute(__MODULE__, :definitions, {unquote(pred_name), unquote(args_ast)})
    end
  end

  defmacro defpred(head, body) do
    # Logger.warn "defpred with do block"
    {pred_name, args_ast} = Macro.decompose_call(head)
    # Logger.info "pred_name = #{inspect(pred_name)}"
    # Logger.info "args_ast = #{inspect(args_ast)}"
    # Logger.info "body = #{inspect(body)}"
    # Logger.info "do_block = #{inspect(body[:do])}"
    # Logger.info "caller_module = #{inspect(__CALLER__.module)}"
    # Logger.info "caller_functions = #{inspect(__CALLER__.module.functions)}"
    quote do
      do_block = unquote(Macro.escape(body[:do]))
      Module.put_attribute(__MODULE__, :definitions, {unquote(pred_name), {unquote(args_ast), do_block}})
    end
  end

  defmacro __before_compile__(env) do
    # TODO On first `iex -S mix` command, this line is necessary,
    # otherwise application crashes. Probably this is due to
    # VarBuilder's Agent nature.
    VarBuilder.start_link

    definitions = Module.get_attribute(env.module, :definitions)
    grouped_defs =  definitions |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    # Logger.info "definitions = #{inspect(definitions)}"
    # Logger.info "grouped_defs = #{inspect(grouped_defs)}"
    # TODO change this 2-size tuple with a 3-size tuple that contains {name, args, do_block}
    for {name, args} <- grouped_defs do
      generate_defcore(name, args)
    end
  end

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__), only: :macros
      use Core
      Module.register_attribute(__MODULE__, :definitions, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  #############
  # Functions #
  #############

  # Calls used by Utils.to_defcore/1
  def generate_defcore({:defpred, _defpred_metadata, [{pred_name, _metadata, []}]}) do
    generate_defcore(pred_name, [[]])
  end

  def generate_defcore({:defpred, _defpred_metadata, [{pred_name, _metadata, defpred_args}]}) when is_list(defpred_args) and not is_list(hd(defpred_args)) do
    generate_defcore(pred_name, [defpred_args])
  end

  def generate_defcore({:defpred, _defpred_metadata, [{pred_name, _metadata, defpred_args}]}) do
    generate_defcore(pred_name, defpred_args)
  end

  def generate_defcore({:defpred, _defpred_metadata, [{pred_name, _metadata, defpred_args}, [do: do_block]]}) do
    generate_defcore(pred_name, [{defpred_args, do_block}])
  end

  def generate_defcore({:defpred, _defpred_metadata, [{pred_name, _metadata, defpred_args}, do_block]}) do
    generate_defcore(pred_name, [{defpred_args, do_block}])
  end
  # End Calls used by Utils.to_defcore/1

  def generate_defcore(pred_name, pred_facts) do
    # Logger.warn "GENERATE DEFCORE!!"
    # Logger.info "pred_name = #{inspect(pred_name)}"
    # Logger.info "pred_facts = #{inspect(pred_facts)}"

    {defcore_args, facts} =
      case pred_facts do
        [[]] -> {[], []}
        [{args, _do_block} | _] ->
          {gen_vars(args), pred_facts}
        _ ->
          [args0 | _] = pred_facts
          {gen_vars(args0), pred_facts}
      end

    quote do
      defcore unquote(pred_name)(unquote_splicing(defcore_args)) do
        unquote{:choice, [], choice_block(facts, defcore_args)}
      end
    end
  end

  ###############################
  #  Public auxiliar functions  #
  ###############################

  #####################
  # Private Functions #
  #####################
  defp choice_block(facts_list, defcore_args) do
    # Logger.warn "CHOICE_BLOCK"
    # Logger.info "facts_list = #{inspect(facts_list)}"
    # Logger.info "defcore_args = #{inspect(defcore_args)}"
    choice_stmts = facts_list |> Enum.map(&choice_stmt(&1, defcore_args))
    choice_block = case choice_stmts do
      [] -> [do: {:__block__, [], []}]
      [do_stmt | else_stmts] ->
        choice_do_stmt = {:do, do_stmt}
        choice_else_stmts = else_stmts
                            |> Enum.map(&{:else, &1})
        List.flatten([choice_do_stmt, choice_else_stmts])
    end
    [
      choice_block
    ]
  end

  defp choice_stmt({facts, do_block}, defcore_args) do
    # Logger.warn "CHOICE STMT"
    # Logger.info "do_block = #{inspect(do_block)}"
    {:__block__, [],
              List.flatten([facts
              |> Enum.zip(defcore_args)
              |> Enum.map(fn {p, arg} -> quote do: unquote(p) = unquote(arg) end), process_block(do_block)])
    }
  end

  defp choice_stmt(facts, defcore_args) do
    # Logger.warn "CHOICE_STMT"
    # Logger.info "facts = #{inspect(facts)}"
    # Logger.info "defcore_args = #{inspect(defcore_args)}"
    {:__block__, [],
              facts
              |> Enum.zip(defcore_args)
              |> Enum.map(fn {p, arg} -> quote do: unquote(p) = unquote(arg) end)
    }
  end

  defp process_block({:__block__, _metadata, stmt_block}) do
    # Logger.warn "PROCESS BLOCK"
    # Logger.info "do_block = #{inspect(do_block)}"
    stmt_block
  end

  defp process_block(stmt) do
    # Logger.warn "PROCESS BLOCK OTHERWISE"
    # Logger.info "stmt = #{inspect(stmt)}"
    [stmt]
  end

  defp gen_vars([]), do: []

  defp gen_vars(args) do
    1..length(args)
    |> Enum.map(fn _x -> {:__aliases__, [], [:"#{VarBuilder.gen_var}"]} end)
  end
end
