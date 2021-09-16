defmodule DepotDemoWeb.FileLiveTest do
  use DepotDemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import DepotDemo.FilesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_file(_) do
    file = file_fixture()
    %{file: file}
  end

  describe "Index" do
    setup [:create_file]

    test "lists all file", %{conn: conn, file: file} do
      {:ok, _index_live, html} = live(conn, Routes.file_index_path(conn, :index))

      assert html =~ "Listing File"
      assert html =~ file.name
    end

    test "saves new file", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.file_index_path(conn, :index))

      assert index_live |> element("a", "New File") |> render_click() =~
               "New File"

      assert_patch(index_live, Routes.file_index_path(conn, :new))

      assert index_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#file-form", file: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.file_index_path(conn, :index))

      assert html =~ "File created successfully"
      assert html =~ "some name"
    end

    test "updates file in listing", %{conn: conn, file: file} do
      {:ok, index_live, _html} = live(conn, Routes.file_index_path(conn, :index))

      assert index_live |> element("#file-#{file.id} a", "Edit") |> render_click() =~
               "Edit File"

      assert_patch(index_live, Routes.file_index_path(conn, :edit, file))

      assert index_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#file-form", file: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.file_index_path(conn, :index))

      assert html =~ "File updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes file in listing", %{conn: conn, file: file} do
      {:ok, index_live, _html} = live(conn, Routes.file_index_path(conn, :index))

      assert index_live |> element("#file-#{file.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#file-#{file.id}")
    end
  end

  describe "Show" do
    setup [:create_file]

    test "displays file", %{conn: conn, file: file} do
      {:ok, _show_live, html} = live(conn, Routes.file_show_path(conn, :show, file))

      assert html =~ "Show File"
      assert html =~ file.name
    end

    test "updates file within modal", %{conn: conn, file: file} do
      {:ok, show_live, _html} = live(conn, Routes.file_show_path(conn, :show, file))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit File"

      assert_patch(show_live, Routes.file_show_path(conn, :edit, file))

      assert show_live
             |> form("#file-form", file: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#file-form", file: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.file_show_path(conn, :show, file))

      assert html =~ "File updated successfully"
      assert html =~ "some updated name"
    end
  end
end
