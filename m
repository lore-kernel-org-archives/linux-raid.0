From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V2] md: simplify code with bio_io_error
Date: Fri, 21 Jul 2017 13:16:21 -0700
Message-ID: <20170721201621.22ujevzgnqfgr43d@kernel.org>
References: <20170721083344.32134-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170721083344.32134-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 21, 2017 at 04:33:44PM +0800, Guoqing Jiang wrote:
> Since bio_io_error sets bi_status to BLK_STS_IOERR,
> and calls bio_endio, so we can use it directly.
> 
> And as mentioned by Shaohua, there are also two
> places in raid5.c can use bio_io_error either.

applied, thanks! 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> V2:
> No changes, just rebased on latest kernel tree.
> 
>  drivers/md/raid1.c  | 3 +--
>  drivers/md/raid10.c | 6 ++----
>  drivers/md/raid5.c  | 9 +++------
>  3 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 1d235cc..f50958d 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -790,8 +790,7 @@ static void flush_bio_list(struct r1conf *conf, struct bio *bio)
>  		bio->bi_next = NULL;
>  		bio->bi_bdev = rdev->bdev;
>  		if (test_bit(Faulty, &rdev->flags)) {
> -			bio->bi_status = BLK_STS_IOERR;
> -			bio_endio(bio);
> +			bio_io_error(bio);
>  		} else if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
>  				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>  			/* Just ignore it */
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e2617d0..f55d4cc 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -905,8 +905,7 @@ static void flush_pending_writes(struct r10conf *conf)
>  			bio->bi_next = NULL;
>  			bio->bi_bdev = rdev->bdev;
>  			if (test_bit(Faulty, &rdev->flags)) {
> -				bio->bi_status = BLK_STS_IOERR;
> -				bio_endio(bio);
> +				bio_io_error(bio);
>  			} else if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
>  					    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>  				/* Just ignore it */
> @@ -1090,8 +1089,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>  		bio->bi_next = NULL;
>  		bio->bi_bdev = rdev->bdev;
>  		if (test_bit(Faulty, &rdev->flags)) {
> -			bio->bi_status = BLK_STS_IOERR;
> -			bio_endio(bio);
> +			bio_io_error(bio);
>  		} else if (unlikely((bio_op(bio) ==  REQ_OP_DISCARD) &&
>  				    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
>  			/* Just ignore it */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index aeeb8d6..4904dff 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3381,9 +3381,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>  			sh->dev[i].sector + STRIPE_SECTORS) {
>  			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
>  
> -			bi->bi_status = BLK_STS_IOERR;
>  			md_write_end(conf->mddev);
> -			bio_endio(bi);
> +			bio_io_error(bi);
>  			bi = nextbi;
>  		}
>  		if (bitmap_end)
> @@ -3403,9 +3402,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>  		       sh->dev[i].sector + STRIPE_SECTORS) {
>  			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
>  
> -			bi->bi_status = BLK_STS_IOERR;
>  			md_write_end(conf->mddev);
> -			bio_endio(bi);
> +			bio_io_error(bi);
>  			bi = bi2;
>  		}
>  
> @@ -3429,8 +3427,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>  				struct bio *nextbi =
>  					r5_next_bio(bi, sh->dev[i].sector);
>  
> -				bi->bi_status = BLK_STS_IOERR;
> -				bio_endio(bi);
> +				bio_io_error(bi);
>  				bi = nextbi;
>  			}
>  		}
> -- 
> 2.10.0
> 
