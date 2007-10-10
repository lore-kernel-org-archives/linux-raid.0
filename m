From: Iustin Pop <iusty@k1024.org>
Subject: Re: [PATCH] Expose the degraded status of an assembled array
	through sysfs
Date: Wed, 10 Oct 2007 08:31:11 +0200
Message-ID: <20071010063111.GA32313@teal.hq.k1024.org>
References: <20070910165114.GA2597@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070910165114.GA2597@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Sep 10, 2007 at 06:51:14PM +0200, Iustin Pop wrote:
> The 'degraded' attribute is useful to quickly determine if the array is
> degraded, instead of parsing 'mdadm -D' output or relying on the other
> techniques (number of working devices against number of defined devices, etc.).
> The md code already keeps track of this attribute, so it's useful to export it.
> 
> Signed-off-by: Iustin Pop <iusty@k1024.org>
> ---
> Note: I sent this back in January and it people agreed it was a good
> idea.  However, it has not been picked up. So here I resend it again.

Ping? Neil, could you spare a few moments to look at this? (and sorry for
bothering you)

> 
> Patch is against 2.6.23-rc5
> 
> Thanks,
> Iustin Pop
> 
>  drivers/md/md.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f883b7e..3e3ad71 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2842,6 +2842,12 @@ sync_max_store(mddev_t *mddev, const char *buf, size_t len)
>  static struct md_sysfs_entry md_sync_max =
>  __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
>  
> +static ssize_t
> +degraded_show(mddev_t *mddev, char *page)
> +{
> +	return sprintf(page, "%i\n", mddev->degraded);
> +}
> +static struct md_sysfs_entry md_degraded = __ATTR_RO(degraded);
>  
>  static ssize_t
>  sync_speed_show(mddev_t *mddev, char *page)
> @@ -2985,6 +2991,7 @@ static struct attribute *md_redundancy_attrs[] = {
>  	&md_suspend_lo.attr,
>  	&md_suspend_hi.attr,
>  	&md_bitmap.attr,
> +	&md_degraded.attr,
>  	NULL,
>  };
>  static struct attribute_group md_redundancy_group = {
> -- 
> 1.5.3.1
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
