defmodule Yodlee.Transaction do
  @moduledoc """
  Functions for `transactions` endpoint.
  """

  import Yodlee
  alias Yodlee.Utils

  defstruct id: nil,
            account_id: nil,
            container: nil,
            amount: nil,
            interest: nil,
            principal: nil,
            date: nil,
            status: nil,
            base_type: nil

  @type t :: %__MODULE__{
          id: integer,
          account_id: integer,
          container: String.t(),
          amount: Yodlee.Money.t(),
          interest: Yodlee.Money.t(),
          principal: Yodlee.Money.t(),
          date: String.t(),
          status: String.t(),
          base_type: String.t()
        }
  @type user_session :: String.t()
  @type error :: Yodlee.Error.t() | HTTPoison.Error.t()

  @endpoint "transactions"

  @doc """
  List transactions by account id.
  """
  @spec list(user_session, String.t(), String.t() | integer) ::
          {:ok, [Yodlee.Transaction.t()]} | {:error, error}
  def list(session, container, account_id) do
    params = %{container: container, accountId: account_id}

    make_request_in_session(:get, @endpoint, session, params)
    |> Utils.handle_resp(:transaction)
  end
end
