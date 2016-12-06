From: JackieLiu <liuyun01@kylinos.cn>
Subject: Re: [PATCH 1/2] md/r5cache: sh->log_start in recovery
Date: Tue, 6 Dec 2016 12:10:11 +0800
Message-ID: <70BD511C-E223-43B3-B13F-5CB6A3A4244C@kylinos.cn>
References: <20161206014657.3592902-1-songliubraving@fb.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3257\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161206014657.3592902-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, =?gb2312?B?wfXV/dSq?= <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> 在 2016年12月6日，09:46，Song Liu <songliubraving@fb.com> 写道：
> 
> We only need to update sh->log_start at the end of recovery,
> which is r5c_recovery_rewrite_data_only_stripes().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
> drivers/md/raid5-cache.c | 17 +++++++----------
> 1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index c3b3124..93f3310 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1681,8 +1681,7 @@ r5l_recovery_replay_one_stripe(struct r5conf *conf,
> 
> static struct stripe_head *
> r5c_recovery_alloc_stripe(struct r5conf *conf,
> -			  sector_t stripe_sect,
> -			  sector_t log_start)
> +			  sector_t stripe_sect)
> {
> 	struct stripe_head *sh;
> 
> @@ -1691,7 +1690,6 @@ r5c_recovery_alloc_stripe(struct r5conf *conf,
> 		return NULL;  /* no more stripe available */
> 
> 	r5l_recovery_reset_stripe(sh);
> -	sh->log_start = log_start;

Hi Song, 
the sh->log_start is not only used in r5c_recovery_rewrite_data_only_stripes function, in my new patch, 
https://git.kernel.org/cgit/linux/kernel/git/shli/md.git/tree/drivers/md/raid5-cache.c?h=for-next&id=43b9674832cc41ad0ad7b7e2ec397e47dcd5f6c3#n2167
Also be used. 

Thanks 
Jackie

> 
> 	return sh;
> }
> @@ -1861,7 +1859,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
> 						stripe_sect);
> 
> 		if (!sh) {
> -			sh = r5c_recovery_alloc_stripe(conf, stripe_sect, ctx->pos);
> +			sh = r5c_recovery_alloc_stripe(conf, stripe_sect);
> 			/*
> 			 * cannot get stripe from raid5_get_active_stripe
> 			 * try replay some stripes
> @@ -1870,7 +1868,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
> 				r5c_recovery_replay_stripes(
> 					cached_stripe_list, ctx);
> 				sh = r5c_recovery_alloc_stripe(
> -					conf, stripe_sect, ctx->pos);
> +					conf, stripe_sect);
> 			}
> 			if (!sh) {
> 				pr_debug("md/raid:%s: Increasing stripe cache size to %d to recovery data on journal.\n",
> @@ -1878,8 +1876,8 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
> 					conf->min_nr_stripes * 2);
> 				raid5_set_cache_size(mddev,
> 						     conf->min_nr_stripes * 2);
> -				sh = r5c_recovery_alloc_stripe(
> -					conf, stripe_sect, ctx->pos);
> +				sh = r5c_recovery_alloc_stripe(conf,
> +							       stripe_sect);
> 			}
> 			if (!sh) {
> 				pr_err("md/raid:%s: Cannot get enough stripes due to memory pressure. Recovery failed.\n",
> @@ -1893,7 +1891,6 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
> 			if (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
> 			    test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags)) {
> 				r5l_recovery_replay_one_stripe(conf, sh, ctx);
> -				sh->log_start = ctx->pos;
> 				list_move_tail(&sh->lru, cached_stripe_list);
> 			}
> 			r5l_recovery_load_data(log, sh, ctx, payload,
> @@ -1932,8 +1929,6 @@ static void r5c_recovery_load_one_stripe(struct r5l_log *log,
> 			set_bit(R5_UPTODATE, &dev->flags);
> 		}
> 	}
> -	list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
> -	atomic_inc(&log->stripe_in_journal_count);
> }
> 
> /*
> @@ -2121,6 +2116,8 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
> 		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
> 			     REQ_OP_WRITE, WRITE_FUA, false);
> 		sh->log_start = ctx->pos;
> +		list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
> +		atomic_inc(&log->stripe_in_journal_count);
> 		ctx->pos = write_pos;
> 		ctx->seq += 1;
> 
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



