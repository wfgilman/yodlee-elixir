defmodule Yodlee.ProviderAccount do
  @moduledoc """
  Functions for `providerAccounts` endpoint.
  """

  import Yodlee
  alias Yodlee.Utils

  defstruct id: nil,
            aggregation_source: nil,
            created_date: nil,
            is_manual: nil,
            last_updated: nil,
            provider_id: nil,
            refresh_info: nil

  @type t :: %__MODULE__{
          id: integer,
          aggregation_source: String.t(),
          created_date: String.t(),
          is_manual: boolean,
          last_updated: String.t(),
          provider_id: integer,
          refresh_info: Yodlee.Refreshinfo.t()
        }
  @type user_session :: String.t()
  @type error :: Yodlee.Error.t() | HTTPoison.Error.t()

  @endpoint "providerAccounts"

  @doc """
  Lists all provider accounts associated with User session.
  """
  @spec list(user_session) :: {:ok, [Yodlee.ProviderAccount.t()]} | {:error, error}
  def list(session) do
    make_request_in_session(:get, @endpoint, session)
    |> Utils.handle_resp(:provider_account)
  end

  @doc """
  Gets provider account by id.
  """
  @spec get(user_session, String.t() | integer) ::
          {:ok, Yodlee.ProviderAccount.t()} | {:error, error}
  def get(session, id) do
    endpoint = "#{@endpoint}/#{id}"

    make_request_in_session(:get, endpoint, session)
    |> Utils.handle_resp(:provider_account)
  end

  @doc """
  Deletes provider account.
  """
  @spec delete(user_session, String.t() | integer) ::
          {:ok, Yodlee.ProviderAccount.t()} | {:error, error}
  def delete(session, id) do
    endpoint = "#{@endpoint}/#{id}"

    make_request_in_session(:delete, endpoint, session)
    |> Utils.handle_resp(:provider_account)
  end
end
