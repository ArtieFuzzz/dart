defmodule Dart.Routing do
  @moduledoc false

  import Plug.Conn
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/tenor" do
    conn = fetch_query_params(conn)

    %{"tags" => tags} = conn.query_params

    if tags == "" do
      send_resp(conn, 400, Jason.encode!(%{error: "tags query is missing"}))
    end

    gif = Dart.TenorWrapper.get(tags)

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{url: gif}))
  end

  match _ do
      send_resp(conn, 404, "Route invalid")
  end
end
