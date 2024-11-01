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

  def get_villages(intro_response) do
    intro_response
    |> Floki.find("[class=quickedit-label]")
    |> Enum.map(fn {_tag_name, _attribute, children} -> children end)
    |> List.flatten()
    |> Enum.map(fn village ->
      Regex.scan(~r/\((\d+)\|(\d+)\)/, village)
      |> List.flatten()
      |> Enum.slice(1..2)
    end)
  end
end
