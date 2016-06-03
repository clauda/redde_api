defmodule ReddeApi.UserView do
  use ReddeApi.Web, :view

  def render("show.json", %{user: user}) do
    %{
      name: user.name,
      email: user.email,
      company: user.company,
      code_area: user.code_area,
      phone_number: user.phone_number
    }
  end
end
