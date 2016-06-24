# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReddeApi.Repo.insert!(%ReddeApi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user = ReddeApi.User.registration_changeset(%ReddeApi.User{}, %{name: "Claudia", email: "claudia@sorta.in", password: "<3phoenix"})
if user.valid?, do: ReddeApi.Repo.insert!(user)
# Repo.aggregate(Region, :count, :id) # Ecto 2.0

defmodule ReddeApi.DatabaseSeeder do
  alias ReddeApi.{Repo, Region}

  defp populate(record) do
    params = record
    |> String.split(",")

    {code_area, _} = Integer.parse(Enum.at(params, 0))
    # changeset = Region.changeset(%Region{name: Enum.at(params, 2), state: Enum.at(params, 1), code_area: code_area})
    # if changeset.valid?, do: Repo.insert!(changeset)
    Repo.insert!(%Region{name: Enum.at(params, 2), state: Enum.at(params, 1), code_area: code_area})
  end

  def clear do
    Repo.delete_all(Region)
  end

  def run do
    File.read!("priv/repo/data/regions.txt")
    |> String.split("\n", trim: true)
    |> Enum.each(&(populate(&1)))
  end
end

ReddeApi.DatabaseSeeder.run

contact = ReddeApi.Contact.changeset(%ReddeApi.Contact{}, %{fullname: "Valim", code_area: 11, phone_number: "99999-9999", user_id: 1, state: "São Paulo"})
if contact.valid?, do: ReddeApi.Repo.insert!(contact)

