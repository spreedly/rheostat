defmodule Rheostat.Adapter.Statix do
  @moduledoc """
  Provide a Statix adapter for Rheostat.

  https://github.com/lexmag/statix
  """


  @behaviour Rheostat.Adapter

  alias Rheostat.Internal.StatixAdapter

  def connect(opts) do
    StatixAdapter.connect(opts)
  end

  def count(metadata, metric, num), do: increment(metric, num, tags: tags(metadata))

  @spec sample(any(), binary() | maybe_improper_list(), any()) :: any()
  def sample(metadata, metric, value),
    do: gauge(metric, value, tags: tags(metadata))

  def measure(metadata, key, fun) when is_map(metadata) do
    measure(key, [tags: tags(metadata)], fun)
  end

  def measure(key, options, subject) when is_binary(key) do
    StatixAdapter.measure(key, options, subject)
  end

  def increment(key, val \\ 1, options \\ []) when is_number(val) do
    StatixAdapter.increment(key, val, options)
  end

  def decrement(key, val \\ 1, options \\ []) when is_number(val) do
    StatixAdapter.decrement(key, val, options)
  end

  def gauge(key, val, options \\ []) do
    StatixAdapter.gauge(key, val, options)
  end

  def histogram(key, val, options \\ []) do
    StatixAdapter.histogram(key, val, options)
  end

  def timing(key, val, options \\ []) do
    StatixAdapter.timing(key, val, options)
  end

  def set(key, val, options \\ []) do
    StatixAdapter.set(key, val, options)
  end

  @doc """
  Create StatsD tags from a map of metadata.

  Returns a list of concatenated metadata: `["key1:value1", "key2:value2", ...]`
  """
  def tags(metadata) do
    metadata
    |> Enum.reduce([], fn {key, value}, list ->
      ["#{key}:#{value}" | list]
    end)
  end
end

defmodule Rheostat.Internal.StatixAdapter do
  use Statix, runtime_config: true
end
