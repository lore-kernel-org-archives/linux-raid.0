From: Neil Brown <neilb@suse.de>
Subject: Re: Raid10 device hangs during resync and heavy I/O.
Date: Mon, 2 Aug 2010 12:29:49 +1000
Message-ID: <20100802122949.7bea3e7c@notabene>
References: <20100716184618.GA25890@gmail.com>
	<20100722184933.GA22647@gmail.com>
	<20100723131925.4b2bd54e@notabene>
	<20100723154701.GA2090@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100723154701.GA2090@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Bronder <jsbronder@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Jul 2010 11:47:01 -0400
Justin Bronder <jsbronder@gentoo.org> wrote:

> On 23/07/10 13:19 +1000, Neil Brown wrote:
> > On Thu, 22 Jul 2010 14:49:33 -0400

> > 
> > So the 'dd' process successfully waited for the barrier to be gone at
> > 189.021179, and thus set pending to '1'.  It then submitted the IO request.
> > We should then see swapper (or possibly some other thread) calling
> > allow_barrier when the request completes.  But we don't.
> > A request could possibly take many milliseconds to complete, but it shouldn't
> > take seconds and certainly not minutes.
> > 
> > It might be helpful if you could run this again, and in make_request(), after
> > the call to "wait_barrier()" print out:
> >   bio->bi_sector, bio->bi_size, bio->bi_rw
> > 
> > I'm guessing that the last request that doesn't seem to complete will be
> > different from the other in some important way.
> 
> Nothing stood out to me, but here's the tail end of a couple of different
> traces.

Thanks a lot!  Something does stand out for me!....

>            <...>-5047  [002]   207.051215: wait_barrier: out: dd - w:0 p:1 b:0
>            <...>-5047  [002]   207.051216: make_request: dd - sector:7472081 sz:20480 rw:0
>            <...>-4958  [003]   207.051218: raise_barrier: mid: md99_resync - w:0 p:1 b:1
>            <...>-5047  [002]   207.051227: wait_barrier: in:  dd - w:0 p:1 b:1
>           <idle>-0     [002]   207.058929: allow_barrier:     swapper - w:1 p:0 b:1
>            <...>-4958  [003]   207.058938: raise_barrier: out: md99_resync - w:1 p:0 b:1
>            <...>-4958  [003]   207.059044: raise_barrier: in:  md99_resync - w:1 p:0 b:1
>            <...>-4957  [003]   207.067171: lower_barrier:     md99_raid10 - w:1 p:0 b:0
>            <...>-5047  [002]   207.067179: wait_barrier: out: dd - w:0 p:1 b:0
>            <...>-5047  [002]   207.067180: make_request: dd - sector:7472121 sz:3584 rw:0
>            <...>-4958  [003]   207.067182: raise_barrier: mid: md99_resync - w:0 p:1 b:1
>            <...>-5047  [002]   207.067184: wait_barrier: in:  dd - w:0 p:1 b:1

The last successful IO is only 3584 bytes - 7 sectors.  All the others are
much larger.
It is almost certain that the read needed to cross a chunk boundary, so some
goes to one device, some to the next.  It was probably a 64K read or similar.
The first 5 pages all fit in one device, and so goes through as a 20K
read. The next page doesn't so it comes down to md/raid10 as a 1 page read.
raid10 splits it into a 7 sector read and a 1 sector read.  We see the 7
sector read being initiated, but it doesn't complete for some reason and the
resync barrier gets in the way so the 1 sector read blocks in wait_barrier.

In the next trace....
> 
> 
> 
>           <idle>-0     [000]   463.231730: allow_barrier:     swapper - w:2 p:4 b:1
>           <idle>-0     [000]   463.231739: allow_barrier:     swapper - w:2 p:3 b:1
>           <idle>-0     [000]   463.231746: allow_barrier:     swapper - w:2 p:2 b:1
>           <idle>-0     [000]   463.231765: allow_barrier:     swapper - w:2 p:1 b:1
>           <idle>-0     [000]   463.231774: allow_barrier:     swapper - w:2 p:0 b:1
>            <...>-5004  [000]   463.231792: raise_barrier: out: md99_resync - w:2 p:0 b:1
>            <...>-5004  [000]   463.232005: raise_barrier: in:  md99_resync - w:2 p:0 b:1
>            <...>-5003  [001]   463.232453: lower_barrier:     md99_raid10 - w:2 p:0 b:0
>            <...>-5009  [000]   463.232463: wait_barrier: out: flush-9:99 - w:1 p:1 b:0
>            <...>-5009  [000]   463.232464: make_request: flush-9:99 - sector:13931137 sz:61440 rw:1
>            <...>-5105  [001]   463.232466: wait_barrier: out: dd - w:0 p:2 b:0
>            <...>-5105  [001]   463.232467: make_request: dd - sector:7204393 sz:40960 rw:0
>            <...>-5009  [000]   463.232476: wait_barrier: in:  flush-9:99 - w:0 p:2 b:0
>            <...>-5009  [000]   463.232477: wait_barrier: out: flush-9:99 - w:0 p:3 b:0
>            <...>-5009  [000]   463.232477: make_request: flush-9:99 - sector:13931257 sz:3584 rw:1
>            <...>-5009  [000]   463.232481: wait_barrier: in:  flush-9:99 - w:0 p:3 b:0
>            <...>-5009  [000]   463.232482: wait_barrier: out: flush-9:99 - w:0 p:4 b:0
>            <...>-5009  [000]   463.232483: make_request: flush-9:99 - sector:13931264 sz:512 rw:1
>            <...>-5105  [001]   463.232492: wait_barrier: in:  dd - w:0 p:4 b:0
>            <...>-5105  [001]   463.232493: wait_barrier: out: dd - w:0 p:5 b:0

We see a similar thing with a write being broken into a 15 page writes, then
a 7 sector write, then a 1 sector write - that all works.

>            <...>-5105  [001]   463.232494: make_request: dd - sector:7204473 sz:3584 rw:0
>            <...>-5004  [000]   463.232495: raise_barrier: mid: md99_resync - w:0 p:5 b:1
>            <...>-5105  [001]   463.232496: wait_barrier: in:  dd - w:0 p:5 b:1
>            <...>-5009  [000]   463.232522: wait_barrier: in:  flush-9:99 - w:1 p:5 b:1
>           <idle>-0     [000]   463.232726: allow_barrier:     swapper - w:2 p:4 b:1
>           <idle>-0     [001]   463.240520: allow_barrier:     swapper - w:2 p:3 b:1
>           <idle>-0     [000]   463.240946: allow_barrier:     swapper - w:2 p:2 b:1
>           <idle>-0     [000]   463.240955: allow_barrier:     swapper - w:2 p:1 b:1
> 

But again we see a 7 sector read following a larger read, and the 1 sector
read that should follow gets blocked.

So it is somehow related to the need to split one-page requests across
multiple devices, and it could be specific to read requests.

Ahhhh.... I see the problem.  Because a 'generic_make_request' is already
active, the once called by raid10::make_request just queues the request until
the top level one completes.   This results in a deadlock.

I'll have to ponder a bit to figure out the best way to fix this.

Thanks again for the report and the help tracking down the problem.

NeilBrown


> Thanks,
> 

