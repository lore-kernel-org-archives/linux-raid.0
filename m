From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 4/4] md/raid5-cache: adjust the write position of the
 empty block and mark it as a checkpoint
Date: Mon, 5 Dec 2016 17:00:32 -0800
Message-ID: <20161206010032.wqdvrogugbbkmhg6@kernel.org>
References: <20161128081921.5641-1-liuyun01@kylinos.cn>
 <20161128081921.5641-4-liuyun01@kylinos.cn>
 <20161129223150.tseez7b4y6lb72fs@kernel.org>
 <256217AC-28C5-4C52-ABDB-9C36221E6A1B@kylinos.cn>
 <20161202201058.e5jrjxkgve3ob776@kernel.org>
 <D667B2F7-64DE-434D-B793-F4F514BB2714@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D667B2F7-64DE-434D-B793-F4F514BB2714@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: JackieLiu <liuyun01@kylinos.cn>
Cc: songliubraving@fb.com, =?utf-8?B?5YiY5q2j5YWD?= <liuzhengyuan@kylinos.cn>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 05, 2016 at 11:58:53AM +0800, JackieLiu wrote:
> 
> > 在 2016年12月3日，04:10，Shaohua Li <shli@kernel.org> 写道：
> > 
> > confusing reading the code. Don't think a 'if () write_empty_block' makes the
> 
> Hi ShaoHua. 
> 
> I rewrote this part of the code, now without data_only_stripes, we write an empty block here,
> with data_only_stripes, mark the first cache block as last_checkpoint.

Next time please send formal patch and fix your mail client (it skews up tabs).
I manually applied this patch this time. Thanks!

Best Regards,
Shaohua

 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 9e72180..5697724 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2072,7 +2072,6 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>                 return -ENOMEM;
>         }
> 
> -       ctx->seq += 10;
>         list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
>                 struct r5l_meta_block *mb;
>                 int i;
> @@ -2132,6 +2131,8 @@ static int r5l_recovery_log(struct r5l_log *log)
>         struct mddev *mddev = log->rdev->mddev;
>         struct r5l_recovery_ctx ctx;
>         int ret;
> +       sector_t pos;
> +       struct stripe_head *sh;
> 
>         ctx.pos = log->last_checkpoint;
>         ctx.seq = log->last_cp_seq;
> @@ -2149,6 +2150,18 @@ static int r5l_recovery_log(struct r5l_log *log)
>         if (ret)
>                 return ret;
> 
> +       pos = ctx.pos;
> +       ctx.seq += 10;
> +
> +       if (ctx.data_only_stripes == 0) {
> +               log->next_checkpoint = ctx.pos;
> +               r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
> +               ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
> +       } else {
> +               sh = list_last_entry(&ctx.cached_list, struct stripe_head, lru);
> +               log->next_checkpoint = sh->log_start;
> +       }
> +
>         if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
>                 pr_debug("md/raid:%s: starting from clean shutdown\n",
>                          mdname(mddev));
> @@ -2166,10 +2179,9 @@ static int r5l_recovery_log(struct r5l_log *log)
>         }
> 
>         log->log_start = ctx.pos;
> -       log->next_checkpoint = ctx.pos;
>         log->seq = ctx.seq;
> -       r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq);
> -       r5l_write_super(log, ctx.pos);
> +       log->last_checkpoint = pos;
> +       r5l_write_super(log, pos);
>         return 0;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
