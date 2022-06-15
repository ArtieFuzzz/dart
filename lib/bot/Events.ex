defmodule Dart.Bot.Events do
  @moduledoc false

  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, message, state}) do
    unless message.author.bot do
      spawn fn ->
        :ignore
      end
    end
  end
end
