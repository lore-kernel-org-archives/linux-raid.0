From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 1/2] md/raid1: Refactor raid1_make_request
Date: Thu, 1 Dec 2016 11:04:51 -0500
Message-ID: <22592.18979.608624.661894@quad.stoffel.home>
References: <20161130212020.15762-1-robert@leblancnet.us>
        <20161130212020.15762-2-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161130212020.15762-2-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Robert" == Robert LeBlanc <robert@leblancnet.us> writes:

Robert> Refactor raid1_make_request to make read and write code in their own
Robert> functions to clean up the code.

Robert> Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
Robert> ---
Robert>  drivers/md/raid1.c | 244 +++++++++++++++++++++++++++--------------------------
Robert>  1 file changed, 126 insertions(+), 118 deletions(-)

Robert> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
Robert> index 21dc00e..5aa0f89 100644
Robert> --- a/drivers/md/raid1.c
Robert> +++ b/drivers/md/raid1.c
Robert> @@ -1032,17 +1032,96 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
Robert>  	kfree(plug);
Robert>  }
 
Robert> -static void raid1_make_request(struct mddev *mddev, struct bio * bio)
Robert> +static void raid1_read_request(struct mddev *mddev, struct bio *bio,
Robert> +				 struct r1bio *r1_bio)
Robert>  {
Robert>  	struct r1conf *conf = mddev->private;
Robert>  	struct raid1_info *mirror;
Robert> -	struct r1bio *r1_bio;
Robert>  	struct bio *read_bio;
Robert> +	struct bitmap *bitmap = mddev->bitmap;
Robert> +	const int op = bio_op(bio);
Robert> +	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
Robert> +	int sectors_handled;
Robert> +	int max_sectors;
Robert> +	int rdisk;
Robert> +
Robert> +read_again:
Robert> +	rdisk = read_balance(conf, r1_bio, &max_sectors);
Robert> +
Robert> +	if (rdisk < 0) {
Robert> +		/* couldn't find anywhere to read from */
Robert> +		raid_end_bio_io(r1_bio);
Robert> +		return;
Robert> +	}
Robert> +	mirror = conf->mirrors + rdisk;
Robert> +
Robert> +	if (test_bit(WriteMostly, &mirror->rdev->flags) &&
Robert> +	    bitmap) {
Robert> +		/* Reading from a write-mostly device must
Robert> +		 * take care not to over-take any writes
Robert> +		 * that are 'behind'
Robert> +		 */
Robert> +		wait_event(bitmap->behind_wait,
Robert> +			   atomic_read(&bitmap->behind_writes) == 0);
Robert> +	}
Robert> +	r1_bio->read_disk = rdisk;
Robert> +	r1_bio->start_next_window = 0;
Robert> +
Robert> +	read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
Robert> +	bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
Robert> +		 max_sectors);
Robert> +
Robert> +	r1_bio->bios[rdisk] = read_bio;
Robert> +
Robert> +	read_bio->bi_iter.bi_sector = r1_bio->sector +
Robert> +		mirror->rdev->data_offset;
Robert> +	read_bio->bi_bdev = mirror->rdev->bdev;
Robert> +	read_bio->bi_end_io = raid1_end_read_request;
Robert> +	bio_set_op_attrs(read_bio, op, do_sync);
Robert> +	read_bio->bi_private = r1_bio;
Robert> +
Robert> +	if (max_sectors < r1_bio->sectors) {
Robert> +		/* could not read all from this device, so we will
Robert> +		 * need another r1_bio.
Robert> +		 */
Robert> +
Robert> +		sectors_handled = (r1_bio->sector + max_sectors
Robert> +				   - bio->bi_iter.bi_sector);
Robert> +		r1_bio->sectors = max_sectors;
Robert> +		spin_lock_irq(&conf->device_lock);
Robert> +		if (bio->bi_phys_segments == 0)
Robert> +			bio->bi_phys_segments = 2;
Robert> +		else
Robert> +			bio->bi_phys_segments++;
Robert> +		spin_unlock_irq(&conf->device_lock);
Robert> +		/* Cannot call generic_make_request directly
Robert> +		 * as that will be queued in __make_request
Robert> +		 * and subsequent mempool_alloc might block waiting
Robert> +		 * for it.  So hand bio over to raid1d.
Robert> +		 */
Robert> +		reschedule_retry(r1_bio);
Robert> +
Robert> +		r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
Robert> +
Robert> +		r1_bio->master_bio = bio;
Robert> +		r1_bio->sectors = bio_sectors(bio) - sectors_handled;
Robert> +		r1_bio->state = 0;
Robert> +		r1_bio->mddev = mddev;
Robert> +		r1_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
Robert> +		goto read_again;
Robert> +	} else
Robert> +		generic_make_request(read_bio);
Robert> +}
Robert> +
Robert> +static void raid1_write_request(struct mddev *mddev, struct bio *bio,
Robert> +				struct r1bio *r1_bio,
Robert> +				sector_t start_next_window)
Robert> +{
Robert> +	struct r1conf *conf = mddev->private;
Robert>  	int i, disks;
Robert> -	struct bitmap *bitmap;
Robert> +	struct bitmap *bitmap = mddev->bitmap;
Robert>  	unsigned long flags;
Robert>  	const int op = bio_op(bio);
Robert> -	const int rw = bio_data_dir(bio);
Robert>  	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
Robert>  	const unsigned long do_flush_fua = (bio->bi_opf &
Robert>  						(REQ_PREFLUSH | REQ_FUA));
Robert> @@ -1052,7 +1131,6 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
Robert>  	int first_clone;
Robert>  	int sectors_handled;
Robert>  	int max_sectors;
Robert> -	sector_t start_next_window;
 
Robert>  	/*
Robert>  	 * Register the new request and wait if the reconstruction
Robert> @@ -1062,12 +1140,11 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 
Robert>  	md_write_start(mddev, bio); /* wait on superblock update early */
 
Robert> -	if (bio_data_dir(bio) == WRITE &&
Robert> -	    ((bio_end_sector(bio) > mddev->suspend_lo &&
Robert> +	if ((bio_end_sector(bio) > mddev->suspend_lo &&
bio-> bi_iter.bi_sector < mddev->suspend_hi) ||
Robert>  	    (mddev_is_clustered(mddev) &&
md_cluster_ops-> area_resyncing(mddev, WRITE,
Robert> -		     bio->bi_iter.bi_sector, bio_end_sector(bio))))) {
Robert> +		     bio->bi_iter.bi_sector, bio_end_sector(bio)))) {
Robert>  		/* As the suspend_* range is controlled by
Robert>  		 * userspace, we want an interruptible
Robert>  		 * wait.
Robert> @@ -1081,119 +1158,14 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
bio-> bi_iter.bi_sector >= mddev->suspend_hi ||
Robert>  			    (mddev_is_clustered(mddev) &&
Robert>  			     !md_cluster_ops->area_resyncing(mddev, WRITE,
Robert> -				     bio->bi_iter.bi_sector, bio_end_sector(bio))))
Robert> +				     bio->bi_iter.bi_sector,
Robert> +				     bio_end_sector(bio))))
Robert>  				break;
Robert>  			schedule();
Robert>  		}
Robert>  		finish_wait(&conf->wait_barrier, &w);
Robert>  	}
 
Robert> -	start_next_window = wait_barrier(conf, bio);
Robert> -
Robert> -	bitmap = mddev->bitmap;
Robert> -
Robert> -	/*
Robert> -	 * make_request() can abort the operation when read-ahead is being
Robert> -	 * used and no empty request is available.
Robert> -	 *
Robert> -	 */
Robert> -	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
Robert> -
Robert> -	r1_bio->master_bio = bio;
Robert> -	r1_bio->sectors = bio_sectors(bio);
Robert> -	r1_bio->state = 0;
Robert> -	r1_bio->mddev = mddev;
Robert> -	r1_bio->sector = bio->bi_iter.bi_sector;
Robert> -
Robert> -	/* We might need to issue multiple reads to different
Robert> -	 * devices if there are bad blocks around, so we keep
Robert> -	 * track of the number of reads in bio->bi_phys_segments.
Robert> -	 * If this is 0, there is only one r1_bio and no locking
Robert> -	 * will be needed when requests complete.  If it is
Robert> -	 * non-zero, then it is the number of not-completed requests.
Robert> -	 */
Robert> -	bio->bi_phys_segments = 0;
Robert> -	bio_clear_flag(bio, BIO_SEG_VALID);
Robert> -
Robert> -	if (rw == READ) {
Robert> -		/*
Robert> -		 * read balancing logic:
Robert> -		 */
Robert> -		int rdisk;
Robert> -
Robert> -read_again:
Robert> -		rdisk = read_balance(conf, r1_bio, &max_sectors);
Robert> -
Robert> -		if (rdisk < 0) {
Robert> -			/* couldn't find anywhere to read from */
Robert> -			raid_end_bio_io(r1_bio);
Robert> -			return;
Robert> -		}
Robert> -		mirror = conf->mirrors + rdisk;
Robert> -
Robert> -		if (test_bit(WriteMostly, &mirror->rdev->flags) &&
Robert> -		    bitmap) {
Robert> -			/* Reading from a write-mostly device must
Robert> -			 * take care not to over-take any writes
Robert> -			 * that are 'behind'
Robert> -			 */
Robert> -			wait_event(bitmap->behind_wait,
Robert> -				   atomic_read(&bitmap->behind_writes) == 0);
Robert> -		}
Robert> -		r1_bio->read_disk = rdisk;
Robert> -		r1_bio->start_next_window = 0;
Robert> -
Robert> -		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
Robert> -		bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
Robert> -			 max_sectors);
Robert> -
Robert> -		r1_bio->bios[rdisk] = read_bio;
Robert> -
Robert> -		read_bio->bi_iter.bi_sector = r1_bio->sector +
Robert> -			mirror->rdev->data_offset;
Robert> -		read_bio->bi_bdev = mirror->rdev->bdev;
Robert> -		read_bio->bi_end_io = raid1_end_read_request;
Robert> -		bio_set_op_attrs(read_bio, op, do_sync);
Robert> -		read_bio->bi_private = r1_bio;
Robert> -
Robert> -		if (max_sectors < r1_bio->sectors) {
Robert> -			/* could not read all from this device, so we will
Robert> -			 * need another r1_bio.
Robert> -			 */
Robert> -
Robert> -			sectors_handled = (r1_bio->sector + max_sectors
Robert> -					   - bio->bi_iter.bi_sector);
Robert> -			r1_bio->sectors = max_sectors;
Robert> -			spin_lock_irq(&conf->device_lock);
Robert> -			if (bio->bi_phys_segments == 0)
Robert> -				bio->bi_phys_segments = 2;
Robert> -			else
Robert> -				bio->bi_phys_segments++;
Robert> -			spin_unlock_irq(&conf->device_lock);
Robert> -			/* Cannot call generic_make_request directly
Robert> -			 * as that will be queued in __make_request
Robert> -			 * and subsequent mempool_alloc might block waiting
Robert> -			 * for it.  So hand bio over to raid1d.
Robert> -			 */
Robert> -			reschedule_retry(r1_bio);
Robert> -
Robert> -			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
Robert> -
Robert> -			r1_bio->master_bio = bio;
Robert> -			r1_bio->sectors = bio_sectors(bio) - sectors_handled;
Robert> -			r1_bio->state = 0;
Robert> -			r1_bio->mddev = mddev;
Robert> -			r1_bio->sector = bio->bi_iter.bi_sector +
Robert> -				sectors_handled;
Robert> -			goto read_again;
Robert> -		} else
Robert> -			generic_make_request(read_bio);
Robert> -		return;
Robert> -	}
Robert> -
Robert> -	/*
Robert> -	 * WRITE:
Robert> -	 */
Robert>  	if (conf->pending_count >= max_queued_requests) {
Robert>  		md_wakeup_thread(mddev->thread);
Robert>  		wait_event(conf->wait_barrier,
Robert> @@ -1236,8 +1208,7 @@ read_again:
Robert>  			int bad_sectors;
Robert>  			int is_bad;
 
Robert> -			is_bad = is_badblock(rdev, r1_bio->sector,
Robert> -					     max_sectors,
Robert> +			is_bad = is_badblock(rdev, r1_bio->sector, max_sectors,
Robert>  					     &first_bad, &bad_sectors);
Robert>  			if (is_bad < 0) {
Robert>  				/* mustn't write here until the bad block is
Robert> @@ -1325,7 +1296,8 @@ read_again:
Robert>  			continue;
 
Robert>  		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
Robert> -		bio_trim(mbio, r1_bio->sector - bio->bi_iter.bi_sector, max_sectors);
Robert> +		bio_trim(mbio, r1_bio->sector - bio->bi_iter.bi_sector,
Robert> +			 max_sectors);
 
Robert>  		if (first_clone) {
Robert>  			/* do behind I/O ?
Robert> @@ -1408,6 +1380,42 @@ read_again:
Robert>  	wake_up(&conf->wait_barrier);
Robert>  }
 
Robert> +static void raid1_make_request(struct mddev *mddev, struct bio *bio)
Robert> +{
Robert> +	struct r1conf *conf = mddev->private;
Robert> +	struct r1bio *r1_bio;
Robert> +	sector_t start_next_window = wait_barrier(conf, bio);
Robert> +
Robert> +	/*
Robert> +	 * make_request() can abort the operation when read-ahead is being
Robert> +	 * used and no empty request is available.
Robert> +	 *
Robert> +	 */
Robert> +	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
Robert> +
Robert> +	r1_bio->master_bio = bio;
Robert> +	r1_bio->sectors = bio_sectors(bio);
Robert> +	r1_bio->state = 0;
Robert> +	r1_bio->mddev = mddev;
Robert> +	r1_bio->sector = bio->bi_iter.bi_sector;
Robert> +
Robert> +	/* We might need to issue multiple reads to different
Robert> +	 * devices if there are bad blocks around, so we keep
Robert> +	 * track of the number of reads in bio->bi_phys_segments.
Robert> +	 * If this is 0, there is only one r1_bio and no locking
Robert> +	 * will be needed when requests complete.  If it is
Robert> +	 * non-zero, then it is the number of not-completed requests.
Robert> +	 */
Robert> +	bio->bi_phys_segments = 0;
Robert> +	bio_clear_flag(bio, BIO_SEG_VALID);
Robert> +
Robert> +	if (bio_data_dir(bio) == READ) {
Robert> +		raid1_read_request(mddev, bio, r1_bio);
Robert> +		return;
Robert> +	}
Robert> +	raid1_write_request(mddev, bio, r1_bio, start_next_window);
Robert> +}

Maybe this is pedantic, but why not have an 'else' instead of the
return to make it more clear?  If someone (like me :-) missed the
return on the quick read through, it's going to be some confusion.

if (bio_data_dir(bio) == READ)
   raid1_read_request(mddev, bui, r1_bio);
else
   raid1_write_request(mddev, bio, r1_bio, start_next_window);

seems cleaner.

Also, why are the calls different with the start_next_window parameter
added in?  Sorry for being dense, trying to understand the code
better...

John
