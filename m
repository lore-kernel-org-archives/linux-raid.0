From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md: add block tracing for bio_remapping
Date: Fri, 18 Nov 2016 09:26:22 -0800
Message-ID: <20161118172622.hzvmtt5rbtmdh7hh@kernel.org>
References: <87shqpfrxv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shqpfrxv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 18, 2016 at 01:22:04PM +1100, Neil Brown wrote:
> 
> The block tracing infrastructure (accessed with blktrace/blkparse)
> supports the tracing of mapping bios from one device to another.
> This is currently used when a bio in a partition is mapped to the
> whole device, when bios are mapped by dm, and for mapping in md/raid5.
> Other md personalities do not include this tracing yet, so add it.
> 
> When a read-error is detected we redirect the request to a different device.
> This could justifiably be seen as a new mapping for the originial bio,
> or a secondary mapping for the bio that errors.  This patch uses
> the second option.
> 
> When md is used under dm-raid, the mappings are not traced as we do
> not have access to the block device number of the parent.

thanks, applied patch 1, 3, 4.

Thanks,
Shaohua
 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
> 
> This is the revised version based on discussions.
> Now uses correct sector for linear and raid0, and code for raid1/raid10
> rearranged a bit.
> 
>  drivers/md/linear.c | 18 ++++++++++++------
>  drivers/md/raid0.c  | 13 ++++++++++---
>  drivers/md/raid1.c  | 26 ++++++++++++++++++++++++--
>  drivers/md/raid10.c | 29 +++++++++++++++++++++++++++--
>  4 files changed, 73 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 9c7d4f5483ea..5975c9915684 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -21,6 +21,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <trace/events/block.h>
>  #include "md.h"
>  #include "linear.h"
>  
> @@ -227,22 +228,22 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
>  	}
>  
>  	do {
> -		tmp_dev = which_dev(mddev, bio->bi_iter.bi_sector);
> +		sector_t bio_sector = bio->bi_iter.bi_sector;
> +		tmp_dev = which_dev(mddev, bio_sector);
>  		start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
>  		end_sector = tmp_dev->end_sector;
>  		data_offset = tmp_dev->rdev->data_offset;
>  		bio->bi_bdev = tmp_dev->rdev->bdev;
>  
> -		if (unlikely(bio->bi_iter.bi_sector >= end_sector ||
> -			     bio->bi_iter.bi_sector < start_sector))
> +		if (unlikely(bio_sector >= end_sector ||
> +			     bio_sector < start_sector))
>  			goto out_of_bounds;
>  
>  		if (unlikely(bio_end_sector(bio) > end_sector)) {
>  			/* This bio crosses a device boundary, so we have to
>  			 * split it.
>  			 */
> -			split = bio_split(bio, end_sector -
> -					  bio->bi_iter.bi_sector,
> +			split = bio_split(bio, end_sector - bio_sector,
>  					  GFP_NOIO, fs_bio_set);
>  			bio_chain(split, bio);
>  		} else {
> @@ -256,8 +257,13 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
>  			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
>  			/* Just ignore it */
>  			bio_endio(split);
> -		} else
> +		} else {
> +			if (mddev->gendisk)
> +				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
> +						      split, disk_devt(mddev->gendisk),
> +						      bio_sector);
>  			generic_make_request(split);
> +		}
>  	} while (split != bio);
>  	return;
>  
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index b3ba77a3c3bc..e628f187e5ad 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -21,6 +21,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <trace/events/block.h>
>  #include "md.h"
>  #include "raid0.h"
>  #include "raid5.h"
> @@ -463,7 +464,8 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
>  	}
>  
>  	do {
> -		sector_t sector = bio->bi_iter.bi_sector;
> +		sector_t bio_sector = bio->bi_iter.bi_sector;
> +		sector_t sector = bio_sector;
>  		unsigned chunk_sects = mddev->chunk_sectors;
>  
>  		unsigned sectors = chunk_sects -
> @@ -472,7 +474,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
>  			 : sector_div(sector, chunk_sects));
>  
>  		/* Restore due to sector_div */
> -		sector = bio->bi_iter.bi_sector;
> +		sector = bio_sector;
>  
>  		if (sectors < bio_sectors(bio)) {
>  			split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
> @@ -491,8 +493,13 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
>  			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
>  			/* Just ignore it */
>  			bio_endio(split);
> -		} else
> +		} else {
> +			if (mddev->gendisk)
> +				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
> +						      split, disk_devt(mddev->gendisk),
> +						      bio_sector);
>  			generic_make_request(split);
> +		}
>  	} while (split != bio);
>  }
>  
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9ac61cd85e5c..2dc1934925ec 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -37,6 +37,7 @@
>  #include <linux/module.h>
>  #include <linux/seq_file.h>
>  #include <linux/ratelimit.h>
> +#include <trace/events/block.h>
>  #include "md.h"
>  #include "raid1.h"
>  #include "bitmap.h"
> @@ -1162,6 +1163,11 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
>  		bio_set_op_attrs(read_bio, op, do_sync);
>  		read_bio->bi_private = r1_bio;
>  
> +		if (mddev->gendisk)
> +			trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
> +					      read_bio, disk_devt(mddev->gendisk),
> +					      r1_bio->sector);
> +
>  		if (max_sectors < r1_bio->sectors) {
>  			/* could not read all from this device, so we will
>  			 * need another r1_bio.
> @@ -1367,13 +1373,20 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
>  
>  		mbio->bi_iter.bi_sector	= (r1_bio->sector +
>  				   conf->mirrors[i].rdev->data_offset);
> -		mbio->bi_bdev = (void*)conf->mirrors[i].rdev;
> +		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
>  		mbio->bi_end_io	= raid1_end_write_request;
>  		bio_set_op_attrs(mbio, op, do_flush_fua | do_sync);
>  		mbio->bi_private = r1_bio;
>  
>  		atomic_inc(&r1_bio->remaining);
>  
> +		if (mddev->gendisk)
> +			trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
> +					      mbio, disk_devt(mddev->gendisk),
> +					      r1_bio->sector);
> +		/* flush_pending_writes() needs access to the rdev so...*/
> +		mbio->bi_bdev = (void*)conf->mirrors[i].rdev;
> +
>  		cb = blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
>  		if (cb)
>  			plug = container_of(cb, struct raid1_plug_cb, cb);
> @@ -2290,6 +2303,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  	struct bio *bio;
>  	char b[BDEVNAME_SIZE];
>  	struct md_rdev *rdev;
> +	dev_t bio_dev;
> +	sector_t bio_sector;
>  
>  	clear_bit(R1BIO_ReadError, &r1_bio->state);
>  	/* we got a read error. Maybe the drive is bad.  Maybe just
> @@ -2303,6 +2318,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  
>  	bio = r1_bio->bios[r1_bio->read_disk];
>  	bdevname(bio->bi_bdev, b);
> +	bio_dev = bio->bi_bdev->bd_dev;
> +	bio_sector = conf->mirrors[r1_bio->read_disk].rdev->data_offset + r1_bio->sector;
>  	bio_put(bio);
>  	r1_bio->bios[r1_bio->read_disk] = NULL;
>  
> @@ -2353,6 +2370,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  			else
>  				mbio->bi_phys_segments++;
>  			spin_unlock_irq(&conf->device_lock);
> +			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
> +					      bio, bio_dev, bio_sector);
>  			generic_make_request(bio);
>  			bio = NULL;
>  
> @@ -2367,8 +2386,11 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
>  				sectors_handled;
>  
>  			goto read_more;
> -		} else
> +		} else {
> +			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
> +					      bio, bio_dev, bio_sector);
>  			generic_make_request(bio);
> +		}
>  	}
>  }
>  
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5290be3d5c26..c63041ec9415 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -25,6 +25,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/ratelimit.h>
>  #include <linux/kthread.h>
> +#include <trace/events/block.h>
>  #include "md.h"
>  #include "raid10.h"
>  #include "raid0.h"
> @@ -1165,6 +1166,10 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  		bio_set_op_attrs(read_bio, op, do_sync);
>  		read_bio->bi_private = r10_bio;
>  
> +		if (mddev->gendisk)
> +			trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
> +					      read_bio, disk_devt(mddev->gendisk),
> +					      r10_bio->sector);
>  		if (max_sectors < r10_bio->sectors) {
>  			/* Could not read all from this device, so we will
>  			 * need another r10_bio.
> @@ -1367,11 +1372,17 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr+
>  					   choose_data_offset(r10_bio,
>  							      rdev));
> -			mbio->bi_bdev = (void*)rdev;
> +			mbio->bi_bdev = rdev->bdev;
>  			mbio->bi_end_io	= raid10_end_write_request;
>  			bio_set_op_attrs(mbio, op, do_sync | do_fua);
>  			mbio->bi_private = r10_bio;
>  
> +			if (conf->mddev->gendisk)
> +				trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
> +						      mbio, disk_devt(conf->mddev->gendisk),
> +						      r10_bio->sector);
> +			mbio->bi_bdev = (void*)rdev;
> +
>  			atomic_inc(&r10_bio->remaining);
>  
>  			cb = blk_check_plugged(raid10_unplug, mddev,
> @@ -1409,11 +1420,17 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>  			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
>  					   choose_data_offset(
>  						   r10_bio, rdev));
> -			mbio->bi_bdev = (void*)rdev;
> +			mbio->bi_bdev = rdev->bdev;
>  			mbio->bi_end_io	= raid10_end_write_request;
>  			bio_set_op_attrs(mbio, op, do_sync | do_fua);
>  			mbio->bi_private = r10_bio;
>  
> +			if (conf->mddev->gendisk)
> +				trace_block_bio_remap(bdev_get_queue(mbio->bi_bdev),
> +						      mbio, disk_devt(conf->mddev->gendisk),
> +						      r10_bio->sector);
> +			mbio->bi_bdev = (void*)rdev;
> +
>  			atomic_inc(&r10_bio->remaining);
>  			spin_lock_irqsave(&conf->device_lock, flags);
>  			bio_list_add(&conf->pending_bio_list, mbio);
> @@ -2496,6 +2513,8 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  	char b[BDEVNAME_SIZE];
>  	unsigned long do_sync;
>  	int max_sectors;
> +	dev_t bio_dev;
> +	sector_t bio_last_sector;
>  
>  	/* we got a read error. Maybe the drive is bad.  Maybe just
>  	 * the block and we can fix it.
> @@ -2507,6 +2526,8 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  	 */
>  	bio = r10_bio->devs[slot].bio;
>  	bdevname(bio->bi_bdev, b);
> +	bio_dev = bio->bi_bdev->bd_dev;
> +	bio_last_sector = r10_bio->devs[slot].addr + rdev->data_offset + r10_bio->sectors;
>  	bio_put(bio);
>  	r10_bio->devs[slot].bio = NULL;
>  
> @@ -2546,6 +2567,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
>  	bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
>  	bio->bi_private = r10_bio;
>  	bio->bi_end_io = raid10_end_read_request;
> +	trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
> +			      bio, bio_dev,
> +			      bio_last_sector - r10_bio->sectors);
> +
>  	if (max_sectors < r10_bio->sectors) {
>  		/* Drat - have to split this up more */
>  		struct bio *mbio = r10_bio->master_bio;
> -- 
> 2.10.2
> 


