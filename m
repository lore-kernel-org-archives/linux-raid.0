From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v6 03/11] md/r5cache: State machine for raid5-cache write
 back mode
Date: Mon, 14 Nov 2016 17:22:21 -0800
Message-ID: <20161115012221.5holqbeqi542k7pa@kernel.org>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-4-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161110204623.3484694-4-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Thu, Nov 10, 2016 at 12:46:15PM -0800, Song Liu wrote:
> This patch adds state machine for raid5-cache. With log device, the
> raid456 array could operate in two different modes (r5c_journal_mode):
>   - write-back (R5C_MODE_WRITE_BACK)
>   - write-through (R5C_MODE_WRITE_THROUGH)
> 
> Existing code of raid5-cache only has write-through mode. For write-back
> cache, it is necessary to extend the state machine.
> 
> With write-back cache, every stripe could operate in two different
> modes:
>   - caching
>   - writing-out
> 
> In caching mode, the stripe handles writes as:
>   - write to journal
>   - return IO
> 
> In writing-out mode, the stripe behaviors as a stripe in write through
> mode R5C_MODE_WRITE_THROUGH.
> 
> STRIPE_R5C_WRITE_OUT is added to sh->state to differentiate caching and
> writing-out mode.
> 
> When the array is write-through, stripes also go between caching mode
> and writing-out mode.
> 
> Please note: this is a "no-op" patch for raid5-cache write-through
> mode.
> 
> The following detailed explanation is copied from the raid5-cache.c:
> 
> /*
>  * raid5 cache state machine
>  *
>  * With rhe RAID cache, each stripe works in two modes:
>  *      - caching mode
>  *      - writing-out mode

'mode' is quite confusing here. it always remainders me r5c_journal_mode. can
you use state?

> + * Note: when the array is in write-through, each stripe still goes through
> + * caching mode and writing-out mode. In such cases, this function is called
> + * in r5c_handle_stripe_dirtying().
> + */
> +static void r5c_make_stripe_write_out(struct stripe_head *sh)
> +{
> +	struct r5conf *conf = sh->raid_conf;
> +	struct r5l_log *log = conf->log;
> +
> +	if (!log)
> +		return;
> +	WARN_ON(test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
> +	set_bit(STRIPE_R5C_WRITE_OUT, &sh->state);
> +}
> +
> +/*
> + * Setting proper flags after writing (or flushing) data and/or parity to the
> + * log device. This is called from r5l_log_endio() or r5l_log_flush_endio().
> + */
> +static void r5c_finish_cache_stripe(struct stripe_head *sh)
> +{
> +	struct r5l_log *log = sh->raid_conf->log;
> +
> +	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
> +		BUG_ON(!test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
> +		/*
> +		 * Set R5_InJournal for parity dev[pd_idx]. This means parity
> +		 * is in the journal. For RAID 6, it is NOT necessary to set
> +		 * the flag for dev[qd_idx], as the two parities are written
> +		 * out together.
> +		 */
> +		set_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags);

if this flag is only for pd_idx disk and you are using it to determine the
stripe data is in journal, why not make it a stripe flag?

Thanks,
Shaohua
