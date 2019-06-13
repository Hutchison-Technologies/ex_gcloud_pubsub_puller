defmodule ExGcloudPubsubPuller.Messages.Sorter do
  @moduledoc """
  Helper functions to sort lists of pubsub messages.
  """

  @doc """
  Sorts a list of GoogleApi.PubSub.V1.Model.ReceivedMessage by publish dates in ascending order.
  """
  @spec by_date([GoogleApi.PubSub.V1.Model.ReceivedMessage.t()]) :: [
          GoogleApi.PubSub.V1.Model.ReceivedMessage.t()
        ]
  def by_date(messages) do
    messages
    |> Enum.sort_by(fn %{message: %{publishTime: datetime}} -> datetime |> Timex.to_unix() end)
  end
end
