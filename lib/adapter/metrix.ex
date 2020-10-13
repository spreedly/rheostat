defmodule Rheostat.Adapter.Metrix do
  @moduledoc """
  Provide a Metrix adapter for Rheostat.

  https://github.com/rwdaigle/metrix
  """

  @behaviour Rheostat.Adapter

  def connect(_opts), do: :ok

  def count(metadata, metric, num), do: Metrix.count(metadata, metric, num)

  def sample(metadata, metric, value), do: Metrix.sample(metadata, metric, value)

  def measure(metadata, key, target) when is_map(metadata) and is_function(target) do
    Metrix.measure(metadata, key, target)
  end

  def measure(metadata, key, target) when is_map(metadata)  do
    Metrix.measure(metadata, key, target)
  end

  def measure(key, options, target) when is_binary(key) and is_function(target) do
    Metrix.measure(metadata(options), key, target)
  end

  def measure(key, options, target) when is_binary(key) do
    Metrix.measure(metadata(options), key, target)
  end

  def increment(key, val \\ 1, options \\ []) when is_number(val) do
    count(metadata(options), key, val)
    :ok
  end

  def decrement(key, val \\ 1, options \\ []) when is_number(val) do
    count(key, val, options)
    :ok
  end

  def gauge(key, val, options \\ []) do
    Metrix.sample(metadata(options), key, val)
    :ok
  end

  def histogram(key, val, options \\ []) do
    Metrix.measure(metadata(options), key, val)
  end

  def timing(key, val, options \\ []) do
    Metrix.measure(metadata(options), key, val)
  end

  def set(key, val, options \\ []) do
    Metrix.sample(metadata(options), key, val)
    :ok
  end

  def metadata(options) do
    options
    |> Keyword.get(:tags, [])
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn [key, value] -> {key, value} end)
    |> Enum.into(%{})
  end
end
