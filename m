From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3] md linear: fix a race between linear_add() and
 linear_congested()
Date: Sat, 28 Jan 2017 17:45:55 -0800
Message-ID: <20170129014555.lgmk2ivste2xttxq@kernel.org>
References: <1485609109-23896-1-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485609109-23896-1-git-send-email-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: colyli@suse.de
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 28, 2017 at 09:11:49PM +0800, colyli@suse.de wrote:
> Recently I receive a bug report that on Linux v3.0 based kerenl, hot add
> disk to a md linear device causes kernel crash at linear_congested(). From
> the crash image analysis, I find in linear_congested(), mddev->raid_disks
> contains value N, but conf->disks[] only has N-1 pointers available. Then
> a NULL pointer deference crashes the kernel.
> 
> There is a race between linear_add() and linear_congested(), RCU stuffs
> used in these two functions cannot avoid the race. Since Linuv v4.0
> RCU code is replaced by introducing mddev_suspend().  After checking the
> upstream code, it seems linear_congested() is not called in
> generic_make_request() code patch, so mddev_suspend() cannot provent it
> from being called. The possible race still exists.
> 
> Here I explain how the race still exists in current code.  For a machine
> has many CPUs, on one CPU, linear_add() is called to add a hard disk to a
> md linear device; at the same time on other CPU, linear_congested() is
> called to detect whether this md linear device is congested before issuing
> an I/O request onto it.
> 
> Now I use a possible code execution time sequence to demo how the possible
> race happens,
> 
> seq    linear_add()                linear_congested()
>  0                                 conf=mddev->private
>  1   oldconf=mddev->private
>  2   mddev->raid_disks++
>  3                              for (i=0; i<mddev->raid_disks;i++)
>  4                                bdev_get_queue(conf->disks[i].rdev->bdev)
>  5   mddev->private=newconf
> 
> In linear_add() mddev->raid_disks is increased in time seq 2, and on
> another CPU in linear_congested() the for-loop iterates conf->disks[i] by
> the increased mddev->raid_disks in time seq 3,4. But conf with one more
> element (which is a pointer to struct dev_info type) to conf->disks[] is
> not updated yet, accessing its structure member in time seq 4 will cause a
> NULL pointer deference fault.
> 
> To fix this race, there are 2 parts of modification in the patch,
>  1) Add 'int raid_disks' in struct linear_conf, as a copy of
>     mddev->raid_disks. It is initialized in linear_conf(), always being
>     consistent with pointers number of 'struct dev_info disks[]'. When
>     iterating conf->disks[] in linear_congested(), use conf->raid_disks to
>     replace mddev->raid_disks in the for-loop, then NULL pointer deference
>     will not happen again.
>  2) RCU stuffs are back again, and use kfree_rcu() in linear_add() to
>     free oldconf memory. Because oldconf may be referenced as mddev->private
>     in linear_congested(), kfree_rcu() makes sure that its memory will not
>     be released until no one uses it any more.
> Also some code comments are added in this patch, to make this modification
> to be easier understandable.
> 
> This patch can be applied for kernels since v4.0 after commit:
> 3be260cc18f8 ("md/linear: remove rcu protections in favour of
> suspend/resume"). But this bug is reported on Linux v3.0 based kernel, for
> people who maintain kernels before Linux v4.0, they need to do some back
> back port to this patch.
> 
> Changelog:
>  - V3: add 'int raid_disks' in struct linear_conf, and use kfree_rcu() to
>        replace rcu_call() in linear_add().
>  - v2: add RCU stuffs by suggestion from Shaohua and Neil.
>  - v1: initial effort.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Shaohua Li <shli@fb.com>
> Cc: Neil Brown <neilb@suse.com>
> Cc: stable@vger.kernel.org
Hi,

Happy new year! Applied, though I changed the format of comments. It should be:
/*
 * comments
 */

> ---
>  drivers/md/linear.c | 38 +++++++++++++++++++++++++++++++++-----
>  drivers/md/linear.h |  2 ++
>  2 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 5975c99..767e4b8 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -53,18 +53,26 @@ static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
>  	return conf->disks + lo;
>  }
>  
> +/*
> + * In linear_congested() conf->raid_disks is used as a copy of
> + * mddev->raid_disks to iterate conf->disks[], because conf->raid_disks
> + * and conf->disks[] are created in linear_conf(), they are always
> + * consitent with each other, but mddev->raid_disks dose not.
> + */
>  static int linear_congested(struct mddev *mddev, int bits)
>  {
>  	struct linear_conf *conf;
>  	int i, ret = 0;
>  
> -	conf = mddev->private;
> +	rcu_read_lock();
> +	conf = rcu_dereference(mddev->private);
>  
> -	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
> +	for (i = 0; i < conf->raid_disks && !ret ; i++) {
>  		struct request_queue *q = bdev_get_queue(conf->disks[i].rdev->bdev);
>  		ret |= bdi_congested(&q->backing_dev_info, bits);
>  	}
>  
> +	rcu_read_unlock();
>  	return ret;
>  }
>  
> @@ -144,6 +152,18 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
>  			conf->disks[i-1].end_sector +
>  			conf->disks[i].rdev->sectors;
>  
> +	/* conf->raid_disks is copy of mddev->raid_disks. The reason to
> +	 * keep a copy of mddev->raid_disks in struct linear_conf is,
> +	 * mddev->raid_disks may not be consistent with pointers number of
> +	 * conf->disks[] when it is updated in linear_add() and used to
> +	 * iterate old conf->disks[] earray in linear_congested().
> +	 * Here conf->raid_disks is always consitent with number of
> +	 * pointers in conf->disks[] array, and mddev->private is updated
> +	 * with rcu_assign_pointer() in linear_addr(), such race can be
> +	 * avoided.
> +	 */
> +	conf->raid_disks = raid_disks;
> +
>  	return conf;
>  
>  out:
> @@ -196,15 +216,23 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
>  	if (!newconf)
>  		return -ENOMEM;
>  
> +	/* newconf->raid_disks already keeps a copy of * the increased
> +	 * value of mddev->raid_disks, WARN_ONCE() is just used to make
> +	 * sure of this. It is possible that oldconf is still referenced
> +	 * in linear_congested(), therefore kfree_rcu() is used to free
> +	 * oldconf until no one uses it anymore.
> +	 */
>  	mddev_suspend(mddev);
> -	oldconf = mddev->private;
> +	oldconf = rcu_dereference(mddev->private);
>  	mddev->raid_disks++;
> -	mddev->private = newconf;
> +	WARN_ONCE(mddev->raid_disks != newconf->raid_disks,
> +		"copied raid_disks doesn't match mddev->raid_disks");
> +	rcu_assign_pointer(mddev->private, newconf);
>  	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>  	set_capacity(mddev->gendisk, mddev->array_sectors);
>  	mddev_resume(mddev);
>  	revalidate_disk(mddev->gendisk);
> -	kfree(oldconf);
> +	kfree_rcu(oldconf, rcu);
>  	return 0;
>  }
>  
> diff --git a/drivers/md/linear.h b/drivers/md/linear.h
> index b685ddd..07fd40c 100644
> --- a/drivers/md/linear.h
> +++ b/drivers/md/linear.h
> @@ -10,6 +10,8 @@ struct linear_conf
>  {
>  	struct rcu_head		rcu;
>  	sector_t		array_sectors;
> +	int			raid_disks;	/* a copy of
> +						 * mddev->raid_disks */
>  	struct dev_info		disks[0];
>  };
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
