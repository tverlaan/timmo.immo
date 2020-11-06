defmodule Timmo do
  @moduledoc """
  Timmo keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  @timezone "Europe/Amsterdam"

  def name() do
    "Timmo Verlaan"
  end

  def email() do
    "timmo@timmo.immo"
  end

  def title() do
    "Timmo's Website"
  end

  def description() do
    "The website of Timmo Verlaan."
  end

  def datetime(date) do
    DateTime.new!(date, ~T[00:00:00], @timezone)
    |> DateTime.to_iso8601()
  end

  def date_updated() do
    Timmo.Blog.build_time()
  end
end
