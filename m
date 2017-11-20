From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3 1/2] md/r5cache: move mddev_lock() out of
 r5c_journal_mode_set()
Date: Sun, 19 Nov 2017 19:54:49 -0800
Message-ID: <20171120035449.5znzyjaayzswcsuy@kernel.org>
References: <20171118012312.2562038-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171118012312.2562038-1-songliubraving@fb.com>
Sender: stable-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, kernel-team@fb.com, neilb@suse.com, artur.paszkiewicz@intel.com, "v4.13+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Nov 17, 2017 at 05:23:11PM -0800, Song Liu wrote:
> r5c_journal_mode_set() is called by r5c_journal_mode_store() and
> raid_ctr() in dm-raid. We don't need mddev_lock() when calling from
> raid_ctr(). This patch fixes this by moves the mddev_lock() to
> r5c_journal_mode_store().
> 
> Cc: stable@vger.kernel.org (v4.13+)
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index f1c86d9..e01f229 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2583,25 +2583,19 @@ int r5c_journal_mode_set(struct mddev *mddev, int mode)
>  	    mode > R5C_JOURNAL_MODE_WRITE_BACK)
>  		return -EINVAL;
>  
> -	err = mddev_lock(mddev);
>  	if (err)
>  		return err;

please make sure your code doesn't have compiling warnning. The 'err' is an
obvious 'use before initialization' warnning.

>  	conf = mddev->private;
> -	if (!conf || !conf->log) {
> -		mddev_unlock(mddev);
> +	if (!conf || !conf->log)
>  		return -ENODEV;
> -	}
>  
>  	if (raid5_calc_degraded(conf) > 0 &&
> -	    mode == R5C_JOURNAL_MODE_WRITE_BACK) {
> -		mddev_unlock(mddev);
> +	    mode == R5C_JOURNAL_MODE_WRITE_BACK)
>  		return -EINVAL;
> -	}
>  
>  	mddev_suspend(mddev);
>  	conf->log->r5c_journal_mode = mode;
>  	mddev_resume(mddev);
> -	mddev_unlock(mddev);
>  
>  	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
>  		 mdname(mddev), mode, r5c_journal_mode_str[mode]);
> @@ -2614,6 +2608,7 @@ static ssize_t r5c_journal_mode_store(struct mddev *mddev,
>  {
>  	int mode = ARRAY_SIZE(r5c_journal_mode_str);
>  	size_t len = length;
> +	int ret;
>  
>  	if (len < 2)
>  		return -EINVAL;
> @@ -2625,8 +2620,10 @@ static ssize_t r5c_journal_mode_store(struct mddev *mddev,
>  		if (strlen(r5c_journal_mode_str[mode]) == len &&
>  		    !strncmp(page, r5c_journal_mode_str[mode], len))
>  			break;
> -
> -	return r5c_journal_mode_set(mddev, mode) ?: length;
> +	mddev_lock(mddev);

and you don't check return value for mddev_lock, which has __must_check marked.

> +	ret = r5c_journal_mode_set(mddev, mode);
> +	mddev_unlock(mddev);
> +	return ret ?: length;
>  }
>  
>  struct md_sysfs_entry
> -- 
> 2.9.5
> 
