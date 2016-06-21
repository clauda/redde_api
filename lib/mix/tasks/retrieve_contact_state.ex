defmodule Mix.Tasks.RetrieveContactState do
  use Mix.Task
  alias ReddeApi.{Repo, Contact, Region}

  @shortdoc "Look for state given code area"
  
  def run(_) do
    Repo.start_link # start
    Repo.all(Contact)
    |> Enum.each(&(update(&1)))
  end

  defp update(contact) do
    if contact && contact.code_area do
      region = Repo.get_by(Region, code_area: contact.code_area)
      if region && region.state do
        Contact.changeset(contact, %{state: region.state})
        |> Repo.update
      end
    end
  end

end