defmodule Yodlee do
  @moduledoc """
  An HTTP Client for Yodleee.

  Yodlee v1.0 API Docs: https://developer.yodlee.com/Yodlee_API/docs/v1_0/aggregation/overview
  """

  use HTTPoison.Base

  defmodule MissingCobrandLoginError do
    defexception message: """
    The Cobrand Login is required to create a session with Yodlee. Please add to
    your config.exs file.

    config :yodlee, cobrand_login: "your_cobrand_login"
    """
  end

  defmodule MissingCobrandPasswordError do
    defexception message: """
    The Cobrand Password is required to create a session with Yodlee. Please add
    to your config.exs file.

    config :yodlee, cobrand_password: "your_cobrand_login"
    """
  end

  defmodule MissingCobrandSessionError do
    defexception message: """
    The Cobrand Session is required to access this endpoint. Set the session
    token by logging in using Yodlee.Cobrand.login/0.
    """
  end

  defmodule MissingRootUriError do
    defexception message: """
    The root_uri is required to specify the Yodlee environment to which you are
    making calls. Please add to your config.exs file.

    config :yodlee, root_uri: "https://developer.api.yodlee.com/ysl/restserver/v1/"
    """
  end

  @spec get_cobrand_cred() :: map | no_return
  def get_cobrand_cred do
    require_cobrand_credentials()
  end

  @spec get_cobrand_session() :: map | no_return
  def get_cobrand_session do
    require_cobrand_session()
  end

  @doc """
  Makes request with session token in header.
  """
  @spec make_request_in_session(atom, String.t, String.t, map, map, Keyword.t) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  def make_request_in_session(method, endpoint, session, body \\ %{}, headers \\ %{}, options \\ []) do
    headers = Map.merge(get_auth_header(session), headers)
    make_request(method, endpoint, body, headers, options)
  end

  @doc """
  Makes request.
  """
  @spec make_request(atom, String.t, map, map, Keyword.t) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  def make_request(method, endpoint, body \\ %{}, headers \\ %{}, options \\ []) do
    rb = Poison.encode!(body)
    rh = get_request_headers() |> Map.merge(headers) |> Map.to_list()
    options = httpoison_request_options() ++ options
    request(method, endpoint, rb, rh, options)
  end

  defp process_url(endpoint) do
    require_root_uri() <> endpoint
  end

  defp process_response_body(""), do: ""
  defp process_response_body(body) do
    case Poison.Parser.parse(body) do
      {:ok, parsed_body} -> parsed_body
      {:error, _}        -> {:invalid, body}
    end
  end

  defp get_request_headers do
    Map.new()
    |> Map.put("Content-Type", "application/json")
    |> Map.put("Accept", "application/json")
  end

  defp get_auth_header(session) do
    cob_session = require_cobrand_session()
    %{"Authorization" => "cobSession=#{cob_session},userSession=#{session}"}
  end

  defp require_cobrand_credentials do
    case {get_cobrand_login(), get_cobrand_password()} do
      {:not_found, _}      -> raise MissingCobrandLoginError
      {_, :not_found}      -> raise MissingCobrandPasswordError
      {login, password}    -> %{cobrandLogin: login, cobrandPassword: password}
    end
  end

  defp require_root_uri do
    case Application.get_env(:yodlee, :root_uri) || :not_found do
      :not_found -> raise MissingRootUriError
      value      -> value
    end
  end

  defp require_cobrand_session do
    case Application.get_env(:yodlee, :cob_session) || :not_found do
      :not_found -> raise MissingCobrandSessionError
      value      -> value
    end
  end

  defp get_cobrand_login do
    Application.get_env(:yodlee, :cobrand_login) || :not_found
  end

  defp get_cobrand_password do
    Application.get_env(:yodlee, :cobrand_password) || :not_found
  end

  defp httpoison_request_options do
    Application.get_env(:yodlee, :httpoison_options, [])
  end

end
