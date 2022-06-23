defmodule Dart.Redis do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :local_redis_client)
  end

  def init(_args) do
    uri = case :application.get_env(:dart, :redis_uri) do
      {:ok, uri} -> uri
      _ -> raise "DART_REDIS_URI must be set in your environment"
    end

    {:ok, client} = Redix.start_link(uri)

    {:ok, %{client: client}}
  end

  def handle_call({:get, key}, _from, state) do
    value = Redix.command(state[:client], ["GET", key])

    {:reply, value, state}
  end

  def handle_cast({:set, key, value}, state) do
    Redix.command(state[:client], ["SET", key, value])

    {:noreply, state}
  end

  def handle_cast({:del, key}, state) do
    Redix.command(state[:client], ["DEL", key])

    {:noreply, state}
  end

  def get(key) do
    {_, response} = GenServer.call(:local_redis_client, {:get, key})

    response
  end

  def del(key) do
    GenServer.cast(:local_redis_client, {:del, key})
  end

  def set(key, value) do
    GenServer.cast(:local_redis_client, {:set, key, value})
  end
end
