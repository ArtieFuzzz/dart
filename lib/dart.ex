defmodule Dart do
  @moduledoc false

  require Logger
  use Application

  def start(_type, _args) do
    Logger.info("Starting Dart service")

    children = [
        Plug.Cowboy.child_spec(
          scheme: :http,
          plug: Dart.Routing,
          options: [
            port: Application.get_env(:dart, :port),
            dispatch: dispatch()
          ]
        )
      ]

    opts = [strategy: :one_for_one, name: Dart.Supervisor]

    Logger.info("Dart service started")
    Logger.info("Listening on port #{Integer.to_string(Application.get_env(:dart, :port))}")

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
