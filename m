From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: patch for raid1 to make it choose the fastest device for READ
Date: Fri, 13 Aug 2004 10:20:58 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408130820.i7D8Kws02549@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Also sprach Neil Brown:"
> > The following message was posted on linux-raid earlier today. I
> > forward it for comment.
> 
> Odd that I didn't see it, but no-matter.

OK - that's the second time that's been said to me. Perhaps I should
resend it. I'll try reflecting this cnversation to the list and see if
it turns up.

> > Here is a preliminary patch for raid1 (2.4) to make it choose the
> > fastest device in the array to read from.
> 
> There is obvious value in that..

Yes.

> > The standard kernel code changes the read device every 128 sectors, in
> > equal-handed style. That's not so good when one device is much slower
> > than the other, as is the cse if one is a network device and one is a
> > local device. In principle, any algorithm which applies some knowledge
> > or intelligence will do better than a 50/50 strategy, provided it's at
> > all oriented in the right direction.
> 
> I've never really liked the "switch after 128 sectors" strategy.  It
> doesn't obviously make sense.
> Maybe "switch if this drive has more sectors currently queued than the
> other drive, by a difference of at least 128"...

Oh, I see - you want to maintain counters of requests in-minus-out for
each component device. That's possible, yes. We can see when we submit a
buffer head to the component device (with make_request), and we can see 
when it comes back finished, via its end_io function (we have modified
it in order to be able to ack the original when the last i/o finishes).

However, the optimum strategy is clearly "always choose the fastest for
read", and so anything else is potentially suboptimal, and therefore why
not directly measure how fast each disk is?  The question is whether the
excess number of sectors queued is an direct or indirect indicator of
the speed, and I'd say it is indirect, since the kernel might at any
particular point simply have chosen to run one device's request function
and not yet have run the others. That makes the strategy have a certain
probability of misestimating the fastest.

> > The patch works by replacing the swapover to the next device=20
> > at 128 sectors by a short blast of testing to get a picture of the
> > latency, then a swapover to the fastest device found, which it stays on
> > for 1024 sectors instead of 128. Here is what logging shows:
> 
> The "read a bit here, and bit there" approach feels a bit untidy,
> though not excessively so.

Maybe one should only do it once, at device insertion? Or perhaps only
at very sporadic intervals, nowehere near as frequently as every 1000
requests.

> What would you think of instead timing writes - which happen across
> all drives in parallel. 

Writes are not necessarily synchronous (indeed, they are usually not).
That might well give a false reading for short bursts.


> That would give a similar indication.

I'm not sure about that.

> For read-only loads you could time the super-block update.  Though

Which happens once. Well, one could run the testing phase just once.
But it "feels" safer to run it at regular intervals. Every 0.5MB is
perhaps a bit frequent. Every 8MB might be more appropriate, or one
could use some other trigger, such as the observed variability in the
latency of the currently used device.


> maybe for a readonly load you wouldn't need to update the superblock
> at all....

One can also issue "double" read requests during testing, one to each
device, and discard the slowest (ack the original request on the first
received, however) .

> Or maybe just time every read request and rely on occasional seeks to
> make sure every drive gets timed...

Because in-sequence reads stay on the same device? I disabled the line
that kept them there, because one should not stay on the slowest device
if by mistake one is on the slowest ...

> You say that you cannot meaningfully test in less than 10 sectors, but
> how much precision do you need?  I'm not sure a 10% difference should

I'm not sure - I only tested with loopback devices (under a UML layer).
I don't presently have a feel for real device latencies. It is unusual
for loopback devices to measure as more than 0 jiffies latency, but they
do sometimes return 10 jiffies late, which is an infinity-to-one
variability :(.

> really have much consequence.  As this is particularly for automatic
> detection of network devices, would not you be expecting more like
> 1000% differences?

I don't know - but I was not happy with the precision in relation to the
loop devices I was testing on.  Is a Gigabit or 100BT ethernet to a
cached remote device so much slower (in terms of latency) than a local
disk?

My concern is arithmetic - doing integer arithmetic to calculate rolling
averages with a weighting of about 9:1 (i.e.  each new info acts like
about one tenth of the total information stored in the rolling average),
at averages near zero there is a huge hysteresis effect that makes it
very hard to move the average off zero, or one, or whatever it is
currently at. That means that the new info is effectively discarded
unless it is at least 10 jiffies different from the average.

If I change the weighting to 4:1, then only about 4 trials are stored in
the rolling average, but he new info makes a difference if it is at
least 4 jiffies different from the average.

I can fix this by storing the latency in units of 1/10 of a jiffy, or
less (so each jiffy counts 10), but I did not want to complicate things.

> I think I would prefer the result of the latency tests to be to
> black-list slow devices for reading, or atleast put a heavy weight
> against them, so that e.g. a "slow" device only ever gets half the reads
> of a "fast" device ( if the difference is 2:1 or less).

I tried that originally - by setting the swapover point to be
proportional to the inverse of the latency. That way devices with low
latency were read from for a long time. But it looked silly - since the
idea is to choose the fastest, why spend a constant proportion of the
time on the slowest, which is what will happen?

> Comments?

As above!

Thanks very much for the feedback.

Peter

