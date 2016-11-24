From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3] md/r5cache: handle alloc_page failure
Date: Wed, 23 Nov 2016 16:51:25 -0800
Message-ID: <20161124005125.rfb3tgzoe53w5w5x@kernel.org>
References: <20161123212018.1099843-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161123212018.1099843-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Wed, Nov 23, 2016 at 01:20:18PM -0800, Song Liu wrote:
> RMW of r5c write back cache uses an extra page to store old data for
> prexor. handle_stripe_dirtying() allocates this page by calling
> alloc_page(). However, alloc_page() may fail.
> 
> To handle alloc_page() failures, this patch adds an extra page to
> disk_info. When alloc_page fails, handle_stripe() trys to use these
> pages. When these pages are used by other stripe (R5C_EXTRA_PAGE_IN_USE),
> the stripe is added to delayed_list.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 28 ++++++++++++++++++++++
>  drivers/md/raid5.c       | 61 +++++++++++++++++++++++++++++++++++++++++-------
>  drivers/md/raid5.h       |  6 +++++
>  3 files changed, 86 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 8cb79fc..3817d2b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2334,15 +2334,43 @@ int r5c_try_caching_write(struct r5conf *conf,
>   */
>  void r5c_release_extra_page(struct stripe_head *sh)
>  {
> +	struct r5conf *conf = sh->raid_conf;
>  	int i;
> +	bool using_disk_info_extra_page;
> +
> +	using_disk_info_extra_page =
> +		sh->dev[0].orig_page == conf->disks[0].extra_page;
>  
>  	for (i = sh->disks; i--; )
>  		if (sh->dev[i].page != sh->dev[i].orig_page) {
>  			struct page *p = sh->dev[i].orig_page;
>  
>  			sh->dev[i].orig_page = sh->dev[i].page;
> +			if (!using_disk_info_extra_page)
> +				put_page(p);
> +		}
> +
> +	if (using_disk_info_extra_page)
> +		clear_bit(R5C_EXTRA_PAGE_IN_USE, &conf->cache_state);
Here we need to wakeup delay stripes (eg, wakeup raid5d)

> +}
> +
> +void r5c_use_extra_page(struct stripe_head *sh)
> +{
> +	struct r5conf *conf = sh->raid_conf;
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
> +		dev->orig_page = conf->disks[i].extra_page;
> +		BUG_ON(!dev->orig_page);
> +	}
>  }
>  
>  /*
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dbab8c7..7656530 100644
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
> +				 * disk_info->extra_page
> +				 */
> +				if (!test_and_set_bit(R5C_EXTRA_PAGE_IN_USE,
> +						      &conf->cache_state)) {
> +					r5c_use_extra_page(sh);
> +					break;
> +				}
> +
> +				/* extra_page in use, add to delayed_list */
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
> @@ -6458,6 +6486,8 @@ static void raid5_free_percpu(struct r5conf *conf)
>  
>  static void free_conf(struct r5conf *conf)
>  {
> +	int i;
> +
>  	if (conf->log)
>  		r5l_exit_log(conf->log);
>  	if (conf->shrinker.nr_deferred)
> @@ -6466,6 +6496,12 @@ static void free_conf(struct r5conf *conf)
>  	free_thread_groups(conf);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
> +	for (i = 0; i < conf->raid_disks; i++)
> +		if (conf->disks[i].extra_page) {
> +			put_page(conf->disks[i].extra_page);
> +			conf->disks[i].extra_page = NULL;
> +		}
> +
>  	kfree(conf->disks);
>  	kfree(conf->stripe_hashtbl);
>  	kfree(conf);
> @@ -6612,9 +6648,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>  
>  	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
>  			      GFP_KERNEL);
> +
>  	if (!conf->disks)
>  		goto abort;
>  
> +	for (i = 0; i < conf->raid_disks; i++) {
> +		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
> +		if (!conf->disks[i].extra_page)
> +			goto abort;
> +	}

resize can change raid_disks, so the extra_page should be reallocated at
resize.

Thanks,
Shaohua
