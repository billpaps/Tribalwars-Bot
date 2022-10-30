defmodule Attack.AutoAttack do
  require Logger

  @root_village "1836"
  @villages [
    {"524|533", %{"light" => 7}}, #175
    {"531|532", %{"light" => 7}}
  ]

  def execute do
    map_response = Wrappers.AutoAttack.get_map(@root_village)
    hash_commands = Attack.Extractors.get_hash_commands(map_response)
    game_data = Extractors.Common.get_game_data(map_response)

    send_attack(@villages, hash_commands, game_data)
  end

  defp send_attack([{xy, troops} | villages], hash, game_data) do
    coordinates = String.split(xy, "|")

    case Wrappers.AutoAttack.confirm_attack(
           @root_village,
           hash,
           game_data["csrf"],
           troops,
           coordinates
         ) do
      nil ->
        send_attack([], "", "")
        Logger.info("Failed to attack #{xy}")

      response ->
        ch_value = Attack.Extractors.get_ch_value(response)

        Logger.info("Attacking #{xy}")

        Wrappers.AutoAttack.send_attack(
          @root_village,
          ch_value,
          game_data["csrf"],
          troops,
          coordinates
        )

        send_attack(villages, hash, game_data)
    end
  end

  defp send_attack([], _hash, _game_data), do: nil
end
