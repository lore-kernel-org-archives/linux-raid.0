From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3 2/2] md/raid10: Refactor raid10_make_request
Date: Fri, 16 Dec 2016 11:59:51 -0800
Message-ID: <20161216195951.hprhmmruxactaxlw@kernel.org>
References: <20161205200258.6653-1-robert@leblancnet.us>
 <20161205200258.6653-3-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161205200258.6653-3-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 05, 2016 at 01:02:58PM -0700, Robert LeBlanc wrote:
> Refactor raid10_make_request into seperate read and write functions to
> clean up the code.

Merged the two patches, thanks!

For this one, you deleted the recovery check for read path, I added it back.
Please double check if the merged patch is good. The cleanup is supposed to not
change behavior, so next time if you change something (like the recovery
check), please do mention.

Thanks,
Shaohua

 
> Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
> ---
>  drivers/md/raid10.c | 215 +++++++++++++++++++++++++++-------------------------
>  1 file changed, 111 insertions(+), 104 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 525ca99..8698e00 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1087,23 +1087,97 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>  	kfree(plug);
>  }
>  
> -static void __make_request(struct mddev *mddev, struct bio *bio)
> +static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> +				struct r10bio *r10_bio)
>  {
>  	struct r10conf *conf = mddev->private;
> -	struct r10bio *r10_bio;
>  	struct bio *read_bio;
> +	const int op = bio_op(bio);
> +	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
> +	int sectors_handled;
> +	int max_sectors;
> +	struct md_rdev *rdev;
> +	int slot;
> +
> +	wait_barrier(conf);
> +
> +read_again:
> +	rdev = read_balance(conf, r10_bio, &max_sectors);
> +	if (!rdev) {
> +		raid_end_bio_io(r10_bio);
> +		return;
> +	}
> +	slot = r10_bio->read_slot;
> +
> +	read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
> +	bio_trim(read_bio, r10_bio->sector - bio->bi_iter.bi_sector,
> +		 max_sectors);
> +
> +	r10_bio->devs[slot].bio = read_bio;
> +	r10_bio->devs[slot].rdev = rdev;
> +
> +	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
> +		choose_data_offset(r10_bio, rdev);
> +	read_bio->bi_bdev = rdev->bdev;
> +	read_bio->bi_end_io = raid10_end_read_request;
> +	bio_set_op_attrs(read_bio, op, do_sync);
> +	if (test_bit(FailFast, &rdev->flags) &&
> +	    test_bit(R10BIO_FailFast, &r10_bio->state))
> +	        read_bio->bi_opf |= MD_FAILFAST;
> +	read_bio->bi_private = r10_bio;
> +
> +	if (mddev->gendisk)
> +	        trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
> +	                              read_bio, disk_devt(mddev->gendisk),
> +	                              r10_bio->sector);
> +	if (max_sectors < r10_bio->sectors) {
> +		/* Could not read all from this device, so we will
> +		 * need another r10_bio.
> +		 */
> +		sectors_handled = (r10_bio->sector + max_sectors
> +				   - bio->bi_iter.bi_sector);
> +		r10_bio->sectors = max_sectors;
> +		spin_lock_irq(&conf->device_lock);
> +		if (bio->bi_phys_segments == 0)
> +			bio->bi_phys_segments = 2;
> +		else
> +			bio->bi_phys_segments++;
> +		spin_unlock_irq(&conf->device_lock);
> +		/* Cannot call generic_make_request directly
> +		 * as that will be queued in __generic_make_request
> +		 * and subsequent mempool_alloc might block
> +		 * waiting for it.  so hand bio over to raid10d.
> +		 */
> +		reschedule_retry(r10_bio);
> +
> +		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
> +
> +		r10_bio->master_bio = bio;
> +		r10_bio->sectors = bio_sectors(bio) - sectors_handled;
> +		r10_bio->state = 0;
> +		r10_bio->mddev = mddev;
> +		r10_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
> +		goto read_again;
> +	} else
> +		generic_make_request(read_bio);
> +	return;
> +}
> +
> +static void raid10_write_request(struct mddev *mddev, struct bio *bio,
> +				 struct r10bio *r10_bio)
> +{
> +	struct r10conf *conf = mddev->private;
>  	int i;
>  	const int op = bio_op(bio);
> -	const int rw = bio_data_dir(bio);
>  	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
>  	const unsigned long do_fua = (bio->bi_opf & REQ_FUA);
>  	unsigned long flags;
>  	struct md_rdev *blocked_rdev;
>  	struct blk_plug_cb *cb;
>  	struct raid10_plug_cb *plug = NULL;
> +	sector_t sectors;
>  	int sectors_handled;
>  	int max_sectors;
> -	int sectors;
>  
>  	md_write_start(mddev, bio);
>  
> @@ -1130,7 +1204,6 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  		wait_barrier(conf);
>  	}
>  	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> -	    bio_data_dir(bio) == WRITE &&
>  	    (mddev->reshape_backwards
>  	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
>  		bio->bi_iter.bi_sector + sectors > conf->reshape_progress)
> @@ -1147,99 +1220,6 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  
>  		conf->reshape_safe = mddev->reshape_position;
>  	}
> -
> -	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
> -
> -	r10_bio->master_bio = bio;
> -	r10_bio->sectors = sectors;
> -
> -	r10_bio->mddev = mddev;
> -	r10_bio->sector = bio->bi_iter.bi_sector;
> -	r10_bio->state = 0;
> -
> -	/* We might need to issue multiple reads to different
> -	 * devices if there are bad blocks around, so we keep
> -	 * track of the number of reads in bio->bi_phys_segments.
> -	 * If this is 0, there is only one r10_bio and no locking
> -	 * will be needed when the request completes.  If it is
> -	 * non-zero, then it is the number of not-completed requests.
> -	 */
> -	bio->bi_phys_segments = 0;
> -	bio_clear_flag(bio, BIO_SEG_VALID);
> -
> -	if (rw == READ) {
> -		/*
> -		 * read balancing logic:
> -		 */
> -		struct md_rdev *rdev;
> -		int slot;
> -
> -read_again:
> -		rdev = read_balance(conf, r10_bio, &max_sectors);
> -		if (!rdev) {
> -			raid_end_bio_io(r10_bio);
> -			return;
> -		}
> -		slot = r10_bio->read_slot;
> -
> -		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
> -		bio_trim(read_bio, r10_bio->sector - bio->bi_iter.bi_sector,
> -			 max_sectors);
> -
> -		r10_bio->devs[slot].bio = read_bio;
> -		r10_bio->devs[slot].rdev = rdev;
> -
> -		read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
> -			choose_data_offset(r10_bio, rdev);
> -		read_bio->bi_bdev = rdev->bdev;
> -		read_bio->bi_end_io = raid10_end_read_request;
> -		bio_set_op_attrs(read_bio, op, do_sync);
> -		if (test_bit(FailFast, &rdev->flags) &&
> -		    test_bit(R10BIO_FailFast, &r10_bio->state))
> -			read_bio->bi_opf |= MD_FAILFAST;
> -		read_bio->bi_private = r10_bio;
> -
> -		if (mddev->gendisk)
> -			trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
> -					      read_bio, disk_devt(mddev->gendisk),
> -					      r10_bio->sector);
> -		if (max_sectors < r10_bio->sectors) {
> -			/* Could not read all from this device, so we will
> -			 * need another r10_bio.
> -			 */
> -			sectors_handled = (r10_bio->sector + max_sectors
> -					   - bio->bi_iter.bi_sector);
> -			r10_bio->sectors = max_sectors;
> -			spin_lock_irq(&conf->device_lock);
> -			if (bio->bi_phys_segments == 0)
> -				bio->bi_phys_segments = 2;
> -			else
> -				bio->bi_phys_segments++;
> -			spin_unlock_irq(&conf->device_lock);
> -			/* Cannot call generic_make_request directly
> -			 * as that will be queued in __generic_make_request
> -			 * and subsequent mempool_alloc might block
> -			 * waiting for it.  so hand bio over to raid10d.
> -			 */
> -			reschedule_retry(r10_bio);
> -
> -			r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
> -
> -			r10_bio->master_bio = bio;
> -			r10_bio->sectors = bio_sectors(bio) - sectors_handled;
> -			r10_bio->state = 0;
> -			r10_bio->mddev = mddev;
> -			r10_bio->sector = bio->bi_iter.bi_sector +
> -				sectors_handled;
> -			goto read_again;
> -		} else
> -			generic_make_request(read_bio);
> -		return;
> -	}
> -
> -	/*
> -	 * WRITE:
> -	 */
>  	if (conf->pending_count >= max_queued_requests) {
>  		md_wakeup_thread(mddev->thread);
>  		raid10_log(mddev, "wait queued");
> @@ -1300,8 +1280,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  			int bad_sectors;
>  			int is_bad;
>  
> -			is_bad = is_badblock(rdev, dev_sector,
> -					     max_sectors,
> +			is_bad = is_badblock(rdev, dev_sector, max_sectors,
>  					     &first_bad, &bad_sectors);
>  			if (is_bad < 0) {
>  				/* Mustn't write here until the bad block
> @@ -1405,8 +1384,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  			r10_bio->devs[i].bio = mbio;
>  
>  			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr+
> -					   choose_data_offset(r10_bio,
> -							      rdev));
> +					   choose_data_offset(r10_bio, rdev));
>  			mbio->bi_bdev = rdev->bdev;
>  			mbio->bi_end_io	= raid10_end_write_request;
>  			bio_set_op_attrs(mbio, op, do_sync | do_fua);
> @@ -1457,8 +1435,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  			r10_bio->devs[i].repl_bio = mbio;
>  
>  			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
> -					   choose_data_offset(
> -						   r10_bio, rdev));
> +					   choose_data_offset(r10_bio, rdev));
>  			mbio->bi_bdev = rdev->bdev;
>  			mbio->bi_end_io	= raid10_end_write_request;
>  			bio_set_op_attrs(mbio, op, do_sync | do_fua);
> @@ -1503,6 +1480,36 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  	one_write_done(r10_bio);
>  }
>  
> +static void __make_request(struct mddev *mddev, struct bio *bio)
> +{
> +	struct r10conf *conf = mddev->private;
> +	struct r10bio *r10_bio;
> +
> +	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
> +
> +	r10_bio->master_bio = bio;
> +	r10_bio->sectors = bio_sectors(bio);
> +
> +	r10_bio->mddev = mddev;
> +	r10_bio->sector = bio->bi_iter.bi_sector;
> +	r10_bio->state = 0;
> +
> +	/* We might need to issue multiple reads to different
> +	 * devices if there are bad blocks around, so we keep
> +	 * track of the number of reads in bio->bi_phys_segments.
> +	 * If this is 0, there is only one r10_bio and no locking
> +	 * will be needed when the request completes.  If it is
> +	 * non-zero, then it is the number of not-completed requests.
> +	 */
> +	bio->bi_phys_segments = 0;
> +	bio_clear_flag(bio, BIO_SEG_VALID);
> +
> +	if (bio_data_dir(bio) == READ)
> +		raid10_read_request(mddev, bio, r10_bio);
> +	else
> +		raid10_write_request(mddev, bio, r10_bio);
> +}
> +
>  static void raid10_make_request(struct mddev *mddev, struct bio *bio)
>  {
>  	struct r10conf *conf = mddev->private;
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
