defmodule LogicElixir.VarBuilder do
  @moduledoc """
    Simple agent to create temporary variables to make easier the
    transformation from core expressions to Elixir expressions
  """
  use Agent

  @spec start_link :: {:ok, pid()}
  def start_link do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  @spec stop :: :ok
  def stop do
    Agent.stop(__MODULE__)
  end

  @spec reset :: :ok
  def reset do
    Agent.update(__MODULE__, fn _state -> 0 end)
  end

  @spec gen_var :: String.t()
  def gen_var do
    x = Agent.get_and_update(__MODULE__, fn state -> {state, state + 1} end)
    "X#{x}"
  end
end
