defmodule ReddeApi.MeetingTest do
  use ReddeApi.ModelCase

  alias ReddeApi.Meeting

  @valid_attrs %{address: "Rua dos Bobos, 0", contact_id: 42, day: "2010-04-17", duration: 42, time: "14:00:00"}
  @invalid_attrs %{contact_id: nil, day: nil}

  test "changeset with valid attributes" do
    changeset = Meeting.changeset(%Meeting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Meeting.changeset(%Meeting{}, @invalid_attrs)
    refute changeset.valid?
  end
end
