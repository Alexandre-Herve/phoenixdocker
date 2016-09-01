defmodule Phoenixdocker.PageController do
  use Phoenixdocker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
