defmodule Recruit.Urls do
  require Logger

  @headers Application.get_env(:tw_bot, :headers)

  def get_recruit_page() do
    "https://enc1.tribalwars.net/game.php?village=1836&screen=train"
    |> HTTPoison.get!(@headers)
    |> Map.get(:body)
  end

  def post_recruit_request(csrf) do
    url =
      "https://enc1.tribalwars.net/game.php?village=1836&screen=train&ajaxaction=train&mode=train&"

    num = Enum.random(8..15)
    body = "units%5Blight%5D=#{num}&h=#{csrf}"

    HTTPoison.post!(url, body, @headers ++ [tribalwars_ajax: 1])
  end
end
