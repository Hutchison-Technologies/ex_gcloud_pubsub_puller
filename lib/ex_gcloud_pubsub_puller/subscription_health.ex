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
end
