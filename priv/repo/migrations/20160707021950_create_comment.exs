defmodule ReddeApi.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :message, :text
      add :kinda, :string, default: "regular" # system/notifications
      add :contact_id, references(:contacts, on_delete: :nothing)

      timestamps
    end
    create index(:comments, [:contact_id])
  end
end
