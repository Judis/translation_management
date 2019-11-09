defmodule Tr.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :title, :string
      add :restrictions, :map

      timestamps([type: :naive_datetime_usec])
    end
  end
end
