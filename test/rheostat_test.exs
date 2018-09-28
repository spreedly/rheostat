defmodule RheostatTest do
  use ExUnit.Case

  alias Rheostat.Adapter.Statix
  alias Rheostat.Adapter.Metrix

  setup do
    Process.register(self(), :test_case)
    Application.put_env(:rheostat, :adapter, Rheostat.Adapter.Test)
  end

  test "transforms the metadata" do
    assert Statix.tags(%{"source" => "whitelist.0", "foo" => "bar"}) == [
             "source:whitelist.0",
             "foo:bar"
           ]
  end

  test "transforms the tags" do
    assert Metrix.metadata(tags: ["source:whitelist.0", "foo:bar"]) == %{
             "source" => "whitelist.0",
             "foo" => "bar"
           }
  end

  test "count/1" do
    Rheostat.count("awesomeness")
    assert_receive {:count, %{}, "awesomeness", 1}
  end

  test "count/2 with metadata" do
    Rheostat.count(%{"source" => "sauce"}, "awesomeness")
    assert_receive {:count, %{"source" => "sauce"}, "awesomeness", 1}
  end

  test "count/2 with num" do
    Rheostat.count("awesomeness", 2)
    assert_receive {:count, %{}, "awesomeness", 2}
  end

  test "count/3" do
    Rheostat.count(%{"source" => "sauce"}, "awesomeness", 2)
    assert_receive {:count, %{"source" => "sauce"}, "awesomeness", 2}
  end

  test "sample/2" do
    Rheostat.sample("awesomeness", "golden")
    assert_receive {:sample, %{}, "awesomeness", "golden"}
  end

  test "sample/3" do
    Rheostat.sample(%{"source" => "sauce"}, "awesomeness", "golden")
    assert_receive {:sample, %{"source" => "sauce"}, "awesomeness", "golden"}
  end

  test "measure/2 fun" do
    Rheostat.measure("awesomeness", fn -> 1 end)
    assert_receive {:measure, "awesomeness", [], fun}
    assert is_function(fun, 0)
  end

  test "measure/2 number" do
    Rheostat.measure("awesomeness", 1)
    assert_receive {:measure, "awesomeness", [], 1}
  end

  test "measure/3 source and fun" do
    Rheostat.measure(%{"source" => "sauce"}, "awesomeness", fn -> 1 end)
    assert_receive {:measure, %{"source" => "sauce"}, "awesomeness", fun}
    assert is_function(fun, 0)
  end

  test "measure/3 source and number" do
    Rheostat.measure(%{"source" => "sauce"}, "awesomeness", 1)
    assert_receive {:measure, %{"source" => "sauce"}, "awesomeness", 1}
  end

  test "measure/3 tags and fun" do
    Rheostat.measure("awesomeness", [tags: ["source:sauce"]], fn -> 1 end)
    assert_receive {:measure, "awesomeness", [tags: ["source:sauce"]], fun}
    assert is_function(fun, 0)
  end

  test "measure/3 tags and number" do
    Rheostat.measure("awesomeness", [tags: ["source:sauce"]], 1)
    assert_receive {:measure, "awesomeness", [tags: ["source:sauce"]], 1}
  end

  test "increment/1" do
    Rheostat.increment("awesomeness")
    assert_receive {:increment, "awesomeness", 1, []}
  end

  test "increment/2" do
    Rheostat.increment("awesomeness", 2)
    assert_receive {:increment, "awesomeness", 2, []}
  end

  test "increment/3" do
    Rheostat.increment("awesomeness", 2, tags: ["source:sauce"])
    assert_receive {:increment, "awesomeness", 2, [tags: ["source:sauce"]]}
  end

  test "decrement/1" do
    Rheostat.decrement("awesomeness")
    assert_receive {:decrement, "awesomeness", 1, []}
  end

  test "decrement/2" do
    Rheostat.decrement("awesomeness", 2)
    assert_receive {:decrement, "awesomeness", 2, []}
  end

  test "decrement/3" do
    Rheostat.decrement("awesomeness", 2, tags: ["source:sauce"])
    assert_receive {:decrement, "awesomeness", 2, [tags: ["source:sauce"]]}
  end

  test "gauge/2" do
    Rheostat.gauge("awesomeness", "golden")
    assert_receive {:gauge, "awesomeness", "golden", []}
  end

  test "gauge/3" do
    Rheostat.gauge("awesomeness", "golden", [tags: ["source:sauce"]])
    assert_receive {:gauge, "awesomeness", "golden", [tags: ["source:sauce"]]}
  end

  test "histogram/2" do
    Rheostat.histogram("awesomeness", "golden")
    assert_receive {:histogram, "awesomeness", "golden", []}
  end

  test "histogram/3" do
    Rheostat.histogram("awesomeness", "golden", [tags: ["source:sauce"]])
    assert_receive {:histogram, "awesomeness", "golden", [tags: ["source:sauce"]]}
  end

  test "timing/2" do
    Rheostat.timing("awesomeness", "golden")
    assert_receive {:timing, "awesomeness", "golden", []}
  end

  test "timing/3" do
    Rheostat.timing("awesomeness", "golden", [tags: ["source:sauce"]])
    assert_receive {:timing, "awesomeness", "golden", [tags: ["source:sauce"]]}
  end

  test "set/2" do
    Rheostat.set("awesomeness", "golden")
    assert_receive {:set, "awesomeness", "golden", []}
  end

  test "set/3" do
    Rheostat.set("awesomeness", "golden", [tags: ["source:sauce"]])
    assert_receive {:set, "awesomeness", "golden", [tags: ["source:sauce"]]}
  end
end
