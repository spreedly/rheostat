# Rheostat

A confugurable stats reporter.

Rheostat has the same functional interface as
[Metrix](https://github.com/rwdaigle/metrix) and [Statix](https://github.com/lexmag/statix) and includes adapters for each.

Rheostat can be configured to use one or the other (or any other adapter
you want to configure).

Metrix is good for logdrain style metrics. Statix is good for StatsD
metrics.

The latter means it works great with DataDog through the [DataDog Heroku
buildpack](https://github.com/DataDog/heroku-buildpack-datadog).

## Installation

```elixir
def deps do
  [
    {:rheostat, "~> 0.1.0"},
  ]
end
```

## Configuration

The most common way to use Rheostat is to configure it to use Metrix in
the `dev` and `test` profiles and to use Statix in `prod`.

```elixir
# dev, test
config :metrix,
  prefix: "my-app."

config :rheostat, adapter: Rheostat.Adapter.Metrix
```

```elixir
# prod
config :statix,
  prefix: "my-app"

config :rheostat, adapter: Rheostat.Adapter.Statix
```

The Metrix adapter is also the default.

Finally, the `Statix` addapter requires initialization, so add this to your application `start`:

```elixir
  def start(_type, _args) do
    :ok = Rheostat.connect()
  end
```

## Usage

Because Rheostat has the same function interface as Metrix you can
replace:

```elixir
  import Metrix
```

with:

```elixir
  import Rheostat
```

Or globaly replace `Metrix` with `Rheostat`.

There may be other more clever ways to do that as well.
