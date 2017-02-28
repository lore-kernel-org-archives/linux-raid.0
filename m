From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 08/13] md: raid1: use bio helper in process_checks()
Date: Tue, 28 Feb 2017 15:39:09 -0800
Message-ID: <20170228233909.slbbjuh24p77pcrv@kernel.org>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-9-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488296503-4987-9-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Tue, Feb 28, 2017 at 11:41:38PM +0800, Ming Lei wrote:
> Avoid to direct access to bvec table.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/raid1.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d0cb5c026506..316bd6dd6cc1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2108,6 +2108,7 @@ static void process_checks(struct r1bio *r1_bio)
>  		int j;
>  		int size;
>  		int error;
> +		struct bio_vec *bi;
>  		struct bio *b = r1_bio->bios[i];
>  		struct resync_pages *rp = get_resync_pages(b);
>  		if (b->bi_end_io != end_sync_read)
> @@ -2126,9 +2127,7 @@ static void process_checks(struct r1bio *r1_bio)
>  		b->bi_private = rp;
>  
>  		size = b->bi_iter.bi_size;
> -		for (j = 0; j < vcnt ; j++) {
> -			struct bio_vec *bi;
> -			bi = &b->bi_io_vec[j];
> +		bio_for_each_segment_all(bi, b, j) {
>  			bi->bv_offset = 0;
>  			if (size > PAGE_SIZE)
>  				bi->bv_len = PAGE_SIZE;
> @@ -2152,17 +2151,22 @@ static void process_checks(struct r1bio *r1_bio)
>  		int error = sbio->bi_error;
>  		struct page **ppages = get_resync_pages(pbio)->pages;
>  		struct page **spages = get_resync_pages(sbio)->pages;
> +		struct bio_vec *bi;
> +		int page_len[RESYNC_PAGES];
>  
>  		if (sbio->bi_end_io != end_sync_read)
>  			continue;
>  		/* Now we can 'fixup' the error value */
>  		sbio->bi_error = 0;
>  
> +		bio_for_each_segment_all(bi, sbio, j)
> +			page_len[j] = bi->bv_len;
> +

If we record length for each page in resync_pages (don't need offset, because
it should be 0), we don't need to access the bio_vec too.

Thanks,
Shaohua
