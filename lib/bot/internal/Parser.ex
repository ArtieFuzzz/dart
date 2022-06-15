defmodule Dart.Bot.Parser do
  @moduledoc false

  @prefix :application.get_env(:dart, :prefix)

  def pre_parse(message) do
    content = message.content

    unless !String.starts_with?(content, @prefix) do
      prefixless = rm(content)
      spaceless = String.replace(prefixless, ~r/\s+/u, " ")
      [cmd|arg] = String.split(spaceless, ~r/\s+/, parts: 2)
      args = List.first(arg)

      data = case args do
        nil -> {cmd, nil}
        arguments -> {cmd, List.to_tuple(arguments)}
      end

      data
    end
  end

  defp rm(content) do
    bytes = byte_size(@prefix)
    <<_::binary-size(bytes), rest::binary>> = content
    rest
  end
end
