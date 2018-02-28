defmodule TaskTracker.Repo.Migrations.CreateManages do
  use Ecto.Migration

  def change do
    create table(:manages) do
      add :underling_id, references(:users, on_delete: :delete_all), null: false
      add :manager_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:manages, [:underling_id])
    create index(:manages, [:manager_id])
  end
end
