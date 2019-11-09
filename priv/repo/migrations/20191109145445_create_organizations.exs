defmodule Tr.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :title, :string
      add :logo_url, :string

      timestamps([type: :naive_datetime_usec])
    end
  end
end
