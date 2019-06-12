defmodule ExGcloudPubsubPullerTest do
  use ExUnit.Case
  doctest ExGcloudPubsubPuller

  describe "main/1 given invalid args" do
    test "raises an ArgumentError" do
      assert_raise ArgumentError, fn ->
        ExGcloudPubsubPuller.main(fn -> nil end)
      end
    end
  end
end
