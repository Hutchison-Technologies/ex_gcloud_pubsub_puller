# ExGcloudPubsubPuller

Cron-based & configurable gcloud pubsub subscription message puller.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_gcloud_pubsub_puller` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_gcloud_pubsub_puller, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_gcloud_pubsub_puller](https://hexdocs.pm/ex_gcloud_pubsub_puller).

## Configuring Pull Controllers
This is using the Quantum library for handling the scheduling : https://hexdocs.pm/quantum/readme.html
Add config to your `config/config.exs` to configure pull controllers, like so:

```
config :my_app, ExGcloudPubsubPuller.Scheduler,
  schedule: {:extended, "*/5"},
  overlap: false,
  timezone: :utc,
  jobs: [
    cost_job: [
      task: {ExGcloudPubsubPuller, :main, [CostPullController]}
    ],
    usage_job: [
      task: {ExGcloudPubsubPuller, :main, [UsagePullController]}
    ]
  ]
```
