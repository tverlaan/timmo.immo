defmodule Timmo.Blog.Post do
  @moduledoc """
  Definition of blog post structure.
  """
  @enforce_keys [:id, :author, :title, :body, :description, :tags, :date]
  defstruct [:id, :author, :title, :body, :description, :tags, :date]

  @doc """
  Generates struct based on file
  """
  def build(filename, attrs, body) do
    [date, id] = filename |> Path.rootname() |> Path.basename() |> String.split("-", parts: 2)
    [year, month, day] = Regex.run(~r/(\d{4})(\d{2})(\d{2})/, date, capture: :all_but_first)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    struct!(__MODULE__, [id: id, date: date, body: body] ++ Map.to_list(attrs))
  end

  def new(title) do
    date = Date.utc_today() |> Date.to_string() |> String.replace("-", "")
    id = String.downcase(title) |> String.replace(" ", "-")
    filename = "#{Timmo.Blog.path()}/#{date}-#{id}.md"

    case File.stat(filename) do
      {:ok, _} ->
        {:error, "post with date=#{date} and id=#{id} already exists"}

      _ ->
        File.write!(filename, template(title))
        {:ok, "post created at #{filename}"}
    end
  end

  defp template(title) do
    """
    %{
      author: "Timmo Verlaan",
      title: "#{title}",
      tags: [],
      description: ""
    }

    ---
    """
  end
end
