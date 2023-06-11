defmodule Utils do
  require Logger

  @spec get_ast(atom()) :: nil | tuple()
  def get_ast(pred_name, template_file \\ "lib/template.ex") do
    {:ok, ast_template} = load_template(template_file)
    {_defmodule, _metadata_module, body} = ast_template
    [_template, [do: {:__block__, [], inner_body}]] = body
    [_use | lines] = inner_body

    ast =
      lines
      |> Enum.filter(fn {_operator, _metadata_defcore, [{defcore_fun, _metadata_fun, _args} | _]} ->
        defcore_fun == pred_name
      end)

    case ast do
      [] -> nil
      [result] -> result
      _ -> ast
    end
  end

  @spec to_def(atom()) :: :ok
  def to_def(pred_name) do
    ast = get_ast(pred_name)

    case ast do
      nil ->
        Logger.error("(to_def) Error: no #{pred_name} function found on template")

      {:def, _metadata, _} ->
        ast |> Macro.to_string() |> IO.puts()

      {:defcore, _metadata, _} ->
        ast |> Core.tr_def() |> Macro.to_string() |> IO.puts()
    end
  end

  @spec to_defcore(atom()) :: :ok
  def to_defcore(pred_name) do
    ast = get_ast(pred_name, "lib/logic_template.ex")

    case ast do
      nil ->
        Logger.error "(to_defcore) Error: no #{pred_name} predicate found on logic template"
      {:defpred, _metadata, _} ->
        ast |> LogicElixir.generate_defcore |> Macro.to_string |> IO.puts
      _ ->
        joint_args = ast
        |> Enum.map(
            fn {:defpred, _metadata, [{_pred_name, _metadata_pred_name, args}]} ->
              args
            end)
        {:defpred, [], [{pred_name, [], joint_args}]}
        |> LogicElixir.generate_defcore
        |> Macro.to_string
        |> IO.puts
    end
  end

  @spec load_template(binary()) :: {:ok, tuple()}
  defp load_template(template_file) do
    template_file
    |> File.read!()
    |> Code.string_to_quoted()
  end
end
