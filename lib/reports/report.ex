defmodule Report do
  def execute do
    Reports.Urls.get_reports()
    |> Reports.Extractors.get_scouted_resources()
  end
end
