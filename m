From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md:MD_CLOSING needs to be cleared after called
 md_set_readonly or do_md_stop
Date: Mon, 10 Apr 2017 10:47:12 -0700
Message-ID: <20170410174712.dz2tlgk4mh25sxhh@kernel.org>
References: <1491448593-12938-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491448593-12938-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Thu, Apr 06, 2017 at 11:16:33AM +0800, Zhilong Liu wrote:
> From: NeilBrown <neilb@suse.com>
> 
> if called md_set_readonly and set MD_CLOSING bit, the mddev cannot
> be opened any more due to the MD_CLOING bit wasn't cleared. Thus it
> needs to be cleared in md_ioctl after any call to md_set_readonly()
> or do_md_stop().
> Fixes: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

thanks, applied! This one looks stable stuff too.

> ---
> 
>  drivers/md/md.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d6..906a4bf 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6776,6 +6776,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>  	void __user *argp = (void __user *)arg;
>  	struct mddev *mddev = NULL;
>  	int ro;
> +	bool did_set_md_closing = false;
>  
>  	if (!md_ioctl_valid(cmd))
>  		return -ENOTTY;
> @@ -6865,7 +6866,9 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>  			err = -EBUSY;
>  			goto out;
>  		}
> +		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
>  		set_bit(MD_CLOSING, &mddev->flags);
> +		did_set_md_closing = true;
>  		mutex_unlock(&mddev->open_mutex);
>  		sync_blockdev(bdev);
>  	}
> @@ -7058,6 +7061,8 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>  		mddev->hold_active = 0;
>  	mddev_unlock(mddev);
>  out:
> +	if(did_set_md_closing)
> +		clear_bit(MD_CLOSING, &mddev->flags);
>  	return err;
>  }
>  #ifdef CONFIG_COMPAT
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
