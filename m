From: Alex Tomas <alex@clusterfs.com>
Subject: Re: linear writes to raid5
Date: Wed, 12 Apr 2006 19:50:32 +0400
Message-ID: <m3hd4yrdx3.fsf@bzzz.home.net>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
	<m3y7ybrffe.fsf@bzzz.home.net>
	<17468.18087.901186.523228@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17468.18087.901186.523228@cse.unsw.edu.au> (Neil Brown's
 message of "Wed, 12 Apr 2006 10:15:35 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> Neil Brown (NB) writes:

 NB> There are a number of aspects to this.

 NB>  - When a write arrives we 'plug' the queue so the stripe goes onto a 
 NB>    'delayed' list which doesn't get processed until an unplug happens,
 NB>    or until the stripe is full and not requiring any reads.
 NB>  - If there is already pre-read active, then we don't start any more
 NB>    prereading until the pre-read is finished.  This effectively
 NB>    batches the prereading which delays writes a little, but not too
 NB>    much.
 NB>  - When the stripe-cache becomes full, we wait until it gets down to
 NB>    3/4 full before allocating another stripe.  This means that when
 NB>    some write requests come in, there should be enough room in the
 NB>    cache to delay them until they become full. 

I see. though my point is a bit different:
say, there is an application that's doing big linear writes in order
to achieve good throughput. on the other hand, most of modern storages
are very sensible to request size and tend to suck serving zillions
of small I/Os. raid5 breaks all incoming requests into small ones and
handles them separately. of couse, one might be lucky and after submiting
those small requests get merged to larger ones. but only due to luck,
I'm afraid. what I'm talking about is expressly code in raid5 that
would try to merge small requests in some obvious cases.
for example:


 NB> You are right.  This isn't optimal.
 NB> I don't think that the queue should get unplugged at this point.
 NB> Do you know what is calling raid5_unplug_device in your step 4?

 NB> We could take the current request into account, but I would rather
 NB> avoid that if possible.  If we can develop a mechanism that does the
 NB> right thing without reference to the current request, then it will
 NB> work equally if the request comes down in smaller chunks.

note also, that there can be other stripes being served. and they
may need reads. thus you'll have to unplug the queue for them.

 >> cause delayed stripes to get activated.

 NB> Can you explain where they cause delayed stripes to get activated?

just catched it:

 [<c0106b3e>] dump_stack+0x1e/0x30
 [<f881186e>] raid5_unplug_device+0xee/0x110 [ raid5]
 [<c02452e2>]blk_unplug_work+0x12/0x20               
 [<c01319ad>] worker_thread+0x19d/0x240
 [<c013611a>] kthread+0xba/0xc0        
 [<c01047c5>] kernel_thread_helper+0x5/0x10


thanks, Alex
