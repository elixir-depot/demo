defmodule DepotDemo.Files.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "file" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
