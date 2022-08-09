defmodule Hut.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table (:bookings) do
      add :user_id, :uuid
      add :name, :string
      add :date, :date
      add :period, :string
      
      timestamps()
    end
    create unique_index(:bookings, [:date, :period])
  end
end
