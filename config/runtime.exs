import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  app_name =
    System.get_env("FLY_APP_NAME") ||
      raise "FLY_APP_NAME not available"

  config :depot_demo, DepotDemoWeb.Endpoint,
    url: [host: "#{app_name}.fly.dev", port: 80],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  # Configure depot storage
  config :depot_demo, DepotDemo.Storage,
    bucket: "depot-demo-fly",
    config: [
      access_key_id: System.fetch_env!("MINIO_ROOT_USER"),
      secret_access_key: System.fetch_env!("MINIO_ROOT_PASSWORD"),
      scheme: "https://",
      region: "local",
      host: "depot-demo-minio.fly.dev",
      port: 443
    ]

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  config :depot_demo, DepotDemoWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.
end
