From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: use a separate bio_set for synchronous IO.
Date: Wed, 21 Jun 2017 10:49:16 -0700
Message-ID: <20170621174916.mpxddat2vbiolrik@kernel.org>
References: <87wp861cfe.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wp861cfe.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 21, 2017 at 09:12:21AM +1000, Neil Brown wrote:
> 
> md devices allocate a bio_set and use it for two
> distinct purposes.
> mddev->bio_set is used to clone bios as part of sending
> upper level requests down to lower level devices,
> and it is also use for synchronous IO such as superblock
> and bitmap updates, and for correcting read errors.
> 
> This multiple usage can lead to deadlocks.  It is likely
> that cloned bios might be queued for write and to be
> waiting for a metadata update before the write can be permitted.
> If the cloning exhausted mddev->bio_set, the metadata update
> may not be able to proceed.
> 
> This scenario has been seen during heavy testing, with lots of IO and
> lots of memory pressure.
> 
> Address this by adding a new bio_set specifically for synchronous IO.
> All synchronous IO goes directly to the underlying device and is not
> queued at the md level, so request using entries from the new
> mddev->sync_set will complete in a timely fashion.
> Requests that use mddev->bio_set will sometimes need to wait
> for synchronous IO, but will no longer risk deadlocking that iO.
> 
> Also: small simplification in mddev_put(): there is no need to
> wait until the spinlock is released before calling bioset_free().

applied, thanks
 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c | 27 ++++++++++++++++++++-------
>  drivers/md/md.h |  3 +++
>  2 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 87edc342ccb3..9d0eb50c458e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -203,6 +203,14 @@ struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
>  }
>  EXPORT_SYMBOL_GPL(bio_alloc_mddev);
>  
> +static struct bio *md_bio_alloc_sync(struct mddev *mddev)
> +{
> +	if (!mddev->sync_set)
> +		return bio_alloc(GFP_NOIO, 1);
> +
> +	return bio_alloc_bioset(GFP_NOIO, 1, mddev->sync_set);
> +}
> +
>  /*
>   * We have a system wide 'event count' that is incremented
>   * on any 'interesting' event, and readers of /proc/mdstat
> @@ -462,8 +470,6 @@ static void mddev_delayed_delete(struct work_struct *ws);
>  
>  static void mddev_put(struct mddev *mddev)
>  {
> -	struct bio_set *bs = NULL;
> -
>  	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
>  		return;
>  	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
> @@ -471,8 +477,12 @@ static void mddev_put(struct mddev *mddev)
>  		/* Array is not configured at all, and not held active,
>  		 * so destroy it */
>  		list_del_init(&mddev->all_mddevs);
> -		bs = mddev->bio_set;
> +		if (mddev->bio_set)
> +			bioset_free(mddev->bio_set);
> +		if (mddev->sync_set)
> +			bioset_free(mddev->sync_set);
>  		mddev->bio_set = NULL;
> +		mddev->sync_set = NULL;
>  		if (mddev->gendisk) {
>  			/* We did a probe so need to clean up.  Call
>  			 * queue_work inside the spinlock so that
> @@ -485,8 +495,6 @@ static void mddev_put(struct mddev *mddev)
>  			kfree(mddev);
>  	}
>  	spin_unlock(&all_mddevs_lock);
> -	if (bs)
> -		bioset_free(bs);
>  }
>  
>  static void md_safemode_timeout(unsigned long data);
> @@ -751,7 +759,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>  	if (test_bit(Faulty, &rdev->flags))
>  		return;
>  
> -	bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
> +	bio = md_bio_alloc_sync(mddev);
>  
>  	atomic_inc(&rdev->nr_pending);
>  
> @@ -783,7 +791,7 @@ int md_super_wait(struct mddev *mddev)
>  int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>  		 struct page *page, int op, int op_flags, bool metadata_op)
>  {
> -	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
> +	struct bio *bio = md_bio_alloc_sync(rdev->mddev);
>  	int ret;
>  
>  	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
> @@ -5432,6 +5440,11 @@ int md_run(struct mddev *mddev)
>  		if (!mddev->bio_set)
>  			return -ENOMEM;
>  	}
> +	if (mddev->sync_set == NULL) {
> +		mddev->sync_set = bioset_create(BIO_POOL_SIZE, 0);
> +		if (!mddev->sync_set)
> +			return -ENOMEM;
> +	}
>  
>  	spin_lock(&pers_lock);
>  	pers = find_pers(mddev->level, mddev->clevel);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 0fa1de42c42b..a1c7aa89bb67 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -444,6 +444,9 @@ struct mddev {
>  	struct attribute_group		*to_remove;
>  
>  	struct bio_set			*bio_set;
> +	struct bio_set			*sync_set; /* for sync operations like
> +						   * metadata and bitmap writes
> +						   */
>  
>  	/* Generic flush handling.
>  	 * The last to finish preflush schedules a worker to submit
> -- 
> 2.12.2
> 


