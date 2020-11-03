defmodule Timmo do
  @moduledoc """
  Timmo keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

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
    title()
  end

  def date_updated() do
    Timmo.Blog.build_time()
  end
end
