defmodule Yodlee.DataExtract do
  @moduledoc """
  Functions for `dataExtracts` endpoint.
  """

  import Yodlee
  alias Yodlee.Utils

  defstruct user: nil, provider_account: [], account: [], transaction: []

  @type t :: %__MODULE__{user: Yodlee.User.t,
                         provider_account: [Yodlee.ProviderAccount.t],
                         account: [Yodlee.Account.t],
                         transaction: [Yodlee.Transaction.t]
                        }
  @type cob_session :: String.t
  @type error :: Yodlee.Error.t | HTTPoison.Error.t

  @endpoint "dataExtracts"

  @doc """
  Gets data extract for user.

  ```
  params = %{
    loginName: "yslasset1",
    fromDate: "2017-02-20T10:18:44",
    toDate: "2017-02-20T10:19:44"
  }
  ```
  """
  @spec get(cob_session, map) :: {:ok, [Yodlee.DataExtract.t]} | {:error, error}
  def get(cob_session, params) do
    endpoint = "#{@endpoint}/userData?" <> Utils.encode_params(params)
    header = %{"Authorization" => "cobSession=#{cob_session}"}
    make_request(:get, endpoint, %{}, header)
    |> Utils.handle_resp(:data_extract)
  end
end
