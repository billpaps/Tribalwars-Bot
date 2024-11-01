import Config

config :tw_bot, :recruit,
  # Recruit every X minutes
  frequency: 5,
  # Amounts of units to recruit
  units: [
    light: 2,
    spear: 0,
    sword: 0,
    axe: 5,
    spy: 0,
    heavy: 0
  ]
