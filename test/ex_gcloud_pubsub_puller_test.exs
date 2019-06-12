defmodule ExGcloudPubsubPullerTest do
  use ExUnit.Case
  doctest ExGcloudPubsubPuller

  test "greets the world" do
    assert ExGcloudPubsubPuller.hello() == :world
  end
end
