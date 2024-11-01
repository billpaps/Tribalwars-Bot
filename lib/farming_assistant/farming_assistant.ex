defmodule FarmingAssistant do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(state) do
    Logger.info("Starting Bot")

    # Run fa, recruit, building, attack managers
    Process.send(self(), :farm, [])

    {:ok, state}
  end

  @impl true
  def handle_info(:farm, state) do
    Logger.info("Running Farming Assistant")

    game_data =
      Api.Game.get_intro_page()
      |> Extractors.Common.get_game_data()

    sleep()
    FarmingAssistantBot.execute(game_data)
    # sleep()
    # Buildings.Manager.execute(game_data)
    sleep()
    # Recruit.execute()
    # sleep()
    # Attack.AutoAttack.execute()

    schedule_worker(:farm, 10)

    {:noreply, state}
  end

  defp schedule_worker(action, time) do
    seconds = 60 * 1000 * Enum.random(time..(time + 2)) + Enum.random(1000..60000)
    Process.send_after(self(), action, seconds)
  end

  defp sleep, do: :timer.sleep(Enum.random(1_000..3_000))
end

defmodule FarmingAssistantBot do
  # TODO: This should be a standalone genserver.

  @doc """
  sends farming assistant attacks to all villages in the FA page
  """
  @spec execute(game_data :: map()) :: :ok
  def execute(game_data) do
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
  end
end
