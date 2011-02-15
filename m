From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 02:00:52 +0100
Message-ID: <20110215010052.GA13135@hellgate.intra.guy>
References: <20110214213817.GG836@hellgate.intra.guy>
 <20110215095042.51ef7e0a@notabene.brown>
 <20110214225754.GK19990@hellgate.intra.guy>
 <20110215104109.06b12b33@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110215104109.06b12b33@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 15, 2011 at 10:41:09AM +1100, NeilBrown wrote:

> > > I suspect your tests did not test for low latency in a low-throughput
> > > scenario.
> > 
> > I thought they did. "High latency" was, in my case, caused by the high seek
> > times (compared to the SSD) of the spinning disks. Throughput-wise, they
> > certainly could have kept up (their sequential read/write performance even
> > exceeds that of the SSD).
> 
> A "MB/s" number is not going to show a difference with write-behind as it is
> fundamentally about throughput.  We cannot turn random writes into sequential
> writes just be doing 'write-behind' as the same locations on disk still have
> to be written to.

Thanks, I understand now; I had hoped write-behind would in fact re-order
the writes to the slow devices. In retrospect, I'm not sure what gave me
that notion. (Reckless optimism, probably. :)

> > What does it actually do? md(4) isn't very forthcoming, and the wiki has no
> > relevant hits either.
> 
> write-behind makes a copy of the data, submits writes to all devices in
> parallel, and reports success to the upper layer as soon as all the
> non-write-behind writes have finished.

So this really only makes a difference for synchronous writes (because
otherwise success would be reported as soon as the write is buffered),
right?

> The approach you suggest could be synthesised by:
> 
>  - add a write-intent bitmap with fairly small chunks.  This should be
>    an external bitmap and should be directly on the fastest drive
>  - have some daemon that fails the 'slow' device, waits 30 seconds, re-adds
>    it, waits for recovery to complete, and loops back.

Ewww. :)

> Actually I just realised another reason why you don' see any improvement.
> You are using an internal bitmap.  This requires a synch write to both
> devices.

Yes, that was something I actually wanted to ask. Since it's write_behind_,
it wouldn't need to be a synchronous write though - you could at least allow
the write-mostly disk to reorder it, couldn't you?

>  The use-case for which write-behind was developed involved an external
> bitmap.

My use case, fwiw, is that I have a single SSD and would like to exploit its
close-to-zero seek time while also providing redundancy (using spinning
disks) with eventual consistency. It's not for databases or anything
irreplaceable, just things like logs, svn working copies, vserver system
files... and an external jfs journal. (I know journal i/o is very nearly
sequential, but I don't have a spinning disk to dedicate to it, and if I use
the same disk for other purposes as well, seeking would definitely occur,
decreasing performance.)

> Maybe I should disable bitmap updates to write-behind devices .....

Or make them asynchronous, or lazy (like, update the bitmap whenever you
must seek into the vicinity anyway), or just infrequent. But yes, this
sounds like a very good idea.

Another approach to take would be to mark as dirty, on the fast devices, all
areas being written to, and in the background continuously synch them to the
slow devices, sequentially (marking as clean synched-and-as-yet-unwritten-to
areas); so that the array would be resyncing continually, but be very fast
for random writes. This would of course also require the bitmap to only be
synchronously updated on the fast devices.

Otoh, this is really a different mechanism from the current write-behind,
aimed at a different use-case, so maybe it could be implemented
orthogonally. (Patches welcome, I'm sure; it's times like these I hate not
being a coder.)

-- 
                     Andras Korn <korn at elan.rulez.org>
                    Take my advice, I don't use it anyway.
