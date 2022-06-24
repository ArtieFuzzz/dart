defmodule Dart.Mongodb do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :local_mongodb_client)
  end

  def init(_args) do
    uri = case :application.get_env(:dart, :mongo_uri) do
      {:ok, uri} -> uri
      _ -> raise "DART_MONGO_URI must be set in your environment"
    end

    {:ok, client} = Mongo.start_link(url: uri)

    {:ok, %{client: client}}
  end

  def handle_call({:get, col, filter}, _from , state) do
    document = Mongo.find_one(state[:client], col, filter)

    {:reply, document, state}
  end

  def handle_cast({:set, col, obj}, state) do
    Mongo.insert_one(state[:client], col, obj)

    {:noreply, state}
  end

  def handle_cast({:delete, col, filter}, state) do
    Mongo.delete_one(state[:client], col, filter)

    {:noreply, state}
  end

  def get(col, filter) do
    obj = GenServer.call(:local_mongodb_client, {:get, col, filter})

    obj
  end

  def set(col, obj) do
    GenServer.cast(:local_mongodb_client, {:set, col, obj})
  end

  def delete(col, filter) do
    GenServer.cast(:local_mongodb_client, {:delete, col, filter})
  end
end
