From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid10: fix FailFast test for wrong device
Date: Tue, 13 Jun 2017 10:11:20 -0700
Message-ID: <20170613171120.55eb7olmkk66f3vp@kernel.org>
References: <20170613031608.25923-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170613031608.25923-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 13, 2017 at 11:16:08AM +0800, Guoqing Jiang wrote:
> We need to test FailFast flag for replacement device here
> since the set up for writing is for the replacement, so we
> need fix it like:
> 
> - if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
> + if (test_bit(FailFast, &conf->mirrors[d].replacement->flags))

good catch!
 
> Since commit f90145f317ef ("md/raid10: add rcu protection
> to rdev access in raid10_sync_request.") had added the rcu
> protection for the part, so let's extend the range protected
> by rcu and use rdev directly.

it's unnecessary, since we already increase the nr_pending for the rdev, but
this isn't harmful either.

Applied, thanks!
> Fixes: 1919cbb ("md/raid10: add failfast handling for writes.")
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/raid10.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3273887..f25a2ae 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3294,7 +3294,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>  			biolist = bio;
>  			bio->bi_end_io = end_sync_read;
>  			bio_set_op_attrs(bio, REQ_OP_READ, 0);
> -			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
> +			if (test_bit(FailFast, &rdev->flags))
>  				bio->bi_opf |= MD_FAILFAST;
>  			bio->bi_iter.bi_sector = sector + rdev->data_offset;
>  			bio->bi_bdev = rdev->bdev;
> @@ -3306,7 +3306,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>  				continue;
>  			}
>  			atomic_inc(&rdev->nr_pending);
> -			rcu_read_unlock();
>  
>  			/* Need to set up for writing to the replacement */
>  			bio = r10_bio->devs[i].repl_bio;
> @@ -3317,11 +3316,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>  			biolist = bio;
>  			bio->bi_end_io = end_sync_write;
>  			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> -			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
> +			if (test_bit(FailFast, &rdev->flags))
>  				bio->bi_opf |= MD_FAILFAST;
>  			bio->bi_iter.bi_sector = sector + rdev->data_offset;
>  			bio->bi_bdev = rdev->bdev;
>  			count++;
> +			rcu_read_unlock();
>  		}
>  
>  		if (count < 2) {
> -- 
> 2.10.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
