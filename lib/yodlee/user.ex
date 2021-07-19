defmodule Yodlee.User do
  @moduledoc """
  Functions for `user` endpoint.
  """

  import Yodlee
  alias Yodlee.Utils

  defstruct id: nil, login_name: nil, session: nil

  @type t :: %__MODULE__{id: integer, login_name: String.t(), session: String.t()}
  @type cob_session :: String.t()
  @type user_session :: String.t()
  @type error :: Yodlee.Error.t() | HTTPoison.Error.t()

  @endpoint "user"
  @fastlink_app_id "10003600"

  @doc """
  Registers a user within a Cobrand session.

  ```
  params = %{
    loginName: "user1@pickpocket.me",
    password: "lcDEig$JI$zC3G1!",
    email: "user1@pickpocket.me"
  }
  ```
  """
  @spec register(cob_session, map) :: {:ok, Yodlee.User.t()} | {:error, error}
  def register(cob_session, params) do
    params = %{user: params}
    endpoint = "#{@endpoint}/register"
    header = %{"Authorization" => "cobSession=#{cob_session}"}

    make_request(:post, endpoint, params, header)
    |> Utils.handle_resp(:user)
  end

  @doc """
  Logs in a user within a Cobrand session:

  `params = %{
    loginName: "user_login_name",
    password: "user_password#123"
  }`
  """
  @spec login(cob_session, map) :: {:ok, Yodlee.User.t()} | {:error, error}
  def login(cob_session, params) do
    params = %{user: Map.merge(params, Utils.locale())}
    endpoint = "#{@endpoint}/login"
    header = %{"Authorization" => "cobSession=#{cob_session}"}

    make_request(:post, endpoint, params, header)
    |> Utils.handle_resp(:user)
  end

  @doc """
  Returns FastLink token from user session token.
  """
  @spec get_fastlink_token(user_session) :: {:ok, map} | {:error, error}
  def get_fastlink_token(session) do
    endpoint = "#{@endpoint}/accessTokens?appIds=#{@fastlink_app_id}"

    make_request_in_session(:get, endpoint, session)
    |> Utils.handle_resp(:fastlink)
  end

  @doc """
  Unregisters (deletes) a Yodlee user.
  """
  @spec unregister(user_session) :: {:ok, Yodlee.User.t()} | {:error, error}
  def unregister(session) do
    endpoint = "#{@endpoint}/unregister"

    make_request_in_session(:delete, endpoint, session)
    |> Utils.handle_resp(:user)
  end
end
