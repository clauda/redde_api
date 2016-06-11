defmodule ReddeApi.ContactView do
  use ReddeApi.Web, :view

  def render("index.json", %{contacts: contacts}) do
    %{data: render_many(contacts, ReddeApi.ContactView, "contact.json")}
  end

  def render("show.json", %{contact: contact}) do
    %{data: render_one(contact, ReddeApi.ContactView, "contact.json")}
  end

  def render("contact.json", %{contact: contact}) do
    %{id: contact.id,
      user_id: contact.user_id,
      fullname: contact.fullname,
      email: contact.email,
      code_area: contact.code_area,
      phone_number: contact.phone_number,
      ambitious: contact.ambitious,
      popularity: contact.popularity,
      purchasing: contact.purchasing,
      accepted: contact.accepted,
      observations: contact.observations,
      inserted_at: contact.inserted_at}
  end
end
