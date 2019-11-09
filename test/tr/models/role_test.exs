defmodule Tr.Models.RoleTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox
  alias Tr.Models.Role
  alias Tr.Repo

  setup do
    Sandbox.checkout(Repo)
    Sandbox.mode(Repo, {:shared, self()})
    :ok
  end

  describe "role model" do
    test "should pass validation" do
      changeset = Role.changeset(
        %Role{},
        %{
          title: "Owner",
          restrictions: %{}
        }
      )

      assert changeset.valid?
    end

    test "should return error if title is not provided" do
      changeset = Role.changeset(
        %Role{},
        %{
          restrictions: %{}
        }
      )

      refute changeset.valid?
      assert changeset.errors == [title: {"can't be blank", [validation: :required]}]
    end

    test "should return error if restrictions is not provided" do
      changeset = Role.changeset(
        %Role{},
        %{
          title: "Owner"
        }
      )

      refute changeset.valid?
      assert changeset.errors == [restrictions: {"can't be blank", [validation: :required]}]
    end
  end

  describe "title length" do
    test "should return error if title is too short" do
      changeset = Role.changeset(
        %Role{},
        %{
          title: "a",
          restrictions: %{}
        }
      )

      refute changeset.valid?
      assert changeset.errors == [title: {"should be at least %{count} character(s)", [count: 3, validation: :length, kind: :min, type: :string]}]
    end

    test "should return error if title is too long" do
      changeset = Role.changeset(
        %Role{},
        %{
          title: String.duplicate("a", 256),
          restrictions: %{}
        }
      )

      refute changeset.valid?
      assert changeset.errors == [title: {"should be at most %{count} character(s)", [count: 255, validation: :length, kind: :max, type: :string]}]
    end
  end
end
