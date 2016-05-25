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
    field :observations, :string

    timestamps
  end

  @required_fields ~w(fullname code_area phone_number)
  @optional_fields ~w(email ambitious popularity purchasing accepted observations)

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
