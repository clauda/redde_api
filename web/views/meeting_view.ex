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
      contact: %{
        id: meeting.contact.id,
        fullname: meeting.contact.fullname,
        code_area: meeting.contact.code_area,
        phone_number: meeting.contact.phone_number
      },
      canceled: meeting.canceled}
  end
end
