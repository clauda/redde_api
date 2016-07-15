defmodule ReddeApi.Repo.Migrations.AddUuidDeviceToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :platform, :string
      add :uuid, :string
      add :version, :string
    end
  end
end
