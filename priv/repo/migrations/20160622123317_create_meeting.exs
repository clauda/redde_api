defmodule ReddeApi.Repo.Migrations.CreateMeeting do
  use Ecto.Migration

  def change do
    create table(:mettings) do
      add :day,         :date
      add :time,        :time
      add :duration,    :integer
      add :address,     :string
      add :contact_id,  references(:contacts)
      add :canceled,    :boolean,   default: false

      timestamps
    end

  end
end
