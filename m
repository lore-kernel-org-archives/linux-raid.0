From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/md0: optimize raid0 discard handling
Date: Mon, 8 May 2017 09:37:43 -0700
Message-ID: <20170508163743.xkct4eoylpjrg72c@kernel.org>
References: <1af0237c374a1e276663fa17824e8345165fcca6.1494203680.git.shli@fb.com>
 <979e4da4-3d31-da5d-459f-0dceecc95a3b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <979e4da4-3d31-da5d-459f-0dceecc95a3b@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Mon, May 08, 2017 at 03:31:47PM +0800, Coly Li wrote:
> On 2017/5/8 上午8:36, Shaohua Li wrote:
> > There are complaints that raid0 discard handling is slow. Currently we
> > divide discard request into chunks and dispatch to underlayer disks. The
> > block layer will do merge to form big requests. This causes a lot of
> > request split/merge and uses significant CPU time.
> > 
> > A simple idea is to calculate the range for each raid disk for an IO
> > request and send a discard request to raid disks, which will avoid the
> > split/merge completely. Previously Coly tried the approach, but the
> > implementation was too complex because of raid0 zones. This patch always
> > split bio in zone boundary and handle bio within one zone. It simplifies
> > the implementation a lot.
> > 
> > Cc: NeilBrown <neilb@suse.com>
> > Cc: Coly Li <colyli@suse.de>
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/raid0.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 102 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index 84e5859..d6c0bc7 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -385,7 +385,7 @@ static int raid0_run(struct mddev *mddev)
> >  		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> >  		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
> >  		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
> > -		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
> > +		blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
> >  
> >  		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> >  		blk_queue_io_opt(mddev->queue,
> > @@ -459,6 +459,95 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
> >  	}
> >  }
> >  
> > +static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
> > +{
> > +	struct r0conf *conf = mddev->private;
> > +	struct strip_zone *zone;
> > +	sector_t start = bio->bi_iter.bi_sector;
> > +	sector_t end;
> > +	unsigned int stripe_size;
> > +	sector_t first_stripe_index, last_stripe_index;
> > +	sector_t start_disk_offset;
> > +	unsigned int start_disk_index;
> > +	sector_t end_disk_offset;
> > +	unsigned int end_disk_index;
> > +	unsigned int disk;
> > +
> > +	zone = find_zone(conf, &start);
> > +
> > +	if (bio_end_sector(bio) > zone->zone_end) {
> > +		struct bio *split = bio_split(bio,
> > +			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
> > +			mddev->bio_set);
> > +		bio_chain(split, bio);
> > +		generic_make_request(bio);
> > +		bio = split;
> > +		end = zone->zone_end;
> > +	} else
> > +		end = bio_end_sector(bio);
> > +
> 
> Nice, good idea. Indeed, I have a WIP patch which trys to follow your
> idea, but no clean as yours.
> 
> 
> > +	if (zone != conf->strip_zone)
> > +		end = end - zone[-1].zone_end;
> > +
> > +	/* Now start and end is the offset in zone */
> > +	stripe_size = zone->nb_dev * mddev->chunk_sectors;
> > +
> > +	first_stripe_index = start;
> > +	sector_div(first_stripe_index, stripe_size);
> > +	last_stripe_index = end;
> > +	sector_div(last_stripe_index, stripe_size);
> > +
> > +	start_disk_index = (int)(start - first_stripe_index * stripe_size) /
> > +		mddev->chunk_sectors;
> > +	start_disk_offset = ((int)(start - first_stripe_index * stripe_size) %
> > +		mddev->chunk_sectors) +
> > +		first_stripe_index * mddev->chunk_sectors;
> > +	end_disk_index = (int)(end - last_stripe_index * stripe_size) /
> > +		mddev->chunk_sectors;
> > +	end_disk_offset = ((int)(end - last_stripe_index * stripe_size) %
> > +		mddev->chunk_sectors) +
> > +		last_stripe_index * mddev->chunk_sectors;
> > +
> 
> Nice code, again! Much simpler. It is enjoyed experience when reading
> these calculation :-)
> 
> 
> > +	for (disk = 0; disk < zone->nb_dev; disk++) {
> > +		sector_t dev_start, dev_end;
> > +		struct bio *discard_bio = NULL;
> > +		struct md_rdev *rdev;
> > +
> > +		if (disk < start_disk_index)
> > +			dev_start = (first_stripe_index + 1) *
> > +				mddev->chunk_sectors;
> > +		else if (disk > start_disk_index)
> > +			dev_start = first_stripe_index * mddev->chunk_sectors;
> > +		else
> > +			dev_start = start_disk_offset;
> > +
> > +		if (disk < end_disk_index)
> > +			dev_end = (last_stripe_index + 1) * mddev->chunk_sectors;
> > +		else if (disk > end_disk_index)
> > +			dev_end = last_stripe_index * mddev->chunk_sectors;
> > +		else
> > +			dev_end = end_disk_offset;
> > +
> > +		if (dev_end <= dev_start)
> > +			continue;
> > +
> > +		rdev = conf->devlist[(zone - conf->strip_zone) *
> > +			conf->strip_zone[0].nb_dev + disk];
> > +		if (__blkdev_issue_discard(rdev->bdev,
> > +			dev_start + zone->dev_start + rdev->data_offset,
> > +			dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
> > +		    !discard_bio)
> > +			continue;
> 
> Could you please give me any hint ? Why __blkdev_issue_discard() is
> called here. The following generic_make_request() will issue the bio to
> underlying device and call __blkdev_issue_discard() in its code path
> eventually, why call this function explicitly here?

I was going to allocate a bio, init it and dispatch it to raid disks, but found
__blkdev_issue_discard essentially does these, so reuse it. did you see any
problem?

Thanks,
Shaohua
