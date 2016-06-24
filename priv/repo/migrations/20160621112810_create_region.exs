defmodule ReddeApi.Repo.Migrations.CreateRegion do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :code_area, :integer
      add :name, :string
      add :state, :string
    end
  end
end
