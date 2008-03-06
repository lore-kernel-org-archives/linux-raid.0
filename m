From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
Date: Thu, 6 Mar 2008 14:29:37 +1100
Message-ID: <18383.25889.876350.431676@notabene.brown>
References: <20080303111240.23302.patches@notabene>
	<1080303001705.23577@suse.de>
	<20080303155449.GA32242@skl-net.de>
	<18380.59250.90214.461186@notabene.brown>
	<20080304112945.GB32242@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Tuesday March 4
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
List-Id: linux-raid.ids

On Tuesday March 4, maan@systemlinux.org wrote:
> On 17:08, Neil Brown wrote:
> > > Do we really need to take the spin lock in the common case where
> > > conf->pending_bio_list.head is NULL? If not, the above could be
> > > optimized to the slightly faster and better readable
> > > 
> > > 	struct bio *bio;
> > > 
> > > 	if (!conf->pending_bio_list.head)
> > > 		return 0;
> > > 	spin_lock_irq(&conf->device_lock);
> > > 	bio = bio_list_get(&conf->pending_bio_list);
> > > 	...
> > > 	spin_unlock_irq(&conf->device_lock);
> > > 	return 1;
> > 
> > Maybe... If I write a memory location inside a spinlock, then after
> > the spinlock is dropped, I read that location on a different CPU,
> > am I always guaranteed to see the new value? or do I need some sort of
> > memory barrier?
> 
> Are you worried about another CPU setting conf->pending_bio_list.head
> to != NULL after the if statement? If that's an issue I think also
> the original patch is problematic because the same might happen after
> the final spin_unlock_irq() but but before flush_pending_writes()
> returns zero.

No.  I'm worried that another CPU might set
conf->pending_bio_list.head *before* the if statement, but it isn't
seen by this CPU because of the lack of memory barriers.  The spinlock
ensures that the memory state is consistent.
It is possible that I am being overcautious.  But I think that is
better than the alternative.

Thanks,
NeilBrown
