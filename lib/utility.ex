defmodule Dart.Utilities do
  @moduledoc false

  @spec reply(String.t(), any) :: {:reply, {:text, any}, any}
  def reply(message, state) do
    {:reply, {:text, message}, state}
  end
end
