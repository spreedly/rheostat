defmodule Rheostat.Adapter.Test do
  @behaviour Rheostat.Adapter

  def connect(_opts), do: :ok

  def count(metadata, metric, num) do
    send(:test_case, {:count, metadata, metric, num})
    :ok
  end

  def sample(metadata, metric, value) do
    send(:test_case, {:sample, metadata, metric, value})
    :ok
  end

  def measure(key, fun) when is_function(fun) do
    result = fun.()
    send(:test_case, {:measure, key, fun})
    result
  end

  def measure(key, ms) when is_number(ms) do
    send(:test_case, {:measure, key, ms})
    ms
  end

  def measure(key, options, fun) when is_function(fun) do
    result = fun.()
    send(:test_case, {:measure, key, options, fun})
    result
  end

  def measure(key, options, ms) when is_number(ms) do
    send(:test_case, {:measure, key, options, ms})
    ms
  end

  def increment(key, val \\ 1, options \\ []) when is_number(val) do
    send(:test_case, {:increment, key, val, options})
    :ok
  end

  def decrement(key, val \\ 1, options \\ []) when is_number(val) do
    send(:test_case, {:decrement, key, val, options})
    :ok
  end

  def gauge(key, val, options \\ []) do
    send(:test_case, {:gauge, key, val, options})
    :ok
  end

  def histogram(key, val, options \\ []) do
    send(:test_case, {:histogram, key, val, options})
  end

  def timing(key, val, options \\ []) do
    send(:test_case, {:timing, key, val, options})
  end

  def set(key, val, options \\ []) do
    send(:test_case, {:set, key, val, options})
  end
end
