From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Tue, 7 Jul 2009 13:42:56 +1000
Message-ID: <19026.50240.504728.428875@notabene.brown>
References: <20090701083802.GC9910@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Wednesday July 1
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

On Wednesday July 1, maan@systemlinux.org wrote:
> Hi Neil,
> 
> here's again the patch that reduces the knowledge about specific
> raid levels from md.c by moving the data integrity code to the
> personalities. The patch was tested and acked by Martin.
> 
> Please review.

Apologies for the delay.  I've been fighting a flu :-(

This patch seems to treat spares inconsistently.

md_integrity_register ignores spares.
However bind_rdev_to_array - which is used for adding a spare - calls
md_integrity_add_rdev to check that the integrity profile of the new
device matches.

We need to be consistent.
Either all devices that are bound to the array - whether active,
spare, or failed - are considered, or only the active devices are
considered.

In the former case we want to take action in bind_rdev_to_array
and possibly in unbind_rdev_from_array.
In the latter we need to take action either in remove_and_add_spares,
or in the per-personality ->hot_add_disk and ->hot_remove_disk
methods.

I think I lean towards the latter, and put code in ->hot_*_disk, but
it isn't a strong leaning.

Thanks,

NeilBrown


> 
> Thanks
> Andre
> 
> commit 51295532895ffe532a5d8401fc32073100268b29
> Author: Andre Noll <maan@systemlinux.org>
> Date:   Fri Jun 19 14:40:46 2009 +0200
> 
>     [PATCH/RFC] md: Push down data integrity code to personalities.
>     
>     This patch replaces md_integrity_check() by two new functions:
>     md_integrity_register() and md_integrity_add_rdev() which are both
>     personality-independent.
>     
>     md_integrity_register() is a public function which is called from
>     the ->run method of all personalities that support data integrity.
>     The function iterates over the component devices of the array and
>     determines if all active devices are integrity capable and if their
>     profiles match. If this is the case, the common profile is registered
>     for the mddev via blk_integrity_register().
>     
>     The second new function, md_integrity_add_rdev(), is internal to
>     md.c and is called by bind_rdev_to_array(), i.e. whenever a new
>     device is about to be added to a raid array. If the new device does
>     not support data integrity or has a profile different from the one
>     already registered, data integrity for the mddev is disabled.
>     
>     Conversely, removing a device from a (raid1-)array might make the mddev
>     integrity-capable. The patch adds a call to md_integrity_register()
>     to the error path of raid1.c in order to activate data integrity in
>     this case.
> 
>     Signed-off-by: Andre Noll <maan@systemlinux.org>
>     Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index dda2f1b..15aa325 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -201,6 +201,7 @@ static int linear_run (mddev_t *mddev)
>  	mddev->queue->unplug_fn = linear_unplug;
>  	mddev->queue->backing_dev_info.congested_fn = linear_congested;
>  	mddev->queue->backing_dev_info.congested_data = mddev;
> +	md_integrity_register(mddev);
>  	return 0;
>  }
>  
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0f11fd1..54436cb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1491,36 +1491,71 @@ static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
>  
>  static LIST_HEAD(pending_raid_disks);
>  
> -static void md_integrity_check(mdk_rdev_t *rdev, mddev_t *mddev)
> +/*
> + * Try to register data integrity profile for an mddev
> + *
> + * This only succeeds if all working and active component devices are integrity
> + * capable with matching profiles.
> + */
> +int md_integrity_register(mddev_t *mddev)
>  {
> -	struct mdk_personality *pers = mddev->pers;
> -	struct gendisk *disk = mddev->gendisk;
> +	mdk_rdev_t *rdev, *reference = NULL;
> +
> +	if (list_empty(&mddev->disks))
> +		return 0; /* nothing to do */
> +	if (blk_get_integrity(mddev->gendisk))
> +		return 0; /* already registered */
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
> +		/* skip spares and non-functional disks */
> +		if (test_bit(Faulty, &rdev->flags))
> +			continue;
> +		if (rdev->raid_disk < 0)
> +			continue;
> +		/*
> +		 * If at least one rdev is not integrity capable, we can not
> +		 * enable data integrity for the md device.
> +		 */
> +		if (!bdev_get_integrity(rdev->bdev))
> +			return -EINVAL;
> +		if (!reference) {
> +			/* Use the first rdev as the reference */
> +			reference = rdev;
> +			continue;
> +		}
> +		/* does this rdev's profile match the reference profile? */
> +		if (blk_integrity_compare(reference->bdev->bd_disk,
> +				rdev->bdev->bd_disk) < 0)
> +			return -EINVAL;
> +	}
> +	/*
> +	 * All component devices are integrity capable and have matching
> +	 * profiles, register the common profile for the md device.
> +	 */
> +	if (blk_integrity_register(mddev->gendisk,
> +			bdev_get_integrity(reference->bdev)) != 0) {
> +		printk(KERN_ERR "md: failed to register integrity for %s\n",
> +			mdname(mddev));
> +		return -EINVAL;
> +	}
> +	printk(KERN_NOTICE "md: data integrity on %s enabled\n",
> +		mdname(mddev));
> +	return 0;
> +}
> +EXPORT_SYMBOL(md_integrity_register);
> +
> +/* Disable data integrity if non-capable/non-matching disk is being added */
> +static void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
> +{
> +	struct gendisk *gd = mddev->gendisk;
>  	struct blk_integrity *bi_rdev = bdev_get_integrity(rdev->bdev);
> -	struct blk_integrity *bi_mddev = blk_get_integrity(disk);
> +	struct blk_integrity *bi_mddev = blk_get_integrity(gd);
>  
> -	/* Data integrity passthrough not supported on RAID 4, 5 and 6 */
> -	if (pers && pers->level >= 4 && pers->level <= 6)
> +	if (!bi_mddev) /* nothing to do */
>  		return;
> -
> -	/* If rdev is integrity capable, register profile for mddev */
> -	if (!bi_mddev && bi_rdev) {
> -		if (blk_integrity_register(disk, bi_rdev))
> -			printk(KERN_ERR "%s: %s Could not register integrity!\n",
> -			       __func__, disk->disk_name);
> -		else
> -			printk(KERN_NOTICE "Enabling data integrity on %s\n",
> -			       disk->disk_name);
> +	if (bi_rdev && blk_integrity_compare(gd, rdev->bdev->bd_disk) >= 0)
>  		return;
> -	}
> -
> -	/* Check that mddev and rdev have matching profiles */
> -	if (blk_integrity_compare(disk, rdev->bdev->bd_disk) < 0) {
> -		printk(KERN_ERR "%s: %s/%s integrity mismatch!\n", __func__,
> -		       disk->disk_name, rdev->bdev->bd_disk->disk_name);
> -		printk(KERN_NOTICE "Disabling data integrity on %s\n",
> -		       disk->disk_name);
> -		blk_integrity_unregister(disk);
> -	}
> +	printk(KERN_NOTICE "disabling data integrity on %s\n", mdname(mddev));
> +	blk_integrity_unregister(gd);
>  }
>  
>  static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
> @@ -1595,7 +1630,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
>  	/* May as well allow recovery to be retried once */
>  	mddev->recovery_disabled = 0;
>  
> -	md_integrity_check(rdev, mddev);
> +	md_integrity_add_rdev(rdev, mddev);
>  	return 0;
>  
>   fail:
> @@ -4048,10 +4083,6 @@ static int do_md_run(mddev_t * mddev)
>  	}
>  	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
>  
> -	if (pers->level >= 4 && pers->level <= 6)
> -		/* Cannot support integrity (yet) */
> -		blk_integrity_unregister(mddev->gendisk);
> -
>  	if (mddev->reshape_position != MaxSector &&
>  	    pers->start_reshape == NULL) {
>  		/* This personality cannot handle reshaping... */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ea2c441..9433a5d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -430,5 +430,6 @@ extern void md_new_event(mddev_t *mddev);
>  extern int md_allow_write(mddev_t *mddev);
>  extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
>  extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
> +extern int md_integrity_register(mddev_t *mddev);
>  
>  #endif /* _MD_MD_H */
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index c1ca63f..3d3a308 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -515,7 +515,7 @@ static int multipath_run (mddev_t *mddev)
>  	mddev->queue->unplug_fn = multipath_unplug;
>  	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
>  	mddev->queue->backing_dev_info.congested_data = mddev;
> -
> +	md_integrity_register(mddev);
>  	return 0;
>  
>  out_free_conf:
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 851e631..902de77 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -346,6 +346,7 @@ static int raid0_run(mddev_t *mddev)
>  
>  	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
>  	dump_zones(mddev);
> +	md_integrity_register(mddev);
>  	return 0;
>  }
>  
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 89939a7..44fbeda 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1045,6 +1045,11 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
>  	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device.\n"
>  		"raid1: Operation continuing on %d devices.\n",
>  		bdevname(rdev->bdev,b), conf->raid_disks - mddev->degraded);
> +	/*
> +	 * The good news is that kicking a disk might allow to enable data
> +	 * integrity on the mddev.
> +	 */
> +	md_integrity_register(mddev);
>  }
>  
>  static void print_conf(conf_t *conf)
> @@ -1178,7 +1183,9 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
>  			/* lost the race, try later */
>  			err = -EBUSY;
>  			p->rdev = rdev;
> +			goto abort;
>  		}
> +		md_integrity_register(mddev);
>  	}
>  abort:
>  
> @@ -2068,7 +2075,7 @@ static int run(mddev_t *mddev)
>  	mddev->queue->unplug_fn = raid1_unplug;
>  	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
>  	mddev->queue->backing_dev_info.congested_data = mddev;
> -
> +	md_integrity_register(mddev);
>  	return 0;
>  
>  out_no_mem:
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index ae12cea..3e553e3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1203,7 +1203,9 @@ static int raid10_remove_disk(mddev_t *mddev, int number)
>  			/* lost the race, try later */
>  			err = -EBUSY;
>  			p->rdev = rdev;
> +			goto abort;
>  		}
> +		md_integrity_register(mddev);
>  	}
>  abort:
>  
> @@ -2218,6 +2220,7 @@ static int run(mddev_t *mddev)
>  
>  	if (conf->near_copies < mddev->raid_disks)
>  		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
> +	md_integrity_register(mddev);
>  	return 0;
>  
>  out_free_conf:
> -- 
> The only person who always got his work done by Friday was Robinson Crusoe
