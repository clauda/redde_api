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
      deleted: contact.deleted,
      inserted_at: contact.inserted_at,
      comments: render_many(contact.comments, __MODULE__, "comment.json", as: :comment)}
  end

  def render("comment.json", %{comment: comment}) do
    %{ 
      message: comment.message,
      kinda: comment.kinda,
      inserted_at: comment.inserted_at
    }
  end
end
