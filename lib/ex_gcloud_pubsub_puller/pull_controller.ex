defmodule ExGcloudPubsubPuller.PullController do
  @moduledoc """
  Implement the behaviour from this module to control pulling from a subscription.

  Add your controller to the config to ensure it gets run.

  ## Examples

      # config/config.exs:
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

      # lib/my_app/cost_pull_controller.ex:
        defmodule CostPullController do
          @behaviour ExGcloudPubsubPuller.PullController

          @impl true
          def subscription_id(), do: "cost-subscription"

          @impl true
          def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: nil}), do: :error
          def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: data}) do
            IO.inspect(data)
            :ok
          end

          @impl true
          def handle_stagnant() do
            some_function_that_fixes_the_world()
          end

          @impl true
          def handle_pull_error(%Tesla.Env{status: 404}), do: IO.inspect("subscription doesn't exist!")
          def handle_pull_error(%Tesla.Env{status: 403}), do: IO.inspect("I am not authorized!")
          def handle_pull_error(%Tesla.Env{} = error), do: IO.inspect("Something went wrong: \#{inspect(error)}")

          @impl true
          def handle_ack_error(%Tesla.Env{status: 404}), do: IO.inspect("message doesn't exist!")
          def handle_ack_error(%Tesla.Env{status: 403}), do: IO.inspect("I am not authorized!")
          def handle_ack_error(%Tesla.Env{} = error), do: IO.inspect("Something went wrong: \#{inspect(error)}")
        end

      # lib/my_app/usage_pull_controller.ex:
        defmodule UsagePullController do
          @behaviour ExGcloudPubsubPuller.PullController

          @impl true
          def subscription_id(), do: "usage-subscription"

          @impl true
          def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: nil}), do: :error
          def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: data}) do
            IO.inspect(data)
            :ok
          end

          @impl true
          def handle_stagnant() do
            some_function_that_fixes_the_world()
          end

          @impl true
          def handle_pull_error(%Tesla.Env{status: 404}), do: IO.inspect("subscription doesn't exist!")
          def handle_pull_error(%Tesla.Env{status: 403}), do: IO.inspect("I am not authorized!")
          def handle_pull_error(%Tesla.Env{} = error), do: IO.inspect("Something went wrong: \#{inspect(error)}")

          @impl true
          def handle_ack_error(%Tesla.Env{status: 404}), do: IO.inspect("message doesn't exist!")
          def handle_ack_error(%Tesla.Env{status: 403}), do: IO.inspect("I am not authorized!")
          def handle_ack_error(%Tesla.Env{} = error), do: IO.inspect("Something went wrong: \#{inspect(error)}")
        end

  """

  @doc """
  Should return the Google PubSub subscription id from which messages will be pulled.

  Gets called at the start of each job run.

  ## Examples

      @impl true
      def subscription_id(), do: "my-super-good-subscription"

  """
  @callback subscription_id() :: String.t()

  @doc """
  Gets called with each message that gets pulled from the subscription.

  Should return either `:ok` or `:error`.

  If `:ok` is returned, the message will be acknowledged.
  If `:error` is returned, the message will *NOT* be acknowledged.

  ## Examples

      @impl true
      def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: nil}), do: :error
      def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: data}) do
        IO.inspect(data)
        :ok
      end

  """
  @callback handle_message(msg :: GoogleApi.PubSub.V1.Model.PubsubMessage.t()) :: :ok | :error

  @doc """
  Gets called if no message has come through the subscription in 30 seconds.

  ## Examples

      @impl true
      def handle_stagnant() do
        some_function_that_fixes_the_world()
      end

  """
  @callback handle_stagnant() :: any()

  @doc """
  Gets called if pulling from Google PubSub yields an error.

  ## Examples

      @impl true
      def handle_pull_error(%Tesla.Env{status: 404}), do: IO.inspect("subscription doesn't exist!")
      def handle_pull_error(%Tesla.Env{status: 403}), do: IO.inspect("I am not authorized!")
      def handle_pull_error(%Tesla.Env{} = error), do: IO.inspect("Something went wrong: \#{inspect(error)}")

  """
  @callback handle_pull_error(Tesla.Env.t()) :: any()

  @doc """
  Gets called if acknowledging a message to Google PubSub yields an error.

  ## Examples

      @impl true
      def handle_ack_error(%Tesla.Env{status: 404}), do: IO.inspect("message doesn't exist!")
      def handle_ack_error(%Tesla.Env{status: 403}), do: IO.inspect("I am not authorized!")
      def handle_ack_error(%Tesla.Env{} = error), do: IO.inspect("Something went wrong: \#{inspect(error)}")

  """
  @callback handle_ack_error(Tesla.Env.t()) :: any()
end
