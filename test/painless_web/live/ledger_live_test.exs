defmodule PainlessWeb.LedgerLiveTest do
  use PainlessWeb.ConnCase

  import Phoenix.LiveViewTest
  import Painless.LedgersFixtures

  @create_attrs %{acct_type: "some acct_type", balance: 42, name: "some name"}
  @update_attrs %{acct_type: "some updated acct_type", balance: 43, name: "some updated name"}
  @invalid_attrs %{acct_type: nil, balance: nil, name: nil}

  defp create_ledger(_) do
    ledger = ledger_fixture()
    %{ledger: ledger}
  end

  describe "Index" do
    setup [:create_ledger]

    test "lists all ledgers", %{conn: conn, ledger: ledger} do
      {:ok, _index_live, html} = live(conn, ~p"/ledgers")

      assert html =~ "Listing Ledgers"
      assert html =~ ledger.acct_type
    end

    test "saves new ledger", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/ledgers")

      assert index_live |> element("a", "New Ledger") |> render_click() =~
               "New Ledger"

      assert_patch(index_live, ~p"/ledgers/new")

      assert index_live
             |> form("#ledger-form", ledger: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ledger-form", ledger: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/ledgers")

      assert html =~ "Ledger created successfully"
      assert html =~ "some acct_type"
    end

    test "updates ledger in listing", %{conn: conn, ledger: ledger} do
      {:ok, index_live, _html} = live(conn, ~p"/ledgers")

      assert index_live |> element("#ledgers-#{ledger.id} a", "Edit") |> render_click() =~
               "Edit Ledger"

      assert_patch(index_live, ~p"/ledgers/#{ledger}/edit")

      assert index_live
             |> form("#ledger-form", ledger: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#ledger-form", ledger: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/ledgers")

      assert html =~ "Ledger updated successfully"
      assert html =~ "some updated acct_type"
    end

    test "deletes ledger in listing", %{conn: conn, ledger: ledger} do
      {:ok, index_live, _html} = live(conn, ~p"/ledgers")

      assert index_live |> element("#ledgers-#{ledger.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#ledger-#{ledger.id}")
    end
  end

  describe "Show" do
    setup [:create_ledger]

    test "displays ledger", %{conn: conn, ledger: ledger} do
      {:ok, _show_live, html} = live(conn, ~p"/ledgers/#{ledger}")

      assert html =~ "Show Ledger"
      assert html =~ ledger.acct_type
    end

    test "updates ledger within modal", %{conn: conn, ledger: ledger} do
      {:ok, show_live, _html} = live(conn, ~p"/ledgers/#{ledger}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ledger"

      assert_patch(show_live, ~p"/ledgers/#{ledger}/show/edit")

      assert show_live
             |> form("#ledger-form", ledger: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ledger-form", ledger: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/ledgers/#{ledger}")

      assert html =~ "Ledger updated successfully"
      assert html =~ "some updated acct_type"
    end
  end
end
