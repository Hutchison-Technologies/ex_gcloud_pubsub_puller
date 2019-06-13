defmodule ExGcloudPubsubPuller.SubscriptionHealth do
  alias ExGcloudPubsubPuller.MemoryStore

  @doc """
  Uses the MemoryStore to determine if a subscription could be considered `stagnant`.
  """
  @spec is_stagnant?(String.t()) :: boolean()
  def is_stagnant?(subscription_id) do
    case MemoryStore.load(subscription_id) do
      nil ->
        false

      %{last_message_at: last_message_at} ->
        Timex.before?(last_message_at, Timex.now() |> Timex.shift(seconds: -30))

      %{} ->
        false
    end
  end

  @doc """
  Uses the MemoryStore to save a subscription's `last_message_at` to now.
  """
  @spec touch(String.t()) :: any()
  def touch(subscription_id) do
    MemoryStore.save(subscription_id, %{last_message_at: Timex.now()})
  end
end
