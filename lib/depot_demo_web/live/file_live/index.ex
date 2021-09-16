defmodule DepotDemoWeb.FileLive.Index do
  use DepotDemoWeb, :live_view

  alias DepotDemo.Files
  alias DepotDemo.Files.File

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit File")
    |> assign(:file, Files.get_file!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New File")
    |> assign(:file, %File{})
    |> assign(:path, "")
    |> assign(:file_collection, list_file(""))
  end

  defp apply_action(socket, :index, params) do
    path = Path.join(params["path"] || [""])

    socket
    |> assign(:page_title, "Listing File")
    |> assign(:path, path)
    |> assign(:file_collection, list_file(path))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    file = Files.get_file!(id)
    {:ok, _} = Files.delete_file(file)

    {:noreply, socket}
  end

  defp list_file(path) do
    {:ok, data} = DepotDemo.Storage.list_contents(path)
    data
  end

  defp file(assigns) do
    case assigns.file_type do
      Depot.Stat.Dir ->
        ~H"""
        <div>
          <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="folder" class="svg-inline--fa fa-folder fa-w-16" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" style="width: 2rem; color: skyblue; display: inline"><path fill="currentColor" d="M464 128H272l-64-64H48C21.49 64 0 85.49 0 112v288c0 26.51 21.49 48 48 48h416c26.51 0 48-21.49 48-48V176c0-26.51-21.49-48-48-48z"></path></svg>
          <%= link @file.name <> "/", to: "./#{@file.name}/" %>
        </div>
        """

      Depot.Stat.File ->
        ~H"""
        <div>
          <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="file" class="svg-inline--fa fa-file fa-w-12" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" style="width: 1rem; color: skyblue; display: inline"><path fill="currentColor" d="M224 136V0H24C10.7 0 0 10.7 0 24v464c0 13.3 10.7 24 24 24h336c13.3 0 24-10.7 24-24V160H248c-13.2 0-24-10.8-24-24zm160-14.1v6.1H256V0h6.1c6.4 0 12.5 2.5 17 7l97.9 98c4.5 4.5 7 10.6 7 16.9z"></path></svg>
          <%= link @file.name, to: "./#{@file.name}/" %>
        </div>
        """
    end
  end
end
