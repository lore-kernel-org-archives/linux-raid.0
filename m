From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 16/36] md/raid1: factor several functions out or raid1d()
Date: Thu, 28 Jul 2011 00:55:41 +0900
Message-ID: <8762mnn2f6.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025849.8422.88896.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025849.8422.88896.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:49 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> raid1d is too big with several deep branches.
> So separate them out into their own functions.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

with some whitespace changes below..


> ---
>
>  drivers/md/raid1.c |  318 ++++++++++++++++++++++++++--------------------------
>  1 files changed, 159 insertions(+), 159 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 08ff21a..d7518dc 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1862,21 +1862,168 @@ static int narrow_write_error(r1bio_t *r1_bio, int i)
>  	return ok;
>  }
>  
> +static void handle_sync_write_finished(conf_t *conf, r1bio_t *r1_bio)
> +{
> +	int m;
> +	int s = r1_bio->sectors;
> +	for (m = 0; m < conf->raid_disks ; m++) {
> +		mdk_rdev_t *rdev = conf->mirrors[m].rdev;
> +		struct bio *bio = r1_bio->bios[m];
> +		if (bio->bi_end_io == NULL)
> +			continue;
> +		if (test_bit(BIO_UPTODATE, &bio->bi_flags) &&
> +		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
> +			rdev_clear_badblocks(rdev,
> +					     r1_bio->sector,
> +					     r1_bio->sectors);
			rdev_clear_badblocks(rdev, r1_bio->sector, s);

> +		}
> +		if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
> +		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
> +			if (!rdev_set_badblocks(rdev,
> +						r1_bio->sector,
> +						r1_bio->sectors, 0))
			if (!rdev_set_badblocks(rdev, r1_bio->sector, s, 0))

> +				md_error(conf->mddev, rdev);
> +		}
> +	}
> +	put_buf(r1_bio);
> +	md_done_sync(conf->mddev, s, 1);
> +}
> +
> +static void handle_write_finished(conf_t *conf, r1bio_t *r1_bio)
> +{
> +	int m;
> +	for (m = 0; m < conf->raid_disks ; m++)
> +		if (r1_bio->bios[m] == IO_MADE_GOOD) {
> +			mdk_rdev_t *rdev = conf->mirrors[m].rdev;
> +			rdev_clear_badblocks(rdev,
> +					     r1_bio->sector,
> +					     r1_bio->sectors);
> +			rdev_dec_pending(rdev, conf->mddev);
> +		} else if (r1_bio->bios[m] != NULL) {
> +			/* This drive got a write error.  We need to
> +			 * narrow down and record precise write
> +			 * errors.
> +			 */
> +			if (!narrow_write_error(r1_bio, m)) {
> +				md_error(conf->mddev,
> +					 conf->mirrors[m].rdev);
> +				/* an I/O failed, we can't clear the bitmap */
> +				set_bit(R1BIO_Degraded, &r1_bio->state);
> +			}
> +			rdev_dec_pending(conf->mirrors[m].rdev,
> +					 conf->mddev);
> +		}
> +	if (test_bit(R1BIO_WriteError, &r1_bio->state))
> +		close_write(r1_bio);
> +	raid_end_bio_io(r1_bio);
> +}
> +
> +static void handle_read_error(conf_t *conf, r1bio_t *r1_bio)
> +{
> +	int disk;
> +	int max_sectors;
> +	mddev_t *mddev = conf->mddev;
> +	struct bio *bio;
> +	char b[BDEVNAME_SIZE];
> +	mdk_rdev_t *rdev;
> +
> +	clear_bit(R1BIO_ReadError, &r1_bio->state);
> +	/* we got a read error. Maybe the drive is bad.  Maybe just
> +	 * the block and we can fix it.
> +	 * We freeze all other IO, and try reading the block from
> +	 * other devices.  When we find one, we re-write
> +	 * and check it that fixes the read error.
> +	 * This is all done synchronously while the array is
> +	 * frozen
> +	 */
> +	if (mddev->ro == 0) {
> +		freeze_array(conf);
> +		fix_read_error(conf, r1_bio->read_disk,
> +			       r1_bio->sector,
> +			       r1_bio->sectors);
			       r1_bio->sector, r1_bio->sectors);

> +		unfreeze_array(conf);
> +	} else
> +		md_error(mddev,
> +			 conf->mirrors[r1_bio->read_disk].rdev);
> +
> +	bio = r1_bio->bios[r1_bio->read_disk];
> +	bdevname(bio->bi_bdev, b);
> +read_more:
> +	disk = read_balance(conf, r1_bio, &max_sectors);
> +	if (disk == -1) {
> +		printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
> +		       " read error for block %llu\n",
> +		       mdname(mddev), b,
> +		       (unsigned long long)r1_bio->sector);
> +		raid_end_bio_io(r1_bio);
> +	} else {
> +		const unsigned long do_sync
> +			= r1_bio->master_bio->bi_rw & REQ_SYNC;
> +		if (bio) {
> +			r1_bio->bios[r1_bio->read_disk] =
> +				mddev->ro ? IO_BLOCKED : NULL;
> +			bio_put(bio);
> +		}
> +		r1_bio->read_disk = disk;
> +		bio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
> +		md_trim_bio(bio,
> +			    r1_bio->sector - bio->bi_sector,
> +			    max_sectors);
		md_trim_bio(bio, r1_bio->sector - bio->bi_sector, max_sectors);

Thanks.
