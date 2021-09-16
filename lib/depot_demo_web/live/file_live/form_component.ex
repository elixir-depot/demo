defmodule DepotDemoWeb.FileLive.FormComponent do
  use DepotDemoWeb, :live_component
  alias DepotDemo.Storage

  @impl true
  def mount(socket) do
    {:ok,
     allow_upload(socket, :file,
       accept: :any,
       max_entries: 1,
       auto_upload: true,
       progress: &handle_progress/3
     )
     |> assign(changeset: Ecto.Changeset.change({%{}, %{}}))}
  end

  @impl true
  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("back", _, socket) do
    socket =
      socket
      |> put_flash(:info, "ok")
      |> push_redirect(to: Routes.file_index_path(socket, :index))

    {:noreply, socket}
  end

  defp handle_progress(:file, entry, socket) do
    if entry.done? do
      uploaded_file =
        consume_uploaded_entry(socket, entry, fn %{} = meta ->
          {{y, mo, d}, {h, m, s}} =
            NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> NaiveDateTime.to_erl()

          path = Path.join([y, mo, d, h, m, s, entry.client_name] |> Enum.map(&to_string/1))
          Storage.write(path, File.read!(meta.path))
          %{name: path}
        end)

      socket =
        socket
        |> put_flash(:info, "file #{uploaded_file.name} uploaded")
        |> push_redirect(to: Routes.file_index_path(socket, :index))

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end
end
