From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/2] md/r5cache: generate R5LOG_PAYLOAD_FLUSH
Date: Thu, 9 Mar 2017 13:53:31 -0800
Message-ID: <20170309215331.dgsyxtp6wr4r7dxh@kernel.org>
References: <20170308014422.4019149-1-songliubraving@fb.com>
 <20170308014422.4019149-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308014422.4019149-2-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

On Tue, Mar 07, 2017 at 05:44:22PM -0800, Song Liu wrote:
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

much simpiler than I expected :)
 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index e69f922..fd0bfea 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -590,7 +590,21 @@ static void r5l_log_endio(struct bio *bio)
>  	mempool_free(io->meta_page, log->meta_pool);
>  
>  	spin_lock_irqsave(&log->io_list_lock, flags);
> -	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
> +
> +	if (list_empty(&io->stripe_list))
> +		/*
> +		 * this io_unit only has R5LOG_PAYLOAD_FLUSH, set
> +		 * to IO_UNIT_STRIPE_END
> +		 */
> +		__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
> +	else
> +		/*
> +		 * io_unit with R5LOG_PAYLOAD_FLUSH and also DATA/PARITY
> +		 * set to IO_UNIT_IO_END and wait for all stripes get
> +		 * handled.
> +		 */
> +		__r5l_set_io_unit_state(io, IO_UNIT_IO_END);

This part along with r5l_do_reclaim change looks strange. Could we call
__r5l_stripe_write_finished here? It makes more sense as we also free io unit
and do other things. The r5l_do_reclaim part looks quite hackish.

Thanks,
Shaohua
