From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Thu, 31 May 2012 14:18:01 +0800
Message-ID: <20120531061801.GC6309@yliu-dev.sh.intel.com>
References: <4FBA0047.5050208@profitbricks.com>
 <20120522092817.1b5946b8@notabene.brown>
 <4FBF7CAD.7000307@profitbricks.com>
 <20120528140505.6eb49b26@notabene.brown>
 <4FC49733.9050905@profitbricks.com>
 <20120529202559.6aa7fd49@notabene.brown>
 <4FC61A94.3050605@profitbricks.com>
 <20120531154256.6eb567c7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120531154256.6eb567c7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 31, 2012 at 03:42:56PM +1000, NeilBrown wrote:
> On Wed, 30 May 2012 15:03:16 +0200 Sebastian Riemer
> <sebastian.riemer@profitbricks.com> wrote:
> 
> > On 29/05/12 12:25, NeilBrown wrote:
> > > On Tue, 29 May 2012 11:30:27 +0200 Sebastian Riemer
> > > <sebastian.riemer@profitbricks.com> wrote:
> > >> Now, I've updated mdadm to version 3.2.5 and it works like you've
[snip]... 
> The elevator at the device level should still collect these 1-page bios into
> larger requests, but I guess that has higher CPU overhead.
> 
> thanks for the report.
> 
> NeilBrown
> 
> From dd47a247ae226896205f753ad246cd40141aadf1 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 31 May 2012 15:39:11 +1000
> Subject: [PATCH] md: raid1/raid10: fix problem with merge_bvec_fn
> 
> The new merge_bvec_fn which calls the corresponding function
> in subsidiary devices requires that mddev->merge_check_needed
> be set if any child has a merge_bvec_fn.
> 
> However were were only setting that when a device was hot-added,
          ^^^^
I guess there is a typo here.

> not when a device was present from the start.
> 
> This bug was introduced in 3.4 so patch is suitable for 3.4.y
> kernels.

And, Reviewed-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> 
> Cc: stable@vger.kernel.org
> Reported-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 15dd59b..d7e9577 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2548,6 +2548,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>  	err = -EINVAL;
>  	spin_lock_init(&conf->device_lock);
>  	rdev_for_each(rdev, mddev) {
> +		struct request_queue *q;
>  		int disk_idx = rdev->raid_disk;
>  		if (disk_idx >= mddev->raid_disks
>  		    || disk_idx < 0)
> @@ -2560,6 +2561,9 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>  		if (disk->rdev)
>  			goto abort;
>  		disk->rdev = rdev;
> +		q = bdev_get_queue(rdev->bdev);
> +		if (q->merge_bvec_fn)
> +			mddev->merge_check_needed = 1;
>  
>  		disk->head_position = 0;
>  	}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 3f91c2e..d037adb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3311,7 +3311,7 @@ static int run(struct mddev *mddev)
>  				 (conf->raid_disks / conf->near_copies));
>  
>  	rdev_for_each(rdev, mddev) {
> -
> +		struct request_queue *q;
>  		disk_idx = rdev->raid_disk;
>  		if (disk_idx >= conf->raid_disks
>  		    || disk_idx < 0)
> @@ -3327,6 +3327,9 @@ static int run(struct mddev *mddev)
>  				goto out_free_conf;
>  			disk->rdev = rdev;
>  		}
> +		q = bdev_get_queue(rdev->bdev);
> +		if (q->merge_bvec_fn)
> +			mddev->merge_check_needed = 1;
>  
>  		disk_stack_limits(mddev->gendisk, rdev->bdev,
>  				  rdev->data_offset << 9);


