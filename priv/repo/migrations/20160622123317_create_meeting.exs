defmodule ReddeApi.Repo.Migrations.CreateMeeting do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :day,         :date
      add :time,        :time
      add :duration,    :integer
      add :address,     :string
      add :user_id,     references(:users)
      add :contact_id,  references(:contacts)
      add :canceled,    :boolean,   default: false

      timestamps
    end

  end
end
