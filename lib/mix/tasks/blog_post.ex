defmodule Mix.Tasks.Blog.Post do
  use Mix.Task

  @shortdoc "Generate new blog post"
  @impl Mix.Task
  def run(args) do
    title = Enum.join(args, " ") |> String.capitalize()

    case Timmo.Blog.Post.new(title) do
      {:ok, msg} -> Mix.shell().info(msg)
      {:error, err} -> Mix.raise(err)
    end
  end
end
