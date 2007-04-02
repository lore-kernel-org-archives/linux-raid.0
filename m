From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] md: Avoid a deadlock when removing a device from an md
 array via sysfs.
Date: Mon, 2 Apr 2007 01:01:41 -0700
Message-ID: <20070402010141.3ad5516d.akpm@linux-foundation.org>
References: <20070402174319.30997.patches@notabene>
	<1070402074417.31093@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1070402074417.31093@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-raid.ids

On Mon, 2 Apr 2007 17:44:17 +1000 NeilBrown <neilb@suse.de> wrote:

> (This patch should go in 2.6.21 as it fixes a recent regression - NB)
> 
> A device can be removed from an md array via e.g.
>   echo remove > /sys/block/md3/md/dev-sde/state
> 
> This will try to remove the 'dev-sde' subtree which will deadlock
> since
>   commit e7b0d26a86943370c04d6833c6edba2a72a6e240
> 
> With this patch we run the kobject_del via schedule_work so as to
> avoid the deadlock.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./drivers/md/md.c           |   13 ++++++++++++-
>  ./include/linux/raid/md_k.h |    1 +
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff .prev/drivers/md/md.c ./drivers/md/md.c
> --- .prev/drivers/md/md.c	2007-04-02 17:43:03.000000000 +1000
> +++ ./drivers/md/md.c	2007-04-02 17:38:46.000000000 +1000
> @@ -1389,6 +1389,12 @@ static int bind_rdev_to_array(mdk_rdev_t
>  	return err;
>  }
>  
> +static void delayed_delete(struct work_struct *ws)
> +{
> +	mdk_rdev_t *rdev = container_of(ws, mdk_rdev_t, del_work);
> +	kobject_del(&rdev->kobj);
> +}
> +
>  static void unbind_rdev_from_array(mdk_rdev_t * rdev)
>  {
>  	char b[BDEVNAME_SIZE];
> @@ -1401,7 +1407,12 @@ static void unbind_rdev_from_array(mdk_r
>  	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
>  	rdev->mddev = NULL;
>  	sysfs_remove_link(&rdev->kobj, "block");
> -	kobject_del(&rdev->kobj);
> +
> +	/* We need to delay this, otherwise we can deadlock when
> +	 * writing to 'remove' to "dev/state"
> +	 */
> +	INIT_WORK(&rdev->del_work, delayed_delete);
> +	schedule_work(&rdev->del_work);
>  }
>  
>  /*
> 
> diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
> --- .prev/include/linux/raid/md_k.h	2007-04-02 17:43:03.000000000 +1000
> +++ ./include/linux/raid/md_k.h	2007-04-02 17:36:32.000000000 +1000
> @@ -104,6 +104,7 @@ struct mdk_rdev_s
>  					   * for reporting to userspace and storing
>  					   * in superblock.
>  					   */
> +	struct work_struct del_work;	/* used for delayed sysfs removal */
>  };
>  

What guarantees that *rdev is still valid when delayed_delete() runs?

And what guarantees that the md module hasn't been rmmodded when
delayed_delete() tries to run?

