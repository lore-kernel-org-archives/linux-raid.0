From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: double read in raid1
Date: Fri, 27 Aug 2004 12:07:15 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408271007.i7RA7Fp04492@oboe.it.uc3m.es>
References: <16683.64082.542823.562247@cse.unsw.edu.au>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16683.64082.542823.562247@cse.unsw.edu.au> from Neil Brown at "Aug
 25, 2004 12:32:50 pm"
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ptb@it.uc3m.es, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Neil Brown:"
> Sounds like "plugging" might be the thing to do.
> 
> When a read request arrives, just stick it on a queue, counting
>    the number of sectors.
> When an "unplug" call is made:
>     Sort the queue
>     Submit half the sectors to one drive, and the other half
>      to the other drive.

I've been thinking about a couple of possible algorithms. The one above
"suffers" in that it has to deal with the latency caused by the queuing
of requests already in the component drivers (assuming we cannot turn it
off) as well as the component readaheads (ditto).  I don't like
introducing an extra queue on top of that.

How about simply divvying up the mirror into say, 64K (or 2M, whatever)
contiguous regions.  If a read request falls in a even numbered region,
send it to the first drive. If it falls in an odd-numbered region, send
it to the second drive.

The region size should be enough to outpace any likely readahead. But
it should be small enough that a full queue of requests on one of the
component drives can't fit into more than about half a region. That
ensures that when the moment comes that queues on the component drives
are unplugged by the kernel (because they can't queue any more
requests), we haven't sent requests only to one of the drives so far.

That allows the raid driver to send requests 1-by-1 instead of plugging
and queueing itself.

Peter
