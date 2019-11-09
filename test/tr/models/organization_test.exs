defmodule Tr.Models.OrganizationTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox
  alias Tr.Models.Organization
  alias Tr.Repo

  setup do
    Sandbox.checkout(Repo)
    Sandbox.mode(Repo, {:shared, self()})
    :ok
  end

  describe "organization model" do
    test "should pass validation" do
      changeset = Organization.changeset(
        %Organization{},
        %{
          title: "Organization name",
          logo_url: "http://domain.com/logo.png"
        }
      )

      assert changeset.valid?
    end

    test "should pass validation if logo_url is not provided" do
      changeset = Organization.changeset(
        %Organization{},
        %{
          title: "Organization name"
        }
      )

      assert changeset.valid?
    end

    test "should return error if title is not provided" do
      changeset = Organization.changeset(
        %Organization{},
        %{
          logo_url: "http://domain.com/logo.png"
        }
      )

      refute changeset.valid?
      assert changeset.errors == [title: {"can't be blank", [validation: :required]}]
    end
  end

  describe "title length" do
    test "should return error if title is too short" do
      changeset = Organization.changeset(
        %Organization{},
        %{
          title: "a"
        }
      )

      refute changeset.valid?
      assert changeset.errors == [title: {"should be at least %{count} character(s)", [count: 3, validation: :length, kind: :min, type: :string]}]
    end

    test "should return error if title is too long" do
      changeset = Organization.changeset(
        %Organization{},
        %{
          title: String.duplicate("a", 256)
        }
      )

      refute changeset.valid?
      assert changeset.errors == [title: {"should be at most %{count} character(s)", [count: 255, validation: :length, kind: :max, type: :string]}]
    end
  end

  describe "url validation" do
    test "should return error if url is incorrect" do
      changeset = Organization.changeset(
        %Organization{},
        %{
          title: "Organization name",
          logo_url: "domain.com"
        }
      )

      refute changeset.valid?
      assert changeset.errors == [logo_url: {"is missing a scheme (e.g. https)", []}]
    end

    test "should return error if url contain error" do
      changeset = Organization.changeset(
        %Organization{},
        %{
          title: "Organization name",
          logo_url: "https://domain..com"
        }
      )

      refute changeset.valid?
      assert changeset.errors == [logo_url: {"invalid host", []}]
    end
  end
end
