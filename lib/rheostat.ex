defmodule Rheostat do
  @moduledoc """
  A configurable stats provider. Rheostat provides a common interface to
  stats provider.

  Configure the provider with:

  ```
  config :rheostat, adapter: Rheostat.Adapter.Statix
  ```
  """

  @doc """
  Opens the connection to the stats server. configuration is read from
  the configuration for the `:statix` application (both globally and per
  connection).
  """
  def connect(opts \\ []) do
    adapter().connect(opts)
  end

  def count(metadata, metric, num) do
    adapter().count(metadata, metric, num)
  end

  def count(metadata, metric) when is_map(metadata) do
    adapter().count(metadata, metric, 1)
  end

  def count(metric, num) do
    adapter().count(%{}, metric, num)
  end

  def count(metric) do
    adapter().count(%{}, metric, 1)
  end

  def sample(metadata, metric, value) do
    adapter().sample(metadata, metric, value)
  end

  def sample(metric, value) do
    adapter().sample(%{}, metric, value)
  end

  def measure(metric, target) do
    measure(metric, [], target)
  end

  def measure(metadata, metric, target) when is_map(metadata) do
    adapter().measure(metadata, metric, target)
  end

  @doc """
  Measures the execution time of the given `function` and writes that to the
  timing identified by `key`.
  This function returns the value returned by `function`, making it suitable for
  easily wrapping existing code.
  ## Examples
      iex> Rheostat.measure("integer_to_string", [], fn -> Integer.to_string(123) end)
      "123"
  """
  def measure(key, options, target) when is_binary(key) do
    adapter().measure(key, options, target)
  end

  @doc """
  Increments the StatsD counter identified by `key` by the given `value`.
  `value` is supposed to be zero or positive and `c:decrement/3` should be
  used for negative values.

  ## Examples
      iex> Rheostat.increment("hits", 1, [])
      :ok
  """
  def increment(key, val, options) do
    adapter().increment(key, val, options)
  end

  @doc """
  Same as `increment(key, 1, [])`.
  """
  def increment(key), do: increment(key, 1, [])

  @doc """
  Same as `increment(key, value, [])`.
  """
  def increment(key, value), do: increment(key, value, [])

  @doc """
  Decrements the StatsD counter identified by `key` by the given `value`.
  Works same as `c:increment/3` but subtracts `value` instead of adding it. For
  this reason `value` should be zero or negative.
  ## Examples
      iex> Rheostat.decrement("open_connections", 1, [])
      :ok
  """
  def decrement(key, value, options) do
    adapter().decrement(key, value, options)
  end

  @doc """
  Same as `decrement(key, 1, [])`.
  """
  def decrement(key), do: decrement(key, 1, [])

  @doc """
  Same as `decrement(key, value, [])`.
  """
  def decrement(key, value), do: decrement(key, value, [])

  @doc """
  Writes to the StatsD gauge identified by `key`.
  ## Examples
      iex> Rheostat.gauge("cpu_usage", 0.83, [])
      :ok
  """
  def gauge(key, value, options), do: adapter().gauge(key, value, options)

  @doc """
  Same as `gauge(key, value, [])`.
  """
  def gauge(key, value), do: gauge(key, value, [])

  @doc """
  Writes `value` to the histogram identified by `key`. Not all
  StatsD-compatible servers support histograms. An example of a such
  server [statsite](https://github.com/statsite/statsite).
  ## Examples
      iex> Rheostat.histogram("online_users", 123, [])
      :ok
  """
  def histogram(key, value, options) do
    adapter().histogram(key, value, options)
  end

  @doc """
  Same as `histogram(key, value, [])`.
  """
  def histogram(key, value), do: histogram(key, value, [])

  @doc """
  Writes the given `value` to the timing identified by `key`. `value` is
  expected in milliseconds.
  ## Examples
      iex> Rheostat.timing("rendering", 12, [])
      :ok
  """
  def timing(key, value, options) do
    adapter().timing(key, value, options)
  end

  @doc """
  Same as `timing(key, value, [])`.
  """
  def timing(key, value), do: timing(key, value, [])

  @doc """
  Writes the given `value` to the set identified by `key`.
  ## Examples
      iex> Rheostat.set("unique_visitors", "user1", [])
      :ok
  """
  def set(key, value, options), do: adapter().set(key, value, options)

  @doc """
  Same as `set(key, value, [])`.
  """
  def set(key, value), do: adapter().set(key, value, [])

  @spec adapter() :: Rheostat.Adapter
  defp adapter do
    Application.get_env(:rheostat, :adapter, Rheostat.Adapter.Metrix)
  end
end
