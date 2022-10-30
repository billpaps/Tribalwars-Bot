defmodule Buildings.Manager do
  require Logger

  @expected_level [
    {"main", 20},
    {"smith", 12}
    # {"wood", 20},
    # {"stone", 18},
    # {"iron", 20}
  ]

  def execute() do
    hq_page = Wrappers.Buildings.get_hq_page()
    game_data = Extractors.Common.get_game_data(hq_page)

    buildings = calculate_building_levels(hq_page, game_data["village"]["buildings"])

    case upgrade_building(buildings) do
      nil ->
        Logger.info("Skipping Building Manager. All levels completed")

      next_upgrade ->
        Wrappers.Buildings.post_upgrade_building(next_upgrade, game_data["csrf"])
    end
  end

  defp upgrade_building(building) do
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

  defp calculate_building_levels(hq_page, building) do
    queue = Extractors.Buildings.extract_queue_levels(hq_page)

    Map.merge(building, queue, fn _k, v1, v2 ->
      Integer.to_string(String.to_integer(v1) + v2)
    end)
  end
end
