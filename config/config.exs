import Config

config :tw_bot, :headers,
  cookie:
    "cid=2037393045; en_auth=54d57a255701:f4a164c08f52906aef756ab4ce6afed023461393d24ef48b985572700727504f; global_village_id=3567; websocket_available=true; ref=start; popup_pos_emoji_picker=1093.7750244140625x257.6875; PHPSESSID=j2e0j359g5m57so7kj0aphq4dv8tnoco0jvguuaqnkqtng9h; popup_pos_unit_popup_catapult=611.4000244140625x521; sid=0%3A47e6fa53749f323bc3b4123604b9e6a2b6ef608f34ce2e3d7ff05a5ac24f26f73bc533713f6e97c7d4eaca4a1ebac40246443acb62ab008cdf3b657183b57b10; io=HveVhmfZJTg97Hn_Bkd6",
  "user-agent":
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36",
  "content-type": "application/x-www-form-urlencoded; charset=UTF-8"

config :tw_bot, world: "enc1"

import_config "#{config_env()}.exs"
