defmodule PlayAppTest do
  use ExUnit.Case
  doctest PlayApp

  test "greets the world" do
    assert PlayApp.hello() == :world
  end
end
