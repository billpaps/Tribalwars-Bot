defmodule Bot.FarmingAssistant do
  use GenServer

  def init(_state) do
    init_state = %{
      "village" => 24103
    }

    game_data =
      init_state["village"]
      |> Api.Game.get_overview_page()
      |> Extractors.Common.get_game_data()

    FarmingAssistantBot.execute(game_data)

    {:ok, init_state}
  end

  def handle_cast(:farm, _from, %{"game_data" => game_data} = state) do
    response = Api.Game.get_farming_assistant_page()

    villages_to_attack = Extractors.FarmingAssistant.get_fa_villages(response)
    template_ids = Extractors.FarmingAssistant.get_templates(response)
    max_loot = Extractors.FarmingAssistant.get_max_loot(response)

    csrf_token = game_data["csrf"]
    source = game_data["village"]["id"] |> Integer.to_string()

    Wrappers.FarmingAssistant.attack_villages(
      villages_to_attack,
      template_ids,
      max_loot,
      source,
      csrf_token
    )

    {:noreply, state}
  end
end
