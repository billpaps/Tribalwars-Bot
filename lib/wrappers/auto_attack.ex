defmodule Wrappers.AutoAttack do
  @headers Application.get_env(:tw_bot, :headers)

  def get_map(source) do
    "https://enc1.tribalwars.net/game.php?village=#{source}&screen=map"
    |> HTTPoison.get!(@headers)
    |> Map.get(:body)
  end

  def get_command(source, destination) do
    HTTPoison.get!(
      "https://enc1.tribalwars.net/game.php?village=#{source}&screen=place&ajax=command&target=#{destination}",
      @headers
    )
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.has_key?("dialog")
  end

  def confirm_attack(source, [hash1, hash2], csrf, troops, [x, y]) do
    body =
      "#{hash1}=#{hash2}&template_id=&source_village=#{source}&" <>
        "spear=&sword=&axe=&spy=1&light=#{troops["light"]}&heavy=&ram=&catapult=&snob=&" <>
        "x=#{x}&y=#{y}&input=&attack=l&h=#{csrf}"

    "https://enc1.tribalwars.net/game.php?village=#{source}&screen=place&ajax=confirm"
    |> HTTPoison.post!(body, @headers ++ [tribalwars_ajax: 1])
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("dialog")
  end

  def confirm_attack(_source, _hash, _csrf, _troops, _coord), do: nil

  def send_attack(source, [ch1, ch2], csrf, troops, [x, y]) do
    body =
      "attack=true&ch=#{ch1}:#{ch2}&cb=troop_confirm_submit&" <>
        "x=#{x}&y=#{y}&source_village=#{source}&village=#{source}&attack_name=&" <>
        "spear=0&sword=0&axe=0&spy=1&light=#{troops["light"]}&" <>
        "heavy=0&ram=0&catapult=0&snob=0&building=main&" <>
        "h=#{csrf}&h=#{csrf}"

    "https://enc1.tribalwars.net/game.php?village=#{source}&screen=place&ajaxaction=popup_command"
    |> HTTPoison.post!(body, @headers ++ ["tribalwars-ajax": 1])
    |> Map.get(:body)
    |> Jason.decode!()

    # |> IO.inspect()
  end
end
