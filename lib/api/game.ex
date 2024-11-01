defmodule Api.Game do
  @moduledoc """
  This is the main tribal wars api.

  In this module we map the game's logic.
  """

  use HTTPoison.Base

  alias Api.Game

  @world Application.compile_env(:tw_bot, :world)

  @headers Application.compile_env(:tw_bot, :headers)
           |> Enum.map(fn {key, value} -> {Atom.to_string(key), value} end)

  @impl HTTPoison.Base
  def process_request_url(endpoint), do: "https://#{@world}.tribalwars.net/game.php?" <> endpoint

  def get_intro_page() do
    "screen=overview_villages&intro"
    |> Game.get!(@headers)
    |> Map.get(:body)
  end

  def get_overview_page(village) do
    "village=#{village}&screen=overview"
    |> Game.get!(@headers)
    |> Map.get(:body)
  end

  @doc "Get farming assistant page"
  @spec get_farming_assistant_page() :: term()
  def get_farming_assistant_page do
    "village=24103&screen=am_farm"
    |> Game.get!(@headers)
    |> Map.get(:body)
  end

  def send_farming_assistant_attack(source, target, template_id, csrf) do
    body = "target=#{target}&template_id=#{template_id}&source=#{source}&h=#{csrf}"

    Game.post!(
      "village=#{source}&screen=am_farm&mode=farm&ajaxaction=farm&json=1",
      body,
      @headers
    )
    |> Map.get(:body)
    |> Jason.decode!()
  end

  @doc "Get recruit page"
  def get_recruit_page(village_id) do
    "village=#{village_id}&screen=train"
    |> Game.get!(@headers)
    |> Map.get(:body)
  end

  def post_recruit_request(csrf) do
    url = "village=24103&screen=train&ajaxaction=train&mode=train&"

    num = Enum.random(8..15)
    body = "units%5Blight%5D=#{num}&h=#{csrf}"

    Game.post!(url, body, @headers ++ [tribalwars_ajax: 1])
  end

  def get_hq_page(village_id) do
    "village=#{village_id}&screen=main"
    |> Game.get!(@headers)
    |> Map.get(:body)
  end
end
