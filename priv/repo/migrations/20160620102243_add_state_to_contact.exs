defmodule ReddeApi.Repo.Migrations.AddStateToContact do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :state,    :string
    end
  end
end
