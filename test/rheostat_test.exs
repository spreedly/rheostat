defmodule RheostatTest do
  use ExUnit.Case

  alias Rheostat.StatixAdapter

  test "transforms the metadata" do
    assert StatixAdapter.tags(%{"source" => "whitelist.0", "foo" => "bar"}) == [
             "source:whitelist.0",
             "foo:bar"
           ]
  end
end
