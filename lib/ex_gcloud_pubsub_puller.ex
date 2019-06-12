defmodule ExGcloudPubsubPuller do
  @typedoc """
  A Module that implements the `ExGcloudPubsubPuller.PullController` behaviour.
  """
  @type pull_controller :: module()

  @doc """
  Main entrypoint to a pull job.
  """
  @spec main(pull_controller()) :: any()
  def main(pull_controller) when is_atom(pull_controller) do
  end

  def main(invalid_arg) do
    raise_invalid_pull_controller(invalid_arg)
  end

  defp raise_invalid_pull_controller(arg) do
    raise ArgumentError,
      message:
        "Expected a module that implements the `ExGcloudPubsubPuller.PullController` behaviour but got: #{
          inspect(arg)
        }"
  end
end
