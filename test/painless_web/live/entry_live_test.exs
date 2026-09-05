defmodule PainlessWeb.EntryLiveTest do
  use PainlessWeb.ConnCase

  import Phoenix.LiveViewTest
  import Painless.AccountsFixtures
  import Painless.BookkeeperFixtures
  import Painless.LeasingAgentFixtures

  alias Painless.Accounts.User

  @create_attrs %{
    amount: 42,
    description: "some description",
    transaction_date: "2023-07-08",
    transaction_type: "income"
  }
  @update_attrs %{
    amount: 43,
    description: "some updated description",
    transaction_date: "2023-07-09",
    transaction_type: "receivable"
  }
  @invalid_attrs %{amount: nil, description: nil, transaction_date: nil}

  defp create_entry(_) do
    tenancy = tenancy_fixture()
    %{tenancy: tenancy, entry: entry_fixture(%{tenancy: tenancy})}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_entry]

    test "lists all entries", %{conn: conn, tenancy: tenancy, entry: entry} do
      {:ok, _index_live, html} = live(conn, ~p"/tenancies/#{tenancy}/entries")

      assert html =~ "Listing Entries"
      assert html =~ entry.description
    end

    test "shows created-by initials with email on hover", %{conn: conn, tenancy: tenancy} do
      author = user_fixture(%{email: "ken.barker@gmail.com"})
      _entry = entry_fixture(%{tenancy: tenancy, created_by: author, description: "created by ken"})

      {:ok, _index_live, html} = live(conn, ~p"/tenancies/#{tenancy}/entries")

      assert html =~ "created by ken"
      assert html =~ "KB"
      assert html =~ ~s(title="ken.barker@gmail.com")
      assert html =~ "rounded-md"
      assert html =~ "font-bold"
      refute html =~ "ken.barker@gmail.com</span>"
    end

    test "saves new entry as the current user", %{conn: conn, tenancy: tenancy, user: user} do
      {:ok, index_live, _html} = live(conn, ~p"/tenancies/#{tenancy}/entries")

      assert index_live |> element("a", "New Entry") |> render_click() =~
               "New Entry"

      assert_patch(index_live, ~p"/tenancies/#{tenancy}/entries/new")
      refute has_element?(index_live, "label", "Created by")

      assert index_live
             |> form("#entry-form", entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#entry-form", entry: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tenancies/#{tenancy}/entries")

      html = render(index_live)
      assert html =~ "Entry created successfully"
      assert html =~ "some description"
      assert html =~ User.initials(user)
      assert html =~ ~s(title="#{user.email}")
    end

    test "updates entry in listing and keeps created by", %{conn: conn, tenancy: tenancy} do
      author = user_fixture(%{email: "ken.barker@gmail.com"})
      entry = entry_fixture(%{tenancy: tenancy, created_by: author})

      {:ok, index_live, _html} = live(conn, ~p"/tenancies/#{tenancy}/entries")

      assert index_live |> element("#entries-#{entry.id} a", "Edit") |> render_click() =~
               "Edit Entry"

      assert_patch(index_live, ~p"/tenancies/#{tenancy}/entries/#{entry}/edit")
      assert has_element?(index_live, "label", "Created by")
      assert render(index_live) =~ "ken.barker@gmail.com"

      assert index_live
             |> form("#entry-form", entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#entry-form", entry: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/tenancies/#{tenancy}/entries")

      html = render(index_live)
      assert html =~ "Entry updated successfully"
      assert html =~ "some updated description"
      assert html =~ "KB"
      assert html =~ ~s(title="ken.barker@gmail.com")
    end

    test "deletes entry in listing", %{conn: conn, tenancy: tenancy, entry: entry} do
      {:ok, index_live, _html} = live(conn, ~p"/tenancies/#{tenancy}/entries")

      assert index_live |> element("#entries-#{entry.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#entries-#{entry.id}")
    end
  end

  describe "Show" do
    setup [:create_entry]

    test "displays entry", %{conn: conn, tenancy: tenancy, entry: entry} do
      {:ok, _show_live, html} = live(conn, ~p"/tenancies/#{tenancy}/entries/#{entry}")

      assert html =~ "Show Entry"
      assert html =~ entry.description
    end

    test "updates entry within modal", %{conn: conn, tenancy: tenancy, entry: entry} do
      {:ok, show_live, _html} = live(conn, ~p"/tenancies/#{tenancy}/entries/#{entry}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Entry"

      assert_patch(show_live, ~p"/tenancies/#{tenancy}/entries/#{entry}/show/edit")

      assert show_live
             |> form("#entry-form", entry: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#entry-form", entry: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/tenancies/#{tenancy}/entries/#{entry}")

      html = render(show_live)
      assert html =~ "Entry updated successfully"
      assert html =~ "some updated description"
    end
  end
end
