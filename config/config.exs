import Config

config :tw_bot, :headers,
  cookie:
    "YOUR COOKIES HERE",
  "user-agent":
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36",
  "content-type": "application/x-www-form-urlencoded; charset=UTF-8"

config :tw_bot, villages: "YOUR_VILLAGE"

import_config "#{config_env()}.exs"
