defmodule Extractors.Common do
  @moduledoc """
  Common extractors across different page responses
  """

  def get_game_data(response) do
    ~r/updateGameData\(([^\n]*)\);/
    |> Regex.scan(response)
    |> List.flatten()
    |> Enum.at(1)
    |> Jason.decode!()
  end
end
