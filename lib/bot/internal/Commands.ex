defmodule Dart.Bot.Commands do
  @moduledoc false

  def execute_command(%{data: %{name: "ping"}}) do
    {:reply, "Pong!"}
  end
end
