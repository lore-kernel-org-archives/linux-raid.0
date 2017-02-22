From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] md/raid1: handle flush request correctly
Date: Wed, 22 Feb 2017 19:43:10 +0800
Message-ID: <ed6dc00a-5433-d0fd-b50b-0e24af2eaf4b@suse.de>
References: <45d118f3ebfef696ffc5a725db5ca775360a51b2.1487703748.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45d118f3ebfef696ffc5a725db5ca775360a51b2.1487703748.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 2017/2/22 上午3:03, Shaohua Li wrote:
> I got a warning triggered in align_to_barrier_unit_end. It's a flush
> request so sectors == 0. The flush request happens to work well without
> the new barrier patch, but we'd better handle it explictly.
> 
> Cc: Coly Li <colyli@suse.de>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly

> ---
>  drivers/md/raid1.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 954d028..e1ee446 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1282,8 +1282,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
>  	unsigned long flags;
>  	const int op = bio_op(bio);
>  	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
> -	const unsigned long do_flush_fua = (bio->bi_opf &
> -						(REQ_PREFLUSH | REQ_FUA));
> +	const unsigned long do_fua = (bio->bi_opf & REQ_FUA);
>  	struct md_rdev *blocked_rdev;
>  	struct blk_plug_cb *cb;
>  	struct raid1_plug_cb *plug = NULL;
> @@ -1509,7 +1508,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
>  				   conf->mirrors[i].rdev->data_offset);
>  		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
>  		mbio->bi_end_io	= raid1_end_write_request;
> -		bio_set_op_attrs(mbio, op, do_flush_fua | do_sync);
> +		bio_set_op_attrs(mbio, op, do_fua | do_sync);
>  		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags) &&
>  		    !test_bit(WriteMostly, &conf->mirrors[i].rdev->flags) &&
>  		    conf->raid_disks - mddev->degraded > 1)
> @@ -1565,6 +1564,11 @@ static void raid1_make_request(struct mddev *mddev, struct bio *bio)
>  	struct bio *split;
>  	sector_t sectors;
>  
> +	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
> +		md_flush_request(mddev, bio);
> +		return;
> +	}
> +
>  	/* if bio exceeds barrier unit boundary, split it */
>  	sectors = align_to_barrier_unit_end(
>  			bio->bi_iter.bi_sector, bio_sectors(bio));
> 

