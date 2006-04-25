From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 1/2] raid6_end_write_request() spinlock fix
Date: Tue, 25 Apr 2006 15:13:49 +1000
Message-ID: <17485.45069.692725.551853@cse.unsw.edu.au>
References: <20060425033542.GA4087@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Coywolf Qi Hunt on Tuesday April 25
Sender: linux-raid-owner@vger.kernel.org
To: Coywolf Qi Hunt <qiyong@fc-cn.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 25, qiyong@fc-cn.com wrote:
> Hello,
> 
> Reduce the raid6_end_write_request() spinlock window.

Andrew: please don't include these in -mm.  This one and the
corresponding raid5 are wrong, and I'm not sure yet the unplug_device
changes.

In this case, the call to md_error, which in turn calls "error" in
raid6main.c, requires the lock to be held as it contains:
	if (!test_bit(Faulty, &rdev->flags)) {
		mddev->sb_dirty = 1;
		if (test_bit(In_sync, &rdev->flags)) {
			conf->working_disks--;
			mddev->degraded++;
			conf->failed_disks++;
			clear_bit(In_sync, &rdev->flags);
			/*
			 * if recovery was running, make sure it aborts.
			 */
			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
		}
		set_bit(Faulty, &rdev->flags);

which is fairly clearly not safe without some locking.

Coywolf:  As I think I have already said, I appreciate your review of
the md/raid code and your attempts to improve it - I'm sure there is
plenty of room to make improvements.  
However posting patches with minimal commentary on code that you don't
fully understand is not the best way to work with the community.
If you see something that you think is wrong, it is much better to ask
why it is the way it is, explain why you think it isn't right, and
quite possibly include an example patch.  Then we can discuss the
issue and find the best solution.

So please feel free to post further patches, but please include more
commentary, and don't assume you understand something that you don't
really.

Thanks,
NeilBrown



> 
> Signed-off-by: Coywolf Qi Hunt <qiyong@fc-cn.com>
> ---
> 
> diff --git a/drivers/md/raid6main.c b/drivers/md/raid6main.c
> index bc69355..820536e 100644
> --- a/drivers/md/raid6main.c
> +++ b/drivers/md/raid6main.c
> @@ -468,7 +468,6 @@ static int raid6_end_write_request (stru
>   	struct stripe_head *sh = bi->bi_private;
>  	raid6_conf_t *conf = sh->raid_conf;
>  	int disks = conf->raid_disks, i;
> -	unsigned long flags;
>  	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
>  
>  	if (bi->bi_size)
> @@ -486,16 +485,14 @@ static int raid6_end_write_request (stru
>  		return 0;
>  	}
>  
> -	spin_lock_irqsave(&conf->device_lock, flags);
>  	if (!uptodate)
>  		md_error(conf->mddev, conf->disks[i].rdev);
>  
>  	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
> -
>  	clear_bit(R5_LOCKED, &sh->dev[i].flags);
>  	set_bit(STRIPE_HANDLE, &sh->state);
> -	__release_stripe(conf, sh);
> -	spin_unlock_irqrestore(&conf->device_lock, flags);
> +	release_stripe(sh);
> +
>  	return 0;
>  }
>  
> 
> -- 
> Coywolf Qi Hunt
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
