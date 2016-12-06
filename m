From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] md/r5cache: do r5c_update_log_state after log
 recovery
Date: Mon, 5 Dec 2016 17:10:06 -0800
Message-ID: <20161206011006.6e3rznt67vglgxrd@kernel.org>
References: <1480841385-21180-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480841385-21180-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 04, 2016 at 04:49:44PM +0800, Zhengyuan Liu wrote:
> We should update log state after we did a log recovery, current completion
> may get wrong log state since log->log_start wasn't initalized until we
> called r5l_recovery_log.
> 
> At log recovery stage, no lock needed as there is no race conditon.
> next_checkpoint field will be initialized in r5l_recovery_log too.

applied, thanks!
 
> Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
> ---
>  drivers/md/raid5-cache.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index fa3319c..07bce0e 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2522,14 +2522,12 @@ static int r5l_load_log(struct r5l_log *log)
>  	if (log->max_free_space > RECLAIM_MAX_FREE_SPACE)
>  		log->max_free_space = RECLAIM_MAX_FREE_SPACE;
>  	log->last_checkpoint = cp;
> -	log->next_checkpoint = cp;
> -	mutex_lock(&log->io_mutex);
> -	r5c_update_log_state(log);
> -	mutex_unlock(&log->io_mutex);
>  
>  	__free_page(page);
>  
> -	return r5l_recovery_log(log);
> +	ret = r5l_recovery_log(log);
> +	r5c_update_log_state(log);
> +	return ret;
>  ioerr:
>  	__free_page(page);
>  	return ret;
> -- 
> 2.7.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
