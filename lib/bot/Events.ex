defmodule Dart.Bot.Events do
  @moduledoc false

  alias Nostrum.Api

  use Nostrum.Consumer

  _opt = fn type, name, desc, opts ->
    %{type: type, name: name, description: desc}
    |> Map.merge(Enum.into(opts, %{}))
  end

  @commands [
    {"ping", "Ping Pong.", []}
  ]

  defp create_guild_commands(guild_id) do
    Enum.each(@commands, fn {name, description ,options} ->
      Api.create_guild_application_command(guild_id, %{
        name: name,
        description: description,
        options: options
      })
    end)
  end

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, %{guilds: guilds} = _data, _state}) do
    guilds
      |> Enum.map(fn guild -> guild.id end)
      |> Enum.each(&create_guild_commands/1)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _state}) do
    message = case Dart.Bot.Commands.execute_command(interaction) do
      {:reply, msg} -> msg
      _ -> :ignore
    end

    Api.create_interaction_response(interaction, %{type: 4, data: %{content: message}})
  end

  def handle_event(_event) do
    :noop
  end
end
