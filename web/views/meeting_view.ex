defmodule ReddeApi.MeetingView do
  use ReddeApi.Web, :view

  def render("index.json", %{mettings: mettings}) do
    %{data: render_many(mettings, ReddeApi.MeetingView, "meeting.json")}
  end

  def render("show.json", %{meeting: meeting}) do
    %{data: render_one(meeting, ReddeApi.MeetingView, "meeting.json")}
  end

  def render("meeting.json", %{meeting: meeting}) do
    %{id: meeting.id,
      day: meeting.day,
      time: meeting.time,
      duration: meeting.duration,
      address: meeting.address,
      contact_id: meeting.contact_id,
      canceled: meeting.canceled}
  end
end
