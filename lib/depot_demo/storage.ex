defmodule DepotDemo.Storage do
  use Depot.Filesystem, adapter: DepotS3, otp_app: :depot_demo
end
