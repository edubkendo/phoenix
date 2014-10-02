defmodule Phoenix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix,
      version: "0.5.0-dev",
      elixir: "~> 1.0.0",
      deps: deps,
      package: [
        contributors: ["Chris McCord", "Darko Fabijan"],
        licenses: ["MIT"],
        links: [github: "https://github.com/phoenixframework/phoenix"]
      ],
      description: """
      Elixir Web Framework targeting full-featured, fault tolerant applications
      with realtime functionality
      """
    ]
  end

  def application do
    [
      mod: { Phoenix, [] },
      applications: [:plug, :linguist, :poison, :logger]
    ]
  end

  def deps do
    [
      {:cowboy, "~> 1.0.0", optional: true},
      {:plug, "~> 0.8.0"},
      {:linguist, "~> 0.1.2"},
      {:poison, "~> 1.1.0"},
      {:earmark, "~> 0.1", only: :docs},
      {:ex_doc, "~> 0.5", only: :docs},
      {:websocket_client, only: :test, github: "jeremyong/websocket_client"}
    ]
  end
end
