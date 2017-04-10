From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md.c:didn't unlock the mddev before return EINVAL in
 array_size_store
Date: Mon, 10 Apr 2017 10:49:53 -0700
Message-ID: <20170410174953.vkbsf373ytdxjyhv@kernel.org>
References: <1491804955-7548-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491804955-7548-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 10, 2017 at 02:15:55PM +0800, Zhilong Liu wrote:
> md.c: it needs to release the mddev lock before
> the array_size_store() returns.

applied, thanks!
 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  drivers/md/md.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d6..5327236 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4843,8 +4843,10 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
>  		return err;
>  
>  	/* cluster raid doesn't support change array_sectors */
> -	if (mddev_is_clustered(mddev))
> +	if (mddev_is_clustered(mddev)) {
> +		mddev_unlock(mddev);
>  		return -EINVAL;
> +	}
>  
>  	if (strncmp(buf, "default", 7) == 0) {
>  		if (mddev->pers)
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
