From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC PATCH] md/raid10: refactor some codes from
 raid10_write_request
Date: Tue, 14 Mar 2017 09:48:36 -0700
Message-ID: <20170314164836.mekttgqcw4smsgsw@kernel.org>
References: <1489397039-3353-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489397039-3353-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com
List-Id: linux-raid.ids

On Mon, Mar 13, 2017 at 05:23:59PM +0800, Guoqing Jiang wrote:
> Previously, we clone both bio and repl_bio in raid10_write_request,
> then add the cloned bio to plug->pending or conf->pending_bio_list
> based on plug or not, and most of the logics are same for the two
> conditions.
> 
> So introduce handle_clonebio (a better name is welcome) for it, and
> use replacement parameter to distinguish the difference. No functional
> changes in the patch.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> Another reason for it is to improve the readability of code, but
> I didn't touch raid10 before so this is labeled as RFC.
> 
>  drivers/md/raid10.c | 172 ++++++++++++++++++++++------------------------------
>  1 file changed, 72 insertions(+), 100 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b1b1f982a722..02d8eff8d26e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1188,18 +1188,81 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>  	return;
>  }
>  
> -static void raid10_write_request(struct mddev *mddev, struct bio *bio,
> -				 struct r10bio *r10_bio)
> +static void handle_clonebio(struct mddev *mddev, struct r10bio *r10_bio,
> +			    struct bio *bio, int i, int replacement,
> +			    int max_sectors)

Maybe raid10_write_one_disk? Please replace 'i' with a meaningful name and
change to 'boo' for replacement.

>  {
> -	struct r10conf *conf = mddev->private;
> -	int i;
>  	const int op = bio_op(bio);
>  	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
>  	const unsigned long do_fua = (bio->bi_opf & REQ_FUA);
>  	unsigned long flags;
> -	struct md_rdev *blocked_rdev;
>  	struct blk_plug_cb *cb;
>  	struct raid10_plug_cb *plug = NULL;
> +	struct r10conf *conf = mddev->private;
> +	struct md_rdev *rdev;
> +	int devnum = r10_bio->devs[i].devnum;
> +	struct bio *mbio;
> +
> +	if (replacement) {
> +		rdev = conf->mirrors[devnum].replacement;
> +		if (rdev == NULL) {
> +			/* Replacement just got moved to main 'rdev' */
> +			smp_mb();
> +			rdev = conf->mirrors[devnum].rdev;
> +		}
> +	} else
> +		rdev = conf->mirrors[devnum].rdev;
> +
> +	mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
> +	bio_trim(mbio, r10_bio->sector - bio->bi_iter.bi_sector, max_sectors);
> +	if (replacement)
> +		r10_bio->devs[i].repl_bio = mbio;
> +	else
> +		r10_bio->devs[i].bio = mbio;
> +
> +	mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
> +				   choose_data_offset(r10_bio, rdev));
> +	mbio->bi_bdev = rdev->bdev;
> +	mbio->bi_end_io	= raid10_end_write_request;
> +	bio_set_op_attrs(mbio, op, do_sync | do_fua);
> +	if (!replacement && test_bit(FailFast, &conf->mirrors[devnum].rdev->flags)
> +			 && enough(conf, devnum))
> +		mbio->bi_opf |= MD_FAILFAST;
> +	mbio->bi_private = r10_bio;
> +
> +	if (conf->mddev->gendisk)
> +		trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
> +				      mbio, disk_devt(conf->mddev->gendisk),
> +				      r10_bio->sector);
> +	/* flush_pending_writes() needs access to the rdev so...*/
> +	mbio->bi_bdev = (void *)rdev;
> +
> +	atomic_inc(&r10_bio->remaining);
> +
> +	cb = blk_check_plugged(raid10_unplug, mddev, sizeof(*plug));
> +	if (cb)
> +		plug = container_of(cb, struct raid10_plug_cb, cb);
> +	else
> +		plug = NULL;
> +	spin_lock_irqsave(&conf->device_lock, flags);
> +	if (plug) {
> +		bio_list_add(&plug->pending, mbio);
> +		plug->pending_cnt++;
> +	} else {
> +		bio_list_add(&conf->pending_bio_list, mbio);
> +		conf->pending_count++;
> +	}
> +	spin_unlock_irqrestore(&conf->device_lock, flags);
> +	if (!plug)
> +		md_wakeup_thread(mddev->thread);
> +}
> +
> +static void raid10_write_request(struct mddev *mddev, struct bio *bio,
> +				 struct r10bio *r10_bio)
> +{
> +	struct r10conf *conf = mddev->private;
> +	int i;
> +	struct md_rdev *blocked_rdev;
>  	sector_t sectors;
>  	int sectors_handled;
>  	int max_sectors;
> @@ -1402,101 +1465,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
>  	bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
>  
>  	for (i = 0; i < conf->copies; i++) {
> -		struct bio *mbio;
> -		int d = r10_bio->devs[i].devnum;
> -		if (r10_bio->devs[i].bio) {
> -			struct md_rdev *rdev = conf->mirrors[d].rdev;
> -			mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
> -			bio_trim(mbio, r10_bio->sector - bio->bi_iter.bi_sector,
> -				 max_sectors);
> -			r10_bio->devs[i].bio = mbio;
> -
> -			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr+
> -					   choose_data_offset(r10_bio, rdev));
> -			mbio->bi_bdev = rdev->bdev;
> -			mbio->bi_end_io	= raid10_end_write_request;
> -			bio_set_op_attrs(mbio, op, do_sync | do_fua);
> -			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags) &&
> -			    enough(conf, d))
> -				mbio->bi_opf |= MD_FAILFAST;
> -			mbio->bi_private = r10_bio;
> -
> -			if (conf->mddev->gendisk)
> -				trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
> -						      mbio, disk_devt(conf->mddev->gendisk),
> -						      r10_bio->sector);
> -			/* flush_pending_writes() needs access to the rdev so...*/
> -			mbio->bi_bdev = (void*)rdev;
> -
> -			atomic_inc(&r10_bio->remaining);
> -
> -			cb = blk_check_plugged(raid10_unplug, mddev,
> -					       sizeof(*plug));
> -			if (cb)
> -				plug = container_of(cb, struct raid10_plug_cb,
> -						    cb);
> -			else
> -				plug = NULL;
> -			spin_lock_irqsave(&conf->device_lock, flags);
> -			if (plug) {
> -				bio_list_add(&plug->pending, mbio);
> -				plug->pending_cnt++;
> -			} else {
> -				bio_list_add(&conf->pending_bio_list, mbio);
> -				conf->pending_count++;
> -			}
> -			spin_unlock_irqrestore(&conf->device_lock, flags);
> -			if (!plug)
> -				md_wakeup_thread(mddev->thread);
> -		}
> -
> -		if (r10_bio->devs[i].repl_bio) {
> -			struct md_rdev *rdev = conf->mirrors[d].replacement;
> -			if (rdev == NULL) {
> -				/* Replacement just got moved to main 'rdev' */
> -				smp_mb();
> -				rdev = conf->mirrors[d].rdev;
> -			}
> -			mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
> -			bio_trim(mbio, r10_bio->sector - bio->bi_iter.bi_sector,
> -				 max_sectors);
> -			r10_bio->devs[i].repl_bio = mbio;
> -
> -			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
> -					   choose_data_offset(r10_bio, rdev));
> -			mbio->bi_bdev = rdev->bdev;
> -			mbio->bi_end_io	= raid10_end_write_request;
> -			bio_set_op_attrs(mbio, op, do_sync | do_fua);
> -			mbio->bi_private = r10_bio;
> -
> -			if (conf->mddev->gendisk)
> -				trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
> -						      mbio, disk_devt(conf->mddev->gendisk),
> -						      r10_bio->sector);
> -			/* flush_pending_writes() needs access to the rdev so...*/
> -			mbio->bi_bdev = (void*)rdev;
> -
> -			atomic_inc(&r10_bio->remaining);
> -
> -			cb = blk_check_plugged(raid10_unplug, mddev,
> -					       sizeof(*plug));
> -			if (cb)
> -				plug = container_of(cb, struct raid10_plug_cb,
> -						    cb);
> -			else
> -				plug = NULL;
> -			spin_lock_irqsave(&conf->device_lock, flags);
> -			if (plug) {
> -				bio_list_add(&plug->pending, mbio);
> -				plug->pending_cnt++;
> -			} else {
> -				bio_list_add(&conf->pending_bio_list, mbio);
> -				conf->pending_count++;
> -			}
> -			spin_unlock_irqrestore(&conf->device_lock, flags);
> -			if (!plug)
> -				md_wakeup_thread(mddev->thread);
> -		}
> +		if (r10_bio->devs[i].bio)
> +			handle_clonebio(mddev, r10_bio, bio, i, 0, max_sectors);
> +		if (r10_bio->devs[i].repl_bio)
> +			handle_clonebio(mddev, r10_bio, bio, i, 1, max_sectors);
>  	}
>  
>  	/* Don't remove the bias on 'remaining' (one_write_done) until
> -- 
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
