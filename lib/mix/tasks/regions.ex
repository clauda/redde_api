# not in use

defmodule Mix.Tasks.Regions do
  use Mix.Task
  alias ReddeApi.{Repo, Region}

  @shortdoc "Seed many regions."
  
  def run(_) do
    Repo.start_link # start
    
    File.read!('priv/repo/data/regions.txt')
    |> String.split("\n", trim: true)
    |> Enum.each(&(insert(&1)))
  end

  defp insert(record) do
    params = record
    |> String.split(",")

    {code_area, _} = Integer.parse(Enum.at(params, 0))
    Repo.insert! %Region{
      name: Enum.at(params, 2),
      state: Enum.at(params, 1),
      code_area: code_area
    }
  end

end