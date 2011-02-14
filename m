From: NeilBrown <neilb@suse.de>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 10:41:09 +1100
Message-ID: <20110215104109.06b12b33@notabene.brown>
References: <20110214213817.GG836@hellgate.intra.guy>
	<20110215095042.51ef7e0a@notabene.brown>
	<20110214225754.GK19990@hellgate.intra.guy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214225754.GK19990@hellgate.intra.guy>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 23:57:54 +0100 Andras Korn <korn@raidlist.elan.rulez.org>
wrote:

> On Tue, Feb 15, 2011 at 09:50:42AM +1100, NeilBrown wrote:
> 
> > > I experimented a bit with write-mostly and write-behind and found that
> > > write-mostly provides a very significant benefit (see below) but
> > > write-behind seems to have no effect whatsoever.
> > 
> > The use-case where write-behind can be expected to have an effect is when the
> > throughput is low enough to be well within the capacity of all devices, but
> > the latency of the write-behind device is higher than desired.
> > write-behind will allow that high latency to be hidden (as long as the
> > throughput limit is not exceeded).
> > 
> > I suspect your tests did not test for low latency in a low-throughput
> > scenario.
> 
> I thought they did. "High latency" was, in my case, caused by the high seek
> times (compared to the SSD) of the spinning disks. Throughput-wise, they
> certainly could have kept up (their sequential read/write performance even
> exceeds that of the SSD).

A "MB/s" number is not going to show a difference with write-behind as it is
fundamentally about throughput.  We cannot turn random writes into sequential
writes just be doing 'write-behind' as the same locations on disk still have
to be written to.

You need a number like transactions-per-second to see a different.
If you write with O_SYNC, the write-behind will probably show a difference.


> 
> But maybe I misunderstand how write-behind works. I thought/hoped it would
> commit writes to the fast drive(s) and mark affected areas dirty in the
> intent map, then lazily sync the dirty areas over to the slow disk(s).
> 
> What does it actually do? md(4) isn't very forthcoming, and the wiki has no
> relevant hits either.

write-behind makes a copy of the data, submits writes to all devices in
parallel, and reports success to the upper layer as soon as all the
non-write-behind writes have finished.

The approach you suggest could be synthesised by:

 - add a write-intent bitmap with fairly small chunks.  This should be
   an external bitmap and should be directly on the fastest drive
 - have some daemon that fails the 'slow' device, waits 30 seconds, re-adds
   it, waits for recovery to complete, and loops back.

Actually I just realised another reason why you don' see any improvement.
You are using an internal bitmap.  This requires a synch write to both
devices.  The use-case for which write-behind was developed involved an
external bitmap.


Maybe I should disable bitmap updates to write-behind devices .....


NeilBrown
