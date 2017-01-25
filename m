From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md linear: fix a race between linear_add() and
 linear_congested()
Date: Wed, 25 Jan 2017 10:02:58 -0800
Message-ID: <20170125180258.fil35zckwtebysqr@kernel.org>
References: <1485342943-9330-1-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485342943-9330-1-git-send-email-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
To: colyli@suse.de
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 25, 2017 at 07:15:43PM +0800, colyli@suse.de wrote:
> Recently I receie a report that on Linux v3.0 based kerenl, hot add disk
> to a md linear device causes kernel crash at linear_congested(). From the
> crash image analysis, I find in linear_congested(), mddev->raid_disks
> contains value N, but conf->disks[] only has N-1 pointers available. Then
> a pointer deference to a NULL pointer crashes the kernel.
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

Good catch, this makes a lot of sense. However, this looks like an incomplete
fix. step 0 will get the old conf, after step 5, linear_add will free the old
conf. So it's possible linear_congested() will use the freed old conf. I think
this is more likely to happen. The easist fix maybe put rcu_lock in
linear_congested and free the old conf in a rcu callback.

Thanks,
Shaohua
 
> In linear_add() mddev->raid_disks is increased in time seq 2, and on
> another CPU in linear_congested() the for-loop iterates conf->disks[i] by
> the increased mddev->raid_disks in time seq 3,4. But conf with one more
> element (which is a pointer to struct dev_info type) to conf->disks[] is
> not updated yet, accessing its structure member in time seq 4 will cause a
> NULL pointer deference fault.
> 
> The fix is to update mddev->private with new value before increasing
> mddev->raid_disks, and to make sure on other CPUs their are seen to be
> updated in same order as linear_add() does (otherwise the race may still
> happen), a smp_mb() is necessary.
> 
> A question is, by this fix, if mddev->private is update to new value in
> linear_add(), but in linear_congested() the for-loop still tests old value
> of mddev->raid_disks, then the iteration will miss the last element of
> conf->disks[]. My answer is don't worry it, it's OK. the reasons are,
>  - When updating mddev->private, the md linear device is suspend, no I/O
>    may happen, it is safe to missing congestion status of the last
>    new-added hard disk. 
>  - In the worst case linear_congested() returns 0 and I/O sent to this md
>    linear device, but the new added hard disk is congested, then the I/O
>    request will be blocked for a while if it just happenly hits the new
>    added hard disk. linear_congested() is in code path of wb_congested(),
>    which is quite hot in write back code path. Comparing to add locking
>    code in linear_congested(), the cost of the worst case is acceptable.
> 
> The bug is reported on Linux v3.0 based kernel, it can and should be
> applied to all kernels since Linux v3.0. I see linear_add() is merged into
> mainline since Linux v2.6.18, maybe stable kernel maintainers after this
> version may consider to pick this fix as well.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Shaohua Li <shli@fb.com>
> Cc: Neil Brown <neilb@suse.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/linear.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 5975c99..48ccfad 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -196,10 +196,22 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
>  	if (!newconf)
>  		return -ENOMEM;
>  
> +	/* In linear_congested(), mddev->raid_disks and mddev->private
> +	 * are accessed without protection by mddev_suspend(). If on
> +	 * another CPU,  in linear_congested() mddev->private is still seen
> +	 * to contains old value but mddev->raid_disks is seen to have the
> +	 * increased value, the last iteration to conf->disks[i].rdev will
> +	 * trigger a NULL pointer deference. To avoid this race, here
> +	 * mddev->private must be updated before increasing
> +	 * mddev->raid_disks, and a smp_mb() is required between them. Then
> +	 * in linear_congested(), we are sure the updated mddev->private is
> +	 * seen when iterating conf->disks[i].
> +	 */
>  	mddev_suspend(mddev);
>  	oldconf = mddev->private;
> -	mddev->raid_disks++;
>  	mddev->private = newconf;
> +	smp_mb();
> +	mddev->raid_disks++;
>  	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>  	set_capacity(mddev->gendisk, mddev->array_sectors);
>  	mddev_resume(mddev);
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
