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

Add to your dependencies in `mix.exs`.

```elixir
def deps do
  [{:yodlee, "~> 1.0"}]
end
```

## Configuration

Add the following configuration to your project.

```elixir
config :yodlee,
  root_uri: "https://developer.api.yodlee.com/ysl/restserver/v1/",
  cob_session: nil,
  cobrand_login: "your_cobrand_username",
  cobrand_password: "your_cobrand_password"
  httpoison_options: [timeout: 10_000, recv_timeout: 100_000]
```

## Tests and Style

This library has sparse test coverage at the moment.

Run tests using `mix test`.

Before making pull requests, run the coverage and style checks.
```elixir
mix coveralls
mix credo
```
