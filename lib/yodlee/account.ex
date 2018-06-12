defmodule Yodlee.Account do
  @moduledoc """
  Functions for `accounts` endpoint.
  """

  import Yodlee
  alias Yodlee.Utils

  defstruct id: nil, account_name: nil, account_number: nil, amount_due: nil, interest_rate_type: nil,
            balance: nil, due_date: nil, interest_rate: nil, last_payment_amount: nil,
            last_payment_date: nil, last_updated: nil, maturity_date: nil,
            minimum_amount_due: nil, account_status: nil, account_type: nil,
            original_loan_amount: nil, provider_id: nil, principal_balance: nil,
            recurring_payment: nil, term: nil, origination_date: nil, created_date: nil,
            frequency: nil, refreshinfo: nil, provider_account_id: nil

  @type t :: %__MODULE__{id: integer,
                         account_name: String.t,
                         account_number: String.t,
                         amount_due: Yodlee.Money.t,
                         interest_rate_type: String.t,
                         balance: Yodlee.Money.t,
                         due_date: String.t,
                         interest_rate: float,
                         last_payment_amount: Yodlee.Money.t,
                         last_payment_date: String.t,
                         last_updated: String.t,
                         maturity_date: String.t,
                         minimum_amount_due: Yodlee.Money.t,
                         account_status: String.t,
                         account_type: String.t,
                         original_loan_amount: Yodlee.Money.t,
                         provider_id: String.t,
                         principal_balance: Yodlee.Money.t,
                         recurring_payment: Yodlee.Money.t,
                         term: String.t,
                         origination_date: String.t,
                         created_date: String.t,
                         frequency: String.t,
                         refreshinfo: Yodlee.Refreshinfo.t,
                         provider_account_id: integer
                        }
  @type user_session :: String.t
  @type error :: Yodlee.Error.t | HTTPoison.Error.t

  @endpoint "accounts"

  @doc """
  Gets all accounts associated with User session.

  ```
  params = %{
    providerAccountId: 10502782
  }
  ```
  """
  @spec search(user_session, map) :: {:ok, [Yodlee.Account.t]} | {:error, error}
  def search(session, params) do
    endpoint =
      case Map.keys(params) do
        [] -> @endpoint
        _  -> "#{@endpoint}?" <> Utils.encode_params(params)
      end
    make_request_in_session(:get, endpoint, session)
    |> Utils.handle_resp(:account)
  end

  @doc """
  List all accounts associated with User session.
  """
  @spec list(user_session) :: {:ok, [Yodlee.Account.t]} | {:error, error}
  def list(session) do
    search(session, %{})
  end

  @doc """
  Gets account by id and container.
  """
  @spec get(user_session, String.t, String.t | integer) :: {:ok, [Yodlee.Account.t]} | {:error, error}
  def get(session, container, id) do
    endpoint = "#{@endpoint}/#{id}?container=#{container}"
    make_request_in_session(:get, endpoint, session)
    |> Utils.handle_resp(:account)
  end

end
