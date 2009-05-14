From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md: raid0: Replace hash table lookup by looping over all
	strip_zones.
Date: Thu, 14 May 2009 17:45:00 +0530
Message-ID: <37d33d830905140515k46b4305du5fff1cf97a32e4ad@mail.gmail.com>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <37d33d830905140501m46a88e1fp318f94b262403d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905140501m46a88e1fp318f94b262403d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: neilb@suse.de, raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 14, 2009 at 5:31 PM, SandeepKsinha <sandeepksinha@gmail.com=
> wrote:
> On Thu, May 14, 2009 at 4:13 PM, Andre Noll <maan@systemlinux.org> wr=
ote:
>> The number of strip_zones of a raid0 array is bounded by the number =
of
>> drives in the array and is in fact much smaller for typical setups. =
=46or
>> example, any raid0 array containing identical disks will have only
>> a single strip_zone.
>>
>> Therefore, the hash tables which are used for quickly finding the
>> strip_zone that holds a particular sector are of questionable value
>> and add quite a bit of unnecessary complexity.
>>
>> This patch replaces the hash table lookup by equivalent code which
>> simply loops over all strip zones to find the zone that holds the
>> given sector.
>>
>> Subsequent cleanup patches will remove the hash table structure.
>>
>> Signed-off-by: Andre Noll <maan@systemlinux.org>
>> ---
>> =A0drivers/md/raid0.c | =A0 32 +++++++++++++++++++-------------
>> =A01 files changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index c08d755..9fd3c3c 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -398,6 +398,22 @@ static int raid0_stop (mddev_t *mddev)
>> =A0 =A0 =A0 =A0return 0;
>> =A0}
>>
>> +/* Find the zone which holds a particular offset */
>> +static struct strip_zone *find_zone(struct raid0_private_data *conf=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t sector)
>> +{
>> + =A0 =A0 =A0 int i;
>> +
>> + =A0 =A0 =A0 for (i =3D 0; i < conf->nr_strip_zones; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct strip_zone *z =3D conf->strip_z=
one + i;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sector < z->zone_start + z->sector=
s)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return z;
>> + =A0 =A0 =A0 }
>> + =A0 =A0 =A0 BUG();
>> + =A0 =A0 =A0 return NULL;
>> +}
>> +
>
> The point here is that rather than figuring the issue after traversin=
g
> through the list of all the zones,
> you can make a check and smartly get away with the situation without
> wasting extra effort.
>
> =A0 =A0 =A0int i;
>
> =A0 =A0 =A0BUG_ON(sector > conf->stripe_zone[0].sectors);
>
> =A0 =A0 =A0 for (i =3D 0; i < conf->nr_strip_zones; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct strip_zone *z =3D conf->strip_zone=
 + i;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sector < z->zone_start + z->sectors)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return z;
> =A0 =A0 =A0 }
>
> =A0 =A0 =A0 return NULL;
>
Sorry taken back. This won't exactly help. But thinking in similar
lines can be helpful.

>
>
>> =A0static int raid0_make_request (struct request_queue *q, struct bi=
o *bio)
>> =A0{
>> =A0 =A0 =A0 =A0mddev_t *mddev =3D q->queuedata;
>> @@ -443,20 +459,10 @@ static int raid0_make_request (struct request_=
queue *q, struct bio *bio)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bio_pair_release(bp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>> =A0 =A0 =A0 =A0}
>> -
>> -
>> - =A0 =A0 =A0 {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t x =3D sector >> conf->sector_=
shift;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_div(x, (u32)conf->spacing);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone =3D conf->hash_table[x];
>> - =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 while (sector >=3D zone->zone_start + zone->sectors)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zone++;
>> -
>> + =A0 =A0 =A0 zone =3D find_zone(conf, sector);
>> + =A0 =A0 =A0 if (!zone)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> =A0 =A0 =A0 =A0sect_in_chunk =3D bio->bi_sector & (chunk_sects - 1);
>> -
>> -
>> =A0 =A0 =A0 =A0{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sector_t x =3D (sector - zone->zone_s=
tart) >> chunksect_bits;
>>
>> --
>> 1.5.4.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
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
