From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3] md/r5cache: gracefully handle journal device errors
 for writeback mode
Date: Thu, 27 Apr 2017 17:19:58 -0700
Message-ID: <20170428001855.e4xzgxhwvbnuw6mr@kernel.org>
References: <20170427054302.3363710-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170427054302.3363710-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Wed, Apr 26, 2017 at 10:43:02PM -0700, Song Liu wrote:
> For the raid456 with writeback cache, when journal device failed during
> normal operation, it is still possible to persist all data, as all
> pending data is still in stripe cache. However, it is necessary to handle
> journal failure gracefully.
> 
> During journal failures, this patch makes the follow changes to land data
> in cache to raid disks gracefully:
> 
> 1. In raid5_remove_disk(), flush all cached stripes;
> 2. In handle_stripe(), allow stripes with data in journal (s.injournal > 0)
>    to make progress;
> 3. In delay_towrite(), only process data in the cache (skip dev->towrite);
> 4. In __get_priority_stripe(), set try_loprio to true, so no stripe stuck
>    in loprio_list
> 5. In r5l_do_submit_io(), submit io->split_bio first (see inline comments
>    for details).
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 27 ++++++++++++++++++---------
>  drivers/md/raid5.c       | 37 +++++++++++++++++++++++++++++++------
>  2 files changed, 49 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index b6194e0..6b922d3 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -632,20 +632,29 @@ static void r5l_do_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
>  	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
>  	spin_unlock_irqrestore(&log->io_list_lock, flags);
>  
> +	/*
> +	 * In case of journal device failures, submit_bio will get error
> +	 * and calls endio, then active stripes will continue write
> +	 * process. Therefore, it is not necessary to check Faulty bit
> +	 * of journal device here.
> +	 *
> +	 * However, calling r5l_log_endio for current_bio may free the
> +	 * io_unit. Therefore, it is necessary to check io->split_bio
> +	 * before submitting io->current_bio.
> +	 */
> +	if (io->split_bio) {
> +		if (io->has_flush)
> +			io->split_bio->bi_opf |= REQ_PREFLUSH;
> +		if (io->has_fua)
> +			io->split_bio->bi_opf |= REQ_FUA;
> +		submit_bio(io->split_bio);
> +	}

So this could happen even there is no IO error if the bio finishes very fast.
Nice catch!

>  	if (io->has_flush)
>  		io->current_bio->bi_opf |= REQ_PREFLUSH;
>  	if (io->has_fua)
>  		io->current_bio->bi_opf |= REQ_FUA;
>  	submit_bio(io->current_bio);
> -
> -	if (!io->split_bio)
> -		return;
> -
> -	if (io->has_flush)
> -		io->split_bio->bi_opf |= REQ_PREFLUSH;
> -	if (io->has_fua)
> -		io->split_bio->bi_opf |= REQ_FUA;
> -	submit_bio(io->split_bio);
>  }
>  
>  /* deferred io_unit will be dispatched here */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 356cd9c..2fb67c2 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -234,10 +234,12 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>  			if (test_bit(R5_InJournal, &sh->dev[i].flags))
>  				injournal++;
>  	/*
> -	 * When quiesce in r5c write back, set STRIPE_HANDLE for stripes with
> -	 * data in journal, so they are not released to cached lists
> +	 * With writeback journal, stripes with data in the journal are
> +	 * released to cached lists. However, when journal device is
> +	 * failed or in quiesce, these stripes need to be handled now.
>  	 */
> -	if (conf->quiesce && r5c_is_writeback(conf->log) &&
> +	if ((conf->quiesce || r5l_log_disk_error(conf)) &&
> +	    r5c_is_writeback(conf->log) &&

r5c_update_on_rdev_error() will switch log to write through, so we might miss
some stripes here. This brings a question. Should r5c_disable_writeback_async()
wait all stripe flushed and then switch to write through? mddev_suspend()
doesn't wait for stripe with cache, it only waits for normal IO. Waitting for
all stripes flushed and then switching to write through sounds more reasonable
to me.

>  	    !test_bit(STRIPE_HANDLE, &sh->state) && injournal != 0) {
>  		if (test_bit(STRIPE_R5C_CACHING, &sh->state))
>  			r5c_make_stripe_write_out(sh);
> @@ -2694,6 +2696,15 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
>  		bdevname(rdev->bdev, b),
>  		mdname(mddev),
>  		conf->raid_disks - mddev->degraded);
> +
> +	if (test_bit(Journal, &rdev->flags) && r5c_is_writeback(conf->log)) {
> +		pr_warn("md/raid:%s: Journal device failed. Flushing data in the writeback cache.",
> +			mdname(mddev));
> +		spin_lock_irqsave(&conf->device_lock, flags);
> +		r5c_flush_cache(conf, INT_MAX);
> +		spin_unlock_irqrestore(&conf->device_lock, flags);
> +	}

I'd suggest moving this to r5c_disable_writeback_async(). We don't do too much
in raid5_error.

>  	r5c_update_on_rdev_error(mddev);
>  }
>  
> @@ -3055,6 +3066,11 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
>   *      When LOG_CRITICAL, stripes with injournal == 0 will be sent to
>   *      no_space_stripes list.
>   *
> + *   3. during journal failure
> + *      In journal failure, we try to flush all cached data to raid disks
> + *      based on data in stripe cache. The array is read-only to upper
> + *      layers, so we would skip all pending writes.
> + *
>   */
>  static inline bool delay_towrite(struct r5conf *conf,
>  				 struct r5dev *dev,
> @@ -3068,6 +3084,9 @@ static inline bool delay_towrite(struct r5conf *conf,
>  	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
>  	    s->injournal > 0)
>  		return true;
> +	/* case 3 above */
> +	if (s->log_failed && s->injournal)
> +		return true;
>  	return false;
>  }
>  
> @@ -4701,10 +4720,15 @@ static void handle_stripe(struct stripe_head *sh)
>  	       " to_write=%d failed=%d failed_num=%d,%d\n",
>  	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
>  	       s.failed_num[0], s.failed_num[1]);
> -	/* check if the array has lost more than max_degraded devices and,
> +	/*
> +	 * check if the array has lost more than max_degraded devices and,
>  	 * if so, some requests might need to be failed.
> +	 *
> +	 * When journal device failed (log_failed), we will only process
> +	 * the stripe if there is data need write to raid disks
>  	 */
> -	if (s.failed > conf->max_degraded || s.log_failed) {
> +	if (s.failed > conf->max_degraded ||
> +	    (s.log_failed && s.injournal == 0)) {
>  		sh->check_state = 0;
>  		sh->reconstruct_state = 0;
>  		break_stripe_batch_list(sh, 0);
> @@ -5280,7 +5304,8 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
>  	struct list_head *handle_list = NULL;
>  	struct r5worker_group *wg;
>  	bool second_try = !r5c_is_writeback(conf->log);
> -	bool try_loprio = test_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +	bool try_loprio = test_bit(R5C_LOG_TIGHT, &conf->cache_state) ||
> +		r5l_log_disk_error(conf);
>  
>  again:
>  	wg = NULL;
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
