defmodule Recruit do
  require Logger

  def execute() do
    units = Application.get_env(:tw_bot, :recruit)
    game_data = Recruit.Urls.get_game_data()

    units[:units]
    |> Enum.filter(fn {_unit, amount} -> amount != 0 end)
    |> Enum.map(fn {unit, amount} ->
      response =
        unit
        |> Atom.to_string()
        |> Recruit.Urls.post_recruit_request(amount, game_data["csrf"])

      if response["success"] do
        Logger.info("#{response["msg"]} for #{amount} #{unit}")
      else
        Logger.error("Failed to recruit #{amount} #{unit} due to: #{response["error"]}")
      end
    end)
  end
end
