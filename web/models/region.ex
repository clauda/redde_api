defmodule ReddeApi.Region do
  use ReddeApi.Web, :model

  schema "regions" do
    field :code_area, :integer
    field :name, :string
    field :state, :string
  end

  @fields ~w(code_area name state)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> validate_required([:code_area])
    |> unique_constraint(:code_area)
  end
end
