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
ReddeApi.Repo.insert!(user)
contact = ReddeApi.Contact.changeset(%ReddeApi.Contact{}, %{fullname: "Valim", code_area: 11, phone_number: "99999-9999", user_id: 1})
ReddeApi.Repo.insert!(contact)