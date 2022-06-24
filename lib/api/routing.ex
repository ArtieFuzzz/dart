defmodule Dart.API.Routing do
  @moduledoc false

  alias Dart.Mongodb

  import Plug.Conn
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  # Tenor API
  get "/tenor" do
    conn = fetch_query_params(conn)

    %{"tags" => tags} = conn.query_params

    gif = Dart.TenorWrapper.get(tags)

    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{url: gif}))
  end

  # Pastes

  post "/p/:id" do
    %Plug.Conn{params: %{"id" => id}} = conn
    data = Mongodb.get("pastes", %{id: id})

    case Mongodb.get("pastes", %{id: id}) do
      nil ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(201, Jason.encode!(%{message: "Created."}))
      ^data ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{message: "Paste already exists"}))
      _ ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{message: "Something went wrong"}))
    end
  end

  get "/p/:id" do
    %Plug.Conn{params: %{"id" => id}} = conn

    case Mongodb.get("pastes", %{id: id}) do
      nil ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(404, Jason.encode!(%{message: "Paste does not exist"}))
      data ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{text: data["text"]}))
    end
  end

  delete "/p/:id" do
    %Plug.Conn{params: %{"id" => id}} = conn

    case Mongodb.get("pastes", %{id: id}) do
      nil ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(404, Jason.encode!(%{message: "Paste does not exist"}))
      _ ->
        Mongodb.delete("pastes", %{id: id})
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{message: "Deleted"}))
    end
  end

  # TODO: add Patch route

  # Some tests :P

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

  match _ do
      send_resp(conn, 404, "Route invalid")
  end
end
