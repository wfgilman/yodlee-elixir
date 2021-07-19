defmodule Yodlee.Mixfile do
  use Mix.Project

  @description """
    An Elixir Library for Yodlee's v1.0 API
  """

  def project do
    [
      app: :yodlee,
      version: "0.1.2",
      description: @description,
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/wfgilman/yodlee-elixir",
      dialyzer: [plt_add_deps: false],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:httpoison, "~> 1.8.0"},
      {:poison, "~> 4.0.1"},
      {:bypass, "~> 2.1.0", only: [:test]},
      {:recase, "~> 0.7.0"},
      {:credo, "~> 1.5.6", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.14.1", only: [:test]},
      {:ex_doc, "~> 0.24.2", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      name: :yodlee_elixir,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      maintainers: ["Will Gilman"],
      links: %{"Github" => "https://github.com/wfgilman/yodlee-elixir"}
    ]
  end
end
