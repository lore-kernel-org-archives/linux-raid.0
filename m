From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 2/6] r5cache: sysfs entry r5c_state
Date: Tue, 27 Sep 2016 15:58:40 -0700
Message-ID: <20160927225840.GB98100@kernel.org>
References: <20160926233050.3351081-1-songliubraving@fb.com>
 <20160926233050.3351081-3-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160926233050.3351081-3-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Mon, Sep 26, 2016 at 04:30:46PM -0700, Song Liu wrote:
> r5c_state have 4 states:
> * no-cache;
> * write-through (write journal only);
> * write-back (w/ write cache);
> * cache-broken (journal missing or Faulty)
> 
> When there is functional write cache, r5c_state is a knob to
> switch between write-back and write-through.
> 
> When the journal device is broken, the raid array is forced
> in readonly mode. In this case, r5c_state can be used to
> remove "journal feature", and thus make the array read-write
> without journal. By writing into r5c_cache_mode, the array
> can transit from cache-broken to no-cache, which removes
> journal feature for the array.

How will user use the new interface? I suppose
-raid array is forced readonly mode (by kernel)
-user uses the new interface to remove journal
-user forces array read-write
-kernel will update superblock and array can run read/write

please describe
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c       |  1 +
>  drivers/md/raid5.h       |  2 ++
>  3 files changed, 60 insertions(+)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 6b28461..0a0b16a 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -54,6 +54,9 @@ enum r5c_state {
>  	R5C_STATE_CACHE_BROKEN = 3,
>  };
>  
> +static char *r5c_state_str[] = {"no-cache", "write-through",
> +				"write-back", "cache-broken"};
> +
>  struct r5l_log {
>  	struct md_rdev *rdev;
>  
> @@ -1242,6 +1245,60 @@ int r5c_flush_cache(struct r5conf *conf, int num)
>  	return count;
>  }
>  
> +ssize_t r5c_state_show(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf = mddev->private;
> +	int val = 0;
> +	int ret = 0;
> +
> +	if (conf->log)
> +		val = conf->log->r5c_state;
> +	else if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
> +		val = R5C_STATE_CACHE_BROKEN;
> +	ret += snprintf(page, PAGE_SIZE - ret, "%d: %s\n",
> +			val, r5c_state_str[val]);
> +	return ret;
> +}
> +
> +ssize_t r5c_state_store(struct mddev *mddev, const char *page, size_t len)
> +{
> +	struct r5conf *conf = mddev->private;
> +	struct r5l_log *log = conf->log;
> +	int val;
> +
> +	if (kstrtoint(page, 10, &val))
> +		return -EINVAL;
> +	if (!log && val != R5C_STATE_NO_CACHE)
> +		return -EINVAL;
> +
> +	if (val < R5C_STATE_NO_CACHE || val > R5C_STATE_WRITE_BACK)
> +		return -EINVAL;
> +	if (val == R5C_STATE_NO_CACHE) {
> +		if (conf->log &&
> +		    !test_bit(Faulty, &log->rdev->flags)) {
> +			pr_err("md/raid:%s: journal device is in use, cannot remove it\n",
> +			       mdname(mddev));
> +			return -EINVAL;
> +		}
> +	}
> +
> +	spin_lock_irq(&conf->device_lock);
> +	if (log)
> +		conf->log->r5c_state = val;
> +	if (val == R5C_STATE_NO_CACHE) {
> +		clear_bit(MD_HAS_JOURNAL, &mddev->flags);
> +		set_bit(MD_UPDATE_SB_FLAGS, &mddev->flags);
> +	}
> +	spin_unlock_irq(&conf->device_lock);
> +	pr_info("md/raid:%s: setting r5c cache mode to %d: %s\n",
> +		mdname(mddev), val, r5c_state_str[val]);
> +	return len;
> +}

Is this safe? Eg, switching from writethrough to writeback or vice versa in
runtime with IO running? I think you'd better call mddev_suspend/mddev_resume.

Thanks,
Shaohua
