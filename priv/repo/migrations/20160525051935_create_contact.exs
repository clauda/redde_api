defmodule ReddeApi.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :fullname, :string
      add :email, :string
      add :code_area, :integer
      add :phone_number, :string
      add :ambitious, :integer
      add :popularity, :integer
      add :purchasing, :integer
      add :accepted, :boolean, default: false
      add :observations, :string

      timestamps
    end

  end
end
