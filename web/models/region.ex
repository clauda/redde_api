defmodule ReddeApi.Region do
  use ReddeApi.Web, :model

  schema "regions" do
    field :code_area, :integer
    field :name, :string
    field :state, :string
  end

  @required_fields ~w(code_area)
  @optional_fields ~w(name state)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:code_area)
  end
end
