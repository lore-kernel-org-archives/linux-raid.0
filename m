From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 6/8] md/r5cache: sysfs entry r5c_state
Date: Wed, 12 Oct 2016 09:56:47 -0700
Message-ID: <20161012165647.GB15323@kernel.org>
References: <20161011002446.2002428-1-songliubraving@fb.com>
 <20161011002446.2002428-7-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161011002446.2002428-7-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Mon, Oct 10, 2016 at 05:24:44PM -0700, Song Liu wrote:
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
> 
> To remove the journal feature:
> - When journal fails, the raid array is forced readonly mode
>   (enforced by kernel)
> - User uses the new interface to remove journal (writing 0
>   to r5c_state, I will add a mdadm option for that later)
> - User forces array read-write;
> - Kernel updates superblock and array can run read/write.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c       |  1 +
>  drivers/md/raid5.h       |  1 +
>  3 files changed, 60 insertions(+)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 2774f93..b19024c 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -57,6 +57,8 @@ enum r5c_state {
>  	R5C_STATE_CACHE_BROKEN = 3,
>  };
>  
> +static char *r5c_state_str[] = {"no-cache", "write-through",
> +				"write-back", "cache-broken"};
>  /*
>   * raid5 cache state machine
>   *
> @@ -1519,6 +1521,62 @@ int r5c_flush_cache(struct r5conf *conf, int num)
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
No point to do PAGE_SIZE - ret

This isn't how sysfs entry is supposed to output. You can either show the value
or the string, not both with format. I'd prefer the string though, and make
store accept string.

Thanks,
Shaohua
