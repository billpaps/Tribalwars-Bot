defmodule Buildings.Manager do
  require Logger

  @expected_level [
    {"stable", 14},
    {"barracks", 18},
    {"wood", 18},
    {"stone", 17},
    {"iron", 16}
    # {"stable", 11},
  ]

  def execute(game_data) do
    hq_page = Wrappers.Buildings.get_hq_page()
    buildings = calculate_building_levels(hq_page, game_data["village"]["buildings"])
    queue_count = Extractors.Buildings.extract_queue_count(hq_page)

    if queue_count < 5 || storage_is_full?(game_data) do
      Logger.info("Trying to build something...")

      case upgrade_building(buildings) do
        nil ->
          Logger.info("Skipping Building Manager. All levels completed")

        next_upgrade ->
          :timer.sleep(Enum.random([200, 800]))
          Wrappers.Buildings.post_upgrade_building(next_upgrade, game_data["csrf"])
      end
    else
      Logger.info("Queue counts is #{queue_count} and storage is not full yet")
    end
  end

  def upgrade_building(building) do
    @expected_level
    |> Enum.map(fn {build, upgrade_level} ->
      current_level = upgrade_level - String.to_integer(building[build])

      case current_level > 0 do
        true -> build
        false -> []
      end
    end)
    |> List.flatten()
    |> Enum.at(0)
  end

  def calculate_building_levels(hq_page, building) do
    queue = Extractors.Buildings.extract_queue_levels(hq_page)

    Map.merge(building, queue, fn _k, v1, v2 ->
      Integer.to_string(String.to_integer(v1) + v2)
    end)
  end

  def storage_is_full?(
        %{
          "village" => %{
            "iron" => iron,
            "stone" => stone,
            "wood" => wood,
            "storage_max" => storage_max
          }
        } = _game_data
      ) do
    dbg("checking if storage full?")
    storage_limit = storage_max * 0.85

    if iron > storage_limit || wood > storage_limit || stone > storage_limit do
      Logger.info("Resources are more than 85% of storage")
      true
    else
      false
    end
  end

  def storage_is_full?(rest) do
    Logger.error("didn't check if storage full")
    dbg(rest)
    Enum.random([true, false, false])
  end
end
