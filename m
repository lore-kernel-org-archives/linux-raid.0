From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/md0: optimize raid0 discard handling
Date: Tue, 09 May 2017 11:03:02 +1000
Message-ID: <87r2zyn8op.fsf@notabene.neil.brown.name>
References: <1af0237c374a1e276663fa17824e8345165fcca6.1494203680.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1af0237c374a1e276663fa17824e8345165fcca6.1494203680.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, May 07 2017, Shaohua Li wrote:

> There are complaints that raid0 discard handling is slow. Currently we
> divide discard request into chunks and dispatch to underlayer disks. The
> block layer will do merge to form big requests. This causes a lot of
> request split/merge and uses significant CPU time.
>
> A simple idea is to calculate the range for each raid disk for an IO
> request and send a discard request to raid disks, which will avoid the
> split/merge completely. Previously Coly tried the approach, but the
> implementation was too complex because of raid0 zones. This patch always
> split bio in zone boundary and handle bio within one zone. It simplifies
> the implementation a lot.
>
> Cc: NeilBrown <neilb@suse.com>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Shaohua Li <shli@fb.com>

Reviewed-by: NeilBrown <neilb@suse.com>

I'm a little bit bothered by the use for __blkdev_issue_discard() which
uses bio_alloc(), which allocates from fs_bio_set.  This code isn't in a
filesystem, so it feels wrong.

fs_bio_set has 4 entries.  If 4 different threads call
__blkdev_issue_discard() on a raid0 device, they could get allocated all
of the entries from the pool.  Then when raid0 calls
__blkdev_issue_discard(), the pool is empty.

I don't think this is actually a problem as discard (presumably) doesn't
happen on the write-out-for-memory-reclaim path, so the bio_alloc() will
eventually be able to get memory from kmalloc() rather than from the
pool.

Maybe next_bio() should use the bio_split pool from
bio->bi_bdev->queue.  But it probably doesn't really matter.

Thanks,
NeilBrown


> ---
>  drivers/md/raid0.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++-=
------
>  1 file changed, 102 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 84e5859..d6c0bc7 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -385,7 +385,7 @@ static int raid0_run(struct mddev *mddev)
>  		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
>  		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
>  		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
> -		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
> +		blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
>=20=20
>  		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
>  		blk_queue_io_opt(mddev->queue,
> @@ -459,6 +459,95 @@ static inline int is_io_in_chunk_boundary(struct mdd=
ev *mddev,
>  	}
>  }
>=20=20
> +static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
> +{
> +	struct r0conf *conf =3D mddev->private;
> +	struct strip_zone *zone;
> +	sector_t start =3D bio->bi_iter.bi_sector;
> +	sector_t end;
> +	unsigned int stripe_size;
> +	sector_t first_stripe_index, last_stripe_index;
> +	sector_t start_disk_offset;
> +	unsigned int start_disk_index;
> +	sector_t end_disk_offset;
> +	unsigned int end_disk_index;
> +	unsigned int disk;
> +
> +	zone =3D find_zone(conf, &start);
> +
> +	if (bio_end_sector(bio) > zone->zone_end) {
> +		struct bio *split =3D bio_split(bio,
> +			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
> +			mddev->bio_set);
> +		bio_chain(split, bio);
> +		generic_make_request(bio);
> +		bio =3D split;
> +		end =3D zone->zone_end;
> +	} else
> +		end =3D bio_end_sector(bio);
> +
> +	if (zone !=3D conf->strip_zone)
> +		end =3D end - zone[-1].zone_end;
> +
> +	/* Now start and end is the offset in zone */
> +	stripe_size =3D zone->nb_dev * mddev->chunk_sectors;
> +
> +	first_stripe_index =3D start;
> +	sector_div(first_stripe_index, stripe_size);
> +	last_stripe_index =3D end;
> +	sector_div(last_stripe_index, stripe_size);
> +
> +	start_disk_index =3D (int)(start - first_stripe_index * stripe_size) /
> +		mddev->chunk_sectors;
> +	start_disk_offset =3D ((int)(start - first_stripe_index * stripe_size) %
> +		mddev->chunk_sectors) +
> +		first_stripe_index * mddev->chunk_sectors;
> +	end_disk_index =3D (int)(end - last_stripe_index * stripe_size) /
> +		mddev->chunk_sectors;
> +	end_disk_offset =3D ((int)(end - last_stripe_index * stripe_size) %
> +		mddev->chunk_sectors) +
> +		last_stripe_index * mddev->chunk_sectors;
> +
> +	for (disk =3D 0; disk < zone->nb_dev; disk++) {
> +		sector_t dev_start, dev_end;
> +		struct bio *discard_bio =3D NULL;
> +		struct md_rdev *rdev;
> +
> +		if (disk < start_disk_index)
> +			dev_start =3D (first_stripe_index + 1) *
> +				mddev->chunk_sectors;
> +		else if (disk > start_disk_index)
> +			dev_start =3D first_stripe_index * mddev->chunk_sectors;
> +		else
> +			dev_start =3D start_disk_offset;
> +
> +		if (disk < end_disk_index)
> +			dev_end =3D (last_stripe_index + 1) * mddev->chunk_sectors;
> +		else if (disk > end_disk_index)
> +			dev_end =3D last_stripe_index * mddev->chunk_sectors;
> +		else
> +			dev_end =3D end_disk_offset;
> +
> +		if (dev_end <=3D dev_start)
> +			continue;
> +
> +		rdev =3D conf->devlist[(zone - conf->strip_zone) *
> +			conf->strip_zone[0].nb_dev + disk];
> +		if (__blkdev_issue_discard(rdev->bdev,
> +			dev_start + zone->dev_start + rdev->data_offset,
> +			dev_end - dev_start, GFP_NOIO, 0, &discard_bio) ||
> +		    !discard_bio)
> +			continue;
> +		bio_chain(discard_bio, bio);
> +		if (mddev->gendisk)
> +			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
> +				discard_bio, disk_devt(mddev->gendisk),
> +				bio->bi_iter.bi_sector);
> +		generic_make_request(discard_bio);
> +	}
> +	bio_endio(bio);
> +}
> +
>  static void raid0_make_request(struct mddev *mddev, struct bio *bio)
>  {
>  	struct strip_zone *zone;
> @@ -473,6 +562,11 @@ static void raid0_make_request(struct mddev *mddev, =
struct bio *bio)
>  		return;
>  	}
>=20=20
> +	if (unlikely((bio_op(bio) =3D=3D REQ_OP_DISCARD))) {
> +		raid0_handle_discard(mddev, bio);
> +		return;
> +	}
> +
>  	bio_sector =3D bio->bi_iter.bi_sector;
>  	sector =3D bio_sector;
>  	chunk_sects =3D mddev->chunk_sectors;
> @@ -498,19 +592,13 @@ static void raid0_make_request(struct mddev *mddev,=
 struct bio *bio)
>  	bio->bi_iter.bi_sector =3D sector + zone->dev_start +
>  		tmp_dev->data_offset;
>=20=20
> -	if (unlikely((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
> -		     !blk_queue_discard(bdev_get_queue(bio->bi_bdev)))) {
> -		/* Just ignore it */
> -		bio_endio(bio);
> -	} else {
> -		if (mddev->gendisk)
> -			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
> -					      bio, disk_devt(mddev->gendisk),
> -					      bio_sector);
> -		mddev_check_writesame(mddev, bio);
> -		mddev_check_write_zeroes(mddev, bio);
> -		generic_make_request(bio);
> -	}
> +	if (mddev->gendisk)
> +		trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
> +				      bio, disk_devt(mddev->gendisk),
> +				      bio_sector);
> +	mddev_check_writesame(mddev, bio);
> +	mddev_check_write_zeroes(mddev, bio);
> +	generic_make_request(bio);
>  }
>=20=20
>  static void raid0_status(struct seq_file *seq, struct mddev *mddev)
> --=20
> 2.9.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkRFUYACgkQOeye3VZi
gbmK8Q/+IccA6tEt5msl1mN3jFNL7xbvUfWNP/eGlMjfK2dWPecrosn5GrRqM6la
BxY/x3UjbIRrYcxB7Ep7sY5BMtXBKP3Oohq7VB+LxXOMDR6dlbP/8QarNEfaXO4C
PEzqc3zESxnOHeBArNHB+vv3nAia+UGDTN6DVkSQyhcF/7bTqCraXAX/LBx4ZnHD
9UjQ04anZPw+MT846WPbcNme6itbcAsrfaoNEdv2YNnoeJaPHfykBFLhIAiO0O8b
/O1Vydy9Nwp7j7LLo9ttmqNcJ81rGzeIyDsXiNZz7Vrk3H++mF1FaYHSMKBUC4yn
/5hJt6L/C/ZdkPzqd16X7UcV01A7VMnG7dNElruYSv1pwAeQV+KNv3skT5oqtrU3
LSZEhcrfUZNeHjZlf9NZcF0qi2g9dVLjWIunMj/qn3ywN+sB/uYcRg/txX6zIDdb
ecHQeGjMGjygJgrvbuF0fnhoVj3Cl/RGDqY0E4fLH72GEWrCRKw6LuREgG25WVsE
yX8S3FmA0YfSEir6Gc90e4+IDWz2J2QUQASAstrDdNxMkI59rmA9xh8UQjb6ciDc
HlGKA1gu5VIWjtRsjnSR8hDBeEJ35zg9EZE1CFtN9554AHDqfUhD2sWlx60QDNc8
yzB14mukvfbQQch4O0fp5Ri58ykrcq1kfK+ngIyuaL+z8KN5lpM=
=jctP
-----END PGP SIGNATURE-----
--=-=-=--
