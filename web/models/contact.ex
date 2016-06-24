defmodule ReddeApi.Contact do
  use ReddeApi.Web, :model

  alias ReddeApi.{Repo, Region}

  schema "contacts" do
    field :fullname, :string
    field :email, :string
    field :code_area, :integer
    field :phone_number, :string
    field :state, :string
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

  @fields ~w(fullname code_area phone_number user_id email state ambitious popularity purchasing accepted observations deleted deleted_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> validate_required([:fullname, :code_area, :phone_number, :user_id])
    |> validate_format(:email, ~r/@/)
    |> update_state
  end

  defp update_state(changeset) do
    if code_area = get_change(changeset, :code_area) do
      region = Repo.get_by(Region, code_area: code_area)
      if region && region.state do 
        changeset = put_change(changeset, :state, region.state)
      end
    end

    changeset
  end

end
