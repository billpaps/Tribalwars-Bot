defmodule Extractors.FarmingAssistant do
  def get_fa_villages(response) do
    ~r/village_(\d*)"/
    |> Regex.scan(response)
    |> Enum.map(&Enum.at(&1, 1))
  end

  def get_templates(response) do
    ~r/name="template\[(\d*)\]\[id\]"/
    |> Regex.scan(response)
    |> Enum.map(&Enum.at(&1, 1))
  end

  def get_max_loot(response) do
    ~r/<img src="http[[:print:]]*\/max_loot\/(\d)/
    |> Regex.scan(response)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.map(&String.to_integer/1)
  end
end
