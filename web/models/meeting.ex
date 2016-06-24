defmodule ReddeApi.Meeting do
  use ReddeApi.Web, :model

  schema "meetings" do
    field :day, Ecto.Date
    field :time, Ecto.Time
    field :duration, :integer, default: 60
    field :address, :string
    field :canceled, :boolean, default: false
    belongs_to :user, ReddeApi.User
    belongs_to :contact, ReddeApi.Contact

    timestamps
  end

  @fields ~w(day time user_id contact_id address duration canceled)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> validate_required([:day, :time, :contact_id])
    |> foreign_key_constraint(:contact_id)
  end
end
