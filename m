From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/r5cache: improve recovery with read ahead page pool
Date: Tue, 7 Mar 2017 12:13:57 -0800
Message-ID: <20170307201357.dsmjp2zi5lyelxep@kernel.org>
References: <20170303210616.56044-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170303210616.56044-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

On Fri, Mar 03, 2017 at 01:06:15PM -0800, Song Liu wrote:
> In r5cache recovery, the journal device is scanned page by page.
> Currently, we use sync_page_io() to read journal device. This is
> not efficient when we have to recovery many stripes from the journal.
> 
> To improve the speed of recovery, this patch introduces a read ahead
> page pool (ra_pool) to recovery_ctx. With ra_pool, multiple consecutive
> pages are read in one IO. Then the recovery code read the journal from
> ra_pool.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 151 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 134 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 3f307be..46afea8 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1552,6 +1552,8 @@ bool r5l_log_disk_error(struct r5conf *conf)
>  	return ret;
>  }
>  
> +#define R5L_RECOVERY_PAGE_POOL_SIZE 64

I'd use a larger pool, for example, 1M memory to create an optimal IO. 1M
should be good for SSD.

>  struct r5l_recovery_ctx {
>  	struct page *meta_page;		/* current meta */
>  	sector_t meta_total_blocks;	/* total size of current meta and data */
> @@ -1560,18 +1562,130 @@ struct r5l_recovery_ctx {
>  	int data_parity_stripes;	/* number of data_parity stripes */
>  	int data_only_stripes;		/* number of data_only stripes */
>  	struct list_head cached_list;
> +
> +	/*
> +	 * read ahead page pool (ra_pool)
> +	 * in recovery, log is read sequentially. It is not efficient to
> +	 * read every page with sync_page_io(). The read ahead page pool
> +	 * reads multiple pages with one IO, so further log read can
> +	 * just copy data from the pool.
> +	 */
> +	struct page *ra_pool[R5L_RECOVERY_PAGE_POOL_SIZE];
> +	sector_t pool_offset;	/* offset of first page in the pool */
> +	int total_pages;	/* total allocated pages */
> +	int valid_pages;	/* pages with valid data */
> +	struct bio *ra_bio;	/* bio to do the read ahead*/
>  };

snip

> +				  struct r5l_recovery_ctx *ctx,
> +				  struct page *page,
> +				  sector_t offset)
> +{
> +	int ret;
> +
> +	if (offset < ctx->pool_offset ||
> +	    offset >= ctx->pool_offset + ctx->valid_pages * BLOCK_SECTORS) {
> +		ret = r5l_recovery_fetch_ra_pool(log, ctx, offset);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	BUG_ON(offset < ctx->pool_offset ||
> +	       offset >= ctx->pool_offset + ctx->valid_pages * BLOCK_SECTORS);
> +
> +	memcpy(page_address(page),
> +	       page_address(ctx->ra_pool[(offset - ctx->pool_offset) / BLOCK_SECTORS]),

sector_t is u64. Divide isn't allowed in 32-bit system. The compiler probably
optmized this to '>> 9', but I'd suggest explictly doing it.

> +	       PAGE_SIZE);
> +	return 0;
> +}
> +
>  static int r5l_recovery_read_meta_block(struct r5l_log *log,
>  					struct r5l_recovery_ctx *ctx)
>  {
>  	struct page *page = ctx->meta_page;
>  	struct r5l_meta_block *mb;
>  	u32 crc, stored_crc;
> +	int ret;
>  
> -	if (!sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page, REQ_OP_READ, 0,
> -			  false))
> -		return -EIO;
> +	ret = r5l_recovery_read_page(log, ctx, page, ctx->pos);
> +	if (ret != 0)
> +		return ret;
>  
>  	mb = page_address(page);
>  	stored_crc = le32_to_cpu(mb->checksum);
> @@ -1653,8 +1767,7 @@ static void r5l_recovery_load_data(struct r5l_log *log,
>  	raid5_compute_sector(conf,
>  			     le64_to_cpu(payload->location), 0,
>  			     &dd_idx, sh);
> -	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
> -		     sh->dev[dd_idx].page, REQ_OP_READ, 0, false);
> +	r5l_recovery_read_page(log, ctx, sh->dev[dd_idx].page, log_offset);
>  	sh->dev[dd_idx].log_checksum =
>  		le32_to_cpu(payload->checksum[0]);
>  	ctx->meta_total_blocks += BLOCK_SECTORS;
> @@ -1673,17 +1786,13 @@ static void r5l_recovery_load_parity(struct r5l_log *log,
>  	struct r5conf *conf = mddev->private;
>  
>  	ctx->meta_total_blocks += BLOCK_SECTORS * conf->max_degraded;
> -	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
> -		     sh->dev[sh->pd_idx].page, REQ_OP_READ, 0, false);
> +	r5l_recovery_read_page(log, ctx, sh->dev[sh->pd_idx].page, log_offset);
>  	sh->dev[sh->pd_idx].log_checksum =
>  		le32_to_cpu(payload->checksum[0]);
>  	set_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags);
>  
>  	if (sh->qd_idx >= 0) {
> -		sync_page_io(log->rdev,
> -			     r5l_ring_add(log, log_offset, BLOCK_SECTORS),
> -			     PAGE_SIZE, sh->dev[sh->qd_idx].page,
> -			     REQ_OP_READ, 0, false);
> +		r5l_recovery_read_page(log, ctx, sh->dev[sh->qd_idx].page, log_offset);

The original code reads from 'r5l_ring_add(log, log_offset, BLOCK_SECTORS)',
now the code reads from log_offset, is this intended?

Thanks,
Shaohua
