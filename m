From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: simplify code with bio_io_error
Date: Fri, 2 Jun 2017 09:29:26 -0700
Message-ID: <20170602162926.onnaflcf26ahuoti@kernel.org>
References: <20170602074914.26842-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170602074914.26842-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 02, 2017 at 03:49:14PM +0800, Guoqing Jiang wrote:
> bio_io_error was introduced in the commit 4246a0b
> ("block: add a bi_error field to struct bio"), so
> use it to simplify code.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Applied, thanks! There are several other places which could use conversion, I added
too.

> ---
>  drivers/md/raid1.c  | 3 +--
>  drivers/md/raid10.c | 3 +--
>  drivers/md/raid5.c  | 3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index af5056d..c20eb78 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -802,8 +802,7 @@ static void flush_bio_list(struct r1conf *conf, struct bio *bio)
>  		bio->bi_next = NULL;
>  		bio->bi_bdev = rdev->bdev;
>  		if (test_bit(Faulty, &rdev->flags)) {
> -			bio->bi_error = -EIO;
> -			bio_endio(bio);
> +			bio_io_error(bio);
>  		} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
>  				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>  			/* Just ignore it */
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 4343d7f..ceb9709 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -913,8 +913,7 @@ static void flush_pending_writes(struct r10conf *conf)
>  			bio->bi_next = NULL;
>  			bio->bi_bdev = rdev->bdev;
>  			if (test_bit(Faulty, &rdev->flags)) {
> -				bio->bi_error = -EIO;
> -				bio_endio(bio);
> +				bio_io_error(bio);
>  			} else if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
>  					    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>  				/* Just ignore it */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7220646..57aa044 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3429,8 +3429,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>  				struct bio *nextbi =
>  					r5_next_bio(bi, sh->dev[i].sector);
>  
> -				bi->bi_error = -EIO;
> -				bio_endio(bi);
> +				bio_io_error(bi);
>  				bi = nextbi;
>  			}
>  		}
> -- 
> 2.10.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
