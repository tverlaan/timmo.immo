%{
  author: "Timmo Verlaan",
  title: "A War Story - from failure to success",
  tags: ["elixir", "team", "failure", "learning"],
  description: "Developing a communication platform is a perfect fit for the BEAM. Learning its characteristics requires users and a significant load. We developed for three years before we added users."
}

---

_This is the written form of a presentation I gave at [Code BEAM V 2020](https://www.codesync.global/conferences/code-beam-sto/). "BEAM" is the name of the [Erlang VM](https://en.wikipedia.org/wiki/BEAM%5F%28Erlang%5Fvirtual%5Fmachine%29)._

There are quite a few technical presentations at the Code BEAM conferences. Wonderful stories about advancing the BEAM, adding different languages to the BEAM, creating new libraries in the ecosystem. The list goes on and on. I'm sharing a different story with you. A war story. About going from failure to success.

## Failures

It's **OK** to have failures. It's **OK** to not know how to go about it. There is no **ready-to-use** solution for your **one-of-a-kind** problem. Handling failure is about fault-tolerance as a team and as a company. We make mistakes and then we fix them. This is not the effort of a single person. It's the effort of everyone involved. I'm sharing it from my perspective. There is no universal truth.

I will not cover Erlang/Elixir anti-patterns or how to design applications for the BEAM. It is mostly about things you should try to avoid and how _we_ went about solving our _own_ issues.

## Background

We needed to replace the existing communication platform (based on [Asterisk](https://www.asterisk.org "Open Source PBX Software") and _a lot_ of PHP scripts). A communication platform is a perfect fit for the BEAM. At least, that is what we thought. Picking the proper tools and software is a good start, but there is still a long road ahead.

At that time we weren't (yet) a group of experienced Erlang or Elixir developers. We designed and created lots of components based on how we thought the BEAM would behave and what we thought our users needed. We were doing a lot of tests and benchmarks to confirm our beliefs. But getting results from a _"lab"_ environment can be quite different from the real world.

## The First Two Years

We started building the platform in Elixir. The company already had some experience with Erlang and running the BEAM in production. I started at zero. I picked up the famous book of Joe Armstrong, [Programming Erlang](https://pragprog.com/titles/jaerlang2/programming-erlang-2nd-edition/). It immediately clicked for me. I recommend this book to anyone that wants to learn Erlang or get a basic understanding of the Erlang Runtime.

At the time we favored Elixir over Erlang for its macro programming capabilities and its syntax. There is a lot more to it, but that would make a different story ;-).

For the first two years, we've developed without any users using it. You can imagine that developing a platform for this long by a team for which Elixir is relatively new was a big gamble. I remember a couple of interesting conversations and promises about that with a key stakeholder during one of our Christmas gatherings.

We created a proof of concept. Then we rewrote it. Then we rewrote it once more. Each iteration showed us something and improved our understanding of how to design it. After the third iteration, we were satisfied with the trade-offs we made. Although only the last iteration eventually was exposed to users.

## Beta Launch

In the third year, we announced and launched the new platform. We had a big party and some really shiny features. It allowed our users to test-drive the platform. We got our first real user feedback. We also got asked for a ton of features we hadn't ported yet from the old platform.

The following year we continued developing the platform. Basic functionality broke at times, but we fixed each bug quickly. The shiny new features seemed to always work. Our users weren't entirely happy about that balance as they wanted to run their businesses using this platform. Understandably, that requires basic functionality to be super stable.

## Go-Live

After another year of development, we ripped off the beta label. Three years of development before we got actual businesses operating on our platform. This resulted in quite different feedback than in the year before the go-live. It didn't take long before we got difficult and complex issues to solve.

We soon realized that our technical design wasn't lined up with the behavior that our users were expecting. It was even a bit unpredictable from their point of view. The behavior was intertwined with our technical design. This meant that altering the behavior required quite a big refactoring. We had some workarounds in place to reduce the friction for our users. It did require a month or two to make the technical design follow the expected behavior. After we migrated the data we finally got predictable behavior from our users' perspective.

While working these first months we also reflected on our development process. A lot of work has been done on "islands". The level of shared understanding was therefore a bit low. We started doing more pairing and better peer review. Not only for approvals but for knowledge sharing. This helped everyone to better understand the patchwork we created.

## An Eventful Year

The first months had settled in and we felt confident about our progress. We never predicted the year ahead of us would be so eventful.

For resiliency reasons we were running multiple nodes and because information between nodes needed to be shared in realtime we were using Erlang clustering. After the initial period, we started getting single node outages. The VM was still running but our application didn't function anymore. The other cluster nodes were not affected at the same time. Investigation showed that the application was no longer able to execute database queries. We updated our libraries. Reduced amount of queries. Upgraded Erlang. We've never found out the exact root-cause, but the issue did disappear eventually.

During the same time, we had issues with a specific application in our [umbrella application](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-projects.html#umbrella-projects). Technically it was a bug that started to appear under certain timing conditions. If we wouldn't have developed on islands, we might have found it sooner. Unraveling the timing issue was a delicate task and revealed a couple of related bugs. By joining our efforts it became easier to manage and work through all these bugs.

We made some obvious mistakes as well. Things that are easily preventable but given our focus just were not in the picture. Our database ran out of space unexpectedly, our HTTPS certificates expired and to top it all off we accidentally dropped all tables in our database. I hear you thinking: those are bad operations practices. You are right, but humans make mistakes and we learn from them. We switched our RDBMS and migrated to different certificate handling. Not because it was better, but because it allowed our infrastructure team to better support the architecture. I must add that [Ecto](https://hexdocs.pm/ecto/Ecto.html) helped a lot in this transition as we didn't have to change much.

Switching the database was good from an operational perspective. There was a big difference in how both databases responded to our workload. We had to finetune a lot. This ranged from changing how we queried our data, adding indexes, increasing performance by adding hardware and caching data in the application.

We were out of the woods for a little while. Our hard work was paying off and our customers were noticing it. The platform was still steadily growing. Three months passed without big issues.

We had a couple of platform-wide outages. This meant our clustered platform had more impact than we wanted and wasn't as resilient as we wanted it to be. It was kind of a snowball effect that happened. We made the snowball much smaller to decrease the impact and we took some precautions to prevent the snowball altogether. These two things combined allowed us to prevent and otherwise control the behavior. A big relief.

## COVID-19

Things were looking promising. I guess we all felt that way. Especially in hindsight. The year could have been so much better.

A part of our communication platform was a videoconferencing solution. It wasn't widely used and we considered dropping it earlier. Suddenly it peaked in traffic and it was the new hotness of the platform. Unfortunately for us, we hadn't been paying much attention to it. Bottlenecks became clear quite soon.

We had a single process ([gen_server](http://erlang.org/doc/man/gen_server.html)) for signaling from our application to our media gateway. It worked properly until then but it was not ready for scale. We refactored this into multiple processes to remove the bottleneck. If COVID-19 wouldn't have happened this would probably not have happened.

## What Have We Learned

Failures are easy. They come in many shapes and for many reasons. Each one of them requires a different solution. Working together allows you to find the best one. You have to do the work to solve them. There are no short-cuts to success!

I feel very grateful for having been a part of an amazing team while facing these challenges. I'm thankful for the support I received from the team and the company.
