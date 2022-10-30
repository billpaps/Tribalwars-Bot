defmodule Attack.Extractors do
  def get_ch_value(text) do
    Regex.scan(~r/\"ch\" value=\"(\w*):(\w*)\"/, text)
    |> List.flatten()
    |> Enum.slice(1..2)
  end

  def get_hash_commands(text) do
    ~r/TWMap.command_hash = \["(\w*)","(\w*)"\]/
    |> Regex.scan(text)
    |> List.flatten()
    |> Enum.slice(1..2)
  end
end
