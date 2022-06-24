defmodule Dart.API.Routing do
  @moduledoc false

  import Plug.Conn
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/tenor" do
    conn = fetch_query_params(conn)

    %{"tags" => tags} = conn.query_params

    gif = Dart.TenorWrapper.get(tags)

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{url: gif}))
  end

  get "/checkAuth" do
    authorization = conn |> get_req_header("authorization")

    case Dart.Redis.get("key:#{authorization}") do
      nil ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(403, Jason.encode!(%{valid: false}))
      _value ->
          conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, Jason.encode!(%{valid: true}))
    end
  end

  get "/mongoTest" do
    Dart.Mongodb.set("pastes", %{text: "Hello World!", id: "XCD"})

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{set: true}))
  end

  get "/mongoTest2" do
    response = Dart.Mongodb.get("pastes", %{id: "XCD"})

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{text: response["text"]}))
  end

  match _ do
      send_resp(conn, 404, "Route invalid")
  end
end
