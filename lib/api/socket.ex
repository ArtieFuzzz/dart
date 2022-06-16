defmodule Dart.API.Socket do
  @moduledoc false
  @behaviour :cowboy_websocket

  alias Dart.Utilities

  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def websocket_handle({:ping, _binary}, state) do
    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    case Jason.decode!(json) do
    %{"message" => message} -> Utilities.reply({200, "Message: #{message}"}, state)    end
  end

  def websocket_info(message, state) do
    {:reply, {:text, message}, state}
  end
end
