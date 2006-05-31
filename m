From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 30 May 2006 17:15:35 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
 <Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
 <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
 <4415F400.5030808@ucolick.org> <17429.64926.100005.904328@cse.unsw.edu.au>
 <Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
 <Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
 <17522.29813.189944.397154@cse.unsw.edu.au> <Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
 <17527.38282.35857.117651@cse.unsw.edu.au> <Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>
 <17529.37347.782285.77442@cse.unsw.edu.au> <Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>
 <17531.35050.632471.433333@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17531.35050.632471.433333@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 May 2006, Neil Brown wrote:

> Could you try this patch please?  On top of the rest.
> And if it doesn't fail in a couple of days, tell me how regularly the
> message 
>    kblockd_schedule_work failed
> gets printed.

i'm running this patch now ... and just after reboot, no freeze yet, i've 
already seen a handful of these:

May 30 17:05:09 localhost kernel: kblockd_schedule_work failed
May 30 17:05:59 localhost kernel: kblockd_schedule_work failed
May 30 17:08:16 localhost kernel: kblockd_schedule_work failed
May 30 17:10:51 localhost kernel: kblockd_schedule_work failed
May 30 17:11:51 localhost kernel: kblockd_schedule_work failed
May 30 17:12:46 localhost kernel: kblockd_schedule_work failed
May 30 17:14:14 localhost kernel: kblockd_schedule_work failed

-dean

> 
> Thanks,
> NeilBrown
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./block/ll_rw_blk.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff ./block/ll_rw_blk.c~current~ ./block/ll_rw_blk.c
> --- ./block/ll_rw_blk.c~current~	2006-05-30 09:48:02.000000000 +1000
> +++ ./block/ll_rw_blk.c	2006-05-30 09:48:48.000000000 +1000
> @@ -1636,7 +1636,11 @@ static void blk_unplug_timeout(unsigned 
>  {
>  	request_queue_t *q = (request_queue_t *)data;
>  
> -	kblockd_schedule_work(&q->unplug_work);
> +	if (!kblockd_schedule_work(&q->unplug_work)) {
> +		/* failed to schedule the work, try again later */
> +		printk("kblockd_schedule_work failed\n");
> +		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
> +	}
>  }
>  
>  /**
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
