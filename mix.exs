defmodule ExGcloudPubsubPuller.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_gcloud_pubsub_puller,
      version: String.trim(File.read!("VERSION")),
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "dialyzer.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExGcloudPubsubPuller.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:eliver, "~> 2.0.0", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false}
    ]
  end
end
