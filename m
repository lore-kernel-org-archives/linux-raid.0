From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 3/3] md/r5cache: sh->log_start in recovery
Date: Thu, 8 Dec 2016 10:41:21 -0800
Message-ID: <20161208184121.ucv2pcn5spmnggev@kernel.org>
References: <20161207174207.3685260-1-songliubraving@fb.com>
 <20161207174207.3685260-3-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161207174207.3685260-3-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn
List-Id: linux-raid.ids

On Wed, Dec 07, 2016 at 09:42:07AM -0800, Song Liu wrote:
> We only need to update sh->log_start at the end of recovery,
> which is r5c_recovery_rewrite_data_only_stripes().
> 
> In when there is data-only stripes, log->next_checkpoint is
> also set in r5c_recovery_rewrite_data_only_stripes().

I didn't get this. please describe why this patch is required instead of what
this patch does.


> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 5301081..ae2684a 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1681,8 +1681,7 @@ r5l_recovery_replay_one_stripe(struct r5conf *conf,
>  
>  static struct stripe_head *
>  r5c_recovery_alloc_stripe(struct r5conf *conf,
> -			  sector_t stripe_sect,
> -			  sector_t log_start)
> +			  sector_t stripe_sect)
>  {
>  	struct stripe_head *sh;
>  
> @@ -1691,7 +1690,6 @@ r5c_recovery_alloc_stripe(struct r5conf *conf,
>  		return NULL;  /* no more stripe available */
>  
>  	r5l_recovery_reset_stripe(sh);
> -	sh->log_start = log_start;
>  
>  	return sh;
>  }
> @@ -1861,7 +1859,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  						stripe_sect);
>  
>  		if (!sh) {
> -			sh = r5c_recovery_alloc_stripe(conf, stripe_sect, ctx->pos);
> +			sh = r5c_recovery_alloc_stripe(conf, stripe_sect);
>  			/*
>  			 * cannot get stripe from raid5_get_active_stripe
>  			 * try replay some stripes
> @@ -1870,7 +1868,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  				r5c_recovery_replay_stripes(
>  					cached_stripe_list, ctx);
>  				sh = r5c_recovery_alloc_stripe(
> -					conf, stripe_sect, ctx->pos);
> +					conf, stripe_sect);
>  			}
>  			if (!sh) {
>  				pr_debug("md/raid:%s: Increasing stripe cache size to %d to recovery data on journal.\n",
> @@ -1878,8 +1876,8 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  					conf->min_nr_stripes * 2);
>  				raid5_set_cache_size(mddev,
>  						     conf->min_nr_stripes * 2);
> -				sh = r5c_recovery_alloc_stripe(
> -					conf, stripe_sect, ctx->pos);
> +				sh = r5c_recovery_alloc_stripe(conf,
> +							       stripe_sect);
>  			}
>  			if (!sh) {
>  				pr_err("md/raid:%s: Cannot get enough stripes due to memory pressure. Recovery failed.\n",
> @@ -1893,7 +1891,6 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  			if (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
>  			    test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags)) {
>  				r5l_recovery_replay_one_stripe(conf, sh, ctx);
> -				sh->log_start = ctx->pos;
>  				list_move_tail(&sh->lru, cached_stripe_list);
>  			}
>  			r5l_recovery_load_data(log, sh, ctx, payload,
> @@ -1932,8 +1929,6 @@ static void r5c_recovery_load_one_stripe(struct r5l_log *log,
>  			set_bit(R5_UPTODATE, &dev->flags);
>  		}
>  	}
> -	list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
> -	atomic_inc(&log->stripe_in_journal_count);
>  }
>  
>  /*
> @@ -2123,9 +2118,11 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
>  			     REQ_OP_WRITE, WRITE_FUA, false);
>  		sh->log_start = ctx->pos;
> +		list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
> +		atomic_inc(&log->stripe_in_journal_count);
>  		ctx->pos = write_pos;
>  		ctx->seq += 1;
> -
> +		log->next_checkpoint = sh->log_start;
>  		list_del_init(&sh->lru);
>  		raid5_release_stripe(sh);
>  	}
> @@ -2139,7 +2136,6 @@ static int r5l_recovery_log(struct r5l_log *log)
>  	struct r5l_recovery_ctx ctx;
>  	int ret;
>  	sector_t pos;
> -	struct stripe_head *sh;
>  
>  	ctx.pos = log->last_checkpoint;
>  	ctx.seq = log->last_cp_seq;
> @@ -2164,9 +2160,6 @@ static int r5l_recovery_log(struct r5l_log *log)
>  		log->next_checkpoint = ctx.pos;
>  		r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
>  		ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
> -	} else {
> -		sh = list_last_entry(&ctx.cached_list, struct stripe_head, lru);
> -		log->next_checkpoint = sh->log_start;
>  	}
>  
>  	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
