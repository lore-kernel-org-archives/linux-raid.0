From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over all
	strip_zones.
Date: Thu, 14 May 2009 17:31:28 +0530
Message-ID: <37d33d830905140501m46a88e1fp318f94b262403d@mail.gmail.com>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-2-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: neilb@suse.de, raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 14, 2009 at 4:13 PM, Andre Noll <maan@systemlinux.org> wrot=
e:
> The number of strip_zones of a raid0 array is bounded by the number o=
f
> drives in the array and is in fact much smaller for typical setups. F=
or
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
> =A0drivers/md/raid0.c | =A0 32 +++++++++++++++++++-------------
> =A01 files changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c08d755..9fd3c3c 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -398,6 +398,22 @@ static int raid0_stop (mddev_t *mddev)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +/* Find the zone which holds a particular offset */
> +static struct strip_zone *find_zone(struct raid0_private_data *conf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t sector)
> +{
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < conf->nr_strip_zones; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct strip_zone *z =3D conf->strip_zo=
ne + i;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sector < z->zone_start + z->sectors=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return z;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 BUG();
> + =A0 =A0 =A0 return NULL;
> +}
> +

The point here is that rather than figuring the issue after traversing
through the list of all the zones,
you can make a check and smartly get away with the situation without
wasting extra effort.

      int i;

      BUG_ON(sector > conf->stripe_zone[0].sectors);

       for (i =3D 0; i < conf->nr_strip_zones; i++) {
               struct strip_zone *z =3D conf->strip_zone + i;

               if (sector < z->zone_start + z->sectors)
                       return z;
       }

       return NULL;



> =A0static int raid0_make_request (struct request_queue *q, struct bio=
 *bio)
> =A0{
> =A0 =A0 =A0 =A0mddev_t *mddev =3D q->queuedata;
> @@ -443,20 +459,10 @@ static int raid0_make_request (struct request_q=
ueue *q, struct bio *bio)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio_pair_release(bp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> -
> -
> - =A0 =A0 =A0 {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t x =3D sector >> conf->sector_s=
hift;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_div(x, (u32)conf->spacing);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone =3D conf->hash_table[x];
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 while (sector >=3D zone->zone_start + zone->sectors)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone++;
> -
> + =A0 =A0 =A0 zone =3D find_zone(conf, sector);
> + =A0 =A0 =A0 if (!zone)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> =A0 =A0 =A0 =A0sect_in_chunk =3D bio->bi_sector & (chunk_sects - 1);
> -
> -
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sector_t x =3D (sector - zone->zone_st=
art) >> chunksect_bits;
>
> --
> 1.5.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
