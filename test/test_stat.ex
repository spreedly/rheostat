defmodule Rheostat.TestStats do
  def connect(), do: :ok

  def count(metric), do: count(metric, 1)
  def count(metric, num) when is_number(num), do: count(%{}, metric, num)
  def count(metadata, metric), do: count(metadata, metric, 1)

  def count(metadata, metric, num) do
    send(:test_case, {metadata, metric, num})
  end

  def sample(metric, value), do: sample(%{}, metric, value)

  def sample(metadata, metric, value) do
    send(:test_case, {metadata, metric, value})
  end

  def measure(metric, ms) when is_number(ms), do: measure(%{}, metric, ms)
  def measure(metric, fun) when is_function(fun), do: measure(%{}, metric, fun)

  def measure(metadata, metric, ms) when is_number(ms) do
    send(:test_case, {metadata, metric, ms})
  end

  def measure(metadata, metric, fun) when is_function(fun) do
    res = fun.()
    send(:test_case, {metadata, metric, ms})
    res
  end
end
