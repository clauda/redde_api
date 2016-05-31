defmodule ReddeApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false
      add :password_hash, :string
      add :company, :string
      add :code_area, :integer
      add :phone_number, :string

      timestamps
    end

    create unique_index(:users, [:email])
  end
end
