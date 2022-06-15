defmodule Dart.Bot.Events do
  @moduledoc false

  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, message, _state}) do
    unless message.author.bot do
        case Dart.Bot.Parser.pre_parse(message) do
          nil -> :ignore
          {:unknown, nil} -> :ignore
          {cmd, args} -> Dart.Bot.Commands.execute(cmd, message, args)
      end
    end
  end

  def handle_event(_event) do
    :noop
  end
end
