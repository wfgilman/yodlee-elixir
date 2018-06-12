defmodule Yodlee.Cobrand do
  @moduledoc """
  Functions for `cobrand` endpoint.
  """

  import Yodlee
  alias Yodlee.Utils

  defstruct cobrand_id: nil, application_id: nil, locale: nil, session: nil

  @type t :: %__MODULE__{cobrand_id: integer,
                         application_id: String.t,
                         locale: String.t,
                         session: String.t
                        }
  @type cob_session :: String.t
  @type error :: Yodlee.Error.t | HTTPoison.Error.t

  @endpoint "cobrand"

  @doc """
  Get's Cobrand session. Uses credentials provided in configuration by default.
  Automatically sets the session token to the configuration variable `cob_session`
  if the login is successful.

  ```
  cred = %{
    cobrandLogin: "your_cobrand_login",
    cobrandPassword: "your_cobrand_password"
  }
  ```
  """
  @spec login(map | nil) :: {:ok, Yodlee.Cobrand.t} | {:error, error}
  def login(cred \\ get_cobrand_cred()) do
    endpoint = "#{@endpoint}/login"
    params = %{cobrand: Map.merge(cred, Utils.locale())}
    make_request(:post, endpoint, params)
    |> Utils.handle_resp(:cobrand)
  end

  @doc """
  Adds a webhook callback URL to the Cobrand.
  """
  @spec add_webhook(cob_session, String.t, String.t) :: {:ok, map} | {:error, error | atom}
  def add_webhook(session, event_name, callback_url) when event_name in ["REFRESH", "DATA_UPDATES"] do
    endpoint = "#{@endpoint}/config/notifications/events/#{event_name}"
    params = %{event: %{callbackUrl: callback_url}}
    make_request_in_session(:post, endpoint, session, params)
    |> Utils.handle_resp(:any)
  end
  def add_webhook(_session, _event_name, _callback_url) do
    {:error, :invalid_params}
  end

  @doc """
  Lists a Cobrand's webhooks.
  """
  @spec list_webhooks(cob_session) :: {:ok, [Yodlee.Webhook.t]} | {:error, error}
  def list_webhooks(session) do
    endpoint = "#{@endpoint}/config/notifications/events"
    make_request_in_session(:get, endpoint, session)
    |> Utils.handle_resp(:webhook)
  end

  @doc """
  Deletes a Cobrand's webhooks associated with event name.
  """
  @spec delete_webhook(cob_session, String.t) :: {:ok, map} | {:error, error}
  def delete_webhook(session, event_name) do
    endpoint = "#{@endpoint}/config/notifications/events/#{event_name}"
    make_request_in_session(:delete, endpoint, session)
    |> Utils.handle_resp(:any)
  end

end
