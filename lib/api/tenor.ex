defmodule Dart.TenorWrapper do

  @spec url(String.t()) :: String.t()
  def url(tags) do
    case :application.get_env(:dart, :tenor_key)  do
    {:ok, key} ->
      tag = tags
        |> String.split()
        |> Enum.join("%20")

      "https://tenor.googleapis.com/v2/search?q=#{tag}&key=#{key}&client_key=dart_app&limit=50&media_filter=gif"
      _ -> raise "You must set DART_TENOR_APIKEY in your environment"
    end
  end

  @spec get(String.t()) :: any
  def get(tags) do
    req_url = url(tags)

    %HTTPoison.Response{body: res} = HTTPoison.get! req_url
    gifs = Jason.decode!(res)["results"]
    gif = Enum.random(gifs)

    gif["media_formats"]["gif"]["url"]
  end
end
