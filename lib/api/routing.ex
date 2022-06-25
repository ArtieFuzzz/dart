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

  # Pastes
  # ! Text should be URIComponent encoded

  post "/p/:id" do
    key = conn |> get_req_header("authorization")
    check_auth(conn, key)

    conn = fetch_query_params(conn)
    %Plug.Conn{params: %{"id" => id}} = conn
    %{"text" => text} = conn.query_params

    case Mongodb.get("pastes", %{id: id}) do
      nil ->
        Mongodb.set("pastes", %{id: id, text: text})

        conn
          |> put_resp_content_type("application/json")
          |> send_resp(201, Jason.encode!(%{message: "Created."}))
      _ ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{message: "Paste already exists"}))
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

  patch "/p/:id" do
    key = conn |> get_req_header("authorization")
    check_auth(conn, key)

    conn = fetch_query_params(conn)
    %Plug.Conn{params: %{"id" => id}} = conn
    %{"text" => text} = conn.query_params

    case Mongodb.get("pastes", %{id: id}) do
      nil ->
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(404, Jason.encode!(%{message: "Paste doesn't exist"}))
      _ ->
        Mongodb.update("pastes", %{id: id}, %{text: text})

        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{message: "Updated"}))
    end
  end

  delete "/p/:id" do
    key = conn |> get_req_header("authorization")
    check_auth(conn, key)

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
