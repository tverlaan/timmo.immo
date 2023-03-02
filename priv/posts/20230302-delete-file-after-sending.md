%{
  author: "Timmo Verlaan",
  title: "Delete file after sending in Phoenix",
  tags: ["elixir", "phoenix", "cowboy", "plug", "bandit"],
  description: "Sometimes you want to delete a file after sending it with Phoenix (or any other webframework). How can you do that reliably?"
}

---

I have a project where the client can do a `POST` request to receive back a [tarball](https://en.wikipedia.org/wiki/Tar_(computing) "Tar on Wikipedia"). On each `POST`, a new tarball will be generated so that after sending the tarball it can safely be removed. The tarball format is chosen to group a bunch of files in a single download. It's a relatively small file, however, I want to avoid running out of disk space, because even small files accumulate over time. Given these constraints, I've tried a few different solutions I want to share with you. I think it can prove helpful in choosing the right solution for your specific use case.

## Keep the file in memory

An easy way out of this pickle is to only write the contents of the file in memory. With Phoenix, you can use [`send_download/3`](https://hexdocs.pm/phoenix/Phoenix.Controller.html#send_download/3 "Documentation for send_download/3") to send the filename plus binary contents. It would look something like this:

```elixir
# %Plug.Conn{} = conn
send_download(conn,
  {:binary, "These are my file contents"},
  filename: "the_filename.txt")
```

There are a few caveats with this approach. Large binaries will be stored off-heap so it won't be a problem for your process, but it still won't scale to very large sizes or many concurrent requests. Another problem can be when you don't control content generation. In my case, I depend on `:erl_tar` which only allows writing the archive to a file. I'd have to read the file after creation into memory, delete the file safely, and then send it to the client. Eg:

```elixir
binary = File.read!("my_archive.tar.gz")
:ok = File.rm!("my_archive.tar.gz")
send_download(conn,
  {:binary, binary},
  filename: "my_archive_20230302.tar.gz")
```

## Delete the file after sending, or so I thought

This assumes Phoenix with `Plug.Cowboy` as the adapter. The idea is simple, you send the file, you delete the file, and you return `%Plug.Conn{}` in your controller.

```elixir
conn =
  conn
  |> put_resp_header("content-disposition", ~s(attachment; filename=my_archive_20230302.tar.gz))
  |> send_file(200, "my_archive.tar.gz")

:ok = File.rm!("my_archive.tar.gz")
conn
```

When I was testing this locally I found that sometimes I didn't receive the file back. _What is going on here?_

Plug's [`send_file/3`](https://hexdocs.pm/plug/Plug.Conn.html#send_file/5 "Documentation for send_file/5") passes the command down the chain to Cowboy's `:cowboy_req.reply/4` and there we find the culprit. The filename is passed from the 'replying'-process (my controller) to the 'requesting'-process (the request worker) with `send/2`. The function in `:cowboy_req` that does this is even called [`cast/2`](https://github.com/ninenines/cowboy/blob/2.9.0/src/cowboy_req.erl#L921 "Link to cowboy_req cast/2"). This means that my controller is racing with the Cowboy process and when it's faster the file is gone before it's read and sent back.

You can work around this by monitoring the requesting process and removing the file only when that process exits. This means you have to interface with Plug's internals. You will also find that the 'requesting'-process is reused and only recycled after a while. The code would look like this:

```elixir
{_adapter, adapter_data} = conn.adapter
spawn(fn ->
  ref = Process.monitor(adapter_data.pid)

  receive do
    {:DOWN, ^ref, :process, _, _} -> :ok = File.remove!("my_archive.tar.gz")
  end
end)

conn
|> put_resp_header("content-disposition", ~s(attachment; filename=my_archive_20230302.tar.gz))
|> send_file(200, "my_archive.tar.gz")
```

## Delete the file after sending, Bandit-edition

[Bandit](https://hexdocs.pm/bandit/Bandit.html "Documentation for Bandit") is a relatively new HTTP server that is compatible with Plug. I've checked the code path that deals with sending files and found out it does send the file from the process _I_ am controlling. This means that my earlier code **Just Works™️** when I configure Bandit as my Phoenix adapter. No need for monitors or reading files into memory. In addition, the code now seems to do what I think it would be doing when reading it. For clarity the code looks like this:

```elixir
conn =
  conn
  |> put_resp_header("content-disposition", ~s(attachment; filename=my_archive_20230302.tar.gz))
  |> send_file(200, "my_archive.tar.gz")

:ok = File.rm!("my_archive.tar.gz")
conn
```

As I said, Bandit is relatively new and doesn't (yet) have the proven track record of Cowboy, but it has a promising story and from what I gather works fine.

## Alternatives?

Did I miss anything or do you have a different approach that deals with this situation? Do let me know! I'd be glad to hear about it.
