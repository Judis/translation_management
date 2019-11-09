defmodule Tr.Models.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field(:title, :string)
    field(:restrictions, :map)

    timestamps(type: :naive_datetime_usec)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [
      :title,
      :restrictions
    ])
    |> validate_required([:title, :restrictions])
    |> validate_changeset
  end

  @doc false
  defp validate_changeset(struct) do
    struct
    |> validate_length(:title, min: 3, max: 255)
  end
end
