From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 2/2] md/raid10: Refactor raid10_make_request
Date: Fri, 2 Dec 2016 14:02:24 -0800
Message-ID: <20161202220224.ls2ppnjzl66psrnp@kernel.org>
References: <20161130212020.15762-1-robert@leblancnet.us>
 <20161202033008.30314-1-robert@leblancnet.us>
 <20161202033008.30314-3-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161202033008.30314-3-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 01, 2016 at 08:30:08PM -0700, Robert LeBlanc wrote:
> Refactor raid10_make_request into seperate read and write functions to
> clean up the code.
> 
> Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
> ---

Hi,

could you please resend the patches against my for-next branch? The two patches
don't apply.

>  			int bad_sectors;
>  			int is_bad;
>  
> -			is_bad = is_badblock(rdev, dev_sector,
> -					     max_sectors,
> +			is_bad = is_badblock(rdev, dev_sector, max_sectors,
>  					     &first_bad, &bad_sectors);
>  			if (is_bad < 0) {
>  				/* Mustn't write here until the bad block
> @@ -1353,8 +1291,7 @@ retry_write:
>  			r10_bio->devs[i].bio = mbio;
>  
>  			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr+
> -					   choose_data_offset(r10_bio,
> -							      rdev));
> +					   choose_data_offset(r10_bio, rdev));
>  			mbio->bi_bdev = rdev->bdev;
>  			mbio->bi_end_io	= raid10_end_write_request;
>  			bio_set_op_attrs(mbio, op, do_sync | do_fua);
> @@ -1395,8 +1332,7 @@ retry_write:
>  			r10_bio->devs[i].repl_bio = mbio;
>  
>  			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
> -					   choose_data_offset(
> -						   r10_bio, rdev));
> +					   choose_data_offset(r10_bio, rdev));
>  			mbio->bi_bdev = rdev->bdev;
>  			mbio->bi_end_io	= raid10_end_write_request;
>  			bio_set_op_attrs(mbio, op, do_sync | do_fua);
> @@ -1434,6 +1370,77 @@ retry_write:
>  	one_write_done(r10_bio);
>  }
>  
> +static void __make_request(struct mddev *mddev, struct bio *bio)
> +{
> +	struct r10conf *conf = mddev->private;
> +	struct r10bio *r10_bio;
> +	int sectors;
> +

we do wait_barrier before md_write_start now. I'm not confortable with this.
Could you please add md_write_start here? A single line of code for write here
doesn't matter.

> +	/*
> +	 * Register the new request and wait if the reconstruction
> +	 * thread has put up a bar for new requests.
> +	 * Continue immediately if no resync is active currently.
> +	 */
> +	wait_barrier(conf);
> +
> +	sectors = bio_sectors(bio);
> +	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +	    bio->bi_iter.bi_sector < conf->reshape_progress &&
> +	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
> +		/* IO spans the reshape position.  Need to wait for
> +		 * reshape to pass
> +		 */
> +		allow_barrier(conf);
> +		wait_event(conf->wait_barrier,
> +			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
> +			   conf->reshape_progress >= bio->bi_iter.bi_sector +
> +			   sectors);
> +		wait_barrier(conf);
> +	}
> +	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +	    bio_data_dir(bio) == WRITE &&
> +	    (mddev->reshape_backwards
> +	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
> +		bio->bi_iter.bi_sector + sectors > conf->reshape_progress)
> +	     : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
> +		bio->bi_iter.bi_sector < conf->reshape_progress))) {
> +		/* Need to update reshape_position in metadata */
> +		mddev->reshape_position = conf->reshape_progress;
> +		set_mask_bits(&mddev->flags, 0,
> +			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
> +		md_wakeup_thread(mddev->thread);
> +		wait_event(mddev->sb_wait,
> +			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> +
> +		conf->reshape_safe = mddev->reshape_position;
> +	}

this is write only and could be moved to write path.

> +
> +	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
> +
> +	r10_bio->master_bio = bio;
> +	r10_bio->sectors = sectors;
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
> +	if (bio_data_dir(bio) == READ) {
> +		raid10_read_request(mddev, bio, r10_bio);
> +		return;
> +	}
Better do the same as raid1 here.

> +	raid10_write_request(mddev, bio, r10_bio);
> +}


Thanks,
Shaohua
