From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: call bitmap_destroy in case bitmap_create
 failed
Date: Fri, 25 Mar 2016 15:02:10 -0700
Message-ID: <20160325220210.GA78806@kernel.org>
References: <1458903614-21498-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458903614-21498-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Fri, Mar 25, 2016 at 07:00:14PM +0800, Guoqing Jiang wrote:
> If bitmap_create returns an error, bitmap_destroy must be
> called to do clean up.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/bitmap.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 7df6b4f..ba908e7 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1865,8 +1865,10 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
>  	struct bitmap_counts *counts;
>  	struct bitmap *bitmap = bitmap_create(mddev, slot);
>  
> -	if (IS_ERR(bitmap))
> +	if (IS_ERR(bitmap)) {
> +		bitmap_destroy(mddev);
>  		return PTR_ERR(bitmap);
> +	}

bitmap_create doesn't set mddev->bitmap, so bitmap_destroy will do nothing.
is this because of reference leak of sysfs_can_clear? can we move
sysfs_put(bitmap->sysfs_can_clear); to bitmap_free?

Thanks,
Shaohua
