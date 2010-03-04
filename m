From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [md PATCH 2/8] Enable OLCE for external IMSM metadata
Date: Thu, 4 Mar 2010 08:48:46 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D10180F56C@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D1016F65B9@irsmsx503.ger.corp.intel.com>
 <20100304171101.4fbb2bea@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100304171101.4fbb2bea@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Yes it makes sense. 

The reason that I've introduce wait_reshape() in md is to get possibility to start OLCE without mdadm (by settings entries in sysfs only).
To do this, all logic for adding new devices has to be in mdmon. Mdmon can learn about delta_disks after reshape start only. Delta_disks is exposed in raid_disks. 
Wait_reshape() gives us ability to start OLCE without direct communication between mdmon and mdadm (the only communication point is "0" stored in sync_complete). Sysfs interface to md is the only thing needed to start OLCE.

This was the only wait_reshape() cause, there was no IMSM specific causes. If we assume that OLCE can be triggered by mdadm only (not by sysfs interface without mdadm) wait_reshape() can be removed.

no problem, I'll redesign this mechanism.

Adam




-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, March 04, 2010 7:11 AM
To: Kwolek, Adam
Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
Subject: Re: [md PATCH 2/8] Enable OLCE for external IMSM metadata

On Wed, 24 Feb 2010 07:43:01 +0000
"Kwolek, Adam" <adam.kwolek@intel.com> wrote:

> >From 0879522dd107d12fc28841d75c9792b32761e4bc Mon Sep 17 00:00:00 2001
> From: Adam Kwolek <adam.kwolek@intel.com>
> Date: Thu, 18 Feb 2010 11:24:51 +0100
> Subject: [PATCH] OLCE: add wait_reshape()
> 
> Changes to be committed:
> 	modified:   md.c
> 	modified:   md.h
> 	modified:   raid5.c
> 
> Add wait_reshape() to personality

Again, no really useful commentary here.

I'm guessing that the problem you are trying to solve here is that
mdadm starts the reshape, but mdmon has the task of adding spare
devices for the reshape to use.  So you need some sort of hand-shake
for mdadm to be able to know when mdmon has done it's bit.

I don't think you need to muck about in the kernel to achieve this.

mdadm already has a mechanism for asking mdmon to make some metadata updates,
but sending messasges of the unix-domain socket.

We should use that to assign the spare space to the reshaped array.
Once mdmon knows that the space is reserved (and can no longer be used as
hot-spare space), with mdadm or mdmon adds the space to the array and then
requests the reshape.
When mdmon notices that the reshape has been requested, it converts the
'spare' assignments to full members of the array undergoing OLCE.

I'm not sure exactly how that will fit with the particular metdata layout of
IMSM, but I really think that is the way this should be structured.

Does that make sense to you?

NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>  drivers/md/md.c    |   14 +++++
>  drivers/md/md.h    |    4 +
>  drivers/md/raid5.c |  161 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 177 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d7e1053..83e6852 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6347,6 +6347,20 @@ void md_do_sync(mddev_t *mddev)
>  	else
>  		desc = "recovery";
>  
> +	/* for reshape wait if any additional configuration is made by mdmon
> +	 * for external meta
> +	 */
> +	if ((mddev->pers->wait_reshape) &&
> +		test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +		(mddev->external)) {
> +		if (mddev->pers->wait_reshape(mddev, 1) == 0) {
> +			max_sectors = 0; /* nothing done so far */
> +			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
> +			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
> +			goto interrupted;
> +		}
> +	}
> +
>  	/* we overload curr_resync somewhat here.
>  	 * 0 == not engaged in resync at all
>  	 * 2 == checking that there is no conflict with another sync
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 070e7c6..9ac5940 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -347,6 +347,10 @@ struct mdk_personality
>  	 * array.
>  	 */
>  	void *(*takeover) (mddev_t *mddev);
> +	/* reshape_wait is used for external meta to complete configuration
> +	 * by mdmon
> +	 */
> +	int (*wait_reshape)(mddev_t *mddev, unsigned int useTimeout);
>  };
>  
>  
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b9c33b4..1c6022d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5392,11 +5392,19 @@ static int raid5_start_reshape(mddev_t *mddev)
>  		    !test_bit(Faulty, &rdev->flags))
>  			spares++;
>  
> -	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
> +	if (spares-mddev->degraded < mddev->delta_disks-conf->max_degraded) {
>  		/* Not enough devices even to make a degraded array
>  		 * of that size
>  		 */
> -		return -EINVAL;
> +		if (mddev->external && mddev->pers->wait_reshape) {
> +			printk(KERN_WARNING "md: %s: Not enough devices"
> +			"even to make a degraded array of that size. "
> +			"Check this again after wait reshape\n",
> +			mdname(mddev));
> +		} else {
> +			return -EINVAL;
> +		}
> +	}
>  
>  	/* Refuse to reduce size of the array.  Any reductions in
>  	 * array size must be through explicit setting of array_size
> @@ -5807,6 +5815,154 @@ static void *raid6_takeover(mddev_t *mddev)
>  	return setup_conf(mddev);
>  }
>  
> +/****************************************************************
> + *  for external meta we have to wait until sync_max in sysfs is 0
> + * Parameters:
> + * 	mddev
> + * 	useTimeout: 1 - allow for countdown
> + * 		    0 - countdown is not used
> + * returns:
> + * 	1 : OK
> + * 	0 : Error
> +****************************************************************/
> +#define RAID5_SINGLE_TIMEOUT    100
> +#define RAID5_TIMOUT_LOOP_LIMIT 100
> +
> +static int raid5_wait_reshape(mddev_t *mddev, unsigned int useTimeout)
> +{
> +	int retVal = 1;
> +	int spares = 0;
> +	/* do not wait forever counter  */
> +	int maxCount = RAID5_TIMOUT_LOOP_LIMIT;
> +	int degraded = 0;
> +
> +	printk(KERN_INFO "raid5: raid5_wait_reshape() was called\n");
> +
> +	if (mddev->private)
> +		print_raid5_conf(mddev->private);
> +
> +	/* for external Raid 5 only */
> +	if (mddev->external) {
> +		spares = 0;
> +		printk(KERN_INFO "Raid5: delaying reshape of %s until"
> +			" resync_max will be greater than 0\n",
> +			mdname(mddev));
> +		if (useTimeout)
> +			printk(KERN_INFO "Raid5: Exit on timeout "
> +				"is allowed.\n");
> +		else
> +			printk(KERN_INFO "Raid5: Timeout not used, "
> +				"wait only for sync_max set to max "
> +				"in sysfs.\n");
> +
> +		/* Exit loop if exit is not requested
> +		 * or sync_max is not set in sysfs
> +		 * or timeout is used in case problems in mdmon
> +		 */
> +		while (retVal &&
> +			(mddev->resync_max == 0) &&
> +			maxCount) {
> +			/* wait */
> +			if (kthread_should_stop()) {
> +				printk(KERN_INFO "Raid5: kthread_should_stop() "
> +					"detected\n");
> +				retVal = 0;
> +			} else {
> +				set_current_state(TASK_UNINTERRUPTIBLE);
> +				schedule_timeout(RAID5_SINGLE_TIMEOUT);
> +
> +				if ((maxCount) && (useTimeout)) {
> +					printk(KERN_INFO "Raid5: Timeout loop"
> +						" %i\n", maxCount);
> +					maxCount--;
> +					/* try notification once more */
> +					sysfs_notify(&mddev->kobj,
> +						NULL,
> +						"sync_action");
> +				}
> +			}
> +		} /* while */
> +
> +		/* reshape not started, exited on timeout */
> +		if ((mddev->resync_max == 0) && useTimeout) {
> +			/* no changes, cannot start */
> +			retVal = 0;
> +			printk(KERN_INFO "Raid5: Timeout was triggered.\n");
> +		}
> +
> +		if (retVal) {
> +			raid5_conf_t *conf = mddev->private;
> +			mdk_rdev_t *rdev;
> +			int added_devices = 0;
> +			unsigned long flags;
> +
> +			/* Add some new drives, as many as will fit. */
> +			/* We know there are enough to make
> +			 * the newly sized array work. */
> +			list_for_each_entry(rdev, &mddev->disks, same_set)
> +				if (rdev->raid_disk < 0 &&
> +					!test_bit(Faulty, &rdev->flags)) {
> +					if (raid5_add_disk(mddev, rdev) == 0) {
> +						char nm[20];
> +						set_bit(In_sync, &rdev->flags);
> +						added_devices++;
> +						rdev->recovery_offset = 0;
> +						sprintf(nm, "rd%d",
> +							rdev->raid_disk);
> +						if (sysfs_create_link(
> +							&mddev->kobj,
> +							&rdev->kobj, nm))
> +							printk(KERN_WARNING
> +								"raid5: "
> +								"failed to create "
> +								" link %s for %s\n",
> +								nm, mdname(mddev));
> +					} else
> +						break;
> +				}
> +
> +			if (mddev->delta_disks > 0) {
> +				int degraded = (conf->raid_disks -
> +					conf->previous_raid_disks) - added_devices;
> +				if (mddev->degraded > degraded) {
> +					spin_lock_irqsave(&conf->device_lock, flags);
> +					mddev->degraded = degraded;
> +					spin_unlock_irqrestore(&conf->device_lock, flags);
> +				}
> +			}
> +
> +			mddev->raid_disks = conf->raid_disks;
> +
> +			/* recheck configuration
> +			 * in case it was incorrect on reshape start */
> +			list_for_each_entry(rdev, &mddev->disks, same_set)
> +				if (rdev->raid_disk < 0 &&
> +					!test_bit(Faulty, &rdev->flags))
> +					spares++;
> +
> +			 /* OLCE new condition */
> +			if ((conf->raid_disks - mddev->raid_disks > conf->max_degraded) ||
> +			    (mddev->degraded > conf->max_degraded) ||
> +			    (conf->max_degraded < degraded)) {
> +				printk(KERN_WARNING "md: %s: Not enough devices even to make "
> +					"a degraded array of that size.\n\t"
> +					"Second check failed (raid5 reshape)\n",
> +					mdname(mddev));
> +				retVal = 0;
> +			} else {
> +				printk(KERN_WARNING "md: %s: Second check PASSED "
> +					"(raid5 reshape).\n",
> +					mdname(mddev));
> +			}
> +		}
> +	}
> +
> +	if (mddev->private)
> +		print_raid5_conf(mddev->private);
> +
> +	return retVal;
> +}
> +
>  
>  static struct mdk_personality raid6_personality =
>  {
> @@ -5851,6 +6007,7 @@ static struct mdk_personality raid5_personality =
>  	.finish_reshape = raid5_finish_reshape,
>  	.quiesce	= raid5_quiesce,
>  	.takeover	= raid5_takeover,
> +	.wait_reshape	= raid5_wait_reshape,
>  };
>  
>  static struct mdk_personality raid4_personality =

