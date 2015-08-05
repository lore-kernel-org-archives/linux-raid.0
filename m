From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 4/9] raid5: log reclaim support
Date: Wed, 5 Aug 2015 13:43:30 +1000
Message-ID: <20150805134330.3f4269e4@noble>
References: <cover.1438215986.git.shli@fb.com>
	<41a6d2e74494506fcd6ffd68a5884d38dc0bfa8e.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41a6d2e74494506fcd6ffd68a5884d38dc0bfa8e.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 17:38:44 -0700 Shaohua Li <shli@fb.com> wrote:

> This is the reclaim support for raid5 log. A stripe write will have
> following steps:
> 
> 1. reconstruct the stripe, read data/calculate parity. ops_run_io
> prepares to write data/parity to raid disks
> 2. hijack ops_run_io. stripe data/parity is appending to log disk
> 3. flush log disk cache
> 4. ops_run_io run again and do normal operation. stripe data/parity is
> written in raid array disks. raid core can return io to upper layer.
> 5. flush cache of all raid array disks
> 6. update super block
> 7. log disk space used by the stripe can be reused
> 
> In practice, several stripes consist of an io_unit and we will batch
> several io_unit in different steps, but the whole process doesn't
> change.
> 
> It's possible io return just after data/parity hit log disk, but then
> read IO will need read from log disk. For simplicity, IO return happens
> at step 4, where read IO can directly read from raid disks.
> 
> Currently reclaim run every minute or out of space. Reclaim is just to
> free log disk spaces, it doesn't impact data consistency.

Having arbitrary times lines "every minute" is a warning sign.
"As soon as possible" and "Just it time" can both make sense easily.
"every minute" needs more justification.

I'll probably say more when I find the code.


> 
> Recovery make sure raid disks and log disk have the same data of a
> stripe. If crash happens before 4, recovery might/might not recovery
> stripe's data/parity depending on if data/parity and its checksum
> matches. In either case, this doesn't change the syntax of an IO write.
> After step 3, stripe is guaranteed recoverable, because stripe's
> data/parity is persistent in log disk. In some cases, log disk content
> and raid disks content of a stripe are the same, but recovery will still
> copy log disk content to raid disks, this doesn't impact data
> consistency. space reuse happens after superblock update and cache
> flush.
> 
> There is one situation we want to avoid. A broken meta in the middle of
> a log causes recovery can't find meta at the head of log. If operations
> require meta at the head persistent in log, we must make sure meta
> before it persistent in log too. The case is stripe data/parity is in
> log and we start write stripe to raid disks (before step 4). stripe
> data/parity must be persistent in log before we do the write to raid
> disks. The solution is we restrictly maintain io_unit list order. In
> this case, we only write stripes of an io_unit to raid disks till the
> io_unit is the first one whose data/parity is in log.
> 
> The io_unit list order is important for other cases too. For example,
> some io_unit are reclaimable and others not. They can be mixed in the
> list, we shouldn't reuse space of an unreclaimable io_unit.
> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 261 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c       |   8 +-
>  drivers/md/raid5.h       |   3 +
>  3 files changed, 271 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 5c9bab6..a418e45 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -25,6 +25,7 @@
>  #include "raid5.h"
>  
>  typedef u64 r5blk_t; /* log blocks, 512B - 4k */
> +#define RECLAIM_TIMEOUT (60 * HZ) /* reclaim run every 60s */
>  
>  struct r5l_log {
>  	struct mddev *mddev;
> @@ -54,9 +55,14 @@ struct r5l_log {
>  
>  	spinlock_t io_list_lock;
>  	struct list_head running_ios; /* running io_unit list */
> +	struct list_head io_end_ios; /* io end io_unit list */
> +	struct list_head stripe_end_ios; /* stripe end io_unit list */

When the comment has nearly the same words as the code, it isn't adding
much, a bit like:
    i++;  /* increment i */

Maybe you mean:

   struct list_head running_ios; /* io_units which are still running,
                                  * and have not yet been completely
                                  * written to the log. */
   struct list_head io_end_ios;  /* io_units which have been completely
                                  * written to the log but not yet
                                  * written to the RAID */
   struct list_head stripe_end_ios;/* io_units which have been
                                    * completely written to the RAID
                                    * but have not yet been considered
                                    * for updating the start of the
                                    * log. */

>  
>  	struct kmem_cache *io_kc;
>  
> +	struct md_thread *reclaim_thread;
> +	r5blk_t reclaim_target; /* 0 means reclaiming possible io_unit */
> +

by "target" I think you mean "number of blocks that need to be
reclaimed".  I can't quite guess what a "possible io_unit" is.

    int reclaim_target; /* number of blocks that need to be reclaimed
                         * promptly.  If 0, then .....
                         */

>  	struct md_thread *log_thread;
>  	struct list_head log_stripes;
>  	spinlock_t log_stripes_lock;
> @@ -537,8 +543,246 @@ void r5l_write_stripe_run(struct r5l_log *log)
>  	md_wakeup_thread(log->log_thread);
>  }
>  
> +void r5l_stripe_write_finished(struct stripe_head *sh)
> +{
> +	struct r5l_io_unit *io;
> +
> +	/* Don't support stripe batch */
> +	io = sh->log_io;
> +	if (!io)
> +		return;
> +	sh->log_io = NULL;
> +
> +	if (!atomic_dec_and_test(&io->pending_stripe))
> +		return;
> +	r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);

 if (atomic_dec_and_test(...))
          r5l_set_io_unit_state(...);

??

> +}
> +
> +static void r5l_compress_stripe_end_list(struct r5l_log *log)
> +{
> +	struct r5l_io_unit *first, *last, *io;
> +
> +	if (list_empty(&log->stripe_end_ios))
> +		return;
> +	first = list_first_entry(&log->stripe_end_ios,
> +		struct r5l_io_unit, log_sibling);
> +	last = list_last_entry(&log->stripe_end_ios,
> +		struct r5l_io_unit, log_sibling);
> +	/* Keep 2 io_unit in the list, superblock points to the last one */
> +	if (first == last)
> +		return;
> +	list_del(&first->log_sibling);
> +	list_del(&last->log_sibling);
> +	while (!list_empty(&log->stripe_end_ios)) {
> +		io = list_first_entry(&log->stripe_end_ios,
> +			struct r5l_io_unit, log_sibling);
> +		list_del(&io->log_sibling);
> +		first->log_end = io->log_end;
> +		r5l_free_io_unit(log, io);
> +	}
> +	list_add_tail(&first->log_sibling, &log->stripe_end_ios);
> +	list_add_tail(&last->log_sibling, &log->stripe_end_ios);
> +}

A comment explaining why you might want to compress a list (which I
think means to only keep the first and last) would be quite helpful
here.

> +
> +static void r5l_move_io_unit_list(struct list_head *from, struct list_head *to,
> +	int state)
> +{
> +	struct r5l_io_unit *io;
> +
> +	while (!list_empty(from)) {
> +		io = list_first_entry(from, struct r5l_io_unit, log_sibling);
> +		/* don't change list order */
> +		if (io->state >= state)
> +			list_move_tail(&io->log_sibling, to);
> +		else
> +			break;
> +	}
> +}
> +
> +/*
> + * Starting dispatch IO to raid.
> + * io_unit(meta) consists of a log. There is one situation we want to avoid. A
> + * broken meta in the middle of a log causes recovery can't find meta at the
> + * head of log. If operations require meta at the head persistent in log, we
> + * must make sure meta before it persistent in log too. A case is:
> + *
> + * stripe data/parity is in log, we start write stripe to raid disks. stripe
> + * data/parity must be persistent in log before we do the write to raid disks.
> + *
> + * The solution is we restrictly maintain io_unit list order. In this case, we
> + * only write stripes of an io_unit to raid disks till the io_unit is the first
> + * one whose data/parity is in log.
> + * */
> +void r5l_flush_stripe_to_raid(struct r5l_log *log)
> +{
> +	struct r5l_io_unit *io;
> +	struct stripe_head *sh;
> +	bool run_stripe;
> +
> +	if (!log)
> +		return;
> +	/* find io_unit with io end but stripes are not running */
> +	spin_lock(&log->io_list_lock);
> +	r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
> +			IO_UNIT_IO_END);
> +	r5l_move_io_unit_list(&log->io_end_ios, &log->stripe_end_ios,
> +			IO_UNIT_STRIPE_END);
> +	r5l_compress_stripe_end_list(log);
> +	run_stripe = !list_empty(&log->io_end_ios);
> +	spin_unlock(&log->io_list_lock);
> +
> +	if (!run_stripe)
> +		return;
> +
> +	blkdev_issue_flush(r5l_bdev(log), GFP_NOIO, NULL);
> +
> +	spin_lock(&log->io_list_lock);
> +	list_for_each_entry(io, &log->io_end_ios, log_sibling) {
> +		if (io->state >= IO_UNIT_STRIPE_START)
> +			continue;
> +		r5l_set_io_unit_state(io, IO_UNIT_STRIPE_START);
> +
> +		while (!list_empty(&io->stripe_list)) {
> +			sh = list_first_entry(&io->stripe_list,
> +				struct stripe_head, log_list);
> +			list_del_init(&sh->log_list);
> +			set_bit(STRIPE_HANDLE, &sh->state);
> +			release_stripe(sh);

This code makes me a bit nervous.  handle_stripe() can potentially be
called on any stripe at any time.
Here you are scheduling a call the handle_stripe() without obviously
changing the state of the stripe.  So whatever is going to happen now
could potentially have happened before... is that safe?


> +		}
> +	}
> +	spin_unlock(&log->io_list_lock);
> +}
> +
> +static void r5l_disks_flush_end(struct bio *bio, int err)
> +{
> +	struct completion *io_complete = bio->bi_private;
> +
> +	complete(io_complete);
> +	bio_put(bio);
> +}
> +
> +static void r5l_flush_all_disks(struct r5l_log *log)
> +{
> +	struct mddev *mddev = log->mddev;
> +	struct bio *bi;
> +	DECLARE_COMPLETION_ONSTACK(io_complete);
> +
> +	bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
> +	bi->bi_end_io = r5l_disks_flush_end;
> +	bi->bi_private = &io_complete;
> +
> +	/* If bio hasn't payload, this function will just flush all disks */
> +	md_flush_request(mddev, bi);
> +
> +	wait_for_completion_io(&io_complete);
> +}
> +
> +static void r5l_kick_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
> +{
> +	/* the log thread will log the io unit */
> +	r5l_wait_io_unit_state(io, IO_UNIT_IO_END);
> +	if (io->state < IO_UNIT_STRIPE_START)
> +		r5l_flush_stripe_to_raid(log);
> +	r5l_wait_io_unit_state(io, IO_UNIT_STRIPE_END);
> +}
> +
> +static void r5l_write_super(struct r5l_log *log, sector_t cp);
> +static void r5l_do_reclaim(struct r5l_log *log)
> +{
> +	struct r5l_io_unit *io, *last;
> +	LIST_HEAD(list);
> +	r5blk_t free = 0;
> +	r5blk_t reclaim_target = xchg(&log->reclaim_target, 0);
> +
> +	spin_lock(&log->io_list_lock);
> +	/*
> +	 * move proper io_unit to reclaim list. We should not change the order.
> +	 * reclaimable/unreclaimable io_unit can be mixed in the list, we
> +	 * shouldn't reuse space of an unreclaimable io_unit
> +	 * */
> +	while (1) {
> +		r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
> +			IO_UNIT_IO_END);
> +		r5l_move_io_unit_list(&log->io_end_ios, &log->stripe_end_ios,
> +				IO_UNIT_STRIPE_END);
> +		while (!list_empty(&log->stripe_end_ios)) {
> +			io = list_first_entry(&log->stripe_end_ios,
> +				struct r5l_io_unit, log_sibling);
> +			list_move_tail(&io->log_sibling, &list);
> +			free += (io->log_end - io->log_start +
> +				log->total_blocks) % log->total_blocks;
> +		}
> +
> +		if (free >= reclaim_target || (list_empty(&log->running_ios) &&
> +		    list_empty(&log->io_end_ios) &&
> +		    list_empty(&log->stripe_end_ios)))
> +			break;
> +
> +		if (!list_empty(&log->io_end_ios)) {
> +			io = list_first_entry(&log->io_end_ios,
> +				struct r5l_io_unit, log_sibling);
> +			spin_unlock(&log->io_list_lock);
> +			/* nobody else can delete the io, we are safe */
> +			r5l_kick_io_unit(log, io);
> +			spin_lock(&log->io_list_lock);
> +			continue;
> +		}
> +
> +		if (!list_empty(&log->running_ios)) {
> +			io = list_first_entry(&log->running_ios,
> +				struct r5l_io_unit, log_sibling);
> +			spin_unlock(&log->io_list_lock);
> +			/* nobody else can delete the io, we are safe */
> +			r5l_kick_io_unit(log, io);
> +			spin_lock(&log->io_list_lock);
> +			continue;
> +		}
> +	}
> +	spin_unlock(&log->io_list_lock);

Well, here we are with the important parts of the reclaim code...

The main result of the above section is to possibly call
r5l_flush_stripe_to_raid() a few times, and to wait until 'list'
contains enough io_units to satisfy the requirement.

As raid5d already calls r5l_flush_stripe_to_raid - which it really must
to make sure that writes complete quickly - this really comes down to
some book keeping and some waiting.
Book keeping can be done as changes happen, and waiting is best not
done at all.

To be more specific: when an io_unit transitions to IO_UNIT_STRIPE_END
it can immediately be removed from the list and if it was the first
io_unit on the list, then the log_start can immediately be updated.


> +
> +	if (list_empty(&list))
> +		return;
> +
> +	r5l_flush_all_disks(log);
> +
> +	/* super always point to last valid meta */
> +	last = list_last_entry(&list, struct r5l_io_unit, log_sibling);
> +	r5l_write_super(log, r5l_block_to_sector(log, last->log_start));

This bit flushes all the disks and then updates the metadata and writes
it.
As md_super_write already uses WRITE_FLUSH_FUA I don't think the extra
flush is needed.

I really think you should just update ->recovery_offset and set
MD_CHANGE_DEVS (or similar) and let the update happen.


> +
> +	mutex_lock(&log->io_mutex);
> +	log->last_checkpoint = last->log_start;
> +	log->last_cp_seq = last->seq;
> +	mutex_unlock(&log->io_mutex);
> +	wake_up(&log->space_waitq);
> +
> +	while (!list_empty(&list)) {
> +		io = list_first_entry(&list, struct r5l_io_unit, log_sibling);
> +		list_del(&io->log_sibling);
> +		r5l_free_io_unit(log, io);
> +	}
> +}

So I really think all of this can be done as-it-happens (the
book-keeping) or asynchronously.  There is no need to push something
every minute.



> +
> +static void r5l_reclaim_thread(struct md_thread *thread)
> +{
> +	struct mddev *mddev = thread->mddev;
> +	struct r5conf *conf = mddev->private;
> +	struct r5l_log *log = conf->log;
> +
> +	if (!log)
> +		return;
> +	r5l_do_reclaim(log);
> +}
> +
>  static void r5l_wake_reclaim(struct r5l_log *log, r5blk_t space)
>  {
> +	r5blk_t target;
> +
> +	do {
> +		target = log->reclaim_target;
> +		if (space < target)
> +			return;
> +	} while (cmpxchg(&log->reclaim_target, target, space) != target);
> +	md_wakeup_thread(log->reclaim_thread);
>  }
>  
>  static int r5l_recovery_log(struct r5l_log *log)
> @@ -642,11 +886,19 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  
>  	spin_lock_init(&log->io_list_lock);
>  	INIT_LIST_HEAD(&log->running_ios);
> +	INIT_LIST_HEAD(&log->io_end_ios);
> +	INIT_LIST_HEAD(&log->stripe_end_ios);
>  
>  	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
>  	if (!log->io_kc)
>  		goto io_kc;
>  
> +	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
> +		log->mddev, "reclaim");
> +	if (!log->reclaim_thread)
> +		goto reclaim_thread;
> +	log->reclaim_thread->timeout = RECLAIM_TIMEOUT;
> +
>  	INIT_LIST_HEAD(&log->log_stripes);
>  	spin_lock_init(&log->log_stripes_lock);
>  	log->log_thread = md_register_thread(r5l_log_thread,
> @@ -662,6 +914,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  error:
>  	md_unregister_thread(&log->log_thread);
>  log_thread:
> +	md_unregister_thread(&log->reclaim_thread);
> +reclaim_thread:
>  	kmem_cache_destroy(log->io_kc);
>  io_kc:
>  	kfree(log);
> @@ -670,6 +924,13 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  
>  void r5l_exit_log(struct r5l_log *log)
>  {
> +	/*
> +	 * at this point all stripes are finished, so io_unit is at least in
> +	 * STRIPE_END state
> +	 * */
> +	r5l_wake_reclaim(log, -1L);
> +	md_unregister_thread(&log->reclaim_thread);
> +	r5l_do_reclaim(log);
>  	md_unregister_thread(&log->log_thread);
>  
>  	kmem_cache_destroy(log->io_kc);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9608a44..d1ddd31 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -417,7 +417,7 @@ static int release_stripe_list(struct r5conf *conf,
>  	return count;
>  }
>  
> -static void release_stripe(struct stripe_head *sh)
> +void release_stripe(struct stripe_head *sh)
>  {
>  	struct r5conf *conf = sh->raid_conf;
>  	unsigned long flags;
> @@ -3101,6 +3101,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>  		if (bi)
>  			bitmap_end = 1;
>  
> +		r5l_stripe_write_finished(sh);
> +
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>  			wake_up(&conf->wait_for_overlap);
>  
> @@ -3499,6 +3501,8 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>  			WARN_ON(dev->page != dev->orig_page);
>  		}
>  
> +	r5l_stripe_write_finished(sh);
> +
>  	if (!discard_pending &&
>  	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
>  		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
> @@ -5867,6 +5871,8 @@ static void raid5d(struct md_thread *thread)
>  		set_bit(R5_DID_ALLOC, &conf->cache_state);
>  	}
>  
> +	r5l_flush_stripe_to_raid(conf->log);
> +
>  	async_tx_issue_pending_all();
>  	blk_finish_plug(&plug);
>  
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index a8daf39..23cc9c3 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -611,8 +611,11 @@ static inline int algorithm_is_DDF(int layout)
>  extern void md_raid5_kick_device(struct r5conf *conf);
>  extern int raid5_set_cache_size(struct mddev *mddev, int size);
>  extern sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
> +extern void release_stripe(struct stripe_head *sh);
>  extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
>  extern void r5l_exit_log(struct r5l_log *log);
>  extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
>  extern void r5l_write_stripe_run(struct r5l_log *log);
> +extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
> +extern void r5l_stripe_write_finished(struct stripe_head *sh);
>  #endif

Thanks,
NeilBrown

