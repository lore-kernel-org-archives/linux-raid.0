From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 5/6] r5cache: handle SYNC and FUA
Date: Tue, 27 Sep 2016 18:32:04 -0700
Message-ID: <20160928013204.GE98100@kernel.org>
References: <20160926233050.3351081-1-songliubraving@fb.com>
 <20160926233050.3351081-6-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160926233050.3351081-6-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Mon, Sep 26, 2016 at 04:30:49PM -0700, Song Liu wrote:
> With raid5 cache, we committing data from journal device. When
> there is flush request, we need to flush journal device's cache.
> This was not needed in raid5 journal, because we will flush the
> journal before committing data to raid disks.
> 
> This is similar to FUA, except that we also need flush journal for
> FUA. Otherwise, corruptions in earlier meta data will stop recovery
> from reaching FUA data.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
> @@ -554,12 +650,22 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
>  
>  	io = log->current_io;
>  
> +	if (test_and_clear_bit(STRIPE_R5C_PREFLUSH, &sh->state))
> +		io->has_flush = 1;
> +
>  	for (i = 0; i < sh->disks; i++) {
>  		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
>  		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
>  			continue;
>  		if (i == sh->pd_idx || i == sh->qd_idx)
>  			continue;
> +		if (test_bit(R5_WantFUA, &sh->dev[i].flags)) {
> +			io->has_fua = 1;
> +			/* we need to flush journal to make sure recovery can
> +			 * reach the data with fua flag
> +			 */
comments format.

> +			io->has_flush = 1;
> +		}
>  		r5l_append_payload_meta(log, R5LOG_PAYLOAD_DATA,
>  					raid5_compute_blocknr(sh, i, 0),
>  					sh->dev[i].log_checksum, 0, false);
> @@ -716,10 +822,16 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
>  	 * don't need to flush again
>  	 */
>  	if (bio->bi_iter.bi_size == 0) {
> -		bio_endio(bio);
> +		mutex_lock(&log->io_mutex);
> +		r5l_get_meta(log, 0);
> +		bio_list_add(&log->current_io->flush_barriers, bio);
> +		log->current_io->has_flush = 1;
> +		log->current_io->has_null_flush = 1;
> +		atomic_inc(&log->current_io->pending_stripe);
> +		r5l_submit_current_io(log);
> +		mutex_unlock(&log->io_mutex);
>  		return 0;
>  	}
please not change the behavior of writethrough mode.

Thanks,
Shaohua
