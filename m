From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch] md/r5cache: enable IRQs on error path
Date: Sun, 27 Nov 2016 21:37:54 -0800
Message-ID: <20161128053754.cbppd4ada3oe6klw@kernel.org>
References: <20161124111304.GI17225@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161124111304.GI17225@mwanda>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 24, 2016 at 02:13:04PM +0300, Dan Carpenter wrote:
> We need to re-enable the IRQs here before returning.
> 
> Fixes: a39f7afde358 ("md/r5cache: write-out phase and reclaim support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!
 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 2a60ce4..6610134 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1029,7 +1029,7 @@ static sector_t r5c_calculate_new_cp(struct r5conf *conf)
>  	spin_lock_irqsave(&log->stripe_in_journal_lock, flags);
>  	if (list_empty(&conf->log->stripe_in_journal_list)) {
>  		/* all stripes flushed */
> -		spin_unlock(&log->stripe_in_journal_lock);
> +		spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
>  		return log->next_checkpoint;
>  	}
>  	sh = list_first_entry(&conf->log->stripe_in_journal_list,
