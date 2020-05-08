# Geolix Adapter: MMDB2 Precompiled

Compile-Time MMDB2 adapter for [`Geolix`](https://github.com/elixir-geolix/geolix).

## Package Setup

To use the Geolix MMDB2 Precompiled Adapter with your projects, edit your `mix.exs` file and add the required dependencies:

```elixir
defp deps do
  [
    # ...
    {:geolix_adapter_mmdb2_precompiled, "~> 0.1.0"},
    # ...
  ]
end
```

An appropriate version of `:geolix` is automatically selected by the adapter's dependency tree.

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

License information about the supported [MaxMind GeoIP2 Country](https://www.maxmind.com/en/geoip2-country-database), [MaxMind GeoIP2 City](https://www.maxmind.com/en/geoip2-city) and [MaxMind GeoLite2](https://dev.maxmind.com/geoip/geoip2/geolite2/) databases can be found on their respective sites.
