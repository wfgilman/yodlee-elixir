defmodule Yodlee.Error do
  @moduledoc """
  Yodlee Error data structure.
  """

  defstruct error_code: nil, error_message: nil, reference_code: nil

  @type t :: %__MODULE__{
          error_code: String.t(),
          error_message: String.t(),
          reference_code: String.t()
        }
end
