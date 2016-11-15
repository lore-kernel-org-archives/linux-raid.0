From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v6 04/11] md/r5cache: caching mode of r5cache
Date: Tue, 15 Nov 2016 09:03:30 -0800
Message-ID: <20161115170330.kdjxussdau54ekus@kernel.org>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-5-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161110204623.3484694-5-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Thu, Nov 10, 2016 at 12:46:16PM -0800, Song Liu wrote:
> As described in previous patch, write back cache operates in two
> modes: caching and writing-out. The caching mode works as:
> 1. write data to journal
>    (r5c_handle_stripe_dirtying, r5c_cache_data)
> 2. call bio_endio
>    (r5c_handle_data_cached, r5c_return_dev_pending_writes).
> 
> Then the writing-out path is as:
> 1. Mark the stripe as write-out (r5c_make_stripe_write_out)
> 2. Calcualte parity (reconstruct or RMW)
> 3. Write parity (and maybe some other data) to journal device
> 4. Write data and parity to RAID disks
> 
> This patch implements caching mode. The cache is integrated with
> stripe cache of raid456. It leverages code of r5l_log to write
> data to journal device.
> 
> Writing-out mode of the cache is implemented in the next patch.
> 
> With r5cache, write operation does not wait for parity calculation
> and write out, so the write latency is lower (1 write to journal
> device vs. read and then write to raid disks). Also, r5cache will
> reduce RAID overhead (multipile IO due to read-modify-write of
> parity) and provide more opportunities of full stripe writes.
> 
> This patch adds 2 flags to stripe_head.state:
>  - STRIPE_R5C_PARTIAL_STRIPE,
>  - STRIPE_R5C_FULL_STRIPE,
> 
> Instead of inactive_list, stripes with cached data are tracked in
> r5conf->r5c_full_stripe_list and r5conf->r5c_partial_stripe_list.
> STRIPE_R5C_FULL_STRIPE and STRIPE_R5C_PARTIAL_STRIPE are flags for
> stripes in these lists. Note: stripes in r5c_full/partial_stripe_list
> are not considered as "active".
> 
> For RMW, the code allocates an extra page for each data block
> being updated.  This is stored in r5dev->page and the old data
> is read into it.  Then the prexor calculation subtracts ->page
> from the parity block, and the reconstruct calculation adds the
> ->orig_page data back into the parity block.
> 
> r5cache naturally excludes SkipCopy. When the array has write back
> cache, async_copy_data() will not skip copy.
> 
> There are some known limitations of the cache implementation:
> 
> 1. Write cache only covers full page writes (R5_OVERWRITE). Writes
>    of smaller granularity are write through.
> 2. Only one log io (sh->log_io) for each stripe at anytime. Later
>    writes for the same stripe have to wait. This can be improved by
>    moving log_io to r5dev.
> 3. With writeback cache, read path must enter state machine, which
>    is a significant bottleneck for some workloads.
> 4. There is no per stripe checkpoint (with r5l_payload_flush) in
>    the log, so recovery code has to replay more than necessary data
>    (sometimes all the log from last_checkpoint). This reduces
>    availability of the array.
> 
> This patch includes a fix proposed by ZhengYuan Liu
> <liuzhengyuan@kylinos.cn>
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 192 +++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/md/raid5.c       | 158 +++++++++++++++++++++++++++++++++-----
>  drivers/md/raid5.h       |  17 +++++
>  3 files changed, 342 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index abb2c58..ad97103 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -218,8 +218,21 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
>  static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>  			      struct list_head *temp_inactive_list)
>  {
> +	int i;
> +	int uptodate = 0;	/* number of data pages with R5_UPTODATE */
> +	int injournal = 0;	/* number of date pages with R5_InJournal */
> +
>  	BUG_ON(!list_empty(&sh->lru));
>  	BUG_ON(atomic_read(&conf->active_stripes)==0);
> +
> +	if (r5c_is_writeback(conf->log))
> +		for (i = sh->disks; i--; ) {
> +			if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
> +				uptodate++;
> +			if (test_bit(R5_InJournal, &sh->dev[i].flags))
> +				injournal++;
> +		}
> +
>  	if (test_bit(STRIPE_HANDLE, &sh->state)) {
>  		if (test_bit(STRIPE_DELAYED, &sh->state) &&
>  		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> @@ -245,8 +258,29 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>  			    < IO_THRESHOLD)
>  				md_wakeup_thread(conf->mddev->thread);
>  		atomic_dec(&conf->active_stripes);
> -		if (!test_bit(STRIPE_EXPANDING, &sh->state))
> -			list_add_tail(&sh->lru, temp_inactive_list);
> +		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> +			if (!r5c_is_writeback(conf->log))
> +				list_add_tail(&sh->lru, temp_inactive_list);
> +			else {
> +				WARN_ON(test_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags));
> +				if (injournal == 0)
> +					list_add_tail(&sh->lru, temp_inactive_list);
> +				else if (uptodate == conf->raid_disks - conf->max_degraded) {
> +					/* full stripe */
> +					if (!test_and_set_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
> +						atomic_inc(&conf->r5c_cached_full_stripes);
> +					if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
> +						atomic_dec(&conf->r5c_cached_partial_stripes);
> +					list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);

Using the R5_UPTODATE bit to determine full stripe is skeptical. Read enters
into the state machine with writeback. After data is is read into stripe cache,
the R5_UPTODATE bit is set. So here we could put stripe which is never written
into r5c_cached_full_stripes. why not just use injournal to do the determination?

> +				} else {
> +					/* partial stripe */
> +					if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
> +							      &sh->state))
> +						atomic_inc(&conf->r5c_cached_partial_stripes);
> +					list_add_tail(&sh->lru, &conf->r5c_partial_stripe_list);
> +				}
> +			}
> +		}
>  	}
>  }
>  
> @@ -830,8 +864,18 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  
>  	might_sleep();
>  
> -	if (r5l_write_stripe(conf->log, sh) == 0)
> -		return;
> +	if (test_bit(STRIPE_R5C_WRITE_OUT, &sh->state)) {
> +		/* writing out mode */
> +		if (r5l_write_stripe(conf->log, sh) == 0)
> +			return;
> +	} else {
> +		/* caching mode */
> +		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state)) {

The STRIPE_LOG_TRAPPED bit isn't designed for this, maybe it just works, I have
to double check. but this one is a little confusing.

>  static struct dma_async_tx_descriptor *
> @@ -1496,7 +1558,8 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
>  	for (i = disks; i--; ) {
>  		struct r5dev *dev = &sh->dev[i];
>  		/* Only process blocks that are known to be uptodate */
> -		if (test_bit(R5_Wantdrain, &dev->flags))
> +		if (test_bit(R5_Wantdrain, &dev->flags) ||
> +		    test_bit(R5_InJournal, &dev->flags))
>  			xor_srcs[count++] = dev->page;
>  	}
>  
> @@ -1530,6 +1593,7 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
>  static struct dma_async_tx_descriptor *
>  ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
>  {
> +	struct r5conf *conf = sh->raid_conf;
>  	int disks = sh->disks;
>  	int i;
>  	struct stripe_head *head_sh = sh;
> @@ -1547,6 +1611,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
>  
>  again:
>  			dev = &sh->dev[i];
> +			clear_bit(R5_InJournal, &dev->flags);

why clear the bit here? isn't this bit cleared when the stripe is initialized?

Thanks,
Shaohua
