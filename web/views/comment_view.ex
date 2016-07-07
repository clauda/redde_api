defmodule ReddeApi.CommentView do
  use ReddeApi.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, ReddeApi.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, ReddeApi.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      message: comment.message,
      kinda: comment.kinda,
      contact_id: comment.contact_id}
  end
end
