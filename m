From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: Single-drive RAID0
Date: Tue, 22 Feb 2011 11:50:11 +0000
Message-ID: <BE2BFE91933D1B4089447C6448604080690FFAB0@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
	<20110214131149.7f0655a3@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
	<20110215110141.30d28302@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068FB347B@irsmsx503.ger.corp.intel.com>
	<20110216114234.0311d27b@notabene.brown>
	<BE2BFE91933D1B4089447C644860408069028F47@irsmsx503.ger.corp.intel.com>
	<20110221131519.1039f37c@notabene.brown>
	<BE2BFE91933D1B4089447C64486040806908FC52@irsmsx503.ger.corp.intel.com>
 <20110222115011.282804d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222115011.282804d9@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, February 22, 2011 1:50 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Single-drive RAID0
> 
> On Mon, 21 Feb 2011 14:11:51 +0000 "Wojcik, Krzysztof"
> <krzysztof.wojcik@intel.com> wrote:
> 
> > Hi,
> >
> > I tested your proposal.
> > It resolve the problem.
> 
> Thanks!
> 
> > What are your future plans?
> > Do you need to consult the patch with someone involved in the block
> devices code?
> > When can I expect final patch?
> 
> Here it is.  As you can see it is quite different - I figured out what
> is
> really going on..
> 
> 
> >
> > >
> > > If it does, then we can explore more...
> > > Did you say that this works better on earlier kernels?  If so, what
> is
> > > the
> > > latest kernel that you have tried that you don't have this problem
> on?
> >
> > I've tested on kernel 2.6.32 from RHEL6.0 and, if I remember
> correctly, 2.6.34- they work properly.
> 
> That fits - I discovered that I broke it in 2.6.35.
> 
> Thanks,
> NeilBrown

Hi,

I confirm. This patch resolve the problem.
I did tests on your current top of for-next branch and issue is not reproducible.
Thank for your cooperation! :-)

Regards
Krzysztof

> 
> From b7fea734c7780ca80f58fb87a6c9f55aa83314d7 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Tue, 22 Feb 2011 11:48:03 +1100
> Subject: [PATCH] md: Fix - again - partition detection when array
> becomes active
> 
> Revert
>     b821eaa572fd737faaf6928ba046e571526c36c6
> and
>     f3b99be19ded511a1bf05a148276239d9f13eefa
> 
> When I wrote the first of these I had a wrong idea about the
> lifetime of 'struct block_device'.  It can disappear at any time that
> the block device is not open if it falls out of the inode cache.
> 
> So relying on the 'size' recorded with it to detect when the
> device size has changed and so we need to revalidate, is wrong.
> 
> Rather, we really do need the 'changed' attribute stored directly in
> the mddev and set/tested as appropriate.
> 
> Without this patch, a sequence of:
>    mknod / open / close / unlink
> 
> (which can cause a block_device to be created and then destroyed)
> will result in a rescan of the partition table and consequence removal
> and addition of partitions.
> Several of these in a row can get udev racing to create and unlink and
> other code can get confused.
> 
> With the patch, the rescan is only performed when needed and so there
> are no races.
> 
> This is suitable for any stable kernel from 2.6.35.
> 
> Reported-by: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Cc: stable@kernel.org
> ---
>  drivers/md/md.c |   22 +++++++++++++++++++++-
>  drivers/md/md.h |    2 ++
>  2 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 330addf..818313e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4627,6 +4627,7 @@ static int do_md_run(mddev_t *mddev)
>  	}
>  	set_capacity(mddev->gendisk, mddev->array_sectors);
>  	revalidate_disk(mddev->gendisk);
> +	mddev->changed = 1;
>  	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
>  out:
>  	return err;
> @@ -4715,6 +4716,7 @@ static void md_clean(mddev_t *mddev)
>  	mddev->sync_speed_min = mddev->sync_speed_max = 0;
>  	mddev->recovery = 0;
>  	mddev->in_sync = 0;
> +	mddev->changed = 0;
>  	mddev->degraded = 0;
>  	mddev->safemode = 0;
>  	mddev->bitmap_info.offset = 0;
> @@ -4830,6 +4832,7 @@ static int do_md_stop(mddev_t * mddev, int mode,
> int is_open)
> 
>  		set_capacity(disk, 0);
>  		mutex_unlock(&mddev->open_mutex);
> +		mddev->changed = 1;
>  		revalidate_disk(disk);
> 
>  		if (mddev->ro)
> @@ -6014,7 +6017,7 @@ static int md_open(struct block_device *bdev,
> fmode_t mode)
>  	atomic_inc(&mddev->openers);
>  	mutex_unlock(&mddev->open_mutex);
> 
> -	check_disk_size_change(mddev->gendisk, bdev);
> +	check_disk_change(bdev);
>   out:
>  	return err;
>  }
> @@ -6029,6 +6032,21 @@ static int md_release(struct gendisk *disk,
> fmode_t mode)
> 
>  	return 0;
>  }
> +
> +static int md_media_changed(struct gendisk *disk)
> +{
> +	mddev_t *mddev = disk->private_data;
> +
> +	return mddev->changed;
> +}
> +
> +static int md_revalidate(struct gendisk *disk)
> +{
> +	mddev_t *mddev = disk->private_data;
> +
> +	mddev->changed = 0;
> +	return 0;
> +}
>  static const struct block_device_operations md_fops =
>  {
>  	.owner		= THIS_MODULE,
> @@ -6039,6 +6057,8 @@ static const struct block_device_operations
> md_fops =
>  	.compat_ioctl	= md_compat_ioctl,
>  #endif
>  	.getgeo		= md_getgeo,
> +	.media_changed  = md_media_changed,
> +	.revalidate_disk= md_revalidate,
>  };
> 
>  static int md_thread(void * arg)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 7e90b85..12215d4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -274,6 +274,8 @@ struct mddev_s
>  	atomic_t			active;		/* general refcount */
>  	atomic_t			openers;	/* number of active opens */
> 
> +	int				changed;	/* True if we might need to
> +							 * reread partition info */
>  	int				degraded;	/* whether md should consider
>  							 * adding a spare
>  							 */
> --
> 1.7.1

