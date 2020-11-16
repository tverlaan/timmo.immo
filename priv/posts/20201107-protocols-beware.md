%{
  author: "Timmo Verlaan",
  title: "Protocols Are Powerful but Beware",
  tags: ["elixir", "protocols"],
  description: "Elixir protocols are powerful for achieving polymorphism. But with great power comes (you've guessed it) great responsibility. I want to share my perspective on this."
}

---

Elixir protocols are a powerful mechanism for achieving polymorphism. But with great power comes _(you've guessed it)_ great responsibility. I want to share my perspective on this as I've seen many useful and very complex protocol implementations.

First of all, if you're not familiar with protocols yet I recommend to check out the [official getting started guide for protocols](https://elixir-lang.org/getting-started/protocols.html "Protocols - the Elixir Lang Getting Started Guide"). It's a very good resource to learn about the topic and understand how it works. For the rest of this post, I'll assume you understand what a protocol is and does. I don't want to repeat the same material with the chance my version is a poor copy of the original. This also has the potential to leave you more clueless than when you started reading this article.

The example given by the official guide is quite useful. It defines the protocol `Size` and it is defined like this:

```elixir
defprotocol Size do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end
```

In fact, the intention of this protocol is not to _calculate_ the size, but to return the pre-computed size of an element (). Perhaps, the protocol would be better named `PreComputedSize` to clarify intent, but it becomes a bit long and you could easily clarify intent in the module documentation. I think it is very important to describe what your protocol is supposed to do. I believe it makes it easier to add new implementations.

## My Webshop

For the moment, let's assume I own a webshop and I sell a couple of office supplies; paper & paperclips. When I need to ship these items I need to know an approximation of the volume so I know how many I can pack in a box. I'll define a protocol called `Product` with a function `volume/1` and implement the protocol for `%Paper` and `%Paperclips{}`. Here is it in code:

```elixir
defprotocol Product do
  @doc "Calculates the volume of a data structure"
  def volume(term)
end

defimpl Product, for: Paperclips do
  def volume(paperclips) do
    paperclips.volume
  end
end

defimpl Product, for: Paper do
  def volume(paper) do
    paper.x * paper.y * paper.z
  end
end
```

As you can see, the data structure for paperclips has a volume key and the protocol can just return the value. For paper, it is a bit more complex as for the dimensions multiplication is required, but it's not too hard. Now when I get a list of items I can easily calculate the volume and pack everything in one or multiple boxes:

```elixir
items
|> Enum.map(&Product.volume/1)
|> pack_in_a_box()
```

And voila! I can sell paper & paperclips via my webshop and pack them in appropriate boxes.

## Adding a Product (or Two)

But to my surprise, the webshop has been **a great success** and I want to add a product. This should be fairly easy as I defined a protocol and `Product` can simply be implemented for `%Pencil{}`. Here we go:

```elixir
defimpl Product, for: Pencil do
  def volume(pencil) do
    pi() * :math.pow(pencil.r / 2, 2) * pencil.h
  end
end
```

It's probably a good idea not to calculate `pi/0` on the spot, but what if I would? From an implementation perspective, it seems to be correct. This is indeed how you calculate the volume for a pencil. However, suddenly my box packing code becomes slow at seemingly random moments. You can see that the protocol makes it easy to extend it. Though the complexity of the implementation may have unintended side-effects. We can still make it a bit worse though since I also plan on selling boxed pencils.

```elixir
defimpl Product, for: Pencilbox do
  def volume(pencilbox) do
    pencilbox.pencil_count * Product.volume(pencilbox.pencil)
  end
end
```

**Whoa! MIND. BLOWN.** We're not only achieving polymorphism but _recursive polymorphism_. While I will admit straight away there might be good use-cases for this, I haven't seen one yet. In most real-world scenarios where you write common business logic, you don't need this level of complexity. It will be hard to reason or understand my simple box packing code because of the underlying complexity that is hidden from the view.

## Here Is My Advice When You're Considering Creating a Protocol

  * Describe your protocol as precise as you can
  * Implementations for the same protocol should have similar complexity
  * You probably don't want recursive polymorphism

One last piece of advice, which is only useful if your protocol needs some helpers, is to wrap access to your protocol in a module and provide the helper functions from there. It is similar to the `Enumerable` protocol and the `Enum` module.

Did you enjoy this blogpost? Do you have something to add? Perhaps you have a different opinion you'd like to share? I'd love to hear and get some feedback! You can find my social/email at the top of the page!

Thank you Alexey G. for proof-reading this post!
