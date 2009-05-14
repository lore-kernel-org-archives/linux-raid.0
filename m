From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over
	all strip_zones.
Date: Thu, 14 May 2009 17:13:37 +0300
Message-ID: <1242310417.3500.8.camel@raz>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-2-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 2009-05-14 at 12:43 +0200, Andre Noll wrote:
> The number of strip_zones of a raid0 array is bounded by the number of
> drives in the array and is in fact much smaller for typical setups. For
> example, any raid0 array containing identical disks will have only
> a single strip_zone.
> 
> Therefore, the hash tables which are used for quickly finding the
> strip_zone that holds a particular sector are of questionable value
> and add quite a bit of unnecessary complexity.
> 
> This patch replaces the hash table lookup by equivalent code which
> simply loops over all strip zones to find the zone that holds the
> given sector.
> 
> Subsequent cleanup patches will remove the hash table structure.
> 
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
>  drivers/md/raid0.c |   32 +++++++++++++++++++-------------
>  1 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c08d755..9fd3c3c 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -398,6 +398,22 @@ static int raid0_stop (mddev_t *mddev)
>  	return 0;
>  }
>  
> +/* Find the zone which holds a particular offset */
> +static struct strip_zone *find_zone(struct raid0_private_data *conf,
> +		sector_t sector)
> +{
> +	int i;
> +
> +	for (i = 0; i < conf->nr_strip_zones; i++) {
> +		struct strip_zone *z = conf->strip_zone + i;
> +
> +		if (sector < z->zone_start + z->sectors)
> +			return z;
> +	}
> +	BUG();
> +	return NULL;
> +}
> +
>  static int raid0_make_request (struct request_queue *q, struct bio *bio)
>  {
>  	mddev_t *mddev = q->queuedata;
> @@ -443,20 +459,10 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
>  		bio_pair_release(bp);
>  		return 0;
>  	}
> - 
> -
> -	{
> -		sector_t x = sector >> conf->sector_shift;
> -		sector_div(x, (u32)conf->spacing);
> -		zone = conf->hash_table[x];
> -	}
> -
> -	while (sector >= zone->zone_start + zone->sectors)
> -		zone++;
> -
> +	zone = find_zone(conf, sector);
> +	if (!zone)
> +		return 1;
? if you cannot serve the io you shouldn't you return an error ?
>  	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
> -
> -
>  	{
>  		sector_t x = (sector - zone->zone_start) >> chunksect_bits;
>  

