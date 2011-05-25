From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2 of 9] MD:  should_read_superblock
Date: Wed, 25 May 2011 14:01:57 +1000
Message-ID: <20110525140157.497bebaf@notabene.brown>
References: <201105240306.p4O369g2029293@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105240306.p4O369g2029293@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 May 2011 22:06:09 -0500 Jonathan Brassow <jbrassow@f14.redhat.com>
wrote:

> Patch name: md-should_read_superblock.patch
> 
> Add new function to determine whether MD superblocks should be read.
> 
> It used to be sufficient to check if mddev->raid_disks was set to determine
> whether to read the superblock or not.  However, device-mapper (dm-raid.c)
> sets this value before calling md_run().  Thus, we need additional mechanisms
> for determining whether to read the superblock.  This patch adds the condition
> that if rdev->meta_bdev is set, the superblock should be read - something that
> only device-mapper does (and only when there are superblocks to be read/used).
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

I've been feeling uncomfortable about this and have spent a while trying to
see if my discomfort is at all justified.  It seems that maybe it is.

The discomfort is really at analyze_sbs being used for dm arrays.  It is
really for arrays where md completely controls the metadata.  dm array are in
a strange intermediate situation where some metadata is controlled by
user-space (so md is told about some details of the array) and other metadata
is managed by the kernel - so md finds those bits out by itself.

It isn't yet entirely clear to me how to handle the half-way state best.

But the particular problem is that analyse_sbs can call kick_rdev_from_array.
This will call export_rdev which will call kobject_put(&rdev->kboj) which is
bad because dm-based rdevs do not get their kobj initialised.

So I think analyse_sbs should not be used for dm arrays.
Rather the code in dm-raid.c which parses the metadata_device info from the
constructor line should load_super.  Then before md_run is called it should
do the 'validate_super' step and record any failures.

So the only super_types method that md code would call on a dm-raid array
would be sync_super.

Does that work for you?

Thanks,
NeilBrown


> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -4421,6 +4421,20 @@ static void md_safemode_timeout(unsigned
>  	md_wakeup_thread(mddev->thread);
>  }
>  
> +static int should_read_super(mddev_t *mddev)
> +{
> +	mdk_rdev_t *rdev, *tmp;
> +
> +	if (!mddev->raid_disks)
> +		return 1;
> +
> +	rdev_for_each(rdev, tmp, mddev)
> +		if (rdev->meta_bdev)
> +			return 1;
> +
> +	return 0;
> +}
> +
>  static int start_dirty_degraded;
>  
>  int md_run(mddev_t *mddev)
> @@ -4442,7 +4456,7 @@ int md_run(mddev_t *mddev)
>  	/*
>  	 * Analyze all RAID superblock(s)
>  	 */
> -	if (!mddev->raid_disks) {
> +	if (should_read_super(mddev)) {
>  		if (!mddev->persistent)
>  			return -EINVAL;
>  		analyze_sbs(mddev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

