From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [RFC 4/5] r5cache: write part of r5cache
Date: Tue, 31 May 2016 05:00:46 -0400
Message-ID: <574D52BE.7040703@suse.com>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
 <1464326983-3798454-5-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-5-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
Cc: shli@fb.com, nfbrown@novell.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com
List-Id: linux-raid.ids

Hi,

I don't know a lot about raid5-cache, just a quick glance about syntax.

On 05/27/2016 01:29 AM, Song Liu wrote:
> This is the write part of r5cache. The cache is integrated with
> stripe cache of raid456. It leverages code of r5l_log to write
> data to journal device.
>
> r5cache split current write path into 2 parts: the write path
> and the reclaim path. The write path is as following:
> 1. write data to journal
> 2. call bio_endio
>
> Then the reclaim path is as:
> 1. Freeze the stripe (no more writes coming in)
> 2. Calcualte parity (reconstruct or RMW)
> 3. Write parity to journal device (data is already written to it)
> 4. Write data and parity to RAID disks
>
> With r5cache, write operation does not wait for parity calculation
> and write out, so the write latency is lower (1 write to journal
> device vs. read and then write to raid disks). Also, r5cache will
> reduce RAID overhead (multipile IO due to read-modify-write of
> parity) and provide more opportunities of full stripe writes.
>
> r5cache adds a new state of each stripe: enum r5c_states. The write
> path runs in state CLEAN and RUNNING (data in cache). Cache writes
> start from r5c_handle_stripe_dirtying(), where bit R5_Wantcache is
> set for devices with bio in towrite. Then, the data is written to
> the journal through r5l_log implementation. Once the data is in the
> journal, we set bit R5_InCache, and presue bio_endio for these
> writes.
>
> The reclaim path starts by freezing the stripe (no more writes).
> This stripes back to raid5 state machine, where
> handle_stripe_dirtying will evaluate the stripe for reconstruct
> writes or RMW writes (read data and calculate parity).
>
> For RMW, the code allocates extra page for prexor. Specifically,
> a new page is allocated for r5dev->page to do prexor; while
> r5dev->orig_page keeps the cached data. The extra page is freed
> after prexor.
>
> r5cache naturally excludes SkipCopy. With R5_Wantcache bit set,
> async_copy_data will not skip copy.
>
> Before writing data to RAID disks, the r5l_log logic stores
> parity (and non-overwrite data) to the journal.
>
> Instead of inactive_list, stripes with cached data are tracked in
> r5conf->r5c_cached_list. r5conf->r5c_cached_stripes tracks how
> many stripes has dirty data in the cache.
>
> Two sysfs entries are provided for the write cache:
> 1. r5c_cached_stripes shows how many stripes have cached data.
>     Writing anything to r5c_cached_stripes will flush all data
>     to RAID disks.
> 2. r5c_cache_mode provides knob to switch the system between
>     write-back or write-through (only write-log).
>
> There are some known limitations of the cache implementation:
>
> 1. Write cache only covers full page writes (R5_OVERWRITE). Writes
>     of smaller granularity are write through.
> 2. Only one log io (sh->log_io) for each stripe at anytime. Later
>     writes for the same stripe have to wait. This can be improved by
>     moving log_io to r5dev.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>   drivers/md/raid5-cache.c | 399 +++++++++++++++++++++++++++++++++++++++++++++--
>   drivers/md/raid5.c       | 172 +++++++++++++++++---
>   drivers/md/raid5.h       |  38 ++++-
>   3 files changed, 577 insertions(+), 32 deletions(-)
>

[snip]

> +
> +/*
> + * this journal write must contain full parity,
> + * it may also contain data of none-overwrites
> + */
> +static void r5c_handle_parity_cached(struct stripe_head *sh)
> +{
> +	int i;
> +
> +	for (i = sh->disks; i--; )
> +		if (test_bit(R5_InCache, &sh->dev[i].flags))
> +			set_bit(R5_Wantwrite, &sh->dev[i].flags);
> +	r5c_set_state(sh, R5C_STATE_PARITY_DONE);
> +}
> +
> +static void r5c_finish_cache_stripe(struct stripe_head *sh)
> +{
> +	switch (sh->r5c_state) {
> +	case R5C_STATE_PARITY_RUN:
> +		r5c_handle_parity_cached(sh);
> +		break;
> +	case R5C_STATE_CLEAN:
> +		r5c_set_state(sh, R5C_STATE_RUNNING);

Maybe you missed break here?

> +	case R5C_STATE_RUNNING:
> +		r5c_handle_data_cached(sh);
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +

[snip]

>   	meta_size =
>   		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
>   		 * data_pages) +
> @@ -766,7 +865,6 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
>   	}
>   }
>   
> -
>   static void r5l_do_reclaim(struct r5l_log *log)
>   {
>   	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
> @@ -826,10 +924,15 @@ static void r5l_reclaim_thread(struct md_thread *thread)
>   
>   	if (!log)
>   		return;
> +/*
> +	spin_lock_irq(&conf->device_lock);
> +	r5c_do_reclaim(conf);
> +	spin_unlock_irq(&conf->device_lock);
> +*/

The above part doesn't make sense.

BTW: there are lots of issues reported by checkpatch.

Thanks,
Guoqing
