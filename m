From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 13/13] md: raid10: avoid direct access to bvec table
 in handle_reshape_read_error
Date: Tue, 28 Feb 2017 15:46:27 -0800
Message-ID: <20170228234627.3h6tospuz33yhdig@kernel.org>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-14-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488296503-4987-14-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Tue, Feb 28, 2017 at 11:41:43PM +0800, Ming Lei wrote:
> The cost is 128bytes(8*16) stack space in kernel thread context, and
> just use the bio helper to retrieve pages from bio.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/raid10.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0b97631e3905..6ffb64ab45f8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4670,7 +4670,15 @@ static int handle_reshape_read_error(struct mddev *mddev,
>  	struct r10bio *r10b = &on_stack.r10_bio;
>  	int slot = 0;
>  	int idx = 0;
> -	struct bio_vec *bvec = r10_bio->master_bio->bi_io_vec;
> +	struct bio_vec *bvl;
> +	struct page *pages[RESYNC_PAGES];
> +
> +	/*
> +	 * This bio is allocated in reshape_request(), and size
> +	 * is still RESYNC_PAGES
> +	 */
> +	bio_for_each_segment_all(bvl, r10_bio->master_bio, idx)
> +		pages[idx] = bvl->bv_page;

The reshape bio is doing IO against the memory we allocated for r10_bio, I'm
wondering why we can't get the pages from r10_bio. In this way, we don't need
access the bio_vec any more.

Thanks,
Shaohua
 
>  	r10b->sector = r10_bio->sector;
>  	__raid10_find_phys(&conf->prev, r10b);
> @@ -4699,7 +4707,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
>  			success = sync_page_io(rdev,
>  					       addr,
>  					       s << 9,
> -					       bvec[idx].bv_page,
> +					       pages[idx],
>  					       REQ_OP_READ, 0, false);
>  			rdev_dec_pending(rdev, mddev);
>  			rcu_read_lock();
> -- 
> 2.7.4
> 
