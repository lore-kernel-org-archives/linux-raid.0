From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Add optional round-robbin read balancing to RAID1
Date: Tue, 7 Sep 2010 08:18:05 +1000
Message-ID: <20100907081805.3bb6cfe0@notabene>
References: <Pine.LNX.4.64.1009061609170.11139@claw.oc9.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1009061609170.11139@claw.oc9.org>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Keene <rkeene@rkeene.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 6 Sep 2010 16:14:17 -0500 (CDT)
Roy Keene <rkeene@rkeene.org> wrote:

> All,
> 
>  	Below is a patch that adds support for an alternate read balancing 
> strategy that blindly performs read round-robbin to the MD RAID1 driver. 
> This can be configure per array via sysfs.  The default behaviour is to 
> preserve existing behaviour (biased read balancing)
> 
> I am looking for comments and possible inclusion upstream.

1/ You have some unnecessary '{' and '}' in there.
2/ I would rather not use '0' and '1' for truth-values in sysfs files.
   I would probably have the sysfs file called 'balance-mode' or something
   like that with 'round-robin' being one option ... not sure though.

but most importantly:

3/ performance tests which show circumstances in which round robin is better
   than the default, and other circumstances in which the default is better.
   Such results really are essential before considering this for inclusion.

Thanks!

NeilBrown


> 
> The motivation behind this is that during a sequential read, under some 
> circumstances balancing the I/O through the paths produces better 
> throughput than reading sequentially from one device.
> 
> Thanks,
>  	Roy Keene
> 
> 
> 
> --- linux-2.6.35.4/drivers/md/raid1.c	2010-08-26 18:47:12.000000000 -0500
> +++ linux-2.6.35.4-2rrrr/drivers/md/raid1.c	2010-09-06 14:50:15.309000014 -0500
> @@ -51,6 +51,52 @@
>    */
>   #define	NR_RAID1_BIOS 256
> 
> +static ssize_t raid1_show_mode_roundrobbin(mddev_t *mddev, char *page)
> +{
> +	conf_t *conf = mddev->private;
> +
> +	if (!conf) {
> +		return(-ENODEV);
> +	}
> +
> +	return sprintf(page, "%d\n", conf->round_robbin);
> +}
> +
> +static ssize_t raid1_store_mode_roundrobbin(mddev_t *mddev, const char *page, size_t len)
> +{
> +	conf_t *conf = mddev->private;
> +	unsigned long new;
> +
> +	if (!conf) {
> +		return(-ENODEV);
> +	}
> +
> +	if (strict_strtoul(page, 10, &new)) {
> +		return -EINVAL;
> +	}
> +
> +	if (new) {
> +		conf->round_robbin = 1;
> +	} else {
> +		conf->round_robbin = 0;
> +	}
> +
> +	return len;
> +}
> +
> +static struct md_sysfs_entry raid1_mode_roundrobbin = __ATTR(round_robbin,
> +		S_IRUGO | S_IWUSR, raid1_show_mode_roundrobbin,
> +		raid1_store_mode_roundrobbin);
> +
> +static struct attribute *raid1_attrs[] =  {
> +        &raid1_mode_roundrobbin.attr,
> +	NULL
> +};
> +
> +static struct attribute_group raid1_attrs_group = {
> +	.name = NULL,
> +	.attrs = raid1_attrs,
> +};
> 
>   static void unplug_slaves(mddev_t *mddev);
> 
> @@ -456,6 +502,10 @@
>   		goto rb_out;
>   	}
> 
> +	/* If round-robbin mode enabled for this array, select next disk */
> +	if (conf->round_robbin) {
> +		new_disk = (new_disk + 1) % conf->raid_disks;
> +	}
> 
>   	/* make sure the disk is operational */
>   	for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
> @@ -480,6 +530,11 @@
>   	if (new_disk < 0)
>   		goto rb_out;
> 
> +	/* Don't bother searching for the best disk if we are in round-robbin mode */
> +	if (conf->round_robbin) {
> +		goto rb_out;
> +	}
> +
>   	disk = new_disk;
>   	/* now disk == new_disk == starting point for search */
> 
> @@ -2061,6 +2116,8 @@
>   		goto abort;
>   	}
> 
> +	conf->round_robbin = 0;
> +
>   	return conf;
> 
>    abort:
> @@ -2147,6 +2204,15 @@
> 
>   	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
> 
> +	if (mddev->to_remove == &raid1_attrs_group) {
> +		mddev->to_remove = NULL;
> +	} else {
> +		if (sysfs_create_group(&mddev->kobj, &raid1_attrs_group))
> +			printk(KERN_WARNING
> +				"md/raid:%s: failed to create sysfs attributes.\n",
> +				mdname(mddev));
> +	}
> +
>   	mddev->queue->unplug_fn = raid1_unplug;
>   	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
>   	mddev->queue->backing_dev_info.congested_data = mddev;
> @@ -2173,6 +2239,7 @@
> 
>   	md_unregister_thread(mddev->thread);
>   	mddev->thread = NULL;
> +	mddev->to_remove = &raid1_attrs_group;
>   	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
>   	if (conf->r1bio_pool)
>   		mempool_destroy(conf->r1bio_pool);
> --- linux-2.6.35.4/drivers/md/raid1.h	2010-08-26 18:47:12.000000000 -0500
> +++ linux-2.6.35.4-2rrrr/drivers/md/raid1.h	2010-09-06 14:26:10.297999975 -0500
> @@ -64,6 +64,8 @@
>   	 * the new thread here until we fully activate the array.
>   	 */
>   	struct mdk_thread_s	*thread;
> +
> +	int round_robbin;
>   };
> 
>   typedef struct r1_private_data_s conf_t;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

