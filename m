From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1:Fix bug about fixing read errors.
Date: Tue, 17 Apr 2012 12:26:52 +1000
Message-ID: <20120417122652.0998a84a@notabene.brown>
References: <201204112008265318561@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qONmGIzUjl_ON1J0vwTK1bm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204112008265318561@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/qONmGIzUjl_ON1J0vwTK1bm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 20:08:31 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From b5b091c186efcd32d191206181590be76a393cda Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Wed, 11 Apr 2012 19:57:01 +0800
> Subject: [PATCH] md/raid1:Fix bug about fixing read errors.
>  Add spare disk  which working when fix read errors.And if it can't read
>  corrected data,it should make all disks badsectors.And no
>  need to read,because this no disk can read.

Thanks for the patch.

However it seems to address multiple issues, and so should be multiple
patches.

Firstly, it allows fix_read_error to read from a disk that is being recover=
ed.
It seems unlikely that this will ever be necessary, but it is theoretically
possible so I am happy with the patch.
I have applied a patch making just this change.


Secondly it records a bad block on every device if it cannot read from
anywhere.
I don't think this is necessary.  fix_read_error should only be addressing
the one read error.  It either fixes it or marks it as bad.
If there are other bad blocks on other disks they will be found and handled
eventually and adding extra code in here  just makes it more complex with
little gain.

So unless you can convince me that it is actually behaving wrongly, I won't
be applying the rest of the patch.

Thanks,

NeilBrown


>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |   38 +++++++++++++++++++++++++++++---------
>  1 files changed, 29 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d35e4c9..67ec686 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1833,7 +1833,7 @@ static void sync_request_write(struct mddev *mddev,=
 struct r1bio *r1_bio)
>   *	3.	Performs writes following reads for array synchronising.
>   */
> =20
> -static void fix_read_error(struct r1conf *conf, int read_disk,
> +static int  fix_read_error(struct r1conf *conf, int read_disk,
>  			   sector_t sect, int sectors)
>  {
>  	struct mddev *mddev =3D conf->mddev;
> @@ -1858,7 +1858,9 @@ static void fix_read_error(struct r1conf *conf, int=
 read_disk,
> =20
>  			rdev =3D conf->mirrors[d].rdev;
>  			if (rdev &&
> -			    test_bit(In_sync, &rdev->flags) &&
> +			    (test_bit(In_sync, &rdev->flags) ||
> +			     (!test_bit(Faulty, &rdev->flags) &&
> +			      (rdev->recovery_offset >=3D sect + s))) &&
>  			    is_badblock(rdev, sect, s,
>  					&first_bad, &bad_sectors) =3D=3D 0 &&
>  			    sync_page_io(rdev, sect, s<<9,
> @@ -1873,10 +1875,15 @@ static void fix_read_error(struct r1conf *conf, i=
nt read_disk,
> =20
>  		if (!success) {
>  			/* Cannot read from anywhere - mark it bad */
> -			struct md_rdev *rdev =3D conf->mirrors[read_disk].rdev;
> -			if (!rdev_set_badblocks(rdev, sect, s, 0))
> -				md_error(mddev, rdev);
> -			break;
> +			struct md_rdev *rdev;
> +			for (d =3D 0; d < conf->raid_disks * 2; d++) {
> +				rdev =3D conf->mirrors[d].rdev;
> +				if (!rdev)
> +					continue;
> +				else if (!rdev_set_badblocks(rdev, sect, s, 0))
> +					md_error(mddev, rdev);
> +			}
> +			return 1;
>  		}
>  		/* write it back and re-read */
>  		start =3D d;
> @@ -1915,6 +1922,7 @@ static void fix_read_error(struct r1conf *conf, int=
 read_disk,
>  		sectors -=3D s;
>  		sect +=3D s;
>  	}
> +	return 0;
>  }
> =20
>  static void bi_complete(struct bio *bio, int error)
> @@ -2072,8 +2080,13 @@ static void handle_read_error(struct r1conf *conf,=
 struct r1bio *r1_bio)
>  	struct bio *bio;
>  	char b[BDEVNAME_SIZE];
>  	struct md_rdev *rdev;
> +	int ret;
> =20
>  	clear_bit(R1BIO_ReadError, &r1_bio->state);
> +
> +	bio =3D r1_bio->bios[r1_bio->read_disk];
> +	bdevname(bio->bi_bdev, b);
> +
>  	/* we got a read error. Maybe the drive is bad.  Maybe just
>  	 * the block and we can fix it.
>  	 * We freeze all other IO, and try reading the block from
> @@ -2084,14 +2097,21 @@ static void handle_read_error(struct r1conf *conf=
, struct r1bio *r1_bio)
>  	 */
>  	if (mddev->ro =3D=3D 0) {
>  		freeze_array(conf);
> -		fix_read_error(conf, r1_bio->read_disk,
> +		ret =3D fix_read_error(conf, r1_bio->read_disk,
>  			       r1_bio->sector, r1_bio->sectors);
>  		unfreeze_array(conf);
> +		/*no need read more */
> +		if (ret) {
> +			printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
> +			      " read error for block %llu\n", mdname(mddev),
> +			      b, (unsigned long long)r1_bio->sector);
> +			raid_end_bio_io(r1_bio);
> +			return;
> +
> +		}
>  	} else
>  		md_error(mddev, conf->mirrors[r1_bio->read_disk].rdev);
> =20
> -	bio =3D r1_bio->bios[r1_bio->read_disk];
> -	bdevname(bio->bi_bdev, b);
>  read_more:
>  	disk =3D read_balance(conf, r1_bio, &max_sectors);
>  	if (disk =3D=3D -1) {


--Sig_/qONmGIzUjl_ON1J0vwTK1bm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4zU7Dnsnt1WYoG5AQK9zRAAiWbJAoiWj9dQGNp1hK31Y/zqlc+5HJAD
uZ6XbWtLMpEkwf4RFMcUM4AYNvyFiGXkltipEiyAuobtIGhHwNLcvXU3mChvnvJW
jqYu7ZFzsr7/qJboeRzM2Bc3OzAM6x2Bka2MWiqFi3BWloP6i5rSOzBtWCIQs7PJ
AjNDf0laK+nLf2OK9n8v/i8Rb1AvWQxnJeZ39mQ6nZBNbXsIklCmLuHM6+I24BHG
kZB3V9JQwF/yrx4wncsnuOzBfJCLgCEFPPJNsW7H0oDPj0g4bOChnri4nv68qXPW
yJrqTLqCRQra71E3fwV21fdbkCaMqLfj4OHSt1jPlf3Md1DauFaXGhTaJgyw0L5i
RGW11u+zKcDDxvBVbTrqBFYz/8/LqzldzYfNeKpY9JXZaGuzUPJXQWvFXn4uBJ+r
AfBNGFcW/Ggmbdzoe2dvDN/GZXayJ5Y6gSYZUP0fEDcWnCQdK/6L4X3yTG8JEd0h
Vh7qyA4OEh/5BLuyuPgM1F9eqAupilccO6NRsT7QtblyjdBbSHeXzVGld4FRaQ+I
j+XqxkQSQiNwIpQEoUy9BNLul7ckvybYJdjS5vjC9UcYqI3ALjskRe9ZswHbtdaD
hWn8OprVtDJWme2iefOnhgdhaPSE4N4ub+spCjn6wKQ9pXy1g24iMADEzlK930fb
Q5P/y7mxY34=
=9ouB
-----END PGP SIGNATURE-----

--Sig_/qONmGIzUjl_ON1J0vwTK1bm--
