From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and
     I/O sizes
Date: Tue, 9 Jun 2009 15:02:08 +1000 (EST)
Message-ID: <6579bc561e648e03ed4a739799e51d9e.squirrel@neil.brown.name>
References: <yq1my8i6naw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1my8i6naw.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, June 9, 2009 2:31 pm, Martin K. Petersen wrote:
>
> Switch MD over to the new disk_stack_limits() function which checks for
> aligment and adjusts preferred I/O sizes when stacking.
>
> Also indicate preferred I/O sizes where applicable.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index ae12cea..dfd18df 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2044,7 +2044,7 @@ raid10_size(mddev_t *mddev, sector_t sectors, int
> raid_disks)
>  static int run(mddev_t *mddev)
>  {
>  	conf_t *conf;
> -	int i, disk_idx;
> +	int i, disk_idx, chunk_size;
>  	mirror_info_t *disk;
>  	mdk_rdev_t *rdev;
>  	int nc, fc, fo;
> @@ -2130,6 +2130,10 @@ static int run(mddev_t *mddev)
>  	spin_lock_init(&conf->device_lock);
>  	mddev->queue->queue_lock = &conf->device_lock;
>
> +	chunk_size = mddev->chunk_sectors << 9;
> +	blk_queue_io_min(mddev->queue, chunk_size);
> +	blk_queue_io_opt(mddev->queue, chunk_size * (mddev->raid_disks >> 1));

 ">> 1" is wrong.  A raid10 may have more than 2 copies for each block.
This calculation needs to be a bit more subtle and take about of the
particular layout (near, offset, or far).


> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 41dc36e..ea8d3fd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4451,7 +4451,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
>  static int run(mddev_t *mddev)
>  {
>  	raid5_conf_t *conf;
> -	int working_disks = 0;
> +	int working_disks = 0, chunk_size;
>  	mdk_rdev_t *rdev;
>
>  	if (mddev->recovery_cp != MaxSector)
> @@ -4606,6 +4606,19 @@ static int run(mddev_t *mddev)
>  	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
>
>  	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
> +	chunk_size = mddev->chunk_sectors << 9;
> +	blk_queue_io_min(mddev->queue, chunk_size);
> +
> +	if (mddev->level == 5)
> +		blk_queue_io_opt(mddev->queue,
> +				 chunk_size * (mddev->raid_disks - 1));
> +	else
> +		blk_queue_io_opt(mddev->queue,
> +				 chunk_size * (mddev->raid_disks - 2));
> +

You seem to be treating raid4 like raid6 :-)
probably what you want is
     blk_queue_io_opt(mddev->queue,
                      chunk_size * (conf->raid_disks - conf->max_degraded));

I'll be a closer look at the patch in the next day or two.

Thanks,
NeilBrown

