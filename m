From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 01/36] md: beginnings of bad block management.
Date: Sat, 23 Jul 2011 01:52:22 +0900
Message-ID: <87r55i45rt.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.29443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025847.8422.29443.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:47 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> This the first step in allowing md to track bad-blocks per-device so
> that we can fail individual blocks rather than the whole device.
>
> This patch just adds a data structure for recording bad blocks, with
> routines to add, remove, search the list.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>
>  drivers/md/md.c |  457 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/md.h |   49 ++++++
>  2 files changed, 502 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2a32050..220fadb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1952,6 +1952,10 @@ static void unbind_rdev_from_array(mdk_rdev_t * rdev)
>  	sysfs_remove_link(&rdev->kobj, "block");
>  	sysfs_put(rdev->sysfs_state);
>  	rdev->sysfs_state = NULL;
> +	kfree(rdev->badblocks.page);
> +	rdev->badblocks.count = 0;
> +	rdev->badblocks.page = NULL;
> +	rdev->badblocks.active_page = NULL;
>  	/* We need to delay this, otherwise we can deadlock when
>  	 * writing to 'remove' to "dev/state".  We also need
>  	 * to delay it due to rcu usage.
> @@ -2778,7 +2782,7 @@ static struct kobj_type rdev_ktype = {
>  	.default_attrs	= rdev_default_attrs,
>  };
>  
> -void md_rdev_init(mdk_rdev_t *rdev)
> +int md_rdev_init(mdk_rdev_t *rdev)
>  {
>  	rdev->desc_nr = -1;
>  	rdev->saved_raid_disk = -1;
> @@ -2794,6 +2798,20 @@ void md_rdev_init(mdk_rdev_t *rdev)
>  
>  	INIT_LIST_HEAD(&rdev->same_set);
>  	init_waitqueue_head(&rdev->blocked_wait);
> +
> +	/* Add space to store bad block list.
> +	 * This reserves the space even on arrays where it cannot
> +	 * be used - I wonder if that matters
> +	 */
> +	rdev->badblocks.count = 0;
> +	rdev->badblocks.shift = 0;
> +	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	rdev->badblocks.active_page = rdev->badblocks.page;
> +	spin_lock_init(&rdev->badblocks.lock);
> +	if (rdev->badblocks.page == NULL)
> +		return -ENOMEM;
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(md_rdev_init);
>  /*
> @@ -2819,8 +2837,11 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	md_rdev_init(rdev);
> -	if ((err = alloc_disk_sb(rdev)))
> +	err = md_rdev_init(rdev);
> +	if (err)
> +		goto abort_free;
> +	err = alloc_disk_sb(rdev);
> +	if (err)
>  		goto abort_free;
>  
>  	err = lock_rdev(rdev, newdev, super_format == -2);

Now error path at abort_free needs to free rdev->badblocks.page
otherwise there will be memory leaks.
