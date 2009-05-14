From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over
     all strip_zones.
Date: Thu, 14 May 2009 21:15:40 +1000 (EST)
Message-ID: <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
    <1242297833-13908-2-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-2-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

On Thu, May 14, 2009 8:43 pm, Andre Noll wrote:
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

Maybe I'm being petty, but I really don't like this...

I really like
> -        while (sector >= zone->zone_start + zone->sectors)
> -                zone++;

It seems to capture what is really happening.
But I can see that your code has a defensive aspect to it
which is hard to argue against.

It's probably the fact that there are two loop variables (i and z)
that bothers me....
Here is a thought.  How about we extend the stripe_zone array
by one element and put a sentinal at the end, with ->zone_start being
the size of the drive ... or maybe even "max sector".

Then the loop could be
   for (i = 0; i < conf->nr_strip_zones; i++)
         if (sector < conf->strip_zone[i+1])
               return conf->strip_zone[i]

Save our selves an 'add' that way :-)


> +	BUG();
> +	return NULL;
> +}
> +
>  static int raid0_make_request (struct request_queue *q, struct bio *bio)
>  {
>  	mddev_t *mddev = q->queuedata;
> @@ -443,20 +459,10 @@ static int raid0_make_request (struct request_queue
> *q, struct bio *bio)
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

I don't much like those last two lines either.  zone will
never be NULL because if find_zone doesn't find anything, it
calls BUG.  And returning from make_request without doing any IO
is just wrong.  So those two lines can go.

Thanks,
NeilBrown


>  	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
> -
> -
>  	{
>  		sector_t x = (sector - zone->zone_start) >> chunksect_bits;
>
> --
> 1.5.4.3
>

