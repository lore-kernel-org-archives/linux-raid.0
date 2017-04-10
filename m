From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md/r5cache: gracefully handle journal device errors
 for writeback mode
Date: Mon, 10 Apr 2017 09:21:49 -0700
Message-ID: <20170410162149.due7ihii7ibrz5pl@kernel.org>
References: <20170329080013.1445439-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170329080013.1445439-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Wed, Mar 29, 2017 at 01:00:13AM -0700, Song Liu wrote:
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
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 27 ++++++++++++++++++---------
>  drivers/md/raid5.c       | 28 ++++++++++++++++++++++++----
>  2 files changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index b6194e0..0838617 100644
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
> +	 * However, calling r5l_log_endio(current_bio) may change
> +	 * split_bio. Therefore, it is necessary to check split_bio before
> +	 * submit current_bio.
> +	 */

sorry, for the delay. what did you mean 'calling r5l_log_endio may change
split_bio'? The split_bio is chained into current_bio. The endio of
current_bio(r5l_log_endio) is only called after all chained bio completion. I
didn't get the point why this change.

> +	if (io->split_bio) {
> +		if (io->has_flush)
> +			io->split_bio->bi_opf |= REQ_PREFLUSH;
> +		if (io->has_fua)
> +			io->split_bio->bi_opf |= REQ_FUA;
> +		submit_bio(io->split_bio);
> +	}
> +
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
> index 6036d5e..4d3d1ab 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3054,6 +3054,11 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
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
> @@ -3067,6 +3072,9 @@ static inline bool delay_towrite(struct r5conf *conf,
>  	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
>  	    s->injournal > 0)
>  		return true;
> +	/* case 3 above */
> +	if (s->log_failed && s->injournal)
> +		return true;
>  	return false;
>  }
>  
> @@ -4689,10 +4697,15 @@ static void handle_stripe(struct stripe_head *sh)
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
> @@ -5272,7 +5285,8 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
>  	struct list_head *handle_list = NULL;
>  	struct r5worker_group *wg;
>  	bool second_try = !r5c_is_writeback(conf->log);
> -	bool try_loprio = test_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +	bool try_loprio = test_bit(R5C_LOG_TIGHT, &conf->cache_state) ||
> +		r5l_log_disk_error(conf);
>  
>  again:
>  	wg = NULL;
> @@ -7526,6 +7540,7 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  	int number = rdev->raid_disk;
>  	struct md_rdev **rdevp;
>  	struct disk_info *p = conf->disks + number;
> +	unsigned long flags;
>  
>  	print_raid5_conf(conf);
>  	if (test_bit(Journal, &rdev->flags) && conf->log) {
> @@ -7535,7 +7550,12 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  		 * neilb: there is no locking about new writes here,
>  		 * so this cannot be safe.
>  		 */
> -		if (atomic_read(&conf->active_stripes)) {
> +		if (atomic_read(&conf->active_stripes) ||
> +		    atomic_read(&conf->r5c_cached_full_stripes) ||
> +		    atomic_read(&conf->r5c_cached_partial_stripes)) {
> +			spin_lock_irqsave(&conf->device_lock, flags);
> +			r5c_flush_cache(conf, INT_MAX);
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
>  			return -EBUSY;

It's weird this is called in raid5_remove_disk, shouldn't this be called in log
disk error in case user doesn't remove the log disk? And this is a policy
change. User might not want to do the flush, as this exposes write hole. I
think at least we should print info out here to warn user the flush.

Thanks,
Shaohua
