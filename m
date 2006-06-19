From: Neil Brown <neilb@suse.de>
Subject: Re: the question about raid0_make_request
Date: Mon, 19 Jun 2006 11:38:13 +1000
Message-ID: <17558.5.526854.354998@cse.unsw.edu.au>
References: <4558af040606181821l17679796tf1c756de636ddb11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from liu yang on Monday June 19
Sender: linux-raid-owner@vger.kernel.org
To: liu yang <liudows2@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 19, liudows2@gmail.com wrote:
> When I read  the code of raid0_make_request,I meet some questions.
> 
> 1\ block = bio->bi_sector >> 1,it's the device offset in kilotytes.
> so why do we use block substract zone->zone_offset? The
> zone->zone_offset is the zone offset relative the mddev in sectors.

zone_offset is set to 'curr_zone_offset' in create_strip_zones,
curr_zone_offset is a sum of 'zone->size' values.
zone->size is (typically) calculated by
    (smallest->size - current_offset) *c
'smallest' is an rdev.
So the unit of 'zone_offset' are ultimately the same units as that of
 rdev->size.
rdev->size is set in md.c is set e.g. from
     calc_dev_size(rdev, sb->chunk_size);
which uses the value from calc_dev_sboffset which shifts the size in
bytes by BLOCK_SIZE_BITS which is defined in fs.h to be 10.
So the units of zone_offset is in kilobytes, not sectors.

> 
> 2\ the codes below:
>   x = block >> chunksize_bits;
>   tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
> actually, we get the underlying device by 'sector_div(x,
> zone->nb_dev)'.The var x is the chunk nr relative to the start  of the
> mddev in my opinion.But not all of the zone->nb_dev is the same, so we
> cann't get the right rdev by 'sector_div(x, zone->nb_dev)', I think.

x is the chunk number relative to the start of the current zone, not
the start of the mddev:
		sector_t x =  (block - zone->zone_offset) >> chunksize_bits;

taking the remainder after dividing this by the number of devices in
the current zone gives the number of the device to use.

Hope that helps.

NeilBrown
