defmodule Dart.Utilities do
  @moduledoc false

  @spec reply({integer, binary}, any) :: {:reply, {:text, any}, any}
  def reply({code, message}, state) do
    encoded = Jason.encode!(%{"message" => message, "code" => code})
    {:reply, {:text, encoded}, state}
  end
end
