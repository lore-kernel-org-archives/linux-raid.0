From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md/r5cache: handle alloc_page failure
Date: Tue, 22 Nov 2016 14:56:07 -0800
Message-ID: <20161122225607.xfslh46asbgn352h@kernel.org>
References: <20161122013127.409257-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161122013127.409257-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Mon, Nov 21, 2016 at 05:31:27PM -0800, Song Liu wrote:
> RMW of r5c write back cache uses an extra page to store old data for
> prexor. handle_stripe_dirtying() allocates this page by calling
> alloc_page(). However, alloc_page() may fail.
> 
> To handle alloc_page() failures, this patch adds a small mempool
> in r5l_log. When alloc_page fails, handle_stripe() trys to use pages
> from the mempool. When the mempool is in use, the stripe is added
> to delayed_list.

Still not as simple as I expected. Since you are using GFP_ATOMIC for memory
allocation from mempool, mempool doesn't buy us anything.
- Just allocat raid_disks pages at start.
- If alloc_page fails, let the stripe owns the preallocated pages even the
  stripe only needs to allocate one page. Other stripes will have delayed bit
set and wait. We only need to guarantee at least one stripe can run. Don't
worry about preallocated pages aren't fully utilized, the memory allocation
should be rare case.

Thanks,
Shaohua

> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c       | 47 ++++++++++++++++++++++++++++++++++++++---------
>  drivers/md/raid5.h       |  8 ++++++++
>  3 files changed, 89 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 8cb79fc..9406c39 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -162,6 +162,9 @@ struct r5l_log {
>  
>  	/* to submit async io_units, to fulfill ordering of flush */
>  	struct work_struct deferred_io_work;
> +
> +	/* to handle alloc_page() failures in handle_stripe_dirtying() */
> +	mempool_t *extra_page_pool;
>  };
>  
>  /*
> @@ -2334,15 +2337,48 @@ int r5c_try_caching_write(struct r5conf *conf,
>   */
>  void r5c_release_extra_page(struct stripe_head *sh)
>  {
> +	struct r5conf *conf = sh->raid_conf;
> +	struct r5l_log *log = conf->log;
>  	int i;
> +	bool using_extra_page_pool;
> +
> +	using_extra_page_pool = test_and_clear_bit(
> +		STRIPE_R5C_EXTRA_PAGE, &sh->state);
>  
>  	for (i = sh->disks; i--; )
>  		if (sh->dev[i].page != sh->dev[i].orig_page) {
>  			struct page *p = sh->dev[i].orig_page;
>  
>  			sh->dev[i].orig_page = sh->dev[i].page;
> +			if (using_extra_page_pool)
> +				mempool_free(p, log->extra_page_pool);
> +			else
> +				put_page(p);
> +		}
> +
> +	if (using_extra_page_pool)
> +		clear_bit(R5C_EXTRA_PAGE_IN_USE, &conf->cache_state);
> +}
> +
> +void r5c_use_extra_page_pool(struct stripe_head *sh)
> +{
> +	struct r5l_log *log = sh->raid_conf->log;
> +	int i;
> +	struct r5dev *dev;
> +	struct page *p;
> +
> +	for (i = sh->disks; i--; ) {
> +		dev = &sh->dev[i];
> +		if (dev->orig_page != dev->page) {
> +			p = dev->orig_page;
> +			dev->orig_page = dev->page;
>  			put_page(p);
>  		}
> +		dev->orig_page = mempool_alloc(log->extra_page_pool,
> +					       GFP_ATOMIC);
> +		BUG_ON(!dev->orig_page);
> +	}
> +	set_bit(STRIPE_R5C_EXTRA_PAGE, &sh->state);
>  }
>  
>  /*
> @@ -2581,6 +2617,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  	if (!log->meta_pool)
>  		goto out_mempool;
>  
> +	log->extra_page_pool = mempool_create_page_pool(conf->raid_disks, 0);
> +	if (!log->extra_page_pool)
> +		goto extra_page_pool;
> +
>  	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
>  						 log->rdev->mddev, "reclaim");
>  	if (!log->reclaim_thread)
> @@ -2611,6 +2651,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  error:
>  	md_unregister_thread(&log->reclaim_thread);
>  reclaim_thread:
> +	mempool_destroy(log->extra_page_pool);
> +extra_page_pool:
>  	mempool_destroy(log->meta_pool);
>  out_mempool:
>  	bioset_free(log->bs);
> @@ -2626,6 +2668,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  void r5l_exit_log(struct r5l_log *log)
>  {
>  	md_unregister_thread(&log->reclaim_thread);
> +	mempool_destroy(log->extra_page_pool);
>  	mempool_destroy(log->meta_pool);
>  	bioset_free(log->bs);
>  	mempool_destroy(log->io_pool);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dbab8c7..9d20849 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -876,6 +876,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  
>  	if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
>  		/* writing out phase */
> +		if (s->waiting_extra_page)
> +			return;
>  		if (r5l_write_stripe(conf->log, sh) == 0)
>  			return;
>  	} else {  /* caching phase */
> @@ -2007,6 +2009,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
>  		INIT_LIST_HEAD(&sh->batch_list);
>  		INIT_LIST_HEAD(&sh->lru);
>  		INIT_LIST_HEAD(&sh->r5c);
> +		INIT_LIST_HEAD(&sh->log_list);
>  		atomic_set(&sh->count, 1);
>  		sh->log_start = MaxSector;
>  		for (i = 0; i < disks; i++) {
> @@ -3580,10 +3583,10 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>  		break_stripe_batch_list(head_sh, STRIPE_EXPAND_SYNC_FLAGS);
>  }
>  
> -static void handle_stripe_dirtying(struct r5conf *conf,
> -				   struct stripe_head *sh,
> -				   struct stripe_head_state *s,
> -				   int disks)
> +static int handle_stripe_dirtying(struct r5conf *conf,
> +				  struct stripe_head *sh,
> +				  struct stripe_head_state *s,
> +				  int disks)
>  {
>  	int rmw = 0, rcw = 0, i;
>  	sector_t recovery_cp = conf->mddev->recovery_cp;
> @@ -3649,12 +3652,32 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>  			    dev->page == dev->orig_page &&
>  			    !test_bit(R5_LOCKED, &sh->dev[sh->pd_idx].flags)) {
>  				/* alloc page for prexor */
> -				dev->orig_page = alloc_page(GFP_NOIO);
> +				struct page *p = alloc_page(GFP_NOIO);
> +
> +				if (p) {
> +					dev->orig_page = p;
> +					continue;
> +				}
>  
> -				/* will handle failure in a later patch*/
> -				BUG_ON(!dev->orig_page);
> +				/*
> +				 * alloc_page() failed, try use
> +				 * log->extra_page_pool
> +				 */
> +				if (!test_and_set_bit(R5C_EXTRA_PAGE_IN_USE,
> +						      &conf->cache_state)) {
> +					r5c_use_extra_page_pool(sh);
> +					break;
> +				}
> +
> +				/* extra_page_pool busy, add to delayed_list */
> +				set_bit(STRIPE_DELAYED, &sh->state);
> +				s->waiting_extra_page = 1;
> +				return -EAGAIN;
>  			}
> +		}
>  
> +		for (i = disks; i--; ) {
> +			struct r5dev *dev = &sh->dev[i];
>  			if ((dev->towrite ||
>  			     i == sh->pd_idx || i == sh->qd_idx ||
>  			     test_bit(R5_InJournal, &dev->flags)) &&
> @@ -3730,6 +3753,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>  	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
>  	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
>  		schedule_reconstruction(sh, s, rcw == 0, 0);
> +	return 0;
>  }
>  
>  static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
> @@ -4545,8 +4569,12 @@ static void handle_stripe(struct stripe_head *sh)
>  			if (ret == -EAGAIN ||
>  			    /* stripe under reclaim: !caching && injournal */
>  			    (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
> -			     s.injournal > 0))
> -				handle_stripe_dirtying(conf, sh, &s, disks);
> +			     s.injournal > 0)) {
> +				ret = handle_stripe_dirtying(conf, sh, &s,
> +							     disks);
> +				if (ret == -EAGAIN)
> +					goto finish;
> +			}
>  		}
>  	}
>  
> @@ -6612,6 +6640,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>  
>  	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
>  			      GFP_KERNEL);
> +
>  	if (!conf->disks)
>  		goto abort;
>  
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index d13fe45..fad19eb 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -276,6 +276,7 @@ struct stripe_head_state {
>  	struct md_rdev *blocked_rdev;
>  	int handle_bad_blocks;
>  	int log_failed;
> +	int waiting_extra_page;
>  };
>  
>  /* Flags for struct r5dev.flags */
> @@ -377,6 +378,9 @@ enum {
>  				 * in conf->r5c_full_stripe_list)
>  				 */
>  	STRIPE_R5C_PREFLUSH,	/* need to flush journal device */
> +	STRIPE_R5C_EXTRA_PAGE,	/* extra orig_page of this stripe is allocated
> +				 * from extra_page_pool
> +				 */
>  };
>  
>  #define STRIPE_EXPAND_SYNC_FLAGS \
> @@ -559,6 +563,9 @@ enum r5_cache_state {
>  				 * only process stripes that are already
>  				 * occupying the log
>  				 */
> +	R5C_EXTRA_PAGE_IN_USE,	/* a stripe is using the pages in
> +				 * r5l_log.extra_page_pool for prexor
> +				 */
>  };
>  
>  struct r5conf {
> @@ -765,6 +772,7 @@ extern void
>  r5c_finish_stripe_write_out(struct r5conf *conf, struct stripe_head *sh,
>  			    struct stripe_head_state *s);
>  extern void r5c_release_extra_page(struct stripe_head *sh);
> +extern void r5c_use_extra_page_pool(struct stripe_head *sh);
>  extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
>  extern void r5c_handle_cached_data_endio(struct r5conf *conf,
>  	struct stripe_head *sh, int disks, struct bio_list *return_bi);
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
