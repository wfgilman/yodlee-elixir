defmodule Yodlee.Money do
  @moduledoc """
  Yodlee data structure for money.
  """

  defstruct amount: nil, currency: nil
  @type t :: %__MODULE__{amount: float, currency: String.t}
end
