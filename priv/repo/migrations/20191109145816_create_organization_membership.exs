defmodule Tr.Repo.Migrations.CreateOrganizationMembership do
  use Ecto.Migration

  def change do
    create table(:organization_memberships) do
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :restrict), null: false

      timestamps([type: :naive_datetime_usec])
    end
  end
end
