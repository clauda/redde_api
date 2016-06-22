defmodule ReddeApi.Meeting do
  use ReddeApi.Web, :model

  schema "mettings" do
    field :day, Ecto.Date
    field :time, Ecto.Time
    field :duration, :integer, default: 60
    field :address, :string
    field :canceled, :boolean, default: false
    belongs_to :contact, ReddeApi.Contact

    timestamps
  end

  @required_fields ~w(day time contact_id)
  @optional_fields ~w(address duration canceled)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:contact_id)
  end
end
