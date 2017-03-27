From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3] md/raid5: use consistency_policy to remove journal
 feature
Date: Mon, 27 Mar 2017 12:02:00 -0700
Message-ID: <20170327190200.qecbco7fw23qbric@kernel.org>
References: <20170327175133.3607211-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170327175133.3607211-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Mon, Mar 27, 2017 at 10:51:33AM -0700, Song Liu wrote:
> When journal device of an array fails, the array is forced into read-only
> mode. To make the array normal without adding another journal device, we
> need to remove journal _feature_ from the array.
> 
> This patch allows remove journal _feature_ from an array, For journal
> existing journal should be either missing or faulty.
> 
> To remove journal feature, it is necessary to remove the journal device
> first:
> 
>   mdadm --fail /dev/md0 /dev/sdb
>   mdadm: set /dev/sdb faulty in /dev/md0
>   mdadm --remove /dev/md0 /dev/sdb
>   mdadm: hot removed /dev/sdb from /dev/md0
> 
> Then the journal feature can be removed by echoing into the sysfs file:
> 
>  cat /sys/block/md0/md/consistency_policy
>  journal
> 
>  echo resync > /sys/block/md0/md/consistency_policy
>  cat /sys/block/md0/md/consistency_policy
>  resync

Looks good, applied, thanks!
 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5.c | 46 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 266d661..6036d5e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8292,17 +8292,41 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
>  	}
>  
>  	if (strncmp(buf, "ppl", 3) == 0 && !raid5_has_ppl(conf)) {
> -		mddev_suspend(mddev);
> -		set_bit(MD_HAS_PPL, &mddev->flags);
> -		err = log_init(conf, NULL);
> -		if (!err)
> +		/* ppl only works with RAID 5 */
> +		if (conf->level == 5) {
> +			mddev_suspend(mddev);
> +			set_bit(MD_HAS_PPL, &mddev->flags);
> +			err = log_init(conf, NULL);
> +			if (!err)
> +				raid5_reset_stripe_cache(mddev);
> +			mddev_resume(mddev);
> +		} else
> +			err = -EINVAL;
> +	} else if (strncmp(buf, "resync", 6) == 0) {
> +		if (raid5_has_ppl(conf)) {
> +			mddev_suspend(mddev);
> +			log_exit(conf);
>  			raid5_reset_stripe_cache(mddev);
> -		mddev_resume(mddev);
> -	} else if (strncmp(buf, "resync", 6) == 0 && raid5_has_ppl(conf)) {
> -		mddev_suspend(mddev);
> -		log_exit(conf);
> -		raid5_reset_stripe_cache(mddev);
> -		mddev_resume(mddev);
> +			mddev_resume(mddev);
> +		} else if (test_bit(MD_HAS_JOURNAL, &conf->mddev->flags) &&
> +			   r5l_log_disk_error(conf)) {
> +			bool journal_dev_exists = false;
> +			struct md_rdev *rdev;
> +
> +			rdev_for_each(rdev, mddev)
> +				if (test_bit(Journal, &rdev->flags)) {
> +					journal_dev_exists = true;
> +					break;
> +				}
> +
> +			if (!journal_dev_exists) {
> +				mddev_suspend(mddev);
> +				clear_bit(MD_HAS_JOURNAL, &mddev->flags);
> +				mddev_resume(mddev);
> +			} else  /* need remove journal device first */
> +				err = -EBUSY;
> +		} else
> +			err = -EINVAL;
>  	} else {
>  		err = -EINVAL;
>  	}
> @@ -8337,6 +8361,7 @@ static struct md_personality raid6_personality =
>  	.quiesce	= raid5_quiesce,
>  	.takeover	= raid6_takeover,
>  	.congested	= raid5_congested,
> +	.change_consistency_policy = raid5_change_consistency_policy,
>  };
>  static struct md_personality raid5_personality =
>  {
> @@ -8385,6 +8410,7 @@ static struct md_personality raid4_personality =
>  	.quiesce	= raid5_quiesce,
>  	.takeover	= raid4_takeover,
>  	.congested	= raid5_congested,
> +	.change_consistency_policy = raid5_change_consistency_policy,
>  };
>  
>  static int __init raid5_init(void)
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
