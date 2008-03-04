From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
Date: Tue, 4 Mar 2008 17:08:50 +1100
Message-ID: <18380.59250.90214.461186@notabene.brown>
References: <20080303111240.23302.patches@notabene>
	<1080303001705.23577@suse.de>
	<20080303155449.GA32242@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday March 3
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
List-Id: linux-raid.ids

On Monday March 3, maan@systemlinux.org wrote:
> On 11:17, NeilBrown wrote:
> 
> > So we create a new function 'flush_pending_writes' to give that attention,
> > and call it in freeze_array to be sure that we aren't waiting on raid1d.
> 
> Two minor remarks:

Thanks for looking.

> 
> Do we really need to take the spin lock in the common case where
> conf->pending_bio_list.head is NULL? If not, the above could be
> optimized to the slightly faster and better readable
> 
> 	struct bio *bio;
> 
> 	if (!conf->pending_bio_list.head)
> 		return 0;
> 	spin_lock_irq(&conf->device_lock);
> 	bio = bio_list_get(&conf->pending_bio_list);
> 	...
> 	spin_unlock_irq(&conf->device_lock);
> 	return 1;

Maybe... If I write a memory location inside a spinlock, then after
the spinlock is dropped, I read that location on a different CPU,
am I always guaranteed to see the new value? or do I need some sort of
memory barrier?
If I could be clear on that (and memory-barriers.txt isn't
helping... maybe if I read it 7 more times) then we probably could
make the change you suggest.
???

> 
> 
> > diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
> > --- .prev/drivers/md/raid1.c	2008-02-22 15:45:35.000000000 +1100
> > +++ ./drivers/md/raid1.c	2008-02-22 15:45:35.000000000 +1100
> > @@ -592,6 +592,37 @@ static int raid1_congested(void *data, i
> >  }
> >  
> >  
> > +static int flush_pending_writes(conf_t *conf)
> > +{
> 
> [snip]
> 
> Any chance to avoid this code duplication?

Not really.
The "conf_t" in each case is a very different conf_t that just happens
to have the same name and some common fields.
There is actually quite a lot of structural similarity between raid1
and raid10, but I don't think there is much to be gained by trying to
share code there.

Thanks,
NeilBrown
