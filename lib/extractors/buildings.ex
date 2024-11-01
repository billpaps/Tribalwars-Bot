defmodule Extractors.Buildings do
  def extract_building_names(body) do
    ~r/<tr id="main_buildrow_(\w*)">/
    |> Regex.scan(body)
    |> Enum.map(&Enum.at(&1, 1))
  end

  def extract_queue_levels(body) do
    ~r/\sbuildorder_(\w*)/
    |> Regex.scan(body)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.reduce(%{}, fn build, acc -> Map.update(acc, build, 1, fn build -> build + 1 end) end)
  end

  def extract_queue_count(body) do
    ~r/\sbuildorder_(\w*)/
    |> Regex.scan(body)
    |> Enum.count()
  end
end
