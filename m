From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md.c:didn't unlock the mddev before return EINVAL in
 array_size_store
Date: Mon, 10 Apr 2017 15:23:55 +0800
Message-ID: <58EB330B.9070309@suse.com>
References: <1491804955-7548-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491804955-7548-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 04/10/2017 02:15 PM, Zhilong Liu wrote:
> md.c: it needs to release the mddev lock before
> the array_size_store() returns.

Fixes: ab5a98b132fd ("md-cluster: change array_sectors and update size 
are not supported")

>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d6..5327236 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4843,8 +4843,10 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
>   		return err;
>   
>   	/* cluster raid doesn't support change array_sectors */
> -	if (mddev_is_clustered(mddev))
> +	if (mddev_is_clustered(mddev)) {
> +		mddev_unlock(mddev);
>   		return -EINVAL;
> +	}

Reviewed-by: Guoqing Jiang <gqjiang@suse.com>

Thanks,
Guoqing
