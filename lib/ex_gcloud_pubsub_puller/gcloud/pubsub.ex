defmodule ExGcloudPubsubPuller.Gcloud.Pubsub do
  @moduledoc """
  Interface to the Google Cloud PubSub system.
  """
  alias GoogleApi.PubSub.V1.{Api, Model}
  alias ExGcloudPubsubPuller.Gcloud

  @doc """
  Pulls messages from the given Google PubSub subscription.
  """
  @spec pull(String.t(), integer()) ::
          {:ok, [Model.ReceivedMessage.t()]} | {:error, Tesla.Env.t()}
  def pull(subscription_id, max_messages \\ 100) do
    conn = Gcloud.connection()

    case Gcloud.project_id() do
      {:error, _} ->
        {:error, "Failed to get project id."}

      {:ok, project_id} ->
        Api.Projects.pubsub_projects_subscriptions_pull(
          conn,
          project_id,
          subscription_id,
          body: %Model.PullRequest{
            maxMessages: max_messages,
            returnImmediately: true
          }
        )
        |> handle_pull_response()
    end
  end

  @dialyzer {:nowarn_function, handle_pull_response: 1}
  @spec handle_pull_response(
          {:error, Tesla.Env.t()}
          | {:ok, Model.PullResponse.t()}
        ) :: {:ok, [Model.ReceivedMessage.t()]} | {:error, Tesla.Env.t()}
  defp handle_pull_response({:error, %Tesla.Env{}} = error), do: error

  defp handle_pull_response({:ok, %Model.PullResponse{receivedMessages: nil}}) do
    {:ok, []}
  end

  defp handle_pull_response({:ok, %Model.PullResponse{receivedMessages: messages}}) do
    {:ok, messages}
  end

  @doc """
  Sends an acknowledge request to Google Cloud for the given message on the given subscription.
  """
  @spec acknowledge(String.t(), String.t()) :: :ok | {:error, Tesla.Env.t()}
  def acknowledge(subscription_id, message_ack_id) do
    conn = Gcloud.connection()

    case Gcloud.project_id() do
      {:error, _} ->
        {:error, "Failed to get project id."}

      {:ok, project_id} ->
        Api.Projects.pubsub_projects_subscriptions_acknowledge(
          conn,
          project_id,
          subscription_id,
          body: %Model.AcknowledgeRequest{
            ackIds: [message_ack_id]
          }
        )
        |> handle_ack_response()
    end
  end

  @spec handle_ack_response(
          {:error, Tesla.Env.t()}
          | {:ok, Model.Empty.t()}
        ) :: :ok | {:error, Tesla.Env.t()}
  defp handle_ack_response({:error, %Tesla.Env{}} = error), do: error

  defp handle_ack_response({:ok, %Model.Empty{}}), do: :ok
end
