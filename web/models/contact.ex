defmodule ReddeApi.Contact do
  use ReddeApi.Web, :model

  schema "contacts" do
    field :fullname, :string
    field :email, :string
    field :code_area, :integer
    field :phone_number, :string
    field :ambitious, :integer, default: 0
    field :popularity, :integer, default: 0
    field :purchasing, :integer, default: 0
    field :accepted, :boolean, default: false
    field :deleted, :boolean, default: false
    field :deleted_at, Ecto.DateTime
    field :observations, :string
    belongs_to :user, ReddeApi.User

    timestamps
  end

  @required_fields ~w(fullname code_area phone_number user_id)
  @optional_fields ~w(email ambitious popularity purchasing accepted observations deleted deleted_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
