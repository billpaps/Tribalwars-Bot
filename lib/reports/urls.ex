defmodule Reports.Urls do
  @headers [
    {"user-agent",
     "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"},
    {"cookie",
     "locale=en_DK; cid=30013070; en_auth=9a6065ccd486:83e512d3e68a3ec3147d6861b55e1398fbd72d5814568c4ab84d076d24f5a2c2; toggler_embedmap_player=1; mobile_mapsize=0; global_village_id=19851; websocket_available=true; popup_pos_group_popup=800.8500366210938x118.9000015258789; ref=start; PHPSESSID=p8bt31lq80psaehgmcvt85a03g5olr0o6kchr3evkfr745sg; sid=0%3A3c49123b3c405bd1542063e50719f0ddfbd845104f46afcedf5939c62329243d87ff70d719cf88b84a3a5e158f5cab70c16f66fd20bd6ad4d45f8aaa0f87ed0b; io=yM0mN-E9f0CAXHa3EDf7"},
    {"content-type", "application/x-www-form-urlencoded; charset=UTF-8"},
    {"upgrade_insecure_requests", "1"}
  ]

  def get_reports() do
    HTTPoison.get!(
      "https://enc1.tribalwars.net/game.php?village=19851&screen=report&mode=all&group_id=0&view=15452985",
      @headers
    )
  end
end
