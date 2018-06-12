defmodule Yodlee.Utils do
  @moduledoc """
  Utility functions.
  """

  alias Yodlee.{Account, Money, Transaction, Refreshinfo, Cobrand, User, ProviderAccount, Provider, DataExtract, Webhook}

  @spec locale() :: map
  def locale do
    %{locale: "en_US"}
  end

  @spec encode_params(map) :: String.t
  def encode_params(params) do
    params
    |> Map.to_list()
    |> Enum.map_join("&", fn x -> pair(x) end)
  end

  defp pair({key, value}) do
    param_name = to_string(key) |> URI.encode_www_form()
    param_value =
      cond do
        is_map(value) ->
          Poison.encode!(value)
        is_list(value) ->
          Enum.map_join(value, "|", fn x -> x end) |> URI.encode_www_form()
        true ->
          to_string(value) |> URI.encode_www_form()
      end
    "#{param_name}=#{param_value}"
  end

  @doc """
  Converts Yodlee camel case keys to Elixir friendly snake case.
  """
  @spec normalize_keys(map) :: map
  def normalize_keys(map) when is_binary(map), do: map
  def normalize_keys(map) do
    map
    |> Map.to_list()
    |> Enum.map(&recase/1)
    |> Enum.into(%{})
  end

  defp recase({k, v}) do
    cond do
      is_map(v) ->
        {Recase.to_snake(k), normalize_keys(v)}
      is_list(v) ->
        {Recase.to_snake(k), Enum.map(v, &normalize_keys/1)}
      true ->
        {Recase.to_snake(k), v}
    end
  end

  @doc """
  Handles Yodlee response and maps to the correct data structure.
  """
  @spec handle_resp({:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}, atom) :: {:ok, any} | {:error, map | Yodlee.Error.t | HTTPoison.Error.t}
  def handle_resp({:ok, %{body: {:invalid, body}}}, _schema) do
    {:error, body}
  end
  def handle_resp({:ok, %{status_code: 200, body: body}}, schema) do
    {:ok, map_body(body, schema)}
  end
  def handle_resp({:ok, %{status_code: code, body: _}}, _schema) when code in 201..299 do
    {:ok, %{}}
  end
  def handle_resp({:ok, resp}, _schema) do
    error =
      resp.body
      |> normalize_keys()
      |> Poison.Decode.decode(as: %Yodlee.Error{})
    {:error, error}
  end
  def handle_resp({:error, %HTTPoison.Error{} = error}, _schema) do
    {:error, error}
  end

  defp map_body(body, _schema) when body == %{} do
    body
  end
  defp map_body(cobrand, :cobrand) do
    session = get_in(cobrand, ["session", "cobSession"])
    Application.put_env(:yodlee, :cob_session, session)
    cobrand
    |> normalize_keys()
    |> Map.put("session", session)
    |> Poison.Decode.decode(as: %Cobrand{})
  end
  defp map_body(%{"user" => user}, :user) do
    session = get_in(user, ["session", "userSession"])
    user
    |> normalize_keys()
    |> Map.put("session", session)
    |> Poison.Decode.decode(as: %User{})
  end
  defp map_body(%{"account" => accounts}, :account) do
    accounts
    |> Enum.map(&normalize_keys/1)
    |> Poison.Decode.decode(as: [%Account{
        amount_due: %Money{},
        balance: %Money{},
        last_payment_amount: %Money{},
        minimum_amount_due: %Money{},
        original_loan_amount: %Money{},
        principal_balance: %Money{},
        refreshinfo: %Refreshinfo{}
      }])
  end
  defp map_body(%{"transaction" => trans}, :transaction) do
    trans
    |> Enum.map(&normalize_keys/1)
    |> Poison.Decode.decode(as: [%Transaction{
        amount: %Yodlee.Money{},
        interest: %Yodlee.Money{},
        principal: %Yodlee.Money{}
      }])
  end
  defp map_body(%{"providerAccount" => provider_accounts}, :provider_account) when is_list(provider_accounts) do
    provider_accounts
    |> Enum.map(&normalize_keys/1)
    |> Poison.Decode.decode(as: [%ProviderAccount{
        refresh_info: %Refreshinfo{}
      }])
  end
  defp map_body(%{"providerAccount" => provider_accounts}, :provider_account) do
    provider_accounts
    |> normalize_keys()
    |> Poison.Decode.decode(as: %ProviderAccount{
        refresh_info: %Refreshinfo{}
      })
  end
  defp map_body(%{"provider" => providers}, :provider) do
    providers
    |> Enum.map(&normalize_keys/1)
    |> Poison.Decode.decode(as: [%Provider{}])
  end
  defp map_body(%{"user" => %{"accessTokens" => [token | _]}}, :fastlink) do
    token
    |> normalize_keys()
    |> Map.take(["app_id", "value", "url"])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
          Map.put(acc, String.to_atom(k), v)
       end)
  end
  defp map_body(%{"userData" => user_data}, :data_extract) do
    user_data
    |> Enum.map(&normalize_keys/1)
    |> Poison.Decode.decode(as: [%DataExtract{
        user: %User{},
        provider_account: [%ProviderAccount{
          refresh_info: %Refreshinfo{}
        }],
        account: [%Account{
          amount_due: %Money{},
          balance: %Money{},
          last_payment_amount: %Money{},
          minimum_amount_due: %Money{},
          original_loan_amount: %Money{},
          principal_balance: %Money{},
          refreshinfo: %Refreshinfo{}
        }],
        transaction: [%Transaction{
          amount: %Yodlee.Money{},
          interest: %Yodlee.Money{},
          principal: %Yodlee.Money{}
        }]
      }])
  end
  defp map_body(%{"event" => webhooks}, :webhook) do
    webhooks
    |> Enum.map(&normalize_keys/1)
    |> Poison.Decode.decode(as: [%Webhook{}])
  end
  defp map_body(_, :webhook) do
    []
  end

end
