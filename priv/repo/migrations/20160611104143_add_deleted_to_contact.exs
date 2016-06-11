# $ `mix ecto.gen.migration add_deleted_to_contact`
# then $ `mix ecto.migrate`

defmodule ReddeApi.Repo.Migrations.AddDeletedToContact do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :deleted,    :boolean, default: false
      add :deleted_at, :datetime
    end
  end
end
