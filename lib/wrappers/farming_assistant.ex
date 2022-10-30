defmodule Wrappers.FarmingAssistant do
  @doc """
  Wrapper for farming assistant requests
  """

  @headers Application.get_env(:tw_bot, :headers)
           |> Enum.map(fn {key, value} -> {Atom.to_string(key), value} end)

  require Logger

  @spec get_farming_assistant_page() :: term()
  def get_farming_assistant_page do
    "https://enc1.tribalwars.net/game.php?village=1836&screen=am_farm"
    |> HTTPoison.get!(@headers)
    |> Map.get(:body)
  end

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
  def attack_villages([village | villages], template_ids, [loot | loots], source, csrf) do
    sleep_randomly()

    village
    |> send_fa_attack(Enum.at(template_ids, loot), source, csrf)
    |> Map.get(:body)
    |> Jason.decode!()
    |> case do
      %{"error" => error} ->
        Logger.warning(
          "Farming assistant: #{source} failed to attack #{village} (reason: #{error})"
        )

        # Recursion ends
        attack_villages([], template_ids, loots, source, csrf)

      _rest ->
        Logger.info("Farming Assistant: Attacking #{village}, from #{source}")
        # Recursion continues
        attack_villages(villages, template_ids, loots, source, csrf)
    end
  end

  def attack_villages([], _template_id, _loots, _source, _csrf), do: :ok

  def attack_villages(_nth, _template_id, _loots, _source, _csrf), do: :ok

  defp send_fa_attack(village, template_id, source, csrf) do
    body = "target=#{village}&template_id=#{template_id}&source=#{source}&h=#{csrf}"

    HTTPoison.post!(
      "http://enc1.tribalwars.net/game.php?village=#{source}&screen=am_farm&mode=farm&ajaxaction=farm&json=1",
      body,
      @headers ++ [{"tribalwars-ajax", "1"}]
    )
  end

  defp sleep_randomly() do
    [200, 350]
    |> Enum.random()
    |> :timer.sleep()
  end
end
