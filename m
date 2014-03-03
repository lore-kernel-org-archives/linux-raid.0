From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid5 write latency is 10x the drive latency
Date: Mon, 3 Mar 2014 22:15:44 +0000
Message-ID: <21268.65296.503057.601739@tree.ty.sabi.co.uk>
References: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> We are testing a fully random 8K write IOMETER workload on a
> raid5 md, composed of 5 drives. [ ... ]

"Doctor, if I stab my hand very hard with a fork it hurts a lot,
what can you do about that?"

> We see that the write latency that the MD device demonstrates

Congratulations on reckoning that write latency matters. People
who think they know better and use parity RAID usually manage to
forget about write latency.

Also congratulations on using a reasonable member count of 4+1.

> is 10 times the latency of individual drives. [ ... ]

The latency of what actually?

That's what 'iostat' reports for "something". The definition of
'await' if that's what you are looking may be interesting.

Also, what does your tool report?

  BTW, why not use 'fio' which along with some versions of
  Garloff's version of 'bonnie' is one of the few reliable
  speed-testing tools (with the right options...).

Also what type of device? Which size of the stripe cache (very
important)?

Which chunk size? Which drive write cache setting? Which use of
barriers? Which filesystem? Which elevator? Which flusher
parameters? Which tool settings? How many threads?

Because some of the numbers look a bit amazing or strange:

* Only 20% of IOPS are reads, which is pretty miraculous.

* 'dm-33' seems significantly faster (seek times) than the other
  members.

* Each drive delivers over 1,000 4kiB IOPS (mixed r/W), which is
  also pretty miraculous if they are disk drives, and terrible if
  they are flash drives.

* That ~50ms full wait-time per IO seems a bit high to me at a
  device utilization of around 70%, and a bit inconsistent with
  the ability of each device to process 1,000 IOPS.

* In your second set of numbers utilization remains the same,the
  per-disk write await doubles to around 90-100ms, average queue
  size nearly doubles too, but 4kiB write IOPS go up to by 50%,
  and the percent of reads goes down to 16.6% almost exactly.
  These numbers tell a story, a pretty strong story.

> [ ... ] with RMW that raid5 is doing, we can expect 2x of the
> drive latency

HAHAHAHAHAHA! HAHAHAHAHAHAHAHAHA! You made my day.

> (1x to load the stipe-head, 1x to update the required
> stripe-head blocks on disk).

Amazing! Send patches! :-)

> raid5d thread is busy updating the bitmap

Using a bitmap and worrying about write latency, I had not even
thought about that as a possibility. Extremely funny!

> commented out the bitmap_unplug call

Ah plugging/unplugging one of the great examples of sheer
"genius" in the Linux code. We can learn a lot from it :-).

> Typically - without the bitmap update - raid5 call takes
> 400-500us, so I don't understand how the additional ~100ms of
> latency is gained

That's really really funny! Thanks! :-)
