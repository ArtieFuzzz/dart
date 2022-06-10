defmodule Dart.Routes.Socket do
  @moduledoc false
  @behaviour :cowboy_websocket

  @timeout 60_000

  alias Dart.Utilities

  def init(req, state) do
    {:cowboy_websocket, req, state, @timeout}
  end

  def websocket_handle({:ping, _binary}, state) do
    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    IO.puts Poison.decode!(json)

    Utilities.reply("Welcome to Dart", state)
  end

  def websocket_info(message, state) do
    {:reply, {:text, message}, state}
  end
end
