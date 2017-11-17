From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC] md: make queue limits depending on limits of RAID members
Date: Fri, 17 Nov 2017 10:40:54 -0800
Message-ID: <20171117184054.jmk6lks7dzxyyxgu@kernel.org>
References: <20171115102512.18269-1-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171115102512.18269-1-mariusz.dabrowski@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com, linux-block@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 15, 2017 at 11:25:12AM +0100, Mariusz Dabrowski wrote:
> Hi all,
> 
> In order to be compliant with a pass-throug drive behavior, RAID queue
> limits should be calculated in a way that minimal io, optimal io and
> discard granularity size will be met from a single drive perspective.
> Currently MD driver is ignoring queue limits reported by members and all
> calculations are based on chunk (stripe) size.

We did use blk_stack_limits, which will care about these.

> I am working on patch which
> changes this. Since kernel 4.13 drives which support streams (write hints)
> might report discard_alignment or discard_granularity bigger than array
> stripe (for more details view NVMe 1.3 specification, chapter 9.3 Streams)
> so result of current calculation is not optimal for those drives. For 
> example for 4 disk RAID 0 with chunk size smaller than discard_granularity
> of member drives, discard_granularity of RAID array should be equal to
> 4*member_discard_granularity.
> 
> The problem is that for some drives there is a risk that result of this
> calculation exceeds unsigned int range. Current implementation of function
> nvme_config_discard in NVMe driver can also suffer the same problem:
> 
> 	if (ctrl->nr_streams && ns->sws && ns->sgs) {
> 		unsigned int sz = logical_block_size * ns->sws * ns->sgs;
> 
> 		ns->queue->limits.discard_alignment = sz;
> 		ns->queue->limits.discard_granularity = sz;
> 	}
> 
> One potential solution for that is to change type of some queue limits
> (at least discard_granularity and discard_alignment, maybe more, like
> max_discard_sectors?) from 32 bits to 64 bits.
> 
> What are your thoughts about this? Do you expect any troubles with 
> changing this in block layer? Would you be willing to do such change?
> 
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
> 
>  drivers/md/md.c     | 24 ++++++++++++++++++++++++
>  drivers/md/md.h     |  1 +
>  drivers/md/raid0.c  | 23 ++++++++++++++++++++---
>  drivers/md/raid10.c | 30 +++++++++++++++++++++++++-----
>  drivers/md/raid5.c  | 25 +++++++++++++++++++------
>  5 files changed, 89 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0ff1bbf6c90e..e0dc114cab19 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -66,6 +66,7 @@
>  #include <linux/raid/md_u.h>
>  #include <linux/slab.h>
>  #include <linux/percpu-refcount.h>
> +#include <linux/lcm.h>
>  
>  #include <trace/events/block.h>
>  #include "md.h"
> @@ -679,6 +680,29 @@ struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr)
>  }
>  EXPORT_SYMBOL_GPL(md_find_rdev_nr_rcu);
>  
> +void md_rdev_get_queue_limits(struct mddev *mddev, struct queue_limits *limits)
> +{
> +	struct md_rdev *rdev;
> +
> +	memset(limits, 0, sizeof(struct queue_limits));
> +
> +	rdev_for_each(rdev, mddev) {
> +		struct queue_limits *rdev_limits;
> +
> +		rdev_limits = &rdev->bdev->bd_queue->limits;
> +		limits->io_min = max(limits->io_min, rdev_limits->io_min);
> +		limits->io_opt = lcm_not_zero(limits->io_opt,
> +					      rdev_limits->io_opt);
> +		limits->discard_granularity =
> +			max(limits->discard_granularity,
> +			    rdev_limits->discard_granularity);
> +		limits->discard_alignment =
> +			max(limits->discard_alignment,
> +			    rdev_limits->discard_alignment);
> +	}
> +}

isn't this exactly what blk_stack_limits does?

> +EXPORT_SYMBOL_GPL(md_rdev_get_queue_limits);
> +
>  static struct md_rdev *find_rdev(struct mddev *mddev, dev_t dev)
>  {
>  	struct md_rdev *rdev;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d8287d3cd1bf..5b514b9bb535 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -702,6 +702,7 @@ extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>  extern void md_update_sb(struct mddev *mddev, int force);
>  extern void md_kick_rdev_from_array(struct md_rdev * rdev);
>  struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
> +void md_rdev_get_queue_limits(struct mddev *mddev, struct queue_limits *limits);
>  
>  static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
>  {
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 5a00fc118470..f1dcf7fd3eb1 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -382,15 +382,31 @@ static int raid0_run(struct mddev *mddev)
>  	if (mddev->queue) {
>  		struct md_rdev *rdev;
>  		bool discard_supported = false;
> +		struct queue_limits limits;
> +		unsigned int io_min, io_opt;
> +		unsigned int granularity, alignment;
> +		unsigned int chunk_size = mddev->chunk_sectors << 9;
>  
> +		md_rdev_get_queue_limits(mddev, &limits);
>  		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
>  		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
>  		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
>  		blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
>  
> -		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> -		blk_queue_io_opt(mddev->queue,
> -				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
> +		io_min = chunk_size > limits.io_min ?
> +			 chunk_size : limits.io_min * mddev->raid_disks;
> +		io_opt = max(chunk_size, limits.io_min) * mddev->raid_disks;
> +		granularity = chunk_size > limits.discard_granularity ?
> +			      limits.discard_granularity :
> +			      limits.discard_granularity * mddev->raid_disks;
> +		alignment = chunk_size > limits.discard_granularity ?
> +			    limits.discard_alignment :
> +			    limits.discard_alignment * mddev->raid_disks;
> +
> +		blk_queue_io_min(mddev->queue, io_min);
> +		blk_queue_io_opt(mddev->queue, io_opt);
> +		mddev->queue->limits.discard_granularity = granularity;
> +		mddev->queue->limits.discard_alignment = alignment;

We use blk_stack_limits below, why we need this change?
  
>  		rdev_for_each(rdev, mddev) {
>  			disk_stack_limits(mddev->gendisk, rdev->bdev,
> @@ -398,6 +414,7 @@ static int raid0_run(struct mddev *mddev)
>  			if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  				discard_supported = true;
>  		}
> +
>  		if (!discard_supported)
>  			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
>  		else
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 374df5796649..5ff1635a2551 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3623,7 +3623,10 @@ static struct r10conf *setup_conf(struct mddev *mddev)
>  static int raid10_run(struct mddev *mddev)
>  {
>  	struct r10conf *conf;
> -	int i, disk_idx, chunk_size;
> +	int i, disk_idx;
> +	unsigned int chunk_size, io_min, io_opt;
> +	unsigned int granularity, alignment;
> +	struct queue_limits limits;
>  	struct raid10_info *disk;
>  	struct md_rdev *rdev;
>  	sector_t size;
> @@ -3649,16 +3652,33 @@ static int raid10_run(struct mddev *mddev)
>  
>  	chunk_size = mddev->chunk_sectors << 9;
>  	if (mddev->queue) {
> +		int factor;
> +
> +		md_rdev_get_queue_limits(mddev, &limits);
>  		blk_queue_max_discard_sectors(mddev->queue,
>  					      mddev->chunk_sectors);
>  		blk_queue_max_write_same_sectors(mddev->queue, 0);
>  		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
> -		blk_queue_io_min(mddev->queue, chunk_size);
> +
>  		if (conf->geo.raid_disks % conf->geo.near_copies)
> -			blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
> +			factor = conf->geo.raid_disks;
>  		else
> -			blk_queue_io_opt(mddev->queue, chunk_size *
> -					 (conf->geo.raid_disks / conf->geo.near_copies));
> +			factor = conf->geo.raid_disks / conf->geo.near_copies;
> +
> +		io_min = chunk_size > limits.io_min ?
> +				 chunk_size : limits.io_min * factor;
> +		io_opt = max(chunk_size, limits.io_min) * factor;
> +		granularity = chunk_size > limits.discard_granularity ?
> +				      limits.discard_granularity :
> +				      limits.discard_granularity * factor;
> +		alignment = chunk_size > limits.discard_alignment ?
> +				    limits.discard_alignment :
> +				    limits.discard_alignment * factor;
> +
> +		blk_queue_io_min(mddev->queue, io_min);
> +		blk_queue_io_opt(mddev->queue, io_opt);
> +		mddev->queue->limits.discard_granularity = granularity;
> +		mddev->queue->limits.discard_alignment = alignment;
>  	}
>  
>  	rdev_for_each(rdev, mddev) {
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4fd34ff2e830..adbbe979c363 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7508,7 +7508,10 @@ static int raid5_run(struct mddev *mddev)
>  	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
>  
>  	if (mddev->queue) {
> -		int chunk_size;
> +		unsigned int chunk_size, io_min, io_opt;
> +		unsigned int granularity, alignment;
> +		struct queue_limits limits;
> +
>  		/* read-ahead size must cover two whole stripes, which
>  		 * is 2 * (datadisks) * chunksize where 'n' is the
>  		 * number of raid devices
> @@ -7519,10 +7522,14 @@ static int raid5_run(struct mddev *mddev)
>  		if (mddev->queue->backing_dev_info->ra_pages < 2 * stripe)
>  			mddev->queue->backing_dev_info->ra_pages = 2 * stripe;
>  
> +		md_rdev_get_queue_limits(mddev, &limits);
>  		chunk_size = mddev->chunk_sectors << 9;
> -		blk_queue_io_min(mddev->queue, chunk_size);
> -		blk_queue_io_opt(mddev->queue, chunk_size *
> -				 (conf->raid_disks - conf->max_degraded));
> +		io_min = chunk_size > limits.io_min ?
> +				chunk_size : limits.io_min * data_disks;
> +		io_opt = max(chunk_size, limits.io_min) * data_disks;
> +		blk_queue_io_min(mddev->queue, io_min);
> +		blk_queue_io_opt(mddev->queue, io_opt);
> +
>  		mddev->queue->limits.raid_partial_stripes_expensive = 1;
>  		/*
>  		 * We can only discard a whole stripe. It doesn't make sense to
> @@ -7533,8 +7540,14 @@ static int raid5_run(struct mddev *mddev)
>  		 * currently assumes that */
>  		while ((stripe-1) & stripe)
>  			stripe = (stripe | (stripe-1)) + 1;
> -		mddev->queue->limits.discard_alignment = stripe;
> -		mddev->queue->limits.discard_granularity = stripe;
> +		granularity = chunk_size > limits.discard_granularity ?
> +			      stripe :
> +			      limits.discard_granularity * data_disks;
> +		alignment = chunk_size > limits.discard_granularity ?
> +			    stripe :
> +			    limits.discard_alignment * data_disks;
> +		mddev->queue->limits.discard_alignment = granularity;
> +		mddev->queue->limits.discard_granularity = alignment;
>  
>  		blk_queue_max_write_same_sectors(mddev->queue, 0);
>  		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
