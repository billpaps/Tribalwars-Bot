defmodule Wrappers.Buildings do
  @moduledoc """
  Wrapper for building upgrades requests
  """

  require Logger
  @headers Application.get_env(:tw_bot, :headers)

  def get_hq_page do
    url = "https://enc1.tribalwars.net/game.php?village=1836&screen=main"

    HTTPoison.get!(url, @headers)
    |> Map.get(:body)
  end

  def post_upgrade_building(building, csrf) do
    url =
      "https://enc1.tribalwars.net/game.php?village=1836&screen=main&ajaxaction=upgrade_building&type=main&"

    body = "id=#{building}&force=1&destroy=0&source=1836&h=#{csrf}"

    url
    |> HTTPoison.post!(body, @headers ++ [tribalwars_ajax: 1])
    |> Map.get(:body)
    |> Jason.decode!()
    |> case do
      %{"error" => error} ->
        Logger.warning("Building Manager -> failed to build #{building} (reason #{error}")

      _rest ->
        Logger.info("Building Manager -> building #{building}")
    end
  end
end
