defmodule ReddeApi.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :fullname, :string, null: false
      add :email, :string
      add :code_area, :integer
      add :phone_number, :string
      add :ambitious, :integer, default: 0
      add :popularity, :integer, default: 0
      add :purchasing, :integer, default: 0
      add :accepted, :boolean, default: false
      add :observations, :string

      timestamps
    end
  end
end
