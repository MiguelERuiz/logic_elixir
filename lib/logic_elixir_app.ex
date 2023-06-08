defmodule LogicElixirApp do
  use Application

  #########################
  # Application callbacks #
  #########################

  def start(_type, _args) do
    children = [
      %{
        id: VarBuilder,
        # start: {Agent, :start_link, [fn -> 0 end, [name: VarBuilder]]}
        start: {VarBuilder, :start_link, []}
      }
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
