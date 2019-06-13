defmodule ExGcloudPubsubPuller.Gcloud.Tokens do
  @moduledoc """
  Makes Goth.Token
  """

  @doc """
  Creates a Goth.Token with pubsub scope
  """
  @spec create :: {:ok, Goth.Token.t()}
  def create do
    Goth.Token.for_scope("https://www.googleapis.com/auth/pubsub")
  end
end
