defmodule ExGcloudPubsubPuller.SubscriptionHealthTest do
  use ExUnit.Case
  doctest ExGcloudPubsubPuller.SubscriptionHealth
  alias ExGcloudPubsubPuller.{SubscriptionHealth, MemoryStore}

  describe "is_stagnant?/1 given subscription_id that has no entry in the memory store" do
    test "returns false" do
      refute SubscriptionHealth.is_stagnant?("warblemuck")
    end
  end

  describe "is_stagnant?/1 given subscription_id that has an entry in the memory store" do
    test "returns false when that entry contains last_message_at < 30 seconds ago" do
      sub_id = "great_sub"
      SubscriptionHealth.touch(sub_id)
      refute SubscriptionHealth.is_stagnant?(sub_id)
      refute SubscriptionHealth.is_stagnant?(sub_id)
    end

    test "returns false when that entry contains last_stagnant_at < 30 seconds ago" do
      sub_id = "poop_sub"
      MemoryStore.save(sub_id, %{last_message_at: Timex.now() |> Timex.shift(seconds: -60)})
      assert SubscriptionHealth.is_stagnant?(sub_id)
      refute SubscriptionHealth.is_stagnant?(sub_id)
    end

    test "returns true when that entry contains last_message_at >= 30 seconds ago" do
      sub_id = "not_great_sub"
      MemoryStore.save(sub_id, %{last_message_at: Timex.now() |> Timex.shift(seconds: -60)})
      assert SubscriptionHealth.is_stagnant?(sub_id)
    end
  end

  describe "touch/1 given subscription_id that has no entry in the memory store" do
    test "doesn't raise" do
      assert SubscriptionHealth.touch("warblemuck")
    end
  end
end
