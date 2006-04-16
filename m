From: Neil Brown <neilb@suse.de>
Subject: Re: linear writes to raid5
Date: Mon, 17 Apr 2006 09:22:40 +1000
Message-ID: <17474.53696.831154.37427@cse.unsw.edu.au>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
	<m3y7ybrffe.fsf@bzzz.home.net>
	<17468.18087.901186.523228@cse.unsw.edu.au>
	<m3hd4yrdx3.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Tomas on Wednesday April 12
Sender: linux-raid-owner@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 12, alex@clusterfs.com wrote:
> >>>>> Neil Brown (NB) writes:
> 
>  NB> There are a number of aspects to this.
> 
>  NB>  - When a write arrives we 'plug' the queue so the stripe goes onto a 
>  NB>    'delayed' list which doesn't get processed until an unplug happens,
>  NB>    or until the stripe is full and not requiring any reads.
>  NB>  - If there is already pre-read active, then we don't start any more
>  NB>    prereading until the pre-read is finished.  This effectively
>  NB>    batches the prereading which delays writes a little, but not too
>  NB>    much.
>  NB>  - When the stripe-cache becomes full, we wait until it gets down to
>  NB>    3/4 full before allocating another stripe.  This means that when
>  NB>    some write requests come in, there should be enough room in the
>  NB>    cache to delay them until they become full. 
> 
> I see. though my point is a bit different:
> say, there is an application that's doing big linear writes in order
> to achieve good throughput. on the other hand, most of modern storages
> are very sensible to request size and tend to suck serving zillions
> of small I/Os. raid5 breaks all incoming requests into small ones and
> handles them separately. of couse, one might be lucky and after submiting
> those small requests get merged to larger ones. but only due to luck,
> I'm afraid. what I'm talking about is expressly code in raid5 that
> would try to merge small requests in some obvious cases.
> for example:

raid5 shouldn't need to merge small requests into large requests.
That is what the 'elevator' or io_scheduler algorithms are for.  There
already merge multiple bio's into larger 'requests'.  If they aren't
doing that, then something needs to be fixed.

It is certainly possible that raid5 is doing something wrong that
makes merging harder - maybe sending bios in the wrong order, or
sending them with unfortunate timing.  And if that is the case it
certainly makes sense to fix it.  
But I really don't see that raid5 should be merging requests together
- that is for a lower-level to do.

> 
> 
>  NB> You are right.  This isn't optimal.
>  NB> I don't think that the queue should get unplugged at this point.
>  NB> Do you know what is calling raid5_unplug_device in your step 4?
> 
>  NB> We could take the current request into account, but I would rather
>  NB> avoid that if possible.  If we can develop a mechanism that does the
>  NB> right thing without reference to the current request, then it will
>  NB> work equally if the request comes down in smaller chunks.
> 
> note also, that there can be other stripes being served. and they
> may need reads. thus you'll have to unplug the queue for them.
> 
>  >> cause delayed stripes to get activated.
> 
>  NB> Can you explain where they cause delayed stripes to get activated?
> 
> just catched it:
> 
>  [<c0106b3e>] dump_stack+0x1e/0x30
>  [<f881186e>] raid5_unplug_device+0xee/0x110 [ raid5]
>  [<c02452e2>]blk_unplug_work+0x12/0x20               
>  [<c01319ad>] worker_thread+0x19d/0x240
>  [<c013611a>] kthread+0xba/0xc0        
>  [<c01047c5>] kernel_thread_helper+0x5/0x10

This implies 3millisecs have passed since the queue was plugged, which
is a long time.....
I guess what could be happening is that the queue is being unplugged
every 3msec whether it is really needed or not.
i.e. we plug the queue, more requests come, the stripes we plugged the
queue for get filled up and processes, but the timer never gets reset.
Maybe we need to find a way to call blk_remove_plug when there are no
stripes waiting for pre-read...

Alternately, stripes on the delayed queue could get a timestamp, and
only get removed if they are older than 3msec.  Then we would replug
the queue if there were some new stripes left....

Something like that might work.

NeilBrown
