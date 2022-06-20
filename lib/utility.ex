defmodule Dart.API.Utilities do
  @moduledoc false

  @spec reply({integer, binary}, any) :: {:reply, {:text, any}, any}
  def reply({code, message}, state) do
    encoded = Jason.encode!(%{"message" => message, "code" => code})
    {:reply, {:text, encoded}, state}
  end

  @spec generate_master_jwt :: binary
  def generate_master_jwt() do
    claims = %{"admin" => true}
    {:ok, token, _claims} = Dart.API.JWT.generate_and_sign(claims)

    token
  end

  def validate_jwt(token) do
    case Dart.API.JWT.verify_and_validate(token) do
      {:ok, claims} -> {:ok, claims}
      {:error, why} -> {:error, why}
    end
  end
end
