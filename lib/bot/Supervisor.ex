defmodule Dart.Bot.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @impl true
  def init(_args) do
    children = [Alchemist.Events]

    Supervisor.init(children,[strategy: :rest_for_one, name: Alchemist.Consumer])
  end

  def terminate(_reason, _state) do
    IO.puts "Terminating"

    :ok
  end
end
