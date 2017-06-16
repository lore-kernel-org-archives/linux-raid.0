From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: don't read page from device with Bitmap_sync
Date: Fri, 16 Jun 2017 10:36:13 -0700
Message-ID: <20170616173613.c2cp6qt2hmoebgct@kernel.org>
References: <20170616091927.12959-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170616091927.12959-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 16, 2017 at 05:19:27PM +0800, Guoqing Jiang wrote:
> The device owns Bitmap_sync flag needs recovery
> to become in sync, and read page from this type
> device could get stale status.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> When develop for clustered raid10 feature, if add a
> disk under grow mode in master node, I could get
> the "bitmap superblock UUID mismatch" warning due
> to the page is read from Bitmap_sync device.
> 
>  drivers/md/bitmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index bf7419a..bf34cd8 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -156,7 +156,8 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
>  
>  	rdev_for_each(rdev, mddev) {
>  		if (! test_bit(In_sync, &rdev->flags)

Why In_sync is set for the rdev? I think it shoudn't.

> -		    || test_bit(Faulty, &rdev->flags))
> +		    || test_bit(Faulty, &rdev->flags)
> +		    || test_bit(Bitmap_sync, &rdev->flags))

I didn't see code clears the Bitmap_sync bit after disk is synced, so likely
there is bug in this side.

>  			continue;
>  
>  		target = offset + index * (PAGE_SIZE/512);
> -- 
> 2.10.0
> 
