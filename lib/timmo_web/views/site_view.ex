defmodule TimmoWeb.SiteView do
  use TimmoWeb, :view
  @timezone "Europe/Amsterdam"

  def datetime(date) do
    DateTime.new!(date, ~T[00:00:00], @timezone)
    |> DateTime.to_iso8601()
  end

  def datetime_recent([recent | _]) do
    datetime(recent.date)
  end

  def year() do
    Timmo.date_updated().year
  end
end
