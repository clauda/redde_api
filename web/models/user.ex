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
    has_many :contacts, ReddeApi.Contacts

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w(name company code_area phone_number)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:email, min: 1, max: 255)
    |> validate_format(:email, ~r/@/)
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
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

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end
end