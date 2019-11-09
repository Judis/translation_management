defmodule Tr.Models.OrganizationMembershipTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox
  alias Tr.Models.OrganizationMembership
  alias Tr.Repo

  setup do
    Sandbox.checkout(Repo)
    Sandbox.mode(Repo, {:shared, self()})
    :ok
  end

  describe "organization_membership model" do
    test "should pass validation" do
      changeset = OrganizationMembership.changeset(
        %OrganizationMembership{},
        %{
          organization_id: 1,
          user_id: 1,
          role_id: 1
        }
      )

      assert changeset.valid?
    end
  end
end
