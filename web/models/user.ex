defmodule ReddeApi.User do
  use ReddeApi.Web, :model
  # @derive {Poison.Encoder, except: [:__meta__]}
  
  schema "users" do
    field :name, :string
    field :email, :string
    field :company, :string
    field :code_area, :integer
    field :phone_number, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :platform, :string
    field :uuid, :string
    field :version, :string
    has_many :contacts, ReddeApi.Contact

    timestamps
  end

  @fields ~w(name email company code_area phone_number platform uuid version)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @fields)
    |> unique_constraint(:uuid)
  end

  def registration_changeset(model, params \\ %{}) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_required([:email])
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

end