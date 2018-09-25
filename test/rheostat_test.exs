defmodule RheostatTest do
  use ExUnit.Case

  alias Rheostat.Adapter.Statix

  test "transforms the metadata" do
    assert Statix.tags(%{"source" => "whitelist.0", "foo" => "bar"}) == [
             "source:whitelist.0",
             "foo:bar"
           ]
  end
end
