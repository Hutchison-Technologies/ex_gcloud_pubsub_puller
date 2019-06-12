defmodule ExGcloudPubsubPuller.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_gcloud_pubsub_puller,
      version: String.trim(File.read!("VERSION")),
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "ExGcloudPubsubPuller",
      source_url: "https://github.com/Hutchison-Technologies/ex_gcloud_pubsub_puller",
      homepage_url: "https://github.com/Hutchison-Technologies/ex_gcloud_pubsub_puller",
      dialyzer: [
        plt_file: {:no_warn, "dialyzer.plt"}
      ],
      test_coverage: [tool: :covertool]
    ]
  end

  defp description() do
    "Cron-based & configurable gcloud pubsub subscription message puller."
  end

  defp package() do
    [
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE VERSION),
      links: %{"GitHub" => "https://github.com/Hutchison-Technologies/ex_gcloud_pubsub_puller"}
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
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.5"},
      {:google_api_pub_sub, "~> 0.7"},
      {:goth, "~> 1.0"},
      {:eliver, "~> 2.0.0", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:junit_formatter, "~> 3.0", only: [:test]},
      {:covertool, "~> 2.0", only: [:test]},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false}
    ]
  end
end
