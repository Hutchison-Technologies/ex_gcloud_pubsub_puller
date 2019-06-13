defmodule ExGcloudPubsubPuller.Messages.SorterTest do
  use ExUnit.Case
  doctest ExGcloudPubsubPuller.Messages.Sorter
  alias ExGcloudPubsubPuller.Messages.Sorter
  alias GoogleApi.PubSub.V1.Model

  @test_list [
    %Model.ReceivedMessage{
      ackId: "mid",
      message: %Model.PubsubMessage{
        publishTime: Timex.now() |> Timex.shift(minutes: -30)
      }
    },
    %Model.ReceivedMessage{
      ackId: "first",
      message: %Model.PubsubMessage{
        publishTime: Timex.now() |> Timex.shift(hours: -1)
      }
    },
    %Model.ReceivedMessage{
      ackId: "last",
      message: %Model.PubsubMessage{
        publishTime: Timex.now()
      }
    }
  ]

  describe "by_date/1" do
    test "returns list of same objects" do
      actual = @test_list |> Sorter.by_date()
      assert actual |> length() == @test_list |> length()

      @test_list
      |> Enum.each(fn msg ->
        assert msg in actual
      end)
    end

    test "returns ordered list" do
      actual = @test_list |> Sorter.by_date()
      assert actual |> List.first() |> Map.get(:ackId) == "first"
      assert actual |> List.last() |> Map.get(:ackId) == "last"
    end
  end
end
