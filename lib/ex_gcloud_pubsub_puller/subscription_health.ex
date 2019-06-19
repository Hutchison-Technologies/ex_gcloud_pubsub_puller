defmodule ExGcloudPubsubPuller.SubscriptionHealth do
  alias ExGcloudPubsubPuller.MemoryStore

  @doc """
  Uses the MemoryStore to determine if a subscription could be considered `stagnant`.
  """
  @spec is_stagnant?(String.t()) :: boolean()
  def is_stagnant?(subscription_id) do
    thirty_seconds_ago = Timex.now() |> Timex.shift(seconds: -30)

    case MemoryStore.load(subscription_id) do
      %{last_message_at: last_message_at, last_stagnant_at: last_stagnant_at} ->
        cond do
          Timex.before?(last_message_at, thirty_seconds_ago) and
              Timex.before?(last_stagnant_at, thirty_seconds_ago) ->
            MemoryStore.save(subscription_id, %{
              last_message_at: last_message_at,
              last_stagnant_at: Timex.now()
            })

            true

          true ->
            false
        end

      %{last_message_at: last_message_at} ->
        cond do
          Timex.before?(last_message_at, thirty_seconds_ago) ->
            MemoryStore.save(subscription_id, %{
              last_message_at: last_message_at,
              last_stagnant_at: Timex.now()
            })

            true

          true ->
            false
        end

      %{last_stagnant_at: last_stagnant_at} ->
        cond do
          Timex.before?(last_stagnant_at, thirty_seconds_ago) ->
            MemoryStore.save(subscription_id, %{
              last_stagnant_at: Timex.now()
            })

            true

          true ->
            false
        end

      _ ->
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
