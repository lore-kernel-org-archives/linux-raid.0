From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1:combine code in fix_read_error and
 fix_sync_read_error.
Date: Tue, 10 Apr 2012 09:47:06 +1000
Message-ID: <20120410094706.1f45aaec@notabene.brown>
References: <201204061515339217832@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FAkKNHnYdCUrnWxlWVKjm_g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204061515339217832@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/FAkKNHnYdCUrnWxlWVKjm_g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Apr 2012 15:15:38 +0800 "majianpeng" <majianpeng@gmail.com> wrote:

> >From d8d5044e65ed2bea15e135918699777c49b6f224 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Fri, 6 Apr 2012 15:07:33 +0800
> Subject: [PATCH] md/raid1:combine code in fix_read_error and
>  fix_sync_read_error.
>


your explanation for the patch is, again, too short.

I don't agree with this patch, I'd rather leave it as it is.

I want to perform all the writes before any reads.

If a read fails, I cannot be certain what the contents of the buffer are, so
I don't want to risk writing it anywhere.

Thanks,
NeilBrown


>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |   36 ++++++++----------------------------
>  1 files changed, 8 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d35e4c9..a9a4361 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1603,7 +1603,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>  		int d =3D r1_bio->read_disk;
>  		int success =3D 0;
>  		struct md_rdev *rdev;
> -		int start;
> =20
>  		if (s > (PAGE_SIZE>>9))
>  			s =3D PAGE_SIZE >> 9;
> @@ -1661,7 +1660,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>  			continue;
>  		}
> =20
> -		start =3D d;
>  		/* write it back and re-read */
>  		while (d !=3D r1_bio->read_disk) {
>  			if (d =3D=3D 0)
> @@ -1675,21 +1673,12 @@ static int fix_sync_read_error(struct r1bio *r1_b=
io)
>  					    WRITE) =3D=3D 0) {
>  				r1_bio->bios[d]->bi_end_io =3D NULL;
>  				rdev_dec_pending(rdev, mddev);
> -			}
> -		}
> -		d =3D start;
> -		while (d !=3D r1_bio->read_disk) {
> -			if (d =3D=3D 0)
> -				d =3D conf->raid_disks * 2;
> -			d--;
> -			if (r1_bio->bios[d]->bi_end_io !=3D end_sync_read)
> -				continue;
> -			rdev =3D conf->mirrors[d].rdev;
> -			if (r1_sync_page_io(rdev, sect, s,
> -					    bio->bi_io_vec[idx].bv_page,
> -					    READ) !=3D 0)
> +			} else if (r1_sync_page_io(rdev, sect, s,
> +					    bio->bi_io_vec[idx].bv_page, READ))
>  				atomic_add(s, &rdev->corrected_errors);
> +
>  		}
> +
>  		sectors -=3D s;
>  		sect +=3D s;
>  		idx ++;
> @@ -1841,7 +1830,6 @@ static void fix_read_error(struct r1conf *conf, int=
 read_disk,
>  		int s =3D sectors;
>  		int d =3D read_disk;
>  		int success =3D 0;
> -		int start;
>  		struct md_rdev *rdev;
> =20
>  		if (s > (PAGE_SIZE>>9))
> @@ -1878,19 +1866,8 @@ static void fix_read_error(struct r1conf *conf, in=
t read_disk,
>  				md_error(mddev, rdev);
>  			break;
>  		}
> +
>  		/* write it back and re-read */
> -		start =3D d;
> -		while (d !=3D read_disk) {
> -			if (d=3D=3D0)
> -				d =3D conf->raid_disks * 2;
> -			d--;
> -			rdev =3D conf->mirrors[d].rdev;
> -			if (rdev &&
> -			    test_bit(In_sync, &rdev->flags))
> -				r1_sync_page_io(rdev, sect, s,
> -						conf->tmppage, WRITE);
> -		}
> -		d =3D start;
>  		while (d !=3D read_disk) {
>  			char b[BDEVNAME_SIZE];
>  			if (d=3D=3D0)
> @@ -1900,6 +1877,9 @@ static void fix_read_error(struct r1conf *conf, int=
 read_disk,
>  			if (rdev &&
>  			    test_bit(In_sync, &rdev->flags)) {
>  				if (r1_sync_page_io(rdev, sect, s,
> +						conf->tmppage, WRITE) =3D=3D 0)
> +					continue;
> +				else if (r1_sync_page_io(rdev, sect, s,
>  						    conf->tmppage, READ)) {
>  					atomic_add(s, &rdev->corrected_errors);
>  					printk(KERN_INFO


--Sig_/FAkKNHnYdCUrnWxlWVKjm_g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4N0+jnsnt1WYoG5AQKsuQ/9Hc8KV1OpXFMlpMXpHVRVy2ZAsrCiJcfa
t5bY5CsP1wrKdDK3I0cCRWd5jlMipzAEjQlQsaBZIjVgN2032PBrz5u62YvGyah9
+/FPvdAXL3sXpSfpFiIaRxC5UqlgfcR9OsSy5gzRjKOfsjbiAlmA0zZCHXG5N9XL
G42gcXf1Sp+9MCiB/qImwNzedK1vTJpOm/U2gyAZz2Neebs47AcQdA76k+EQFhIB
4hTTKuhzss7E+KrkI8XW8rPQlMJogH7NS2GUKRE0ICwADjFLjqcqRrL+VuaHk93o
afNdk6nptqQaLXkK+oVjkkgZa2dfGpV+uRa9zBjKMqAf2VHe/OYNPyjweS1QJ8QL
c/UbJqjr9mhbo37xygnaP9/ImKBFsbR1FJiLHouEHPxZvPe9POet4ytljTTHWGg+
zbaMpUXwFsKSb7qPKqUkdoqOXKJ/IiDNFe8KcDO9zdZEUuUepNN5mJbdTLmYGFZZ
X/W+SEJwuW5t88EgjTQyG13stZZdm79op+WIBBAK9IyIIPmA0fPVkNZ1UWNhgzet
PMVKUgHQtuqSRS05uOWoHN7hdYO2UVaUc9cKwLeFFK3ntJCThd4x2s0Q3NJ7IRv6
7AtTmDt74VdyIo/JI07DB9FT5KyTgB1pP+z+TulDm4Xs63JKEl3JiWX+dNaFW1Sn
dBI/ude3yRU=
=vXZI
-----END PGP SIGNATURE-----

--Sig_/FAkKNHnYdCUrnWxlWVKjm_g--
