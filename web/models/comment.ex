defmodule ReddeApi.Comment do
  use ReddeApi.Web, :model

  schema "comments" do
    field :message, :string
    field :kinda, :string, default: "regular"
    belongs_to :contact, ReddeApi.Contact

    timestamps
  end

  @fields ~w(message contact_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> validate_required([:message, :contact_id])
    |> foreign_key_constraint(:contact_id)
  end
end
