From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 5/8] md/r5cache: reclaim support
Date: Wed, 12 Oct 2016 09:50:31 -0700
Message-ID: <20161012165031.GA15323@kernel.org>
References: <20161011002446.2002428-1-songliubraving@fb.com>
 <20161011002446.2002428-6-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161011002446.2002428-6-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Mon, Oct 10, 2016 at 05:24:43PM -0700, Song Liu wrote:
> There are two limited resources, stripe cache and journal disk space.
> For better performance, we priotize reclaim of full stripe writes.
> To free up more journal space, we free earliest data on the journal.
> 
> In current implementation, reclaim happens when:
> 1. every R5C_RECLAIM_WAKEUP_INTERVAL (5 seconds)

This is the protection. If no reclaim runs in last 5 seconds, trigger this.
Otherwise, don't do this.

> 2. when there are R5C_FULL_STRIPE_FLUSH_BATCH (8) cached full stripes
>    (r5c_check_cached_full_stripe)

8 stripes aren't big. I'd use 128k so 32 strieps. 128k size IO should be good
for harddisk.

I'd suggest something like this:

1. if no stripe cache pressure and there are 32+ full stripes, flush all full
stripes
2. if stripe cache pressure is moderate, flush all full stripes

3. if stripe cache pressure is high, flush all full stripes first. If pressure
is still higher than a watermark, flush partial full stripes.

The principle is to flush full stripes if possible and flush as more as
possible. reclaim will do disk cache flush and so is an expensive operation.

> 3. when raid5_get_active_stripe sees pressure in stripe cache space
>    (r5c_check_stripe_cache_usage)
> 4. when there is pressure in journal space.
> 
> 1-3 above are straightforward. The following explains details of 4.
> 
> To avoid deadlock due to log space, we need to reserve enough space
> to flush cached data. The size of required log space depends on total
> number of cached stripes (stripe_in_cache_count). In current
> implementation, the reclaim path automatically include pending
> data writes with parity writes (similar to write through case).
> Therefore, we need up to (conf->raid_disks + 1) pages for each cached
> stripe (1 page for meta data, raid_disks pages for all data and
> parity). r5c_log_required_to_flush_cache() calculates log space
> required to flush cache. In the following, we refer to the space
> calculated by r5c_log_required_to_flush_cache() as
> reclaim_required_space.
> 
> Two flags are added to r5conf->cache_state: R5C_LOG_TIGHT and
> R5C_LOG_CRITICAL. R5C_LOG_TIGHT is set when free space on the log
> device is less than 3x of reclaim_required_space. R5C_LOG_CRITICAL
> is set when free space on the log device is less than 2x of
> reclaim_required_space.
> 
> r5c_cache keeps all data in cache (not fully committed to RAID) in
> a list (stripe_in_cache_list). These stripes are in the order of their
> first appearance on the journal. So the log tail (last_checkpoint)
> should point to the journal_start of the first item in the list.
> 
> When R5C_LOG_TIGHT is set, r5l_reclaim_thread starts flushing out
> stripes at the head of stripe_in_cache. When R5C_LOG_CRITICAL is
> set, the state machine only writes data that are already in the
> log device (in stripe_in_cache_list).
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 363 +++++++++++++++++++++++++++++++++++++++++++----
>  drivers/md/raid5.c       |  17 +++
>  drivers/md/raid5.h       |  39 +++--
>  3 files changed, 383 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 92d3d7b..2774f93 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -29,12 +29,21 @@
>  #define BLOCK_SECTORS (8)
>  
>  /*
> - * reclaim runs every 1/4 disk size or 10G reclaimable space. This can prevent
> - * recovery scans a very long log
> + * log->max_free_space is min(1/4 disk size, 10G reclaimable space).
> + *
> + * In write through mode, the reclaim runs every log->max_free_space.
> + * This can prevent the recovery scans for too long
>   */
>  #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
>  #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
>  
> +/* wake up reclaim thread periodically */
> +#define R5C_RECLAIM_WAKEUP_INTERVAL (5 * HZ)
> +/* start flush with these full stripes */
> +#define R5C_FULL_STRIPE_FLUSH_BATCH 8
> +/* reclaim stripes in groups */
> +#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
> +
>  /*
>   * We only need 2 bios per I/O unit to make progress, but ensure we
>   * have a few more available to not get too tight.
> @@ -141,6 +150,11 @@ struct r5l_log {
>  
>  	/* for r5c_cache */
>  	enum r5c_state r5c_state;
> +	struct list_head stripe_in_cache_list;	/* all stripes in r5cache, with
> +						 * sh->log_start in order
> +						 */

The comment isn't correct. log_start could wrap. The stripes are actually
ordered in seq. Please move the comments above stripe_in_cache_list.

> +/*
> + * r5c_flush_stripe moves stripe from cached list to handle_list. When called,
> + * the stripe must be on r5c_cached_full_stripes or r5c_cached_partial_stripes.
> + *
> + * must hold conf->device_lock
> + */
> +static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
> +{
> +	BUG_ON(list_empty(&sh->lru));
> +	BUG_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
> +	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
> +	assert_spin_locked(&conf->device_lock);
> +
> +	list_del_init(&sh->lru);
> +	atomic_inc(&sh->count);
> +
> +	set_bit(STRIPE_HANDLE, &sh->state);
> +	atomic_inc(&conf->active_stripes);
> +	r5c_freeze_stripe_for_reclaim(sh);
> +
> +	set_bit(STRIPE_PREREAD_ACTIVE, &sh->state);

we increase preread_active_stripes too if the STRIPE_PREREAD_ACTIVE isn't set.
Why not here?

Thanks,
Shaohua
