defmodule Tr.Models.UserTest do
  use ExUnit.Case, async: true

  alias Ecto.Adapters.SQL.Sandbox
  alias Tr.Models.User
  alias Tr.Repo

  setup do
    Sandbox.checkout(Repo)
    Sandbox.mode(Repo, {:shared, self()})
    :ok
  end

  describe "user model" do
    test "should pass validation" do
      changeset = User.changeset(
        %User{},
        %{
          name: "User",
          email: "test@test.com",
          password: "testPass",
          password_confirmation: "testPass"
        }
      )

      assert changeset.valid?
    end

    test "should return error if email is not valid" do
      changeset = User.changeset(
        %User{},
        %{
          name: "User",
          email: "testtest.com",
          password: "testPass",
          password_confirmation: "testPass"
        }
      )

      refute changeset.valid?
      assert changeset.errors == [email: {"has invalid format", [validation: :format]}]
    end
  end
end
