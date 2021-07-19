defmodule Yodlee.Webhook do
  @moduledoc """
  Webhook data structure.
  """

  defstruct callback_url: nil, name: nil

  @type t :: %__MODULE__{callback_url: String.t(), name: String.t()}
end
