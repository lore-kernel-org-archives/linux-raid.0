From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v6 09/11] md/r5cache: r5cache recovery: part 2
Date: Tue, 15 Nov 2016 16:37:40 -0800
Message-ID: <20161116003740.pupcjwr2jvh7tr2o@kernel.org>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-10-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161110204623.3484694-10-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Thu, Nov 10, 2016 at 12:46:21PM -0800, Song Liu wrote:
> 1. In previous patch, we:
>       - add new data to r5l_recovery_ctx
>       - add new functions to recovery write-back cache
>    The new functions are not used in this patch, so this patch does not
>    change the behavior of recovery.
> 
> 2. In this patchpatch, we:
>       - modify main recovery procedure r5l_recovery_log() to call new
>         functions
>       - remove old functions
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
> -/* copy data/parity from log to raid disks */
> -static void r5l_recovery_flush_log(struct r5l_log *log,
> -				   struct r5l_recovery_ctx *ctx)
> -{
> -	while (1) {
> -		if (r5l_recovery_read_meta_block(log, ctx))
> -			return;
> -		if (r5l_recovery_flush_one_meta(log, ctx))
> -			return;
> -		ctx->seq++;
> -		ctx->pos = r5l_ring_add(log, ctx->pos, ctx->meta_total_blocks);
> -	}
> -}
> -
>  static void
>  r5l_recovery_create_empty_meta_block(struct r5l_log *log,
>  				     struct page *page,
> @@ -2139,7 +2001,9 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  
>  static int r5l_recovery_log(struct r5l_log *log)
>  {
> +	struct mddev *mddev = log->rdev->mddev;
>  	struct r5l_recovery_ctx ctx;
> +	int ret;
>  
>  	ctx.pos = log->last_checkpoint;
>  	ctx.seq = log->last_cp_seq;
> @@ -2151,47 +2015,33 @@ static int r5l_recovery_log(struct r5l_log *log)
>  	if (!ctx.meta_page)
>  		return -ENOMEM;
>  
> -	r5l_recovery_flush_log(log, &ctx);
> +	ret = r5c_recovery_flush_log(log, &ctx);
>  	__free_page(ctx.meta_page);
>  
> -	/*
> -	 * we did a recovery. Now ctx.pos points to an invalid meta block. New
> -	 * log will start here. but we can't let superblock point to last valid
> -	 * meta block. The log might looks like:
> -	 * | meta 1| meta 2| meta 3|
> -	 * meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If
> -	 * superblock points to meta 1, we write a new valid meta 2n.  if crash
> -	 * happens again, new recovery will start from meta 1. Since meta 2n is
> -	 * valid now, recovery will think meta 3 is valid, which is wrong.
> -	 * The solution is we create a new meta in meta2 with its seq == meta
> -	 * 1's seq + 10 and let superblock points to meta2. The same recovery will
> -	 * not think meta 3 is a valid meta, because its seq doesn't match
> -	 */
> -	if (ctx.seq > log->last_cp_seq) {
> -		int ret;
> -
> -		ret = r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq + 10);
> -		if (ret)
> -			return ret;
> -		log->seq = ctx.seq + 11;
> -		log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
> -		r5l_write_super(log, ctx.pos);
> -		log->last_checkpoint = ctx.pos;
> -		log->next_checkpoint = ctx.pos;
> -	} else {
> -		log->log_start = ctx.pos;
> -		log->seq = ctx.seq;
> -	}
> +	if (ret)
> +		return ret;
>  
> -	/*
> -	 * This is to suppress "function defined but not used" warning.
> -	 * It will be removed when the two functions are used (next patch).
> -	 */

BTW, this isn't necessary. it's ok an intermediate patch causes compile
warning, as long as it doesn't break biset.
