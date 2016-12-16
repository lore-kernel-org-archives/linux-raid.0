From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5-cache: removes unnecessary write-through mode
 judgments
Date: Fri, 16 Dec 2016 12:12:44 -0800
Message-ID: <20161216201244.6xnckow6t35ruuvd@kernel.org>
References: <20161213055527.3306-1-liuyun01@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161213055527.3306-1-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: JackieLiu <liuyun01@kylinos.cn>
Cc: songliubraving@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 13, 2016 at 01:55:27PM +0800, JackieLiu wrote:
> The write-through mode has been returned in front of the function,
> do not need to do it again.
applied, thanks!
 
> Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
> ---
>  drivers/md/raid5-cache.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 6d1a150..4dd8e4e 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2418,9 +2418,6 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
>  	if (do_wakeup)
>  		wake_up(&conf->wait_for_overlap);
>  
> -	if (conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
> -		return;
> -
>  	spin_lock_irq(&conf->log->stripe_in_journal_lock);
>  	list_del_init(&sh->r5c);
>  	spin_unlock_irq(&conf->log->stripe_in_journal_lock);
> -- 
> 2.10.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
