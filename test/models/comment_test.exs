defmodule ReddeApi.CommentTest do
  use ReddeApi.ModelCase

  alias ReddeApi.Comment

  @valid_attrs %{message: "some content", contact_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
