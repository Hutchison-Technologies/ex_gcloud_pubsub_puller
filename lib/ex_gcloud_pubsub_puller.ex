defmodule ExGcloudPubsubPuller do
  require Logger
  alias ExGcloudPubsubPuller.SubscriptionHealth
  alias ExGcloudPubsubPuller.Messages.Sorter
  alias ExGcloudPubsubPuller.Gcloud.Pubsub

  @typedoc """
  A Module that implements the `ExGcloudPubsubPuller.PullController` behaviour.
  """
  @type pull_controller :: module()

  @doc """
  Main entrypoint to a pull job.

  Expects to be given a module that implements the `ExGcloudPubsubPuller.PullController` behaviour.
  """
  @spec main(pull_controller()) :: any()
  def main(pull_controller) do
    pull_controller = pull_controller |> validate_pull_controller!()
    subscription_id = pull_controller.subscription_id() |> validate_subscription_id!()
    log_prefix = ["[", subscription_id, "] "] |> Enum.join()
    prefixed_log = fn msg -> log(log_prefix, msg) end
    prefixed_log.("Starting pull job")

    case Pubsub.pull(subscription_id) do
      {:ok, []} ->
        prefixed_log.("Received no messages")

        if SubscriptionHealth.is_stagnant?(subscription_id) do
          prefixed_log.("Subscription is stagnant")
          pull_controller.handle_stagnant()
        end

      {:ok, messages} ->
        prefixed_log.("Received #{messages |> length()} messages")
        SubscriptionHealth.touch(subscription_id)

        messages
        |> Sorter.by_date()
        |> Enum.each(fn %{ackId: ack_id, message: message} ->
          case pull_controller.handle_message(%{
                 message
                 | data: message.data |> Base.decode64!() |> Poison.decode!()
               }) do
            :ok ->
              case Pubsub.acknowledge(subscription_id, ack_id) do
                :ok ->
                  nil

                {:error, error} ->
                  prefixed_log.("Received error from acknowledge: #{error |> inspect()}")

                  pull_controller.handle_ack_error(error)
              end

            :error ->
              prefixed_log.(
                "Pull controller #{pull_controller |> inspect()}.handle_message returned :error whilst handling message: #{
                  message |> inspect()
                }"
              )
          end
        end)

      {:error, error} ->
        prefixed_log.("Received error from pull: #{error |> inspect()}")
        pull_controller.handle_pull_error(error)
    end
  end

  @spec validate_pull_controller!(pull_controller()) :: pull_controller()
  defp validate_pull_controller!(some_module) when is_atom(some_module) do
    case Code.ensure_loaded(some_module) do
      {:module, handler_module} ->
        cond do
          function_exported?(handler_module, :subscription_id, 0) and
            function_exported?(handler_module, :handle_stagnant, 0) and
            function_exported?(handler_module, :handle_pull_error, 1) and
            function_exported?(handler_module, :handle_ack_error, 1) and
              function_exported?(handler_module, :handle_message, 1) ->
            handler_module

          true ->
            raise_invalid_pull_controller!(handler_module)
        end

      error ->
        raise ArgumentError,
              "Error ensuring pull controller module #{inspect(some_module)} was loaded: #{
                inspect(error)
              }"
    end
  end

  defp validate_pull_controller!(invalid_arg), do: raise_invalid_pull_controller!(invalid_arg)

  @spec raise_invalid_pull_controller!(any()) :: any()
  defp raise_invalid_pull_controller!(arg) do
    raise ArgumentError,
      message:
        "Expected a module that implements the `ExGcloudPubsubPuller.PullController` behaviour but got: #{
          inspect(arg)
        }"
  end

  @spec validate_subscription_id!(String.t()) :: String.t()
  defp validate_subscription_id!(subscription_id) when is_binary(subscription_id) do
    cond do
      Regex.match?(~r/^[a-zA-Z0-9][a-zA-Z0-9-.]+$/, subscription_id) ->
        subscription_id

      true ->
        raise_invalid_subscription_id!(subscription_id)
    end
  end

  defp validate_subscription_id!(invalid_arg), do: raise_invalid_subscription_id!(invalid_arg)

  @spec raise_invalid_subscription_id!(any()) :: any()
  defp raise_invalid_subscription_id!(arg) do
    raise ArgumentError,
      message:
        "subscription_id should be alphanumeric with dashes (cannot start with a dash), got: #{
          inspect(arg)
        }"
  end

  @spec log(String.t(), String.t()) :: any()
  defp log(prefix, msg) do
    [prefix, msg]
    |> Enum.join()
    |> Logger.info()
  end
end
