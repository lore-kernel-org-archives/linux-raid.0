From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] MD: Free bioset when md_run fails
Date: Sat, 17 Feb 2018 13:08:41 -0800
Message-ID: <20180217210841.2ognsi2mwwu5wk65@kernel.org>
References: <1516767458-6542-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516767458-6542-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 24, 2018 at 12:17:38PM +0800, Xiao Ni wrote:
> Signed-off-by: Xiao Ni <xni@redhat.com>
applied, thanks

> ---
>  drivers/md/md.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1e562f5..f57b3a9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5485,8 +5485,10 @@ int md_run(struct mddev *mddev)
>  	}
>  	if (mddev->sync_set == NULL) {
>  		mddev->sync_set = bioset_create(BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
> -		if (!mddev->sync_set)
> -			return -ENOMEM;
> +		if (!mddev->sync_set) {
> +			err = -ENOMEM;
> +			goto abort;
> +		}
>  	}
>  
>  	spin_lock(&pers_lock);
> @@ -5499,7 +5501,8 @@ int md_run(struct mddev *mddev)
>  		else
>  			pr_warn("md: personality for level %s is not loaded!\n",
>  				mddev->clevel);
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto abort;
>  	}
>  	spin_unlock(&pers_lock);
>  	if (mddev->level != pers->level) {
> @@ -5512,7 +5515,8 @@ int md_run(struct mddev *mddev)
>  	    pers->start_reshape == NULL) {
>  		/* This personality cannot handle reshaping... */
>  		module_put(pers->owner);
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto abort;
>  	}
>  
>  	if (pers->sync_request) {
> @@ -5586,7 +5590,7 @@ int md_run(struct mddev *mddev)
>  		mddev->private = NULL;
>  		module_put(pers->owner);
>  		bitmap_destroy(mddev);
> -		return err;
> +		goto abort;
>  	}
>  	if (mddev->queue) {
>  		bool nonrot = true;
> @@ -5648,6 +5652,18 @@ int md_run(struct mddev *mddev)
>  	sysfs_notify_dirent_safe(mddev->sysfs_action);
>  	sysfs_notify(&mddev->kobj, NULL, "degraded");
>  	return 0;
> +
> +abort:
> +	if (mddev->bio_set) {
> +		bioset_free(mddev->bio_set);
> +		mddev->bio_set = NULL;
> +	}
> +	if (mddev->sync_set) {
> +		bioset_free(mddev->sync_set);
> +		mddev->sync_set = NULL;
> +	}
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(md_run);
>  
> -- 
> 2.7.4
> 
