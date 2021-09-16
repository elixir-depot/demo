defmodule DepotDemo.Minio do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    case config() do
      config when is_list(config) ->
        children = [
          {MinioServer, config},
          {Task,
           fn ->
             {_, config} = DepotDemo.Storage.__filesystem__()
             upsert_bucket(config.bucket)
           end}
        ]

        Supervisor.init(children, strategy: :one_for_one)

      _ ->
        :ignore
    end
  end

  def config do
    Application.get_env(:depot_demo, __MODULE__)
  end

  def upsert_bucket(name) do
    {:ok, %{body: %{buckets: buckets}}} =
      ExAws.S3.list_buckets()
      |> ExAws.request(config())

    unless name in buckets do
      initialize_bucket(name)
    end
  end

  def initialize_bucket(name) do
    {:ok, _} =
      ExAws.S3.put_bucket(name, Keyword.fetch!(config(), :region))
      |> ExAws.request(config())
  end

  def recreate_bucket(name) do
    ExAws.S3.delete_bucket(name)
    |> ExAws.request(config())

    {:ok, _} =
      ExAws.S3.put_bucket(name, Keyword.fetch!(config(), :region))
      |> ExAws.request(config())
  end

  def clean_bucket(name) do
    with {:ok, %{body: %{contents: list}}} <-
           ExAws.S3.list_objects(name)
           |> ExAws.request(config()) do
      for item <- list do
        ExAws.S3.delete_object(name, item.key) |> ExAws.request(config())
      end
    end
  end
end
