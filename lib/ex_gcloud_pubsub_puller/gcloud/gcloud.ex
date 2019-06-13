defmodule ExGcloudPubsubPuller.Gcloud do
  @moduledoc """
  Wrapper to gather all the steps needed to create a Tesla.Client connection to Google Cloud.
  """
  alias ExGcloudPubsubPuller.Gcloud.{Conn, Tokens}

  @doc """
  Creates a Tesla.Client connection with Google Cloud.
  """
  @spec connection :: Tesla.Client.t()
  def connection() do
    cond do
      Application.get_env(:goth, :disabled, false) ->
        Conn.create()

      true ->
        {:ok, %{token: token}} = Tokens.create()
        Conn.create(token)
    end
  end

  @doc """
  Retrieves the Google Cloud Project ID from the credentials currently being used to
  communicate with Google Cloud.
  """
  @spec project_id :: {:ok, String.t()} | {:error, <<>>}
  def project_id() do
    cond do
      Application.get_env(:goth, :disabled, false) ->
        {:ok, "test-proj"}

      true ->
        case Goth.Config.get(:project_id) do
          {:ok, project_id} ->
            {:ok, project_id}

          :error ->
            {:error, ""}
        end
    end
  end
end
