From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [PATCH 003/009]: raid0 :Enables chunk size other than 4K.
Date: Wed, 20 May 2009 11:38:32 +1000
Message-ID: <18963.24344.358054.597926@notabene.brown>
References: <1242749227.3293.63.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>, ofer <ofer@bitband.com>, yaron <yaronp@bitband.com>
List-Id: linux-raid.ids

On Tuesday May 19, raziebe@gmail.com wrote:
> 	Enables chunk size other than 4K.
> 2. Maintain two flows, one for pow2 chunk sizes and a flow for the general case.
>    This is for the sake of performance.
> 3. in make_request move the splliting code after the likely code. It is
>    possible for the compiler to neglect ( gcc .. -Os.. see What 
>    programmer should know about memory,urlich dreper, page 57)
> 4. add a memeory allocation check after the bio_split.
> 5. inroduce map_sector as the remapping of the bio in the common case.
> 6. fix blk_mergeable to support the two flows.

Much better change log...
The fact that you could find 5 different changes in there should have
suggested to you that it might have been better as more smaller
patches.

  Point 4 is wrong.  bio_split cannot fail.  It uses a mempool and
  will wait until memory is available.  I have removed that bit of the
  patch.

  Point 3 is a change that is completely independent of the other
  changes (it has nothing to do with changing the supported chunk
  size) so, if anything, it really should be a separate patch.
  If you really need the re-ordering with -Os, maybe -freorder-blocks
  should be explicitly included with -Os??
  I'm not firmly against this change, but it really needs to be a
  separate patch.

I have applied the patch but removed the block re-ordering and the
bio_split failure test and tidied some other bits up, some of which I'll
comment on below.
You can find the result in my for-next branch.
  

>  
> -static int raid0_make_request (struct request_queue *q, struct bio *bio)
> +/*
> + * remaps the bio to the target device. we separate two flows.
> + * power 2 flow and a general flow for the sake of perfromance
> +*/
> +static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
> +				sector_t sector, sector_t *sector_offset)
>  {
> -	mddev_t *mddev = q->queuedata;
> -	unsigned int sect_in_chunk, chunksect_bits, chunk_sects;
> -	raid0_conf_t *conf = mddev->private;
> -	struct strip_zone *zone;
> -	mdk_rdev_t *tmp_dev;
> +	sector_t sect_in_chunk;
>  	sector_t chunk;
> -	sector_t sector, rsect, sector_offset;
> +	sector_t x;
> +	raid0_conf_t *conf = mddev->private;
> +	sector_t chunk_sects = mddev->chunk_size >> 9;
> +
> +	if (is_power_of_2(mddev->chunk_size)) {
> +		int chunksect_bits = ffz(~chunk_sects);
> +		/* find the sector offset inside the chunk */
> +		sect_in_chunk  = sector & (chunk_sects - 1);
> +		/* chunk in zone */
> +		x = *sector_offset >> chunksect_bits;
> +		/* quotient is the chunk in real device*/
> +		sector_div(x, zone->nb_dev);
> +		chunk  = x;

We don't need this 'x'.  Just set 'chunk = *sector_offset ..' and use
chunk.

> +		/*
> +		* we treat the device list a two dimensional array.
> +		* devices row + offset inside the devices row = real dev
> +		*/
> +		x = sector >> chunksect_bits;

Equally this 'x' can just be 'sector'.

> +	} else{
> +		x = sector;
> +		sect_in_chunk = sector_div(x, chunk_sects);
> +		x = *sector_offset;
> +		sector_div(x, chunk_sects);
> +		sector_div(x, zone->nb_dev);
> +		chunk = x;
> +		x = sector;
> +		sector_div(x, chunk_sects);

The same two 'x' conversions apply here.

Thanks,
NeilBrown
