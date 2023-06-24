defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

  use Application

  #########################
  # Application callbacks #
  #########################

  @impl true
  def start(_type, _args) do
    LogicElixir.Supervisor.start_link(name: LogicElixir.Supervisor)
  end

  ##########
  # Macros #
  ##########

  defmacro __using__(_params) do
    quote do
      use LogicElixir.Defpred
    end
  end
end
