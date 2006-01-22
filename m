From: Tuomas Leikola <tuomas.leikola@gmail.com>
Subject: Re: paralellism of device use in md
Date: Sun, 22 Jan 2006 18:43:07 +0200
Message-ID: <5b170a7d0601220843p323a1d6ew6c22a5e952513ef6@mail.gmail.com>
References: <20060117120927.GU7017@strugglers.net> <43CD8A73.90703@nsr500.net>
	 <dqkrfm$9k9$1@sea.gmane.org> <dqktgu$fea$1@sea.gmane.org>
	 <fd8d0180601180955j691f5d2bn@mail.gmail.com>
	 <17358.53380.670707.439455@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17358.53380.670707.439455@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/19/06, Neil Brown <neilb@suse.de> wrote:
>
> The read balancing in raid1 is clunky at best.  I've often thought
> "there must be a better way".  I've never thought what the better way
> might be (though I haven't tried very hard).
>
> If anyone would like to experiment with the read-balancing code,
> suggest and test changes, it would be most welcome.
>

An interesting and desperately complex topic, intertwined with IO
schedulers in general. I'll follow with my 2 cents.

The way I see this, there are two fundamentally different approaches:
optimize for throughput or latency.

When optimizing for latency, the balancer would always choose a device
that can serve a request in the shortest time. This is close to what
the current code does, altough it doesn't seem to account for devices'
pending request queue lengths. (I'd estimate for a traditional ATA
disk, around 2-3 short seek requests is worth 1 long seek, because of
spindle latency). I'd assume a "fair" in-order service for the latency
mode.

When optimizing for throughput, the balancer would choose a device
that will have it's total queue completion time increased the least.
This indicates reordering of requests etc.

For queue depth of 1, the thoughput balancer would pick the "closest"
available device as long as the devices are idle, and when they are
all busy, leave the requests into array-wide queue until one of the
devices becomes available, and then dequeue the request the device can
serve fastest (or one that's had its deadline exceeded).

Both approaches become difficult when taking into account device
queues. The throughput balancer, as described, could just estimate how
close the new request is to all others already in the device, and pick
one that is nearby the other work. The latency scheduler is propably
pretty much useless in this scenario, as its definition will change if
requests can push each other around. I'd expect it to be useful in the
common desktop configuration with no device queues though.

One thing i'd like to see is more powerful estimates of request cost
for a device. It's possible, if not practical, to profile devices for
things like spindle latency and sector locations. If this cost
estimation data is correct enough, per-device queues become less
important as performance factors. As it is now, one can only hope that
requests that are near LBA-wise are near timewise, which is not true
for most devices. Yes, i know it's mostly wishful thinking.
Measurements would be tricky and would provide complex maps for
estimating costs, and (I think) would be virtually impossible to do
correctly for anything with device queues.

I'd expect that no drives in the market expose this kind of latency
estimation data to the controller or OS. I'd also expect that high end
storage system vendors use the very same information in their hardware
raid implementations to provide better queuing and load balancing.

Both the described balancer algorithms can be implemented somewhat
easily, and (I'd expect) will work relatively well with common desktop
drives. They could be optional (like the IO schedulers currently are),
and different cost estimation algorithms could also be optional (and
tunable if autotuning is out of question). Unfortunately my kernel
hacking skills are too weak for most of this - there needs to be
another who's interested enough.
