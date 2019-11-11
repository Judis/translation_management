defmodule Tr.Scenario do
  @moduledoc """
  Specifies API for scenarios.
  """

  @type opts :: map()
  @type scenario :: Ecto.Multi.t()

  @callback scenario(opts()) :: scenario()
  @callback act(opts()) :: {:ok, term()} | {:error, term()}
end
