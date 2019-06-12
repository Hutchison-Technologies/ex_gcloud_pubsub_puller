defmodule ExGcloudPubsubPullerTest do
  use ExUnit.Case
  doctest ExGcloudPubsubPuller

  describe "main/1 given invalid args" do
    test "raises an ArgumentError" do
      assert_raise ArgumentError, fn ->
        ExGcloudPubsubPuller.main(fn -> nil end)
      end

      assert_raise ArgumentError, fn ->
        ExGcloudPubsubPuller.main(:some_atom)
      end

      assert_raise ArgumentError, fn ->
        defmodule IncompleteModule do
        end

        ExGcloudPubsubPuller.main(IncompleteModule)
      end

      assert_raise ArgumentError, fn ->
        defmodule CostPullController do
          @behaviour ExGcloudPubsubPuller.PullController

          @impl true
          def subscription_id(), do: "cost-subscription"

          @impl true
          def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: nil}), do: :error

          def handle_message(%GoogleApi.PubSub.V1.Model.PubsubMessage{data: data}) do
            IO.inspect(data)
            :ok
          end

          @impl true
          def handle_stagnant(), do: nil
        end

        ExGcloudPubsubPuller.main(CostPullController)
      end
    end
  end
end
