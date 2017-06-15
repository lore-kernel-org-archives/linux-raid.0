From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC PATCH] md/raid1: remove unused bio in sync_request_write
Date: Thu, 15 Jun 2017 10:04:31 -0700
Message-ID: <20170615170431.43guhslraqbjpltr@kernel.org>
References: <20170615090025.22826-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170615090025.22826-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: shli@fb.com, neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 15, 2017 at 05:00:25PM +0800, Guoqing Jiang wrote:
> The "bio" is not used in sync_request_write after commit a68e58703575
> ("md/raid1: split out two sub-functions from sync_request_write").

applied, wondering why gcc doesn't report this.
 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> Not sure if my understanding is right, so it is for RFC. 
> 
>  drivers/md/raid1.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6701993..9c51e31 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2181,9 +2181,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>  	struct r1conf *conf = mddev->private;
>  	int i;
>  	int disks = conf->raid_disks * 2;
> -	struct bio *bio, *wbio;
> -
> -	bio = r1_bio->bios[r1_bio->read_disk];
> +	struct bio *wbio;
>  
>  	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>  		/* ouch - failed to read all of that. */
> -- 
> 2.10.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
