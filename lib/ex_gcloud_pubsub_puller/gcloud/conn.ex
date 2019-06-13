defmodule ExGcloudPubsubPuller.Gcloud.Conn do
  @moduledoc """
  Makes authed or unauthed GoogleApi.PubSub.V1.Connection
  """

  @doc """
  Creates an authless connection
  """
  @spec create :: Tesla.Client.t()
  def create() do
    GoogleApi.PubSub.V1.Connection.new()
  end

  @doc """
  Creates an authenticated connection
  """
  @spec create(String.t()) :: Tesla.Client.t()
  def create(token) do
    GoogleApi.PubSub.V1.Connection.new(token)
  end
end
