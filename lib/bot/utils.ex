defmodule Bot.Utils do
  def schedule_worker(minutes), do: 60 * 1000 * Enum.random(minutes) + Enum.random(1000..60000)
end
