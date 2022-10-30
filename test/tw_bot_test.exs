defmodule TwBotTest do
  use ExUnit.Case
  doctest TwBot

  test "greets the world" do
    assert TwBot.hello() == :world
  end
end
