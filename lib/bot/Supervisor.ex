defmodule Dart.Bot.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [Dart.Bot.Events]

    Supervisor.init(children, strategy: :rest_for_one)
  end

  def terminate(reason, _state) do
    IO.puts "Terminating with reason #{reason}"

    :ok
  end
end
