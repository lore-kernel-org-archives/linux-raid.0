From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 4/6] r5cache: r5c recovery
Date: Tue, 27 Sep 2016 18:08:06 -0700
Message-ID: <20160928010806.GD98100@kernel.org>
References: <20160926233050.3351081-1-songliubraving@fb.com>
 <20160926233050.3351081-5-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160926233050.3351081-5-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Mon, Sep 26, 2016 at 04:30:48PM -0700, Song Liu wrote:
> For Data-Only strips, we need to finish complete calculate parity and
> finish the full reconstruct write or RMW write. For simplicity, in
> the recovery, we load the stripe to stripe cache. Once the array is
> started, the stripe cache state machine will handle these stripes
> through normal write path.

please make sure not change the behavior of writethrough mode. In writethrough,
we discard data-only stripes.

Is it safe to run the state machine in recovery stage? For exmaple, md
personablity ->run is called before bitmap is initialized.

> r5c_recovery_flush_log contains the main procedure of recovery. The
> recovery code first scans through the journal and loads data to
> stripe cache. The code keeps tracks of all these stripes in a list
> (use sh->lru and ctx->cached_list), stripes in the list are
> organized in the order of its first appearance on the journal.
> During the scan, the recovery code assesses each stripe as
> Data-Parity or Data-Only.
> 
> During scan, the array may run out of stripe cache. In these cases,
> the recovery code tries to release some stripe head by replaying
> existing Data-Parity stripes. Once these replays are done, these
> stripes can be released. When releasing Data-Parity stripes is not
> enough, the recovery code will also call raid5_set_cache_size to
> increase stripe cache size.
> 
> At the end of scan, the recovery code replays all Data-Parity
> stripes, and sets proper states for Data-Only stripes. The recovery
> code also increases seq number by 10 and rewrites all Data-Only
> stripes to journal. This is to avoid confusion after repeated
> crashes. More details is explained in raid5-cache.c before
> r5c_recovery_rewrite_data_only_stripes().
...
> +r5c_recovery_analyze_meta_block(struct r5l_log *log,
> +				struct r5l_recovery_ctx *ctx,
> +				struct list_head *cached_stripe_list)
> +{
> +	struct mddev *mddev = log->rdev->mddev;
> +	struct r5conf *conf = mddev->private;
>  	struct r5l_meta_block *mb;
> -	int offset;
> +	struct r5l_payload_data_parity *payload;
> +	int mb_offset;
>  	sector_t log_offset;
> -	sector_t stripe_sector;
> +	sector_t stripe_sect;
> +	struct stripe_head *sh;
> +	int ret;
> +
> +	/* for mismatch in data blocks, we will drop all data in this mb, but
> +	 * we will still read next mb for other data with FLUSH flag, as
> +	 * io_unit could finish out of order.
> +	 */
please correct the format

> +	ret = r5l_recovery_verify_data_checksum_for_mb(log, ctx);
> +	if (ret == -EINVAL)
> +		return -EAGAIN;
> +	else if (ret)
> +		return ret;
>  
>  	mb = page_address(ctx->meta_page);
> -	offset = sizeof(struct r5l_meta_block);
> +	mb_offset = sizeof(struct r5l_meta_block);
>  	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
>  
> -	while (offset < le32_to_cpu(mb->meta_size)) {
> +	while (mb_offset < le32_to_cpu(mb->meta_size)) {
>  		int dd;
>  
> -		payload = (void *)mb + offset;
> -		stripe_sector = raid5_compute_sector(conf,
> -						     le64_to_cpu(payload->location), 0, &dd, NULL);
> -		if (r5l_recovery_flush_one_stripe(log, ctx, stripe_sector,
> -						  &offset, &log_offset))
> +		payload = (void *)mb + mb_offset;
> +		stripe_sect = (payload->header.type == R5LOG_PAYLOAD_DATA) ?
> +			raid5_compute_sector(
> +				conf, le64_to_cpu(payload->location), 0, &dd,
> +				NULL)
> +			: le64_to_cpu(payload->location);
> +
> +		sh = r5c_recovery_lookup_stripe(cached_stripe_list,
> +						stripe_sect);
> +
> +		if (!sh) {
> +			sh = r5c_recovery_alloc_stripe(conf, cached_stripe_list,
> +						       stripe_sect, ctx->pos);
> +			/* cannot get stripe from raid5_get_active_stripe
> +			 * try replay some stripes
> +			 */
ditto

Thanks,
Shaohua
