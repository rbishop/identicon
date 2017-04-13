defmodule Identicon.Mixfile do
  use Mix.Project

  def project do
    [app: :identicon,
     version: "0.3.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     name: "Identicon",
     source_url: "https://github.com/rbishop/identicon",
     homepage_url: "https://github.com/rbishop/identicon",
     description: "Elixir library for generating unique identicons from strings.",
   ]
  end

  def application do
    [applications: [:logger, :crypto]]
  end

  defp deps do
    []
  end

  defp package do
    %{licenses: ["Apache 2"],
      contributors: ["Richard Bishop"],
      links: %{"Github" => "https://github.com/rbishop/identicon"}}
  end
end
