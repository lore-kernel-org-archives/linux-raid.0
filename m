From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: RAID5 crash and burn
Date: Mon, 1 Nov 2004 00:29:11 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0411010019200.17633-100000@coffee.psychology.mcmaster.ca>
References: <4185BAFB.50502@ndietsch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4185BAFB.50502@ndietsch.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >>If you are seriously considering the performance implications of RAID1 
> >>vs RAID5 for swap, you are already done for performance wise.
> >>    
> >>
> >
> >I disagree.  the whole point of Linux's approach to swap is that 
> >it's fairly cheap to write a page to swap.
> >
> Writing to any form of secondary storage is not "cheap" when compared to 
> memory.

nonsense - from the cpu and kernel perspective, firing off 
a write of a page really is normally cheap.  more expensive
than doing nothing, well, yeah.

> Writing to a swap RAID5 volume, where you will probably incur a 
> read-modify-write operation is not considered "cheap" either.

hence my message.

> >whether you ever need 
> >it again depends on how overcommitted you are.  this is assuming that
> >the kernel successfully chooses not-likley-to-be-reused pages to 
> >write to swap, and that your swap partitions are reasonably fast 
> >to write to. 
> >
> This is what I am getting at: Any partition can not be considered 
> reasonably fast to write to when compared to memory.

perhaps you missed the point because I was sloppy with "fast".
what I meant was "low overhead".  that is, forcing a page to 
swap is largely a fire-and-forget kind of operation.  yes, you 
sometimes have to handle an interrupt, but it's not expensive,
and doesn't slow you down.  you're not holding up progress until
the write completes.  the overhead is largely book-keeping.

> Sorry, I still don't buy the premise that writing to disk can be 
> considered cheap.

do some benchmarking.

> Simply: Looking for performance improvements in swap means that you are 
> already very, very overloaded OR it is simply an exercise in theory.

no.  current linux VM logic uses swap as a way of optimizing page 
usage; handling overcommit is useful, even essential, but not a 
normal function of swap, and not relevant to most machines.

let me put it a completely other way: swap outs are normal, fairly
frequent, and GOOD for performance.  swap *IN*s are unusual, quite
infrequent, and bad for performance.  you're in trouble if you see
more than a trivial number of swap-ins, but even a lot of swap-outs
is not a problem.  (obviously, you don't want swapouts to starve your 
explicit/non-swap IO needs.)

