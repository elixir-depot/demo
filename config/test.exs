import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :depot_demo, DepotDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Local S3 Server
config :depot_demo, DepotDemo.Minio,
  access_key_id: "minio_key",
  secret_access_key: "minio_secret",
  scheme: "http://",
  region: "local",
  host: "127.0.0.1",
  port: 9000

# Configure depot storage
config :depot_demo, DepotDemo.Storage,
  adapter: DepotS3,
  bucket: "depot-demo-dev",
  config: [
    access_key_id: "minio_key",
    secret_access_key: "minio_secret",
    scheme: "http://",
    region: "local",
    host: "127.0.0.1",
    port: 9000
  ]
