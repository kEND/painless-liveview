defmodule PainlessWeb.PageController do
  use PainlessWeb, :controller

  plug :put_layout, false when action in [:index]

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
