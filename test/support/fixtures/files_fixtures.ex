defmodule DepotDemo.FilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DepotDemo.Files` context.
  """

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> DepotDemo.Files.create_file()

    file
  end
end
