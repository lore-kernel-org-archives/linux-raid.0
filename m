From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: raid10: wake up frozen array
Date: Fri, 1 Aug 2008 13:03:40 +1000
Message-ID: <18578.32012.13358.269935@notabene.brown>
References: <20080725190338.GA27484@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arthur Jones on Friday July 25
Sender: linux-raid-owner@vger.kernel.org
To: Arthur Jones <ajones@riverbed.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 25, ajones@riverbed.com wrote:
> When rescheduling a bio in raid10, we wake up
> the md thread, but if the array is frozen, this
> will have no effect.  This causes the array to
> remain frozen for eternity.  We add a wake_up
> to allow the array to de-freeze.  This code is
> nearly identical to the raid1 code, which has
> this fix already.

Thanks for this!  It is "obviously correct" based on the similarity
with raid1.

It is on its way to Linus.

NeilBrown


> 
> Signed-off-by: Arthur Jones <ajones@riverbed.com>
> ---
>  drivers/md/raid10.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 159535d..d41bebb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -215,6 +215,9 @@ static void reschedule_retry(r10bio_t *r10_bio)
>  	conf->nr_queued ++;
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
>  
> +	/* wake up frozen array... */
> +	wake_up(&conf->wait_barrier);
> +
>  	md_wakeup_thread(mddev->thread);
>  }
>  
> -- 
> 1.5.4.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
