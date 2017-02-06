From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: ensure md devices are freed before module is
 unloaded.
Date: Mon, 6 Feb 2017 12:03:09 -0800
Message-ID: <20170206200309.ryu7dg6hjczsibao@kernel.org>
References: <87r33cvy58.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r33cvy58.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 06, 2017 at 01:41:39PM +1100, Neil Brown wrote:
> 
> 
> Commit: cbd199837750 ("md: Fix unfortunate interaction with evms")
> change mddev_put() so that it would not destroy an md device while
> ->ctime was non-zero.
> 
> Unfortunately, we didn't make sure to clear ->ctime when unloading
> the module, so it is possible for an md device to remain after
> module unload.  An attempt to open such a device will trigger
> an invalid memory reference in:
>   get_gendisk -> kobj_lookup -> exact_lock -> get_disk
> 
> when tring to access disk->fops, which was in the module that has
> been removed.
> 
> So ensure we clear ->ctime in md_exit(), and explain how that is useful,
> as it isn't immediately obvious when looking at the code.
> 
> Fixes: cbd199837750 ("md: Fix unfortunate interaction with evms")
> Tested-by: Guoqing Jiang <gqjiang@suse.com>
> Signed-off-by: NeilBrown <neilb@suse.com>
Applied, thanks!

> ---
>  drivers/md/md.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 01175dac0db6..8926fb781cdc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8980,7 +8980,14 @@ static __exit void md_exit(void)
>  
>  	for_each_mddev(mddev, tmp) {
>  		export_array(mddev);
> +		mddev->ctime = 0;
>  		mddev->hold_active = 0;
> +		/* for_each_mddev() will call mddev_put() at the
> +		 * end of each iteration.  As the mddev is now
> +		 * fully clear, this will schedule the mddev for destruction
> +		 * by a workqueue, and the destroy_workqueue() below
> +		 * will wait for that to complete.
> +		 */
>  	}
>  	destroy_workqueue(md_misc_wq);
>  	destroy_workqueue(md_wq);
> -- 
> 2.11.0
> 


