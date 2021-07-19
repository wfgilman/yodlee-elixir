defmodule Yodlee.Refreshinfo do
  @moduledoc """
  Yodlee data structure for provider account refresh information.
  """

  defstruct status_code: nil,
            status_message: nil,
            next_refresh_scheduled: nil,
            last_refreshed: nil,
            last_refresh_attempt: nil,
            action_required: nil,
            additional_status: nil,
            message: nil

  @type t :: %__MODULE__{
          status_code: String.t(),
          status_message: String.t(),
          next_refresh_scheduled: String.t(),
          last_refreshed: String.t(),
          last_refresh_attempt: String.t(),
          action_required: String.t(),
          additional_status: String.t(),
          message: String.t()
        }
end
