defmodule PainlessWeb.TenancyLiveTest do
  use PainlessWeb.ConnCase

  import Phoenix.LiveViewTest
  import Painless.TenanciesFixtures

  @create_attrs %{active: true, balance: 42, late_fee: 42, name: "some name", notes: "some notes", property: "some property", rent: 42, rent_day_of_month: 42}
  @update_attrs %{active: false, balance: 43, late_fee: 43, name: "some updated name", notes: "some updated notes", property: "some updated property", rent: 43, rent_day_of_month: 43}
  @invalid_attrs %{active: false, balance: nil, late_fee: nil, name: nil, notes: nil, property: nil, rent: nil, rent_day_of_month: nil}

  defp create_tenancy(_) do
    tenancy = tenancy_fixture()
    %{tenancy: tenancy}
  end

  describe "Index" do
    setup [:create_tenancy]

    test "lists all tenancies", %{conn: conn, tenancy: tenancy} do
      {:ok, _index_live, html} = live(conn, ~p"/tenancies")

      assert html =~ "Listing Tenancies"
      assert html =~ tenancy.name
    end

    test "saves new tenancy", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tenancies")

      assert index_live |> element("a", "New Tenancy") |> render_click() =~
               "New Tenancy"

      assert_patch(index_live, ~p"/tenancies/new")

      assert index_live
             |> form("#tenancy-form", tenancy: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tenancy-form", tenancy: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tenancies")

      assert html =~ "Tenancy created successfully"
      assert html =~ "some name"
    end

    test "updates tenancy in listing", %{conn: conn, tenancy: tenancy} do
      {:ok, index_live, _html} = live(conn, ~p"/tenancies")

      assert index_live |> element("#tenancies-#{tenancy.id} a", "Edit") |> render_click() =~
               "Edit Tenancy"

      assert_patch(index_live, ~p"/tenancies/#{tenancy}/edit")

      assert index_live
             |> form("#tenancy-form", tenancy: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tenancy-form", tenancy: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tenancies")

      assert html =~ "Tenancy updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes tenancy in listing", %{conn: conn, tenancy: tenancy} do
      {:ok, index_live, _html} = live(conn, ~p"/tenancies")

      assert index_live |> element("#tenancies-#{tenancy.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tenancy-#{tenancy.id}")
    end
  end

  describe "Show" do
    setup [:create_tenancy]

    test "displays tenancy", %{conn: conn, tenancy: tenancy} do
      {:ok, _show_live, html} = live(conn, ~p"/tenancies/#{tenancy}")

      assert html =~ "Show Tenancy"
      assert html =~ tenancy.name
    end

    test "updates tenancy within modal", %{conn: conn, tenancy: tenancy} do
      {:ok, show_live, _html} = live(conn, ~p"/tenancies/#{tenancy}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tenancy"

      assert_patch(show_live, ~p"/tenancies/#{tenancy}/show/edit")

      assert show_live
             |> form("#tenancy-form", tenancy: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tenancy-form", tenancy: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tenancies/#{tenancy}")

      assert html =~ "Tenancy updated successfully"
      assert html =~ "some updated name"
    end
  end
end
