defmodule ReddeApi.RegionTest do
  use ReddeApi.ModelCase

  alias ReddeApi.Region

  @valid_attrs %{code_area: 42, name: "Earth", state: "Galaxy"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Region.changeset(%Region{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Region.changeset(%Region{}, @invalid_attrs)
    refute changeset.valid?
  end
end
