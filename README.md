# Rheostat

A confugurable stats reporter.

Rheostat has the same interface, but in a different namespace, as
[Metrix](https://github.com/rwdaigle/metrix) and includes a Metrix
adapter.

More importantly, Rheostat includes an adapter for
[Statix](https://github.com/lexmag/statix), which is a StatsD client.
That means it works great with DataDog through the [DataDog Heroku
buildpack](https://github.com/DataDog/heroku-buildpack-datadog).

## Installation

```elixir
def deps do
  [
    {:rheostat, git: "https://github.com/spreedly/rheostat.git"},
  ]
end
```

## Configuration

The most common way to use Rheostat is to configure it to use Metrix in
the `dev` and `test` profiles and to use Statix in `prod`.

```elixir
# dev, test
config :metrix,
  prefix: "kafka-s3."

config :rheostat, adapter: Rheostat.Adapter.Metrix
```

```elixir
# prod
config :statix,
  prefix: "kafka-s3"

config :rheostat, adapter: Rheostat.Adapter.Statix
```

The Metrix adapter is also the default.

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

There may be other more clever ways to do that as well.
