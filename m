From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: the '--setra 65536' mistery, analysis and WTF?
Date: Thu, 20 Mar 2008 08:12:26 +0000
Message-ID: <18402.7274.174605.611654@tree.ty.sabi.co.uk>
References: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
	<18400.13488.178782.156775@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18400.13488.178782.156775@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... on large read-ahead being needed for reasonable Linux RAID
read performance ... ]

>> * Most revealingly, when I used values of read ahead which
>> were powers of 10, the numbers of block/s reported by 'vmstat
>> 1' was also a multiple of that power of 10.

> Most disturbingly, this seems to indicate that not only the
> Linux block IO subsystems issues IO operations in multiples of
> the read-ahead size, but does so at a fixed number of times per
> second that is a multiple of 10.

> Which leads me to suspect that the queueing of IO requests on
> the driver's queue, or even the issuing of requests from the
> driver to the device, may end up being driven by the clock tick
> interrupt frequency, not the device interrupt frequency.

Which lead me to think about elevators, which was also mentioned
in some recent (and otherwise less interesting :->) comments as
some elevator do it periodically.

So I have done a quick test with the 'anticipatory' elevator
instead of the RHEL4 default CFQ and large readheads are not
necessary and I get 260MB/s writing and 520MB/s reading with an
8 sector readahead on the same 4*(1+1) RAID0 f2 used previously.

In theory the elevator should have no influence on a strict
sequential reading test that with strictly increasing read
addresses, as there is nothing to reorder.

However RHEL4, which was mentioned by other people reporting the
use of very large read-aheads, comes with an old version of the
elevator subsystem (which can only change elevator for all block
devices and only on reboot too).

Perhaps the CFQ version in RHEL4 inserts pauses in the stream of
read requests which have to be amortized over large read request
streams, and perhaps the variability in performance depends on
resonances between the length of the read-ahead at the RAID
block device level and the interval between pauses at the
underlying disk level.

I have used 'anticipatory' in my test above because it is known
to favour sequential access patterns. Unfortunately it does so a
bit too much and also leads to poor latency with multiple streams,
probably the reason why the default is CFQ. Again, the version
of CFQ in RHEL4 is old, so it has few tweakables, but perhaps it
can be tweaked to be less stop-and-go.

Anyhow the elevator seems to be why there are pauses in the
stream of read operations (but not [much] with write ones...).
It still seems the case to me that the block IO subsystem
structures IO in lots of read-ahead sectors, which is not good,
but at least not bad if the read-ahead is rather small (a few
KiB) as it should be.

Finally, I am getting a bit skeptical about elevators in general;
several tests show no-elevator as not being significantly worse
and sometimes better than any elevator. I suspect that elevators
as currently designed have too common pathological cases, as
their designers may have been not as careful as to ensuring
their influence was small and robust...
