defmodule Tr.Models.OrganizationMembership do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tr.Models.Organization
  alias Tr.Models.Role
  alias Tr.Models.User

  schema "organization_membership" do
    belongs_to(:organization, Organization)
    belongs_to(:role, Role)
    belongs_to(:user, User)

    timestamps(type: :naive_datetime_usec)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [
      :organization_id,
      :role_id,
      :user_id
    ])
    |> validate_required([
      :organization_id,
      :role_id,
      :user_id
    ])
  end
end
