From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5-cache: remove the unnecessary next_cp_seq field
 from the r5l_log
Date: Tue, 29 Nov 2016 14:37:58 -0800
Message-ID: <20161129223758.jybulclyeascfuo3@kernel.org>
References: <20161129031320.9025-1-liuyun01@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161129031320.9025-1-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: JackieLiu <liuyun01@kylinos.cn>
Cc: shli@fb.com, songliubraving@fb.com, liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 29, 2016 at 11:13:20AM +0800, JackieLiu wrote:
> The next_cp_seq field is useless, remove it.

applied, thanks!
 
> Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
> ---
>  drivers/md/raid5-cache.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 5f817bd..95bd51e 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -113,7 +113,6 @@ struct r5l_log {
>  	u64 seq;			/* log head sequence */
>  
>  	sector_t next_checkpoint;
> -	u64 next_cp_seq;
>  
>  	struct mutex io_mutex;
>  	struct r5l_io_unit *current_io;	/* current io_unit accepting new data */
> @@ -1075,7 +1074,6 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
>  			break;
>  
>  		log->next_checkpoint = io->log_start;
> -		log->next_cp_seq = io->seq;
>  
>  		list_del(&io->log_sibling);
>  		mempool_free(io, log->io_pool);
> -- 
> 2.10.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
