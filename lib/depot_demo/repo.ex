defmodule DepotDemo.Repo do
  use Ecto.Repo,
    otp_app: :depot_demo,
    adapter: Ecto.Adapters.Postgres
end
