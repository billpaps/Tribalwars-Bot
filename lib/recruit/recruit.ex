defmodule Recruit.Recruit do
  def execute() do
    game_data = Recruit.Urls.get_recruit_page() |> Extractors.Common.get_game_data()

    Recruit.Urls.post_recruit_request(game_data["csrf"])
  end
end
