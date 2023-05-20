defmodule Utils do
  require Logger

  @spec load_template() :: {:ok, tuple()}
  def load_template do
    "lib/template.ex"
    |>
    File.read!
    |>
    Code.string_to_quoted
  end

  @spec get_ast(atom()) :: nil | tuple()
  def get_ast(pred_name) do
    {:ok, ast_template} = load_template()
    {_defmodule, _metadata_module, body} = ast_template
    [_template, [do: {:__block__, [], inner_body}]] = body
    [_use | lines] = inner_body
    ast = lines
    |>
    Enum.find(
      fn {_operator, _metadata_defcore, [{defcore_fun, _metadata_fun, _args} | _]} ->
          defcore_fun == pred_name
      end
    )
    case ast do
      nil -> nil
      _ -> ast
    end
  end

  @spec to_def(atom()) :: :ok
  def to_def(pred_name) do
    ast = get_ast(pred_name)
    case ast do
      nil ->
        Logger.error "(to_def) Error: no #{pred_name} function found on template"
      {:def, _metadata, _} -> ast |> Macro.to_string |> IO.puts
      {:defcore, _metadata, _} -> ast |> Core.trace_defcore
    end
  end
end
