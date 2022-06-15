defmodule Dart.Bot.Commands do
  @moduledoc false

  alias Nostrum.Api

  def execute("ping", message, _args) do
    Api.create_message!(message.channel_id, "Pong!")
  end
end
