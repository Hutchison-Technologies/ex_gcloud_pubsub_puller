defmodule ExGcloudPubsubPuller do
  @typedoc """
  A Module that implements the `ExGcloudPubsubPuller.PullController` behaviour.
  """
  @type pull_controller :: module()

  @doc """
  Main entrypoint to a pull job.

  Expects to be given a module that implements the `ExGcloudPubsubPuller.PullController` behaviour.
  """
  @spec main(pull_controller()) :: any()
  def main(pull_controller) when is_atom(pull_controller) do
    _pull_controller = validate_pull_controller!(pull_controller)
  end

  def main(invalid_arg) do
    raise_invalid_pull_controller(invalid_arg)
  end

  @spec validate_pull_controller!(pull_controller()) :: pull_controller()
  defp validate_pull_controller!(some_module) do
    case Code.ensure_loaded(some_module) do
      {:module, handler_module} ->
        cond do
          function_exported?(handler_module, :subscription_id, 0) and
            function_exported?(handler_module, :handle_stagnant, 0) and
            function_exported?(handler_module, :handle_pull_error, 1) and
              function_exported?(handler_module, :handle_message, 1) ->
            handler_module

          true ->
            raise_invalid_pull_controller(some_module)
        end

      error ->
        raise ArgumentError,
              "Error ensuring pull controller module #{inspect(some_module)} was loaded: #{
                inspect(error)
              }"
    end
  end

  @spec raise_invalid_pull_controller(any()) :: any()
  defp raise_invalid_pull_controller(arg) do
    raise ArgumentError,
      message:
        "Expected a module that implements the `ExGcloudPubsubPuller.PullController` behaviour but got: #{
          inspect(arg)
        }"
  end
end
