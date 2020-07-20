From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V1 1/3] Move codes related with submitting discard bio
 into one function
Date: Mon, 20 Jul 2020 13:14:13 +0800
Message-ID: <409c3135-c831-6afb-5d58-075d0d5a6fc4@suse.de>
References: <1595221108-10137-1-git-send-email-xni@redhat.com>
 <1595221108-10137-2-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595221108-10137-2-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids

On 2020/7/20 12:58, Xiao Ni wrote:
> These codes can be used in raid10. So we can move these codes into md.c. raid0 and raid10
> can share these codes.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>

It looks good to me.

Reviewed-by: Coly Li <colyli@suse.de>




> ---
>  drivers/md/md.c    | 22 ++++++++++++++++++++++
>  drivers/md/md.h    |  3 +++
>  drivers/md/raid0.c | 15 ++-------------
>  3 files changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 07e5b67..2b8f654 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8559,6 +8559,28 @@ void md_write_end(struct mddev *mddev)
>  
>  EXPORT_SYMBOL(md_write_end);
>  
> +void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> +				struct bio *bio,
> +				sector_t dev_start, sector_t dev_end)
> +{
> +	struct bio *discard_bio = NULL;
> +
> +	if (__blkdev_issue_discard(rdev->bdev,
> +	    dev_start + rdev->data_offset,
> +	    dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
> +	    !discard_bio)
> +		return;
> +
> +	bio_chain(discard_bio, bio);
> +	bio_clone_blkg_association(discard_bio, bio);
> +	if (mddev->gendisk)
> +		trace_block_bio_remap(bdev_get_queue(rdev->bdev),
> +			discard_bio, disk_devt(mddev->gendisk),
> +			bio->bi_iter.bi_sector);
> +	submit_bio_noacct(discard_bio);
> +}
> +EXPORT_SYMBOL(md_submit_discard_bio);
> +
>  /* md_allow_write(mddev)
>   * Calling this ensures that the array is marked 'active' so that writes
>   * may proceed without blocking.  It is important to call this before
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index c26fa8b..83ae77e 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -710,6 +710,9 @@ extern void md_write_end(struct mddev *mddev);
>  extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
>  extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
>  extern void md_finish_reshape(struct mddev *mddev);
> +extern void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
> +				struct bio *bio,
> +				sector_t dev_start, sector_t dev_end);
>  
>  extern int mddev_congested(struct mddev *mddev, int bits);
>  extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e9e91c8..e37fe8a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -525,7 +525,6 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>  
>  	for (disk = 0; disk < zone->nb_dev; disk++) {
>  		sector_t dev_start, dev_end;
> -		struct bio *discard_bio = NULL;
>  		struct md_rdev *rdev;
>  
>  		if (disk < start_disk_index)
> @@ -548,18 +547,8 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>  
>  		rdev = conf->devlist[(zone - conf->strip_zone) *
>  			conf->strip_zone[0].nb_dev + disk];
> -		if (__blkdev_issue_discard(rdev->bdev,
> -			dev_start + zone->dev_start + rdev->data_offset,
> -			dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
> -		    !discard_bio)
> -			continue;
> -		bio_chain(discard_bio, bio);
> -		bio_clone_blkg_association(discard_bio, bio);
> -		if (mddev->gendisk)
> -			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
> -				discard_bio, disk_devt(mddev->gendisk),
> -				bio->bi_iter.bi_sector);
> -		submit_bio_noacct(discard_bio);
> +		dev_start += zone->dev_start;
> +		md_submit_discard_bio(mddev, rdev, bio, dev_start, dev_end);
>  	}
>  	bio_endio(bio);
>  }
> 
