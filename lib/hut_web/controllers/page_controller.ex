defmodule HutWeb.PageController do
  use HutWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
