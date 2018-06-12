defmodule Yodlee.Provider do
  @moduledoc """
  Functions for `providers` endpoint.
  """

  import Yodlee
  alias Yodlee.Utils

  defstruct id: nil, auth_type: nil, base_url: nil, container_names: [],
            favicon: nil, forget_password_url: nil,
            is_auto_refresh_enabled: nil, last_modified: nil,
            login_url: nil, logo: nil, name: nil, status: nil

  @type t :: %__MODULE__{id: integer,
                         auth_type: String.t,
                         base_url: String.t,
                         container_names: [String.t],
                         favicon: String.t,
                         forget_password_url: String.t,
                         is_auto_refresh_enabled: boolean,
                         last_modified: String.t,
                         login_url: String.t,
                         logo: String.t,
                         name: String.t,
                         status: String.t
                        }
  @type user_session :: String.t
  @type error :: Yodlee.Error.t | HTTPoison.Error.t

  @endpoint "providers"

  @doc """
  Searches providers in User session.

  ```
  params = %{
    name: "Wells Fargo"
  }
  ```
  """
  @spec search(user_session, map) :: {:ok, [Yodlee.Provider.t]} | {:error, error}
  def search(session, params \\ %{}) do
    endpoint =
      case Map.keys(params) do
        [] -> @endpoint
        _  -> "#{@endpoint}?" <> Utils.encode_params(params)
      end
    make_request_in_session(:get, endpoint, session)
    |> Utils.handle_resp(:provider)
  end

  @doc """
  Gets provider by id.
  """
  @spec get(user_session, String.t | integer) :: {:ok, Yodlee.Provider.t} | {:error, error}
  def get(session, id) do
    endpoint = "#{@endpoint}/#{id}"
    make_request_in_session(:get, endpoint, session)
    |> Utils.handle_resp(:provider)
  end
end
