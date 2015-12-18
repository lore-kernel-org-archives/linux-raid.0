From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Thu, 17 Dec 2015 17:58:48 -0800
Message-ID: <20151218015847.GA2146501@devbig084.prn1.facebook.com>
References: <1450390197-19479-1-git-send-email-hch@lst.de>
 <1450390197-19479-4-git-send-email-hch@lst.de>
 <20151217234748.GA1860175@devbig084.prn1.facebook.com>
 <874mfg8qyc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874mfg8qyc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 18, 2015 at 12:51:07PM +1100, NeilBrown wrote:
> On Fri, Dec 18 2015, Shaohua Li wrote:
> 
> > On Thu, Dec 17, 2015 at 11:09:57PM +0100, Christoph Hellwig wrote:
> >> And propagate the error up the stack so we can add the stripe
> >> to no_stripes_list and retry our log operation later.  This avoids
> >> blocking raid5d due to reclaim, an it allows to get rid of the
> >> deadlock-prone GFP_NOFAIL allocation.
> >> 
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> ---
> >>  drivers/md/raid5-cache.c | 49 +++++++++++++++++++++++++++++++++---------------
> >>  1 file changed, 34 insertions(+), 15 deletions(-)
> >> 
> >> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> >> index e0a605f..ddee884 100644
> >> --- a/drivers/md/raid5-cache.c
> >> +++ b/drivers/md/raid5-cache.c
> >> @@ -287,8 +287,10 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
> >>  	struct r5l_io_unit *io;
> >>  	struct r5l_meta_block *block;
> >>  
> >> -	/* We can't handle memory allocate failure so far */
> >> -	io = kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NOFAIL);
> >> +	io = kmem_cache_zalloc(log->io_kc, GFP_ATOMIC);
> >> +	if (!io)
> >> +		return NULL;
> >> +
> >>  	io->log = log;
> >>  	INIT_LIST_HEAD(&io->log_sibling);
> >>  	INIT_LIST_HEAD(&io->stripe_list);
> >> @@ -326,8 +328,12 @@ static int r5l_get_meta(struct r5l_log *log, unsigned int payload_size)
> >>  	    log->current_io->meta_offset + payload_size > PAGE_SIZE)
> >>  		r5l_submit_current_io(log);
> >>  
> >> -	if (!log->current_io)
> >> +	if (!log->current_io) {
> >>  		log->current_io = r5l_new_meta(log);
> >> +		if (!log->current_io)
> >> +			return -ENOMEM;
> >> +	}
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> @@ -372,11 +378,12 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
> >>  	r5_reserve_log_entry(log, io);
> >>  }
> >>  
> >> -static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
> >> +static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
> >>  			   int data_pages, int parity_pages)
> >>  {
> >>  	int i;
> >>  	int meta_size;
> >> +	int ret;
> >>  	struct r5l_io_unit *io;
> >>  
> >>  	meta_size =
> >> @@ -385,7 +392,10 @@ static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
> >>  		sizeof(struct r5l_payload_data_parity) +
> >>  		sizeof(__le32) * parity_pages;
> >>  
> >> -	r5l_get_meta(log, meta_size);
> >> +	ret = r5l_get_meta(log, meta_size);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >>  	io = log->current_io;
> >>  
> >>  	for (i = 0; i < sh->disks; i++) {
> >> @@ -415,6 +425,8 @@ static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
> >>  	list_add_tail(&sh->log_list, &io->stripe_list);
> >>  	atomic_inc(&io->pending_stripe);
> >>  	sh->log_io = io;
> >> +
> >> +	return 0;
> >>  }
> >>  
> >>  static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
> >> @@ -429,6 +441,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
> >>  	int meta_size;
> >>  	int reserve;
> >>  	int i;
> >> +	int ret = 0;
> >>  
> >>  	if (!log)
> >>  		return -EAGAIN;
> >> @@ -477,18 +490,24 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
> >>  	mutex_lock(&log->io_mutex);
> >>  	/* meta + data */
> >>  	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
> >> -	if (r5l_has_free_space(log, reserve))
> >> -		r5l_log_stripe(log, sh, data_pages, parity_pages);
> >> -	else {
> >> -		spin_lock(&log->no_space_stripes_lock);
> >> -		list_add_tail(&sh->log_list, &log->no_space_stripes);
> >> -		spin_unlock(&log->no_space_stripes_lock);
> >> -
> >> -		r5l_wake_reclaim(log, reserve);
> >> -	}
> >> -	mutex_unlock(&log->io_mutex);
> >> +	if (!r5l_has_free_space(log, reserve))
> >> +		goto err_retry;
> >>  
> >> +	ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
> >> +	if (ret)
> >> +		goto err_retry;
> >> +
> >> +out_unlock:
> >> +	mutex_unlock(&log->io_mutex);
> >>  	return 0;
> >> +
> >> +err_retry:
> >> +	spin_lock(&log->no_space_stripes_lock);
> >> +	list_add_tail(&sh->log_list, &log->no_space_stripes);
> >> +	spin_unlock(&log->no_space_stripes_lock);
> >> +
> >> +	r5l_wake_reclaim(log, reserve);
> >> +	goto out_unlock;
> >>  }
> >
> > if the reclaim thread doesn't have anything to reclaim,
> > r5l_run_no_space_stripes isn't called. we might miss the retry.
> 
> so something like this:
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 18de1fc4a75b..b63878edf7e9 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -596,7 +596,8 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
>  		return;
>  	}
>  
> -	if (r5l_reclaimable_space(log) > log->max_free_space)
> +	if (r5l_reclaimable_space(log) > log->max_free_space ||
> +	    !list_empty(&log->no_space_stripes))
>  		r5l_wake_reclaim(log, 0);
>  
>  	spin_unlock_irqrestore(&log->io_list_lock, flags);
> 
> or is that too simplistic?

maybe add a new list and run the list at the begining of r5l_do_reclaim().

> >
> > I'm a little worrying about the GFP_ATOMIC allocation. In the first try,
> > GFP_NOWAIT is better. And on the other hand, why sleep is bad here? We
> > could use GFP_NOIO | __GFP_NORETRY, there is no deadlock risk.
> >
> > In the retry, GFP_NOIO looks better. No deadlock too, since it's not
> > called from raid5d (maybe we shouldn't call from reclaim thread if using
> > GFP_NOIO, a workqueue is better). Otherwise we could keep retring but do
> > nothing.
> 
> I did wonder a little bit about that.
> GFP_ATOMIC is (__GFP_HIGH)
> GFP_NOIO | __GFP_NORETRY is  (__GFP_WAIT | __GFP_NORETRY)
> 
> It isn't clear that we need 'HIGH', and WAIT with NORETRY should be OK.
> It allows __alloc_pages_direct_reclaim, but only once and never waits
> for other IO.
> 
> We probably should add __GFP_NOWARN too because we expect occasional
> failure.
> 
> So
> 
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -287,7 +287,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
>  	struct r5l_io_unit *io;
>  	struct r5l_meta_block *block;
>  
> -	io = kmem_cache_zalloc(log->io_kc, GFP_ATOMIC);
> +	io = kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
>  	if (!io)
>  		return NULL;

Looks good.

Thanks,
Shaohua
