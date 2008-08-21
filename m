From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Thu, 21 Aug 2008 08:34:09 +0100
Message-ID: <18605.6769.44592.478277@tree.ty.sabi.co.uk>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi>
	<18597.64737.508658.390657@notabene.brown>
	<alpine.DEB.1.10.0808181339010.365@kurp.hut.fi>
	<18601.25349.670500.530839@notabene.brown>
	<alpine.DEB.1.10.0808181501010.698@kurp.hut.fi>
	<alpine.DEB.1.10.0808201506440.7882@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0808201506440.7882@kurp.hut.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] For the 3 x 4disk raid0s the values were ~390MB
> Writeback and ~14MB Dirty. Aggretate write rate 690MB/sec.

> For the 1 x 12disk raid0 just ~14MB Writeback and ~190MB
> Dirty. Write rate 473 MB/sec. [ ... ]

That coincides with my own experience. But note that it is a very
special case, where optimum speed is reached only if requests hit
the member block devices in exactly the "right" way. In most
workloads latency also is a big part, so the ability to issue long
sequential streams of back-to-back requests is less important.

Anyhow my impression is that the recent 2.6 linux block IO
subsystem has some rather misguided behaviours (but then so much
of the Linux kernel contains several "brilliant" ideas of random
busybodies, most notably in paging, swapping and memory mangement),
and MD does not interact well with them.

As previously mentioned, on the read side the amount of data read
in a single transaction seems to be exactly the same as the block
device read ahead, which means that very large read-ahead values
give (much) better performance than smaller values, which would
not be the case if the block layer was streaming.

As to the write side, my current guess is that the effect above is
due to similar non streaming behaviour, probably dependent on the
unwise "plugging" idea that one of the usual busybodies has added
to the block layer. I have tried to disable that but there seem to
be deeper problems. I suspect also request reordering in the
elevator algorithms; using 'noop' as the elevator sometimes helps.

Overall the current Linux block layer instead of being based on
streaming seems to be based on batching of requests, and this
interacts pooly with MD, as the batch sizes and their passing on
timing might not be those that can best keep several MD member
block devices busy.

To see the detailed effects of all these layers of "brilliant"
policies, IO rates on individual devices should be looked at, and
I use something like this command line (with a very tall terminal
window).

  watch -n2 iostat -d -m /dev/mdXXX /dev/sdNNN /dev/sdMMM ... 1 2

My experience is that often the traffic is not quite evenly
balanced across the member drives, and when it is, the rate
sometimes is well below the one at which the member device
can operate.
