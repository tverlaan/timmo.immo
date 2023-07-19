defmodule TimmoWeb.PostLive do
  @moduledoc false
  use TimmoWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    post = Timmo.Blog.get_post_by_id(id)

    {:ok,
     socket
     |> assign(:post, post)
     |> assign(:page_title, post.title)
     |> assign_meta(post)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <article role="article" class="space-y-4">
      <header>
        <h1 class="text-brand text-3xl md:text-4xl font-bold"><%= @post.title %></h1>
      </header>
      <div class="flex justify-between">
        <p class="text-sm"><%= @post.date %></p>
      </div>
      <section class="prose prose-lg md:prose-xl print:prose-sm print:max-w-none dark:prose-dark">
        <%= raw(link_headings(@post.body)) %>
      </section>
    </article>
    """
  end

  @h2_regex ~r/<h2.*?>(.*?)<\/h2>/s
  defp link_headings(content) do
    Regex.replace(@h2_regex, content, fn match, title ->
      id = header_to_id(title)

      if id == "" do
        match
      else
        """
        <h2 id="#{id}">
          <a href="##{id}" aria-hidden="true" tabindex="-1"><svg class="icon anchor" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg></a>
          #{title}
        </h2>
        """
      end
    end)
  end

  defp header_to_id(header) do
    header
    |> String.replace(~r/<.+>/, "")
    |> String.replace(~r/&#\d+;/, "")
    |> String.replace(~r/&[A-Za-z0-9]+;/, "")
    |> String.replace(~r/\W+/u, "-")
    |> String.trim("-")
    |> String.downcase()
  end
end
