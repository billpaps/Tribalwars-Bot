defmodule Recruit.Urls do
  require Logger

  @headers Application.compile_env(:tw_bot, :headers)

  def get_game_data() do
    "https://enc1.tribalwars.net/game.php?village=24103&screen=barracks&_partial"
    |> HTTPoison.get!(@headers)
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("game_data")
  end

  @doc """
  What and how much units to train.

  ## Unit

  - spear
  - sword
  - axe
  - spy
  - light
  - heavy
  """
  def post_recruit_request(unit, amount, csrf) do
    url =
      "https://enc1.tribalwars.net/game.php?village=24103&screen=train&ajaxaction=train&mode=train&"

    body = "units%5B#{unit}%5D=#{amount}&h=#{csrf}"

    url
    |> HTTPoison.post!(body, @headers ++ [tribalwars_ajax: 1])
    |> Map.get(:body)
    |> Jason.decode!()
  end
end
