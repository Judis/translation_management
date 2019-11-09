defmodule Tr.Models.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tr.Models.OrganizationMembership

  schema "organizations" do
    field(:title, :string)
    field(:logo_url, :string)

    has_many(:organization_memberships, OrganizationMembership)
    has_many(:users, through: [:organization_memberships, :user])

    timestamps(type: :naive_datetime_usec)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [
      :title,
      :logo_url
    ])
    |> validate_required([:title])
    |> validate_changeset
  end

  @doc false
  defp validate_changeset(struct) do
    struct
    |> validate_length(:title, min: 3, max: 255)
    |> validate_url(:logo_url)
  end

  defp validate_url(changeset, field, opts \\ []) do
    validate_change changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} -> "is missing a scheme (e.g. https)"
        %URI{host: nil} -> "is missing a host"
        %URI{host: host} ->
          case :inet.gethostbyname(Kernel.to_charlist host) do
            {:ok, _} -> nil
            {:error, _} -> "invalid host"
          end
      end
      |> case do
        error when is_binary(error) -> [{field, Keyword.get(opts, :message, error)}]
        _ -> []
      end
    end
  end
end
