defmodule TimmoWeb.SiteView do
  use TimmoWeb, :view
  import Timmo, only: [datetime: 1]

  defp datetime_recent([recent | _]) do
    datetime(recent.date)
  end

  defp year() do
    Timmo.date_updated().year
  end
end
