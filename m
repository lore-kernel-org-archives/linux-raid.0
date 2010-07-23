From: Neil Brown <neilb@suse.de>
Subject: Re: Raid10 device hangs during resync and heavy I/O.
Date: Fri, 23 Jul 2010 13:19:25 +1000
Message-ID: <20100723131925.4b2bd54e@notabene>
References: <20100716184618.GA25890@gmail.com>
	<20100722184933.GA22647@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100722184933.GA22647@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Bronder <jsbronder@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Jul 2010 14:49:33 -0400
Justin Bronder <jsbronder@gentoo.org> wrote:

> On 16/07/10 14:46 -0400, Justin Bronder wrote:
> > I've been able to reproduce this across a number of machines with the same
> > hardware configuration.  During a raid10 resync, it's possible to hang the
> > device so that any further I/O operations will also block.  This can be
> > fairly simply done using dd.  
> > 
> > Interestingly, this is not reproducible when using a non-partitioned device.
> > That is, creating the device with --auto=yes and then directly using it
> > functions as expected.  However, using --auto=yes or --auto=mdp and then
> > creating a partition across the device will cause the hang.
> > 
> 
> I've done some more research that may potentially help. All of
> the following was done with 2.6.34.1.
> 
> Still produces the hang:
>     - Using cp (may take a bit longer).
>     - Using jfs as the filesystem.
>     - Dropping RESYNC_DEPTH to 32
>     - Using the offset layout.
> 
> Does not produce the hang:
>     - Using the near layout.
>     - Using dd on the partition directly instead of on a
>       filesystem via something like:
>       dd if=/dev/${MD_DEV}p1 of=/dev/${MD_DEV}p1 seek=4001 bs=1M
> 
> 
> As the barrier code is very similiar, I repeated a number of
> these tests using raid1 instead of raid10.  In every case, I was
> unable to cause the system to hang.  I focused on the barriers
> due to the tracebacks in the previous email.  For the heck of it,
> I added some tracing (patch below) where the reason for the hang
> is fairly obvious.  Of course, how it happened isn't.
> 
> The last bit of the trace before the hang.

Thanks for doing this!

See below...

> 
>           <idle>-0     [003]   188.987489: allow_barrier:     swapper - w:2 p:1 b:1
>           <idle>-0     [003]   188.987495: allow_barrier:     swapper - w:2 p:0 b:1
>            <...>-4910  [003]   188.987518: raise_barrier: out: md99_resync - w:2 p:0 b:1
>            <...>-4910  [003]   188.987733: raise_barrier: in:  md99_resync - w:2 p:0 b:1
>            <...>-4909  [003]   188.988174: lower_barrier:     md99_raid10 - w:2 p:0 b:0
>            <...>-4915  [002]   188.988188: wait_barrier: out: flush-9:99 - w:1 p:1 b:0
>            <...>-4996  [003]   188.988199: wait_barrier: out: dd - w:0 p:2 b:0
>            <...>-4915  [002]   188.988203: wait_barrier: in:  flush-9:99 - w:0 p:2 b:0
>            <...>-4915  [002]   188.988204: wait_barrier: out: flush-9:99 - w:0 p:3 b:0
>            <...>-4915  [002]   188.988208: wait_barrier: in:  flush-9:99 - w:0 p:3 b:0
>            <...>-4915  [002]   188.988209: wait_barrier: out: flush-9:99 - w:0 p:4 b:0
>            <...>-4996  [003]   188.988211: wait_barrier: in:  dd - w:0 p:4 b:0
>            <...>-4996  [003]   188.988211: wait_barrier: out: dd - w:0 p:5 b:0
>            <...>-4996  [003]   188.988214: wait_barrier: in:  dd - w:0 p:5 b:0
>            <...>-4996  [003]   188.988214: wait_barrier: out: dd - w:0 p:6 b:0
>            <...>-4915  [002]   188.988234: wait_barrier: in:  flush-9:99 - w:0 p:6 b:0
>            <...>-4915  [002]   188.988235: wait_barrier: out: flush-9:99 - w:0 p:7 b:0
>            <...>-4915  [002]   188.988244: wait_barrier: in:  flush-9:99 - w:0 p:7 b:0
>            <...>-4915  [002]   188.988244: wait_barrier: out: flush-9:99 - w:0 p:8 b:0
>            <...>-4915  [002]   188.988248: wait_barrier: in:  flush-9:99 - w:0 p:8 b:0
>            <...>-4915  [002]   188.988249: wait_barrier: out: flush-9:99 - w:0 p:9 b:0
>            <...>-4996  [003]   188.988251: wait_barrier: in:  dd - w:0 p:9 b:0
>            <...>-4996  [003]   188.988252: wait_barrier: out: dd - w:0 p:10 b:0
>            <...>-4996  [003]   188.988261: wait_barrier: in:  dd - w:0 p:10 b:0
>            <...>-4996  [003]   188.988262: wait_barrier: out: dd - w:0 p:11 b:0
>            <...>-4996  [003]   188.988264: wait_barrier: in:  dd - w:0 p:11 b:0
>            <...>-4996  [003]   188.988264: wait_barrier: out: dd - w:0 p:12 b:0
>            <...>-4915  [002]   188.988272: wait_barrier: in:  flush-9:99 - w:0 p:12 b:0
>            <...>-4915  [002]   188.988272: wait_barrier: out: flush-9:99 - w:0 p:13 b:0
>            <...>-4915  [002]   188.988281: wait_barrier: in:  flush-9:99 - w:0 p:13 b:0
>            <...>-4915  [002]   188.988281: wait_barrier: out: flush-9:99 - w:0 p:14 b:0
>            <...>-4996  [003]   188.988282: wait_barrier: in:  dd - w:0 p:14 b:0
>            <...>-4996  [003]   188.988283: wait_barrier: out: dd - w:0 p:15 b:0
>            <...>-4915  [002]   188.988285: wait_barrier: in:  flush-9:99 - w:0 p:15 b:0
>            <...>-4915  [002]   188.988286: wait_barrier: out: flush-9:99 - w:0 p:16 b:0
>            <...>-4996  [003]   188.988290: wait_barrier: in:  dd - w:0 p:16 b:0
>            <...>-4996  [003]   188.988290: wait_barrier: out: dd - w:0 p:17 b:0
>            <...>-4996  [003]   188.988292: wait_barrier: in:  dd - w:0 p:17 b:0
>            <...>-4996  [003]   188.988293: wait_barrier: out: dd - w:0 p:18 b:0
>            <...>-4915  [002]   188.988309: wait_barrier: in:  flush-9:99 - w:0 p:18 b:0
>            <...>-4915  [002]   188.988310: wait_barrier: out: flush-9:99 - w:0 p:19 b:0
>            <...>-4996  [003]   188.988310: wait_barrier: in:  dd - w:0 p:19 b:0
>            <...>-4996  [003]   188.988311: wait_barrier: out: dd - w:0 p:20 b:0
>            <...>-4996  [003]   188.988317: wait_barrier: in:  dd - w:0 p:20 b:0
>            <...>-4996  [003]   188.988318: wait_barrier: out: dd - w:0 p:21 b:0
>            <...>-4996  [003]   188.988321: wait_barrier: in:  dd - w:0 p:21 b:0
>            <...>-4996  [003]   188.988321: wait_barrier: out: dd - w:0 p:22 b:0
>            <...>-4915  [002]   188.988323: allow_barrier:     flush-9:99 - w:0 p:21 b:0
>            <...>-4996  [003]   188.988327: wait_barrier: in:  dd - w:0 p:21 b:0
>            <...>-4996  [003]   188.988328: wait_barrier: out: dd - w:0 p:22 b:0
>            <...>-4915  [002]   188.988356: wait_barrier: in:  flush-9:99 - w:0 p:22 b:0
>            <...>-4915  [002]   188.988356: wait_barrier: out: flush-9:99 - w:0 p:23 b:0
>            <...>-4915  [002]   188.988361: wait_barrier: in:  flush-9:99 - w:0 p:23 b:0
>            <...>-4915  [002]   188.988361: wait_barrier: out: flush-9:99 - w:0 p:24 b:0
>            <...>-4910  [003]   188.988370: raise_barrier: mid: md99_resync - w:0 p:24 b:1
>            <...>-4915  [002]   188.988378: wait_barrier: in:  flush-9:99 - w:0 p:24 b:1
>            <...>-4996  [003]   188.988638: wait_barrier: in:  dd - w:1 p:24 b:1
>           <idle>-0     [003]   188.988887: allow_barrier:     swapper - w:2 p:23 b:1
>           <idle>-0     [003]   188.988895: allow_barrier:     swapper - w:2 p:22 b:1
>           <idle>-0     [003]   188.988899: allow_barrier:     swapper - w:2 p:21 b:1
>           <idle>-0     [003]   188.988905: allow_barrier:     swapper - w:2 p:20 b:1
>           <idle>-0     [003]   188.988909: allow_barrier:     swapper - w:2 p:19 b:1
>           <idle>-0     [002]   188.996299: allow_barrier:     swapper - w:2 p:18 b:1
>           <idle>-0     [002]   188.996310: allow_barrier:     swapper - w:2 p:17 b:1
>           <idle>-0     [002]   188.996317: allow_barrier:     swapper - w:2 p:16 b:1
>           <idle>-0     [002]   188.996325: allow_barrier:     swapper - w:2 p:15 b:1
>           <idle>-0     [002]   188.996330: allow_barrier:     swapper - w:2 p:14 b:1
>           <idle>-0     [002]   188.996336: allow_barrier:     swapper - w:2 p:13 b:1
>           <idle>-0     [002]   188.996340: allow_barrier:     swapper - w:2 p:12 b:1
>           <idle>-0     [003]   189.004270: allow_barrier:     swapper - w:2 p:11 b:1
>           <idle>-0     [003]   189.004278: allow_barrier:     swapper - w:2 p:10 b:1
>           <idle>-0     [003]   189.004284: allow_barrier:     swapper - w:2 p:9 b:1
>           <idle>-0     [003]   189.004302: allow_barrier:     swapper - w:2 p:8 b:1
>           <idle>-0     [003]   189.004313: allow_barrier:     swapper - w:2 p:7 b:1
>           <idle>-0     [003]   189.004322: allow_barrier:     swapper - w:2 p:6 b:1
>           <idle>-0     [002]   189.004936: allow_barrier:     swapper - w:2 p:5 b:1
>           <idle>-0     [002]   189.004959: allow_barrier:     swapper - w:2 p:4 b:1
>           <idle>-0     [002]   189.004970: allow_barrier:     swapper - w:2 p:3 b:1
>           <idle>-0     [002]   189.004979: allow_barrier:     swapper - w:2 p:2 b:1
>           <idle>-0     [002]   189.004996: allow_barrier:     swapper - w:2 p:1 b:1
>           <idle>-0     [002]   189.005006: allow_barrier:     swapper - w:2 p:0 b:1
>            <...>-4910  [002]   189.005030: raise_barrier: out: md99_resync - w:2 p:0 b:1
>            <...>-4910  [002]   189.005251: raise_barrier: in:  md99_resync - w:2 p:0 b:1
>            <...>-4909  [002]   189.005676: lower_barrier:     md99_raid10 - w:2 p:0 b:0
>            <...>-4915  [003]   189.005687: wait_barrier: out: flush-9:99 - w:1 p:1 b:0
>            <...>-4996  [003]   189.005713: wait_barrier: out: dd - w:0 p:2 b:0
>            <...>-4910  [002]   189.005715: raise_barrier: mid: md99_resync - w:0 p:2 b:1
>            <...>-4996  [003]   189.005724: wait_barrier: in:  dd - w:0 p:2 b:1
>           <idle>-0     [002]   189.012925: allow_barrier:     swapper - w:1 p:1 b:1
>           <idle>-0     [002]   189.013271: allow_barrier:     swapper - w:1 p:0 b:1
>            <...>-4910  [002]   189.013295: raise_barrier: out: md99_resync - w:1 p:0 b:1
>            <...>-4910  [002]   189.013414: raise_barrier: in:  md99_resync - w:1 p:0 b:1
>            <...>-4909  [002]   189.021171: lower_barrier:     md99_raid10 - w:1 p:0 b:0
>            <...>-4996  [003]   189.021179: wait_barrier: out: dd - w:0 p:1 b:0
>            <...>-4910  [002]   189.021182: raise_barrier: mid: md99_resync - w:0 p:1 b:1
>            <...>-4996  [003]   189.021184: wait_barrier: in:  dd - w:0 p:1 b:1
>            <...>-4915  [003]   218.929283: wait_barrier: in:  flush-9:99 - w:1 p:1 b:1
> 
> 

So the 'dd' process successfully waited for the barrier to be gone at
189.021179, and thus set pending to '1'.  It then submitted the IO request.
We should then see swapper (or possibly some other thread) calling
allow_barrier when the request completes.  But we don't.
A request could possibly take many milliseconds to complete, but it shouldn't
take seconds and certainly not minutes.

It might be helpful if you could run this again, and in make_request(), after
the call to "wait_barrier()" print out:
  bio->bi_sector, bio->bi_size, bio->bi_rw

I'm guessing that the last request that doesn't seem to complete will be
different from the other in some important way.

Thanks,
NeilBrown




