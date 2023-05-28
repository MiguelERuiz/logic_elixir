defmodule LogicElixir do
  @moduledoc """
  Documentation for `LogicElixir`.
  """

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
    for {name, args} <- definitions do# |> Enum.group_by(&elem(&1, 0), &elem(&1, 1)) do
      quote do
        defcore unquote(name)(X1, X2) do
          unquote(Enum.at(args, 0)) = X1
          unquote(Enum.at(args, 1)) = X2
        end
      end
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

  ###############################
  #  Public auxiliar functions  #
  ###############################

  def to_core(t) when is_tuple(t), do: t
  def to_core(lit), do: {:ground, lit}

  #####################
  # Private Functions #
  #####################
end
