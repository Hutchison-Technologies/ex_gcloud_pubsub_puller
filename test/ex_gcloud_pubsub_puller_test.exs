defmodule ExGcloudPubsubPullerTest do
  use ExUnit.Case
  doctest ExGcloudPubsubPuller

  describe "main/1 given invalid args" do
    test "raises an ArgumentError when given module doesn't implement full ExGcloudPubsubPuller.PullController behaviour" do
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
          def handle_message(_), do: :ok

          @impl true
          def handle_stagnant(), do: nil
        end

        ExGcloudPubsubPuller.main(CostPullController)
      end
    end

    test "raises an ArgumentError when given module returns invalid subscription_id" do
      assert_raise ArgumentError, fn ->
        defmodule BadSubOnePullController do
          @behaviour ExGcloudPubsubPuller.PullController

          @impl true
          def subscription_id(), do: "-subscription"

          @impl true
          def handle_message(_), do: :ok

          @impl true
          def handle_stagnant(), do: nil

          @impl true
          def handle_pull_error(_), do: nil

          @impl true
          def handle_ack_error(_), do: nil
        end

        ExGcloudPubsubPuller.main(BadSubOnePullController)
      end

      assert_raise ArgumentError, fn ->
        defmodule BadSubTwoPullController do
          @behaviour ExGcloudPubsubPuller.PullController

          @impl true
          def subscription_id(), do: "sub scription"

          @impl true
          def handle_message(_), do: :ok

          @impl true
          def handle_stagnant(), do: nil

          @impl true
          def handle_pull_error(_), do: nil

          @impl true
          def handle_ack_error(_), do: nil
        end

        ExGcloudPubsubPuller.main(BadSubTwoPullController)
      end

      assert_raise ArgumentError, fn ->
        defmodule BadSubThreePullController do
          @behaviour ExGcloudPubsubPuller.PullController

          @impl true
          def subscription_id(), do: "sub?scription"

          @impl true
          def handle_message(_), do: :ok

          @impl true
          def handle_stagnant(), do: nil

          @impl true
          def handle_pull_error(_), do: nil

          @impl true
          def handle_ack_error(_), do: nil
        end

        ExGcloudPubsubPuller.main(BadSubThreePullController)
      end
    end
  end

  describe "main/1 given valid args" do
    test "raises no error when given module implements full ExGcloudPubsubPuller.PullController behaviour" do
      defmodule GoodController do
        @behaviour ExGcloudPubsubPuller.PullController

        @impl true
        def subscription_id(), do: "cost-subscription"

        @impl true
        def handle_message(_), do: :ok

        @impl true
        def handle_stagnant(), do: nil

        @impl true
        def handle_pull_error(_), do: nil

        @impl true
        def handle_ack_error(_), do: nil
      end

      ExGcloudPubsubPuller.main(GoodController)
    end

    test "raises no error when given module returns valid subscription_id" do
      defmodule GoodSubOnePullController do
        @behaviour ExGcloudPubsubPuller.PullController

        @impl true
        def subscription_id(), do: "cost-subscription"

        @impl true
        def handle_message(_), do: :ok

        @impl true
        def handle_stagnant(), do: nil

        @impl true
        def handle_pull_error(_), do: nil

        @impl true
        def handle_ack_error(_), do: nil
      end

      ExGcloudPubsubPuller.main(GoodSubOnePullController)

      defmodule GoodSubTwoPullController do
        @behaviour ExGcloudPubsubPuller.PullController

        @impl true
        def subscription_id(), do: "subscription"

        @impl true
        def handle_message(_), do: :ok

        @impl true
        def handle_stagnant(), do: nil

        @impl true
        def handle_pull_error(_), do: nil

        @impl true
        def handle_ack_error(_), do: nil
      end

      ExGcloudPubsubPuller.main(GoodSubTwoPullController)

      defmodule GoodSubThreePullController do
        @behaviour ExGcloudPubsubPuller.PullController

        @impl true
        def subscription_id(), do: "subScri0ption"

        @impl true
        def handle_message(_), do: :ok

        @impl true
        def handle_stagnant(), do: nil

        @impl true
        def handle_pull_error(_), do: nil

        @impl true
        def handle_ack_error(_), do: nil
      end

      ExGcloudPubsubPuller.main(GoodSubThreePullController)
    end
  end
end
