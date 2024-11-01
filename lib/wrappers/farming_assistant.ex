defmodule Wrappers.FarmingAssistant do
  @moduledoc """
  Wrapper for farming assistant requests
  """

  require Logger

  @doc """
  Attacks the given `villages` from the `source`
  village with the given `template_ids` based on `loots`.

  `csrf` is the generated csrf_token
  """
  @spec attack_villages(
          villages :: list(),
          template_id :: list(String.t()),
          loots :: list(String.t()),
          source :: String.t(),
          csrf :: String.t()
        ) :: :ok
  def attack_villages([target | villages], template_ids, [loot | loots], source, csrf) do
    sleep_randomly()

    source
    |> Api.Game.send_farming_assistant_attack(target, Enum.at(template_ids, loot), csrf)
    |> case do
      %{"error" => error} ->
        Logger.warning(
          "Farming assistant: #{source} failed to attack #{target} (reason: #{error})"
        )

        # Recursion ends
        attack_villages([], template_ids, loots, source, csrf)

      _rest ->
        Logger.info(
          "Farming Assistant: Attacking #{target}, from #{source} with template: #{loot}"
        )

        # Recursion continues
        attack_villages(villages, template_ids, loots, source, csrf)
    end
  end

  def attack_villages([], _template_id, _loots, _source, _csrf), do: :ok

  def attack_villages(_nth, _template_id, _loots, _source, _csrf), do: :ok

  defp sleep_randomly() do
    [200, 350]
    |> Enum.random()
    |> :timer.sleep()
  end
end
