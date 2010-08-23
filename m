From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 13:03:06 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008231258130.17716@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823125100.75a9de56.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100823125100.75a9de56.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 Aug 2010, Andrew Morton wrote:

> > > > diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> > > > --- a/drivers/md/dm-region-hash.c
> > > > +++ b/drivers/md/dm-region-hash.c
> > > > @@ -289,8 +289,12 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
> > > >  	struct dm_region *reg, *nreg;
> > > >  
> > > >  	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
> > > > -	if (unlikely(!nreg))
> > > > -		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
> > > > +	if (unlikely(!nreg)) {
> > > > +		/* FIXME: this may potentially loop forever */
> > > > +		do {
> > > > +			nreg = kmalloc(sizeof(*nreg), GFP_NOIO);
> > > > +		} while (!nreg);
> > > > +	}
> > > >  
> > > >  	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
> > > >  		      DM_RH_CLEAN : DM_RH_NOSYNC;
> > > 
> > > erm.
> > > 
> > > The reason for adding GFP_NOFAIL in the first place was my observation
> > > that the kernel contained lots of open-coded retry-for-ever loops.
> > > 
> > > All of these are wrong, bad, buggy and mustfix.  So we consolidated the
> > > wrongbadbuggymustfix concept into the core MM so that miscreants could
> > > be easily identified and hopefully fixed.
> > > 
> > 
> > That consolidation would have been unnecessary, then, since all 
> > allocations with order < PAGE_ALLOC_COSTLY_ORDER automatically loop 
> > indefinitely in the page allocator.
> 
> The difference is that an order-0 !__GFP_NOFAIL allocation attempt can
> fail due to oom-killing.  Unless someone broke that.
> 

This is GFP_NOIO, which all the allocations in this patchset are (or 
GFP_NOFS), so the oom killer isn't involved.
