defmodule Dart.API.Routing do
  @moduledoc false

  alias Dart.Mongodb

  import Plug.Conn
  use Plug.Router

  plug(:match)
  plug(:dispatch)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  # Tenor API
  get "/tenor" do
    conn = fetch_query_params(conn)

    %{"tags" => tags} = conn.query_params

    gif = Dart.TenorWrapper.get(tags)

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{url: gif}))
  end

  # Some tests :P

  get "/checkAuth" do
    authorization = conn |> get_req_header("authorization")

    case is_authorized(authorization) do
      :no_permission ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(403, Jason.encode!(%{valid: false}))
      :ok ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{valid: true}))
    end
  end

  match _ do
      send_resp(conn, 404, "Route invalid")
  end

  defp check_auth(conn, key) do
    case is_authorized(key) do
      :no_permission ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(403, Jason.encode!(%{message: "You do not have permission to access this route."}))
      :ok -> :ok
    end
  end

  defp is_authorized(key) do
    case Dart.Redis.get("key:#{key}") do
      nil -> :no_permission
      _ -> :ok
    end
  end
end
