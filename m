From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 7/7] raid5-ppl: runtime PPL enabling or disabling
Date: Mon, 27 Feb 2017 17:31:35 -0800
Message-ID: <20170228013135.g4x7cu63rakvpacx@kernel.org>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
 <20170221194401.18733-8-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170221194401.18733-8-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 21, 2017 at 08:44:01PM +0100, Artur Paszkiewicz wrote:
> Allow writing to 'consistency_policy' attribute when the array is
> active. Add a new function 'change_consistency_policy' to the
> md_personality operations structure to handle the change in the
> personality code. Values "ppl" and "resync" are accepted and
> turn PPL on and off respectively.
> 
> When enabling PPL its location and size should first be set using
> 'ppl_sector' and 'ppl_size' attributes and a valid PPL header should be
> written at this location on each member device.
> 
> Enabling or disabling PPL is performed under a suspended array.  The
> raid5_reset_stripe_cache function frees the stripe cache and allocates
> it again in order to allocate or free the ppl_pages for the stripes in
> the stripe cache.
> 
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/md.c        | 12 ++++++++---
>  drivers/md/md.h        |  2 ++
>  drivers/md/raid5-ppl.c |  4 ++++
>  drivers/md/raid5.c     | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 73 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3ff979d538d4..b70e19513588 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5003,14 +5003,20 @@ consistency_policy_show(struct mddev *mddev, char *page)
>  static ssize_t
>  consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> +	int err = 0;
> +
>  	if (mddev->pers) {
> -		return -EBUSY;
> +		if (mddev->pers->change_consistency_policy)
> +			err = mddev->pers->change_consistency_policy(mddev, buf);
> +		else
> +			err = -EBUSY;
>  	} else if (mddev->external && strncmp(buf, "ppl", 3) == 0) {
>  		set_bit(MD_HAS_PPL, &mddev->flags);
> -		return len;
>  	} else {
> -		return -EINVAL;
> +		err = -EINVAL;
>  	}
> +
> +	return err ? err : len;
>  }
>  
>  static struct md_sysfs_entry md_consistency_policy =
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 66a5a16e79f7..88a5155c152e 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -548,6 +548,8 @@ struct md_personality
>  	/* congested implements bdi.congested_fn().
>  	 * Will not be called while array is 'suspended' */
>  	int (*congested)(struct mddev *mddev, int bits);
> +	/* Changes the consistency policy of an active array. */
> +	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
>  };
>  
>  struct md_sysfs_entry {
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index c2070d124849..a5c4d3333bce 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -1095,6 +1095,10 @@ int ppl_init_log(struct r5conf *conf)
>  		 */
>  		mddev->recovery_cp = MaxSector;
>  		set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
> +	} else if (mddev->pers && ppl_conf->mismatch_count > 0) {
> +		/* no mismatch allowed when enabling PPL for a running array */
> +		ret = -EINVAL;
> +		goto err;
>  	}
>  
>  	conf->ppl = ppl_conf;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b17e90f06f19..754fb8e1c76f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8319,6 +8319,63 @@ static void *raid6_takeover(struct mddev *mddev)
>  	return setup_conf(mddev);
>  }
>  
> +static void raid5_reset_stripe_cache(struct mddev *mddev)
> +{
> +	struct r5conf *conf = mddev->private;
> +
> +	mutex_lock(&conf->cache_size_mutex);
> +	while (conf->max_nr_stripes &&
> +	       drop_one_stripe(conf))
> +		;
> +	while (conf->min_nr_stripes > conf->max_nr_stripes &&
> +	       grow_one_stripe(conf, GFP_KERNEL))
> +		;
> +	mutex_unlock(&conf->cache_size_mutex);
> +}
> +
> +static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
> +{
> +	struct r5conf *conf;
> +	int err;
> +
> +	err = mddev_lock(mddev);
> +	if (err)
> +		return err;
> +	conf = mddev->private;
> +	if (!conf) {
> +		mddev_unlock(mddev);
> +		return -ENODEV;
> +	}
> +
> +	if (strncmp(buf, "ppl", 3) == 0 &&
> +	    !test_bit(MD_HAS_PPL, &mddev->flags)) {
> +		mddev_suspend(mddev);
> +		err = ppl_init_log(conf);

I didn't see you check if all rdev have valid ppl setting in ppl_load. Am I
missing anything? Is it possible some rdevs have ppl set, but some not. In the
case, we should just bail out.

Also check if this is raid5

Thanks,
Shaohua
