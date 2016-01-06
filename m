From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 2/2] raid5-cache: correctly handle stripe with enough
 journal space
Date: Tue, 5 Jan 2016 17:55:44 -0800
Message-ID: <20160106015544.GA4082618@devbig084.prn1.facebook.com>
References: <9ab2f48aab9ddc9aa7ac2b9b6a594a97c2d82f5f.1451954517.git.shli@fb.com>
 <8bafb456f68b960bebaff8b742021d565554d5d4.1451954517.git.shli@fb.com>
 <871t9vxyjv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871t9vxyjv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 06, 2016 at 12:54:28PM +1100, NeilBrown wrote:
> On Tue, Jan 05 2016, Shaohua Li wrote:
> 
> > If there are spaces in journal, we do nothing. Likely a typo merging
> > recent io_unit mempool patch.
> 
> Very likely.
> 
> I think the same effect as your patch can be achieved with
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 55a905e56e8a..6d2b4789a928 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -500,7 +500,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
>  		spin_unlock(&log->no_space_stripes_lock);
>  
>  		r5l_wake_reclaim(log, reserve);
> -
> +	} else {
>  		ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
>  		if (ret) {
>  			spin_lock_irq(&log->io_list_lock);
> 
> Are you OK with me just merging that into the offending patch?

sure, please go ahead
