defmodule Tr.Scenarios.SignUpScenario do
  @moduledoc """
  Scenario to register new user.
  """

  @behaviour Tr.Scenario
  @owner_role_title "Owner"

  alias Ecto.Multi
  alias Tr.Models.{Organization, OrganizationMembership, Role, User}
  alias Tr.Repo

  @impl true
  def act(opts) do
    opts
    |> scenario()
    |> Repo.transaction()
    |> format_result()
  end

  @impl true
  def scenario(opts) do
    Multi.new()
    |> Multi.run(:assigns, &assign_params(&1, &2, opts))
    |> Multi.insert(:create_user, &create_user/1)
    |> Multi.insert(:create_organization, &create_organization/1)
    |> Multi.run(:find_owner_role, &find_owner_role/2)
    |> Multi.insert(:create_organization_membership, &create_organization_membership/1)
    |> Multi.run(:send_email_confirmation, &send_email_confirmation/2)
  end

  defp assign_params(_repo, _changes, opts) do
    {:ok, opts}
  end

  defp create_user(%{assigns: %{user_params: params}}) do
    User.changeset(%User{}, params)
  end

  defp create_organization(%{assigns: %{user_params: %{organization_title: title}}}) do
    Organization.changeset(%Organization{}, %{title: title})
  end

  defp create_organization(_) do
    Organization.changeset(%Organization{}, %{title: nil})
  end

  defp find_owner_role(repo, _) do
    case repo.get_by(Role, title: @owner_role_title) do
      nil -> {:error, :role_is_not_found}
      role -> {:ok, role}
    end
  end

  defp create_organization_membership(%{
         create_user: user,
         create_organization: organization,
         find_owner_role: role
       }) do
    OrganizationMembership.changeset(%OrganizationMembership{}, %{
      user_id: user.id,
      organization_id: organization.id,
      role_id: role.id
    })
  end

  defp send_email_confirmation(_, _) do
    {:ok, :sent}
  end

  defp format_result({:ok, %{create_user: user}}) do
    {:ok, user}
  end

  defp format_result({:error, _, %Ecto.Changeset{} = error, _}) do
    {:error, error}
  end
end
