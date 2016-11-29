From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 4/4] md/raid5-cache: adjust the write position of the
 empty block and mark it as a checkpoint
Date: Tue, 29 Nov 2016 14:31:50 -0800
Message-ID: <20161129223150.tseez7b4y6lb72fs@kernel.org>
References: <20161128081921.5641-1-liuyun01@kylinos.cn>
 <20161128081921.5641-4-liuyun01@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161128081921.5641-4-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: JackieLiu <liuyun01@kylinos.cn>
Cc: songliubraving@fb.com, liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 28, 2016 at 04:19:21PM +0800, JackieLiu wrote:
> When recovery is complete, we write an empty block and record his
> position first, then make the data-only stripes rewritten done,
> the location of the empty block as the last checkpoint position
> to write into the super block. And we should update last_checkpoint
> to this empty block position.
> 
> ------------------------------------------------------------------
> |  old log       | empty block | data only stripes | invalid log |
> ------------------------------------------------------------------
> ^                ^                                 ^
> |                |- log->last_checkpoint           |- log->log_start
> |                |- log->last_cp_seq               |- log->next_checkpoint
> |- log->seq=n    |- log->seq=10+n
> 
> At the same time, if there is no data-only stripes, this scene may appear,
> | meta1 | meta2 | meta3 |
> meta 1 is valid, meta 2 is invalid. meta 3 could be valid. so we should 
> The solution is we create a new meta in meta2 with its seq == meta1's 
> seq + 10 and let superblock points to meta2. 
> 
> Reviewed-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
> Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
> ---
>  drivers/md/raid5-cache.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 9e72180..20594f7 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2072,7 +2072,6 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  		return -ENOMEM;
>  	}
>  
> -	ctx->seq += 10;
>  	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
>  		struct r5l_meta_block *mb;
>  		int i;
> @@ -2132,6 +2131,7 @@ static int r5l_recovery_log(struct r5l_log *log)
>  	struct mddev *mddev = log->rdev->mddev;
>  	struct r5l_recovery_ctx ctx;
>  	int ret;
> +	sector_t pos;
>  
>  	ctx.pos = log->last_checkpoint;
>  	ctx.seq = log->last_cp_seq;
> @@ -2149,6 +2149,10 @@ static int r5l_recovery_log(struct r5l_log *log)
>  	if (ret)
>  		return ret;
>  
> +	pos = ctx.pos;
> +	r5l_log_write_empty_meta_block(log, ctx.pos, (ctx.seq += 10));

hmm, move the ctx.seq += 10 out please
> +	ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
> +
>  	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
>  		pr_debug("md/raid:%s: starting from clean shutdown\n",
>  			 mdname(mddev));
> @@ -2167,9 +2171,9 @@ static int r5l_recovery_log(struct r5l_log *log)
>  
>  	log->log_start = ctx.pos;
>  	log->next_checkpoint = ctx.pos;
> +	log->last_checkpoint = pos;
>  	log->seq = ctx.seq;
> -	r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq);
> -	r5l_write_super(log, ctx.pos);
> +	r5l_write_super(log, pos);
>  	return 0;
>  }

Applied the first 3 patches in the series. This one looks good too, but why we
always create the empty meta block? It's only required when we don't rewrite
the data. Eg, the data_only_stripes == 0.

Thanks,
Shaohua
