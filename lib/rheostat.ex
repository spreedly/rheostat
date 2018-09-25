defmodule Rheostat do
  @stats Application.get_env(:rheostat, :adapter, Rheostat.Adapter.Metrix)

  def connect(), do: @stats.connect()

  def count(metric), do: count(metric, 1)
  def count(metric, num) when is_number(num), do: count(%{}, metric, num)
  def count(metadata, metric), do: count(metadata, metric, 1)
  def count(metadata, metric, num), do: @stats.count(metadata, metric, num)

  def sample(metric, value), do: sample(%{}, metric, value)
  def sample(metadata, metric, value), do: @stats.sample(metadata, metric, value)

  def measure(metric, ms) when is_number(ms), do: measure(%{}, metric, ms)
  def measure(metric, fun) when is_function(fun), do: measure(%{}, metric, fun)
  def measure(metadata, metric, ms) when is_number(ms), do: @stats.measure(metadata, metric, ms)

  def measure(metadata, metric, fun) when is_function(fun),
    do: @stats.measure(metadata, metric, fun)
end

defmodule Rheostat.Adapter.Metrix do
  def connect(), do: :ok

  def count(metric), do: count(metric, 1)
  def count(metric, num) when is_number(num), do: count(%{}, metric, num)
  def count(metadata, metric), do: count(metadata, metric, 1)
  def count(metadata, metric, num), do: Metrix.count(metadata, metric, num)

  def sample(metric, value), do: sample(%{}, metric, value)
  def sample(metadata, metric, value), do: Metrix.sample(metadata, metric, value)

  def measure(metric, ms) when is_number(ms), do: measure(%{}, metric, ms)
  def measure(metric, fun) when is_function(fun), do: measure(%{}, metric, fun)

  def measure(metadata, metric, ms) when is_number(ms), do: Metrix.measure(metadata, metric, ms)

  def measure(metadata, metric, fun) when is_function(fun),
    do: Metrix.measure(metadata, metric, fun)
end

defmodule Rheostat.Adapter.Statix do
  alias Rheostat.Internal.Adapter.Statix

  def connect(), do: Statix.connect()

  def count(metric), do: count(metric, 1)
  def count(metric, num) when is_number(num), do: count(%{}, metric, num)
  def count(metadata, metric), do: count(metadata, metric, 1)
  def count(metadata, metric, num), do: Statix.increment(metric, num, tags: tags(metadata))

  def sample(metric, value), do: sample(%{}, metric, value)
  def sample(metadata, metric, value), do: Statix.gauge(metric, value, tags: tags(metadata))

  def measure(metric, ms) when is_number(ms), do: measure(%{}, metric, ms)
  def measure(metric, fun) when is_function(fun), do: measure(%{}, metric, fun)

  def measure(metadata, metric, ms) when is_number(ms) do
    Statix.timing(metric, ms, tags: tags(metadata))
  end

  def measure(metadata, metric, fun) when is_function(fun) do
    Statix.measure(metric, [tags: tags(metadata)], fun)
  end

  def tags(metadata) do
    metadata
    |> Enum.reduce([], fn {key, value}, list ->
      ["#{key}:#{value}" | list]
    end)
  end
end

defmodule Rheostat.Internal.Adapter.Statix do
  use Statix
end
