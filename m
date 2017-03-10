From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md/r5cache: generate R5LOG_PAYLOAD_FLUSH
Date: Thu, 9 Mar 2017 21:03:06 -0800
Message-ID: <20170310050306.mv7tj7ddlalbni25@kernel.org>
References: <20170310002403.1951485-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170310002403.1951485-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

On Thu, Mar 09, 2017 at 04:24:03PM -0800, Song Liu wrote:
> In r5c_finish_stripe_write_out(), R5LOG_PAYLOAD_FLUSH is append to
> log->current_io.
> 
> Appending R5LOG_PAYLOAD_FLUSH in quiesce needs extra writes to
> journal. To simplify the logic, we just skip R5LOG_PAYLOAD_FLUSH in
> quiesce.
> 
> Even R5LOG_PAYLOAD_FLUSH supports multiple stripes per payload.
> However, current implementation is one stripe per R5LOG_PAYLOAD_FLUSH,
> which is simpler.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index e69f922..f148c68 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -588,10 +588,11 @@ static void r5l_log_endio(struct bio *bio)
>  
>  	bio_put(bio);
>  	mempool_free(io->meta_page, log->meta_pool);
> +	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
>  
>  	spin_lock_irqsave(&log->io_list_lock, flags);
> -	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
why move this out the lock?

> -	if (log->need_cache_flush)
> +
> +	if (log->need_cache_flush && !list_empty(&io->stripe_list))
>  		r5l_move_to_end_ios(log);
>  	else
>  		r5l_log_run_stripes(log);
> @@ -619,9 +620,11 @@ static void r5l_log_endio(struct bio *bio)
>  			bio_endio(bi);
>  			atomic_dec(&io->pending_stripe);
>  		}
> -		if (atomic_read(&io->pending_stripe) == 0)
> -			__r5l_stripe_write_finished(io);
>  	}
> +
> +	/* finish flush only io_unit and PAYLOAD_FLUSH only io_unit */
> +	if (list_empty(&io->stripe_list))

we don't hold lock here, so can't check the list. checking the pending_stripe
should work too and is safe.

Thanks,
Shaohua
