# Yodlee

[![Build Status](https://travis-ci.org/wfgilman/yodlee-elixir.svg?branch=master)](https://travis-ci.org/wfgilman/yodlee-elixir)
[![Hex.pm Version](https://img.shields.io/hexpm/v/yodlee_elixir.svg)](https://hex.pm/packages/yodlee_elixir)

Elixir library for Yodlee's v1.0 API

Supported Yodlee endpoints:
- [x] Cobrand
- [x] User
- [x] Accounts
- [ ] Holdings
- [x] Providers
- [x] ProviderAccounts
- [x] Transactions
- [ ] Statements
- [ ] Derived
- [x] DataExtracts
- [ ] Refresh

## Usage

Add to your dependencies in `mix.exs`. The hex specification is required.

```elixir
def deps do
  [{:yodlee, "~> 0.1", hex: :yodlee_elixir}]
end
```

## Configuration

Add the following configuration to your project.

```elixir
config :yodlee,
  root_uri: "https://developer.api.yodlee.com/ysl/restserver/v1/",
  cob_session: nil,
  cobrand_login: "your_cobrand_username",
  cobrand_password: "your_cobrand_password",
  httpoison_options: [timeout: 10_000, recv_timeout: 100_000]
```

## Getting Started

Here's a few usage examples for getting started (courtesy of [tmaszk](https://github.com/tmaszk)).


#### Logging in

Establishing a Cobrand session
```elixir
iex(1)> {:ok, cobrand} = Yodlee.Cobrand.login()
{:ok,
 %Yodlee.Cobrand{
   application_id: "XXXXX",
   cobrand_id: 10...,
   locale: "en_US",
   session: "08..."
 }}
```

Establishing a User session (required for most API calls)
```elixir
iex(2)> {:ok, user} = Yodlee.User.login(cobrand.session, %{ loginName: "YourCobrandLoginName", password: "YourCobrandPassword", email: "YourEmailAddress" })
{:ok,
 %Yodlee.User{
   id: 10...,
   login_name: "..",
   session: "08..."
 }}
```

#### Linking a Provider Account

I recommend using Yodlee's FastLink for facilitating the addition and updating of Provider
Accounts due to the complexity and ever-changing nature of Provider login and MFA
challenges. FastLink is fully supported by Yodlee.

#### Fetching User Data

Searching Providers
```elixir
iex(3)> Yodlee.Provider.search(user.session, %{ name: "Hamilton"} )
{:ok,
 [
   %Yodlee.Provider{
     auth_type: "MFA_CREDENTIALS",
     base_url: "http://www.hamiltonstatebank.com/",
     container_names: ["loan", "bank"],
     ...
   },
   %Yodlee.Provider{...},
   ...
 ]}
```

Getting Transactions from a linked User Account
```elixir
iex(4)> {:ok, accounts} = Yodlee.Account.list(user.session)
{:ok,
 [
   %Yodlee.Account{
     account_name: "DDA",
     account_number: "...",
     account_status: "ACTIVE",
     account_type: "CHECKING",
     ....
   },
   %Yodlee.Account{...},
   ...
 ]}

iex(5)> {:ok, transactions} = Yodlee.Transaction.list(user.session, "bank", hd(accounts).id)
{:ok,
 [
   %Yodlee.Transaction{
     account_id: 100....,
     amount: %Yodlee.Money{amount: 6268.87, currency: "USD"},
     base_type: "CREDIT",
     container: "bank",
     date: "2018-07-06",
     id: 910000,
     interest: nil,
     principal: nil,
     status: "PENDING"
   },
   %Yodlee.Transaction{...},
   ...
 ]}
```


## Tests and Style

This library has sparse test coverage at the moment.

Run tests using `mix test`.

Before making pull requests, run the coverage and style checks.
```elixir
mix coveralls
mix credo
```
