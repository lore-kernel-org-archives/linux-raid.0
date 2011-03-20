From: NeilBrown <neilb@suse.de>
Subject: Re: high throughput storage server?
Date: Sun, 20 Mar 2011 14:41:47 +1100
Message-ID: <20110320144147.29141f04@notabene.brown>
References: <4D6AC288.20101@wildgooses.com>
	<AANLkTinjPJJrUYrA=fxcau02Q+4Z67YVsJhcGxeTpAAW@mail.gmail.com>
	<4D6DC585.90304@gmail.com>
	<AANLkTi=yWhnqY_RTd8GH+fvEQfHfQ6TpWxnzpx-Fv=aj@mail.gmail.com>
	<AANLkTimB2hv8aP01JdQyOJehtkX2j=G5HtgVi6eNjmLx@mail.gmail.com>
	<AANLkTin=0PN+ovNY=rLu21-VRiy2Ffzrf69_fWsS54iN@mail.gmail.com>
	<20110313201000.GA14090@infradead.org>
	<4D7E0994.3020303@hardwarefreak.com>
	<20110314124733.GA31377@infradead.org>
	<4D835B2A.1000805@hardwarefreak.com>
	<20110318140509.GA26226@infradead.org>
	<4D837DAF.6060107@hardwarefreak.com>
	<20110319090101.1786cc2a@notabene.brown>
	<4D8559A2.6080209@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D8559A2.6080209@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, Roberto Spadim <roberto@spadim.com.br>, Drew <drew.kay@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 19 Mar 2011 20:34:26 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> NeilBrown put forth on 3/18/2011 5:01 PM:
> > On Fri, 18 Mar 2011 10:43:43 -0500 Stan Hoeppner <stan@hardwarefreak.com>
> > wrote:
> > 
> >> Christoph Hellwig put forth on 3/18/2011 9:05 AM:
> >>
> >> Thanks for the confirmations and explanations.
> >>
> >>> The kernel is pretty smart in placement of user and page cache data, but
> >>> it can't really second guess your intention.  With the numactl tool you
> >>> can help it doing the proper placement for you workload.  Note that the
> >>> choice isn't always trivial - a numa system tends to have memory on
> >>> multiple nodes, so you'll either have to find a good partitioning of
> >>> your workload or live with off-node references.  I don't think
> >>> partitioning NFS workloads is trivial, but then again I'm not a
> >>> networking expert.
> >>
> >> Bringing mdraid back into the fold, I'm wondering what kinda of load the
> >> mdraid threads would place on a system of the caliber needed to push
> >> 10GB/s NFS.
> >>
> >> Neil, I spent quite a bit of time yesterday spec'ing out what I believe
> > 
> > Addressing me directly in an email that wasn't addressed to me directly seem
> > a bit ... odd.  Maybe that is just me.
> 
> I guess that depends on one's perspective.  Is it the content of email
> To: and Cc: headers that matters, or the substance of the list
> discussion thread?  You are the lead developer and maintainer of Linux
> mdraid AFAIK.  Thus I would have assumed that directly addressing a
> question to you within any given list thread was acceptable, regardless
> of whose address was where in the email headers.

This assumes that I read every email on this list.  I certainly do read a lot,
but I tend to tune out of threads that don't seem particularly interesting -
and configuring hardware is only vaguely interesting to me - and I am sure
there are people on the list with more experience.

But whatever... there is certainly more chance of me missing something that
isn't directly addressed to me (such messages get filed differently).


> 
> >> How much of each core's cycles will we consume with normal random read
> > 
> > For RAID10, the md thread plays no part in reads.  Which ever thread
> > submitted the read submits it all the way down to the relevant member device.
> > If the read fails the thread will come in to play.
> 
> So with RIAD10 read scalability is in essence limited to the execution
> rate of the block device layer code and the interconnect b/w required.

Correct.

> 
> > For writes, the thread is used primarily to make sure the writes are properly
> > orders w.r.t. bitmap updates.  I could probably remove that requirement if a
> > bitmap was not in use...
> 
> How compute intensive is this thread during writes, if at all, at
> extreme IO bandwidth rates?

Not compute intensive at all - just single threaded.  So it will only
dispatch a single request at a time.  Whether single threading the writes is
good or bad is not something that I'm completely clear on.  It seems bad in
the sense that modern machines have lots of CPUs and we are fore-going any
possible benefits of parallelism.  However the current VM seems to do all
(or most) writeout from a single thread per device - the 'bdi' threads.
So maybe keeping it single threaded in the md level is perfectly natural and
avoids cache bouncing...


> 
> >> operations assuming 10GB/s of continuous aggregate throughput?  Would
> >> the mdraid threads consume sufficient cycles that when combined with
> >> network stack processing and interrupt processing, that 16 cores at
> >> 2.4GHz would be insufficient?  If so, would bumping the two sockets up
> >> to 24 cores at 2.1GHz be enough for the total workload?  Or, would we
> >> need to move to a 4 socket system with 32 or 48 cores?
> >>
> >> Is this possibly a situation where mdraid just isn't suitable due to the
> >> CPU, memory, and interconnect bandwidth demands, making hardware RAID
> >> the only real option?
> > 
> > I'm sorry, but I don't do resource usage estimates or comparisons with
> > hardware raid.  I just do software design and coding.
> 
> I probably worded this question very poorly and have possibly made
> unfair assumptions about mdraid performance.
> 
> >>     And if it does requires hardware RAID, would it
> >> be possible to stick 16 block devices together in a --linear mdraid
> >> array and maintain the 10GB/s performance?  Or, would the single
> >> --linear array be processed by a single thread?  If so, would a single
> >> 2.4GHz core be able to handle an mdraid --leaner thread managing 8
> >> devices at 10GB/s aggregate?
> > 
> > There is no thread for linear or RAID0.
> 
> What kernel code is responsible for the concatenation and striping
> operations of mdraid linear and RAID0 if not an mdraid thread?
> 

When the VM or filesystem or whatever wants to start an IO request, it calls
into the md code to find out how big it is allowed to make that request.  The
md code returns a number which ensures that the request will end up being
mapped onto just one drive (at least in the majority of cases).
The VM or filesystem builds up the request (a struct bio) to at most that
size and hands it to md.  md simply assigns a different target device and
offset in that device to the request, and hands it over the the target device.

So whatever thread it was that started the request carries it all the way
down to the device which is a member of the RAID array (for RAID0/linear).
Typically it then gets placed on a queue, and an interrupt handler takes it
off the queue and acts upon it.

So - no separate md thread.

RAID1 and RAID10 make only limited use of their thread, doing as much of the
work as possible in the original calling thread.
RAID4/5/6 do lots of work in the md thread.  The calling thread just finds a
place in the stripe cache to attach the request, attaches it, and signals the
thread.
(Though reads on a non-degraded array can by-pass the cache and are handled
much like reads on RAID0).

> > If you want to share load over a number of devices, you would normally use
> > RAID0.  However if the load had a high thread count and the filesystem
> > distributed IO evenly across the whole device space, then linear might work
> > for you.
> 
> In my scenario I'm thinking I'd want to stay away RAID0 because of the
> multi-level stripe width issues of double nested RAID (RAID0 over
> RAID10).  I assumed linear would be the way to go, as my scenario calls
> for using XFS.  Using 32 allocation groups should evenly spread the
> load, which is ~50 NFS clients.

You may well be right.

> 
> What I'm trying to figure out is how much CPU time I am going to need for:
> 
> 1.  Aggregate 10GB/s IO rate
> 2.  mdraid managing 384 drives
>     A.  16 mdraid10 arrays of 24 drives each
>     B.  mdraid linear concatenating the 16 arrays

I very much doubt that CPU is going to be an issue.  Memory bandwidth might -
but I'm only really guessing here, so it is probably time to stop.


> 
> Thanks for your input Neil.
> 
Pleasure.

NeilBrown
