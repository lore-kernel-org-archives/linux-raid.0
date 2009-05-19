From: Neil Brown <neilb@suse.de>
Subject: Re: Subject [ raid0 PATCH 3/6] : Add support to chunk size of 4K*n
	instead of 4K*2^n
Date: Tue, 19 May 2009 10:36:46 +1000
Message-ID: <18961.65310.282446.521193@notabene.brown>
References: <1242687904.21201.13.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

On Tuesday May 19, raziebe@gmail.com wrote:
> Add support to chunk size of 4K*n instead of 4K*2^n

This is a very short comment for a very long change set.

When I read the comment at the top of a change set I want it to tell
me everything that I should expect to find in the patch set, and to
explain why it is there.

In this case I would expect to at least see some mention of why
handle_split has been made a separate function, and why we have both
"position_bio_pow2" and "position_bio_notpow2".  I know I suggested
that last distinction, but I am not the only one who reads the change
log, and I might come back and read it in 5 years having completely
forgotten this conversation.

> Raid0.c |  205 ++++++++++++++++++++++++++++++++++++++++++++++++----------------
> 1 file changed, 156 insertions(+), 49 deletions(-)
> Signed-off-by: raziebe@gmail.com
> --
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 80ac685..dc2671f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -23,6 +23,9 @@
>  #include "md.h"
>  #include "raid0.h"
>  
> +static int handle_split(struct request_queue *q,
> +		unsigned int chunk_sects, struct bio *bio);
> +
>  static void raid0_unplug(struct request_queue *q)
>  {
>  	mddev_t *mddev = q->queuedata;
> @@ -263,7 +266,12 @@ static int raid0_mergeable_bvec(struct request_queue *q,
>  	unsigned int chunk_sectors = mddev->chunk_size >> 9;

Hmm... if someone wanted to globally replace mddev->chunk_size with
chunk_sectors, I wouldn't complain (Hi Andre :-)

>  	unsigned int bio_sectors = bvm->bi_size >> 9;
>  
> -	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
> +	if (is_power_of_2(mddev->chunk_size))
> +		max =  (chunk_sectors - ((sector & (chunk_sectors-1))
> +						+ bio_sectors)) << 9;
> +	else
> +		max =  (chunk_sectors - (sector_div(sector, chunk_sectors)
> +						+ bio_sectors)) << 9;
>  	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
>  	if (max <= biovec->bv_len && bio_sectors == 0)
>  		return biovec->bv_len;
> @@ -356,15 +364,114 @@ static struct strip_zone *find_zone(struct raid0_private_data *conf,
>  	BUG();
>  }
>  
> +static void position_bio_pow2(mddev_t *mddev, struct bio *bio)
>  {
> +
> +
> +	chunksect_bits = ffz(~chunk_sects);
> +	/* find the sector offset inside the chunk */
> +	sect_in_chunk  = bio->bi_sector & (chunk_sects - 1);
> +	/* chunk in zone */
> +	x = sector_offset >> chunksect_bits;
> +	chunk  = x;
> +	x = bio->bi_sector >> chunksect_bits;

> +	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;

> +}
> +
> +static void position_bio_notpow2(mddev_t *mddev, struct bio *bio)
> +{
> +

> +	/* find the sector offset inside the chunk */
> +	x = bio->bi_sector;
> +	sect_in_chunk = sector_div(x, chunk_sects);
> +	/* find the chunk in the zone */
> +	x = sector_offset;
> +	sector_div(x, chunk_sects);
> +	chunk = x;
> +	x = bio->bi_sector;
> +	sector_div(x, chunk_sects);

> +	rsect = (chunk * chunk_sects) + zone->dev_start + sect_in_chunk;

> +}

The two "position_bio_" functions are very similar.  I have removed
all the lines that were the same leaving just this core bit that
is different.  I would rather just that difference stood out more so
it was easier to see...

How about a function like
    map_sector(conf, zone, &sector)
which returns an rdev, and modifies 'sector' to be the offset in that
zone, of the rdev.
Then raid0_make_request could have code like:

   sector_offset = sector;
   zone = find_zone(conf, &sector_offset);
   tmp_dev = map_sector(zone, &sector_offset);
   bio->bi_bdev = tmp_dev->bdev;
   bio->bi_sector = sector_offset + zone->dev_start +
   tmp_dev->data_offset;

and map_sector would be something like
   if is_power_of_2(chunksize) {
        ...
   } else {
        ...
   }

????

> +
> +/*
> + * position the io to the real target device.
> + * for the sake of performance we maintain two flows, one for
> + * power2 chunk sizes and one non-power 2 chunk size.
> +*/
> +static void position_bio(mddev_t *mddev, struct bio *bio)
> +{
> +	if (is_power_of_2(mddev->chunk_size))
> +		return (void)position_bio_pow2(mddev, bio);
> +	position_bio_notpow2(mddev, bio);
> +}

I don't think this is big enough to be worth a function as it is only
used once.


> +
> +/*
> + * Is io distribute over 1 or more chunks ?
> +*/
> +static inline int is_io_in_chunk_boundary(mddev_t *mddev,
> +			unsigned int chunk_sects, struct bio *bio)
> +{
> +	if (is_power_of_2(mddev->chunk_size)) {
> +		return !(chunk_sects < ((bio->bi_sector & (chunk_sects-1))
> +					+ (bio->bi_size >> 9)));
> +	} else{
> +		sector_t sector = bio->bi_sector;
> +		return !(chunk_sects < (sector_div(sector, chunk_sects)
> +						+ (bio->bi_size >> 9)));
> +	}

Rather than
    if (! a < b)
can we have
    if ( a >= b)
?
I think it is easier to read.

> +}
> +
> +static int raid0_make_request(struct request_queue *q, struct bio *bio)
> +{
> +	mddev_t *mddev = q->queuedata;
> +	unsigned int chunk_sects;
>  	const int rw = bio_data_dir(bio);
>  	int cpu;
>  
> @@ -380,59 +487,59 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
>  	part_stat_unlock();
>  
>  	chunk_sects = mddev->chunk_size >> 9;
> -	chunksect_bits = ffz(~chunk_sects);
> -	sector = bio->bi_sector;
> -
> -	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
> -		struct bio_pair *bp;
> -		/* Sanity check -- queue functions should prevent this happening */
> -		if (bio->bi_vcnt != 1 ||
> -		    bio->bi_idx != 0)
> -			goto bad_map;
> -		/* This is a one page bio that upper layers
> -		 * refuse to split for us, so we need to split it.
> -		 */
> -		bp = bio_split(bio, chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
> -		if (raid0_make_request(q, &bp->bio1))
> -			generic_make_request(&bp->bio1);
> -		if (raid0_make_request(q, &bp->bio2))
> -			generic_make_request(&bp->bio2);
> -
> -		bio_pair_release(bp);
> -		return 0;
> +	if (is_io_in_chunk_boundary(mddev, chunk_sects, bio)) {
> +		position_bio(mddev, bio);
> +		/* let upper layer do the actual io */
> +		return 1;
>

You have lost the "unlikely()" declaration.

And if you want to separate the handling request-splitting into a
separate function, that should be done in a separate patch.
I'm not sure it is an improvement... but I could be convinced.

  	}
> -	sector_offset = sector;
> -	zone = find_zone(conf, &sector_offset);
> -	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
> -	{
> -		sector_t x = sector_offset >> chunksect_bits;
> -
> -		sector_div(x, zone->nb_dev);
> -		chunk = x;
> -
> -		x = sector >> chunksect_bits;
> -		tmp_dev = conf->devlist[(zone - conf->strip_zone)*mddev->raid_disks
> -					+ sector_div(x, zone->nb_dev)];
> -	}
> -	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
> - 
> -	bio->bi_bdev = tmp_dev->bdev;
> -	bio->bi_sector = rsect + tmp_dev->data_offset;
> -
>  	/*
> -	 * Let the main block layer submit the IO and resolve recursion:
> -	 */
> -	return 1;
> +	* io splits over two chunks at least
> +	*/
> +	if (!handle_split(q, chunk_sects, bio))
> +		/*
> +		 * handle split already made the ios
> +		 * report all ok and leave
> +		 */
> +		return 0;
>  
> -bad_map:
>  	printk("raid0_make_request bug: can't convert block across chunks"
>  		" or bigger than %dk %llu %d\n", chunk_sects / 2,
>  		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
> -
>  	bio_io_error(bio);
>  	return 0;
>  }
>  
> +/*
> + *  This io should be splitted to two ios.We split it,bounce it up,
> +  * and each io will return to raid within the chunk boundaries
> +*/
> +static int handle_split(struct request_queue *q,
> +		unsigned int chunk_sects, struct bio *bio)
> +{

Please always define functions before yet are used, unless you have a
very good reason (in which case it should be explained in the comment
at the top of the patch.

> +	sector_t sector = bio->bi_sector;
> +	struct bio_pair *bp;
> +	mddev_t *mddev = q->queuedata;
> +	/* Sanity check -- queue functions should prevent this happening */
> +	if (bio->bi_vcnt != 1 || bio->bi_idx != 0)
> +			return 1;
> +	/* This is a one page bio that upper layers
> +	 * refuse to split for us, so we need to split it.
> +	*/
> +	if (likely(is_power_of_2(mddev->chunk_size)))
> +		bp = bio_split(bio, chunk_sects - (bio->bi_sector &
> +							 (chunk_sects-1)));
> +	else
> +		bp = bio_split(bio, chunk_sects -
> +				sector_div(sector, chunk_sects));
> +	if (raid0_make_request(q, &bp->bio1))
> +		generic_make_request(&bp->bio1);
> +	if (raid0_make_request(q, &bp->bio2))
> +		generic_make_request(&bp->bio2);
> +
> +	bio_pair_release(bp);
> +	return 0;
> +}
> +
>  static void raid0_status(struct seq_file *seq, mddev_t *mddev)
>  {
>  #undef MD_DEBUG
> 

Thanks,
NeilBrown
