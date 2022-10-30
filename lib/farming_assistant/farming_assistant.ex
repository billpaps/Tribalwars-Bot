defmodule FarmingAssistant do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(state) do
    Logger.info("Starting Farming Assistant")
    FarmingAssistantBot.execute(state)
    # Buildings.Manager.execute()
    # Recruit.Recruit.execute()
    Attack.AutoAttack.execute()

    schedule_worker(state)

    {:ok, state}
  end

  @impl true
  def handle_info(:farm, state) do
    Logger.info("Running Farming Assistant")

    FarmingAssistantBot.execute(state)
    # Buildings.Manager.execute()
    # Recruit.Recruit.execute()
    Attack.AutoAttack.execute()

    schedule_worker(state)
    {:noreply, state}
  end

  defp schedule_worker(_state) do
    seconds = 60 * 1000 * Enum.random(10..13) + Enum.random(1000..60000)
    Process.send_after(self(), :farm, seconds)
  end
end

defmodule FarmingAssistantBot do
  @spec execute(opts :: keyword()) :: :ok
  def execute(_opts \\ []) do
    response = Wrappers.FarmingAssistant.get_farming_assistant_page()

    game_data = Extractors.Common.get_game_data(response)
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
  end

  def get_game_data(response) do
    ~r/updateGameData\(([^\n]*)\);/
    |> Regex.scan(response.body)
    |> get_element_from_list(1)
    |> Jason.decode!()
  end

  def get_max_loot(response) do
    ~r/<img src="http[[:print:]]*\/max_loot\/(\d)/
    |> Regex.scan(response.body)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.map(&String.to_integer/1)
  end

  defp get_element_from_list(list, element) do
    list
    |> List.flatten()
    |> Enum.at(element)
  end
end
