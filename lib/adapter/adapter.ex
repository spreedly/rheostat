defmodule Rheostat.Adapter do
  @type key :: iodata
  @type options :: [sample_rate: float, tags: [String.t()]]
  @type on_send :: :ok | {:error, term}

  ## Metrix interface
  @callback count(map(), String.t(), number()) :: any()

  @callback sample(map(), String.t(), any()) :: any()

  @callback measure(map(), String.t(), any()) :: any()

  @callback measure(String.t(), list(), any()) :: any()

  ## StatsD interface

  @doc """
  Opens the connection to the StatsD-compatible server.
  The configuration is read from the configuration for the `:statix` application
  (both globally and per connection).
  """
  @callback connect(list()) :: :ok

  @doc """
  Increments the StatsD counter identified by `key` by the given `value`.
  `value` is supposed to be zero or positive and `c:decrement/3` should be
  used for negative values.
  ## Examples
      iex> MyApp.Statix.increment("hits", 1, [])
      :ok
  """
  @callback increment(key, value :: number, options) :: on_send

  @doc """
  Same as `increment(key, 1, [])`.
  """
  @callback increment(key) :: on_send

  @doc """
  Same as `increment(key, value, [])`.
  """
  @callback increment(key, value :: number) :: on_send

  @doc """
  Decrements the StatsD counter identified by `key` by the given `value`.
  Works same as `c:increment/3` but subtracts `value` instead of adding it. For
  this reason `value` should be zero or negative.
  ## Examples
      iex> MyApp.Statix.decrement("open_connections", 1, [])
      :ok
  """
  @callback decrement(key, value :: number, options) :: on_send

  @doc """
  Same as `decrement(key, 1, [])`.
  """
  @callback decrement(key) :: on_send

  @doc """
  Same as `decrement(key, value, [])`.
  """
  @callback decrement(key, value :: number) :: on_send

  @doc """
  Writes to the StatsD gauge identified by `key`.
  ## Examples
      iex> MyApp.Statix.gauge("cpu_usage", 0.83, [])
      :ok
  """
  @callback gauge(key, value :: String.Chars.t(), options) :: on_send

  @doc """
  Same as `gauge(key, value, [])`.
  """
  @callback gauge(key, value :: String.Chars.t()) :: on_send

  @doc """
  Writes `value` to the histogram identified by `key`.
  Not all StatsD-compatible servers support histograms. An example of a such
  server [statsite](https://github.com/statsite/statsite).
  ## Examples
      iex> MyApp.Statix.histogram("online_users", 123, [])
      :ok
  """
  @callback histogram(key, value :: String.Chars.t(), options) :: on_send

  @doc """
  Same as `histogram(key, value, [])`.
  """
  @callback histogram(key, value :: String.Chars.t()) :: on_send

  @doc """
  Writes the given `value` to the StatsD timing identified by `key`.
  `value` is expected in milliseconds.
  ## Examples
      iex> MyApp.Statix.timing("rendering", 12, [])
      :ok
  """
  @callback timing(key, value :: String.Chars.t(), options) :: on_send

  @doc """
  Same as `timing(key, value, [])`.
  """
  @callback timing(key, value :: String.Chars.t()) :: on_send

  @doc """
  Writes the given `value` to the StatsD set identified by `key`.
  ## Examples
      iex> MyApp.Statix.set("unique_visitors", "user1", [])
      :ok
  """
  @callback set(key, value :: String.Chars.t(), options) :: on_send

  @doc """
  Same as `set(key, value, [])`.
  """
  @callback set(key, value :: String.Chars.t()) :: on_send
end
