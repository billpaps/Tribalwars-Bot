defmodule Reports.Extractors do
  @doc """
  Returns scouted [`wood`, `clay`, `iron`]
  """
  @spec get_scouted_resources(response :: HTTPoison.Response.t()) :: list()
  def get_scouted_resources(response) do
    ~r/title="\w\w\w\w"> <\/span>(\d*)<\/span>/
    |> Regex.scan(response.body)
    |> Enum.map(&Enum.at(&1, 1))
  end
end
