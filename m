From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/4] md/r5cache: flush data only stripes in
 r5l_recovery_log()
Date: Sat, 21 Jan 2017 10:03:27 -0800
Message-ID: <20170121180327.qwdbe4ovortwdszv@kernel.org>
References: <20170113012243.3246467-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170113012243.3246467-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Thu, Jan 12, 2017 at 05:22:40PM -0800, Song Liu wrote:
> When there is data only stripes in the journal, we flush them out in
> r5l_recovery_log(). Ths logic is implemented in a new function:
> r5c_recovery_flush_data_only_stripes():
> 
> 1. enable write back cache
> 2. set flag R5C_PRE_INIT_FLUSH in conf->cache_state
> 3. flush all stripes
> 4. wake up conf->mddev->thread
> 5. wait for all stripes get flushed (reuse wait_for_quiescent)
> 6. clear R5C_PRE_INIT_FLUSH
> 7. disable write back cache

Please explain why we need this and if this applies to writethrough too. Also
please explain why it's safe to wakeup mddev->thread in r5l_recovery_log() as
the mddev isn't fully initialized yet.
 
> do_release_stripe() will wake up the wait when conf->active_stripe
> reduces to 0.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 58 +++++++++++++++++++++++++++++++++++-------------
>  drivers/md/raid5.c       |  4 ++++
>  drivers/md/raid5.h       |  3 +++
>  3 files changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 0c88648..2bbc38b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2102,7 +2102,7 @@ static int
>  r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  				       struct r5l_recovery_ctx *ctx)
>  {
> -	struct stripe_head *sh, *next;
> +	struct stripe_head *sh;
>  	struct mddev *mddev = log->rdev->mddev;
>  	struct page *page;
>  	sector_t next_checkpoint = MaxSector;
> @@ -2116,7 +2116,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  
>  	WARN_ON(list_empty(&ctx->cached_list));
>  
> -	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
> +	list_for_each_entry(sh, &ctx->cached_list, lru) {
>  		struct r5l_meta_block *mb;
>  		int i;
>  		int offset;
> @@ -2166,14 +2166,41 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  		ctx->pos = write_pos;
>  		ctx->seq += 1;
>  		next_checkpoint = sh->log_start;
> -		list_del_init(&sh->lru);
> -		raid5_release_stripe(sh);
>  	}
>  	log->next_checkpoint = next_checkpoint;
>  	__free_page(page);
>  	return 0;
>  }
>  
> +static void r5c_recovery_flush_data_only_stripes(struct r5l_log *log,
> +						 struct r5l_recovery_ctx *ctx)
> +{
> +	struct mddev *mddev = log->rdev->mddev;
> +	struct r5conf *conf = mddev->private;
> +	struct stripe_head *sh, *next;
> +
> +	if (ctx->data_only_stripes == 0)
> +		return;
> +
> +	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_BACK;
> +	set_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state);
> +
> +	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
> +		r5c_make_stripe_write_out(sh);
> +		set_bit(STRIPE_HANDLE, &sh->state);
> +		list_del_init(&sh->lru);
> +		raid5_release_stripe(sh);
> +	}
> +
> +	md_wakeup_thread(conf->mddev->thread);
> +	/* reuse conf->wait_for_quiescent in recovery */
> +	wait_event(conf->wait_for_quiescent,
> +		   atomic_read(&conf->active_stripes) == 0);
> +
> +	clear_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state);
> +	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> +}
> +
>  static int r5l_recovery_log(struct r5l_log *log)
>  {
>  	struct mddev *mddev = log->rdev->mddev;
> @@ -2200,32 +2227,31 @@ static int r5l_recovery_log(struct r5l_log *log)
>  	pos = ctx.pos;
>  	ctx.seq += 10000;
>  
> -	if (ctx.data_only_stripes == 0) {
> -		log->next_checkpoint = ctx.pos;
> -		r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
> -		ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
> -	}
>  
>  	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
>  		pr_debug("md/raid:%s: starting from clean shutdown\n",
>  			 mdname(mddev));
> -	else {
> +	else
>  		pr_debug("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
>  			 mdname(mddev), ctx.data_only_stripes,
>  			 ctx.data_parity_stripes);
>  
> -		if (ctx.data_only_stripes > 0)
> -			if (r5c_recovery_rewrite_data_only_stripes(log, &ctx)) {
> -				pr_err("md/raid:%s: failed to rewrite stripes to journal\n",
> -				       mdname(mddev));
> -				return -EIO;
> -			}
> +	if (ctx.data_only_stripes == 0) {
> +		log->next_checkpoint = ctx.pos;
> +		r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
> +		ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
> +	} else if (r5c_recovery_rewrite_data_only_stripes(log, &ctx)) {
> +		pr_err("md/raid:%s: failed to rewrite stripes to journal\n",
> +		       mdname(mddev));
> +		return -EIO;
>  	}
>  
>  	log->log_start = ctx.pos;
>  	log->seq = ctx.seq;
>  	log->last_checkpoint = pos;
>  	r5l_write_super(log, pos);
> +
> +	r5c_recovery_flush_data_only_stripes(log, &ctx);
>  	return 0;
>  }
>  
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b8e45cc..0d2082d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -266,6 +266,10 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>  			    < IO_THRESHOLD)
>  				md_wakeup_thread(conf->mddev->thread);
>  		atomic_dec(&conf->active_stripes);
> +		if (test_bit(R5C_PRE_INIT_FLUSH, &conf->cache_state) &&
> +		    atomic_read(&conf->active_stripes) == 0)
> +			wake_up(&sh->raid_conf->wait_for_quiescent);

Don't understand why R5C_PRE_INIT_FLUSH must be introduced. Shouldn't we always
wakeup wait_for_quiescent after active_stripes == 0? If not, this is a bug in
existing code.


Thanks,
Shaohua
