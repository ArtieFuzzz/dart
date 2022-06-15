defmodule Dart do
  @moduledoc false

  require Logger
  use Application

  @version Mix.Project.config[:version]

  def start(_type, _args) do
    Logger.info("Starting Dart")

    children = [
        Plug.Cowboy.child_spec(
          scheme: :http,
          plug: Dart.API.Routing,
          options: [
            port: Application.get_env(:dart, :port),
            dispatch: dispatch()
          ]
        ),
        Dart.Bot.Supervisor,
      ]

    opts = [strategy: :one_for_one, name: Dart.Supervisor]

    Logger.info("Dart service started\n")

    IO.puts "Version #{@version}"
    IO.puts "Listening on port #{Integer.to_string(Application.get_env(:dart, :port))}"

    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {
        :_, [
          {"/ws", Dart.Routes.Socket, []},
          {:_, Plug.Cowboy.Handler, {Dart.Routing, [] }}
        ]
      }
    ]
  end
end
