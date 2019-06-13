defmodule ExGcloudPubsubPuller.MemoryStore do
  @moduledoc """
  Barebones in-memory store
  """
  use Agent

  @doc """
  Starts the MemoryStore.
  """
  @spec start_link(map()) :: {:ok, pid()} | {:error, any()}
  def start_link(%{} = initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  @doc """
  Saves a value to the MemoryStore, updating it if the key already exists.
  """
  @spec save(String.t(), any()) :: :ok
  def save(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end

  @doc """
  Retrieves a value from the MemoryStore, returning `nil` if the key doesn't exist.
  """
  @spec load(String.t()) :: any()
  def load(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
