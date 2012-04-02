From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:If r1bio->sectors % 8 != 0,then the memcmp and  later
 memcpy will omit the last bio_vec.
Date: Mon, 2 Apr 2012 11:41:12 +1000
Message-ID: <20120402114112.042b19e1@notabene.brown>
References: <201203311544085318429@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5eqP1pUXe3.+ouPUAHeIhJ5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203311544085318429@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5eqP1pUXe3.+ouPUAHeIhJ5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Mar 2012 15:44:14 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 72e5ad9da511689f7efe330ce5093a3df2c92738 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Sat, 31 Mar 2012 15:36:01 +0800
> Subject: [PATCH] md/raid1:If r1bio->sectors % 8 !=3D 0,then the memcmp and
>  later memcpy will omit the last bio_vec.

Thanks for this.

There is a bug here. However I think your fix is overly complex.

Also the 'memcpy' doesn't need to be changed - it doesn't hurt if it copies
more bytes than necessary.
However it could hurt if we compare more bytes than necessary.

I've applied a very different patch as below.

Thanks,
NeilBrown


=46rom 9d49d24d665146d121d3ae349adc92e83460d75d Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 2 Apr 2012 11:39:05 +1000
Subject: [PATCH] md/raid1,raid10: don't compare excess byte during
 consistency check.

When comparing two pages read from different legs of a mirror, only
compare the bytes that were read, not the whole page.

I most cases were read a whole page, but in some cases with
bad blocks or odd sizes devices we might read fewer than that.

This bug has been present "forever" but at worst it might cause
a report of two many mismatches and generate a little bit
extra resync IO, so there is no need to back-port to -stable
kernels.

Reported-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8c420f1..d35e4c9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1738,7 +1738,7 @@ static int process_checks(struct r1bio *r1_bio)
 				s =3D sbio->bi_io_vec[j].bv_page;
 				if (memcmp(page_address(p),
 					   page_address(s),
-					   PAGE_SIZE))
+					   sbio->bi_io_vec[j].bv_len))
 					break;
 			}
 		} else
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3540316..fff7821 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1821,7 +1821,7 @@ static void sync_request_write(struct mddev *mddev, s=
truct r10bio *r10_bio)
 			for (j =3D 0; j < vcnt; j++)
 				if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
 					   page_address(tbio->bi_io_vec[j].bv_page),
-					   PAGE_SIZE))
+					   fbio->bi_io_vec[j].bv_len))
 					break;
 			if (j =3D=3D vcnt)
 				continue;



>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..11a28ca 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1711,7 +1711,7 @@ static int process_checks(struct r1bio *r1_bio)
>  	struct mddev *mddev =3D r1_bio->mddev;
>  	struct r1conf *conf =3D mddev->private;
>  	int primary;
> -	int i;
> +	int i, vcnt;
> =20
>  	for (primary =3D 0; primary < conf->raid_disks * 2; primary++)
>  		if (r1_bio->bios[primary]->bi_end_io =3D=3D end_sync_read &&
> @@ -1721,9 +1721,9 @@ static int process_checks(struct r1bio *r1_bio)
>  			break;
>  		}
>  	r1_bio->read_disk =3D primary;
> +	vcnt =3D (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
>  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
>  		int j;
> -		int vcnt =3D r1_bio->sectors >> (PAGE_SHIFT- 9);
>  		struct bio *pbio =3D r1_bio->bios[primary];
>  		struct bio *sbio =3D r1_bio->bios[i];
>  		int size;
> @@ -1736,9 +1736,16 @@ static int process_checks(struct r1bio *r1_bio)
>  				struct page *p, *s;
>  				p =3D pbio->bi_io_vec[j].bv_page;
>  				s =3D sbio->bi_io_vec[j].bv_page;
> +				if ((j =3D=3D vcnt - 1) &&
> +					(r1_bio->sectors &
> +					 (PAGE_SIZE / 512 - 1)))
> +					size =3D (r1_bio->sectors << 9)
> +						- (PAGE_SIZE * j);
> +				else
> +					size =3D PAGE_SIZE;
>  				if (memcmp(page_address(p),
>  					   page_address(s),
> -					   PAGE_SIZE))
> +					   size))
>  					break;
>  			}
>  		} else
> @@ -2480,7 +2487,6 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr, int *skipp
>  	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
>   bio_full:
>  	r1_bio->sectors =3D nr_sectors;
> -
>  	/* For a user-requested sync, we read all readable devices and do a
>  	 * compare
>  	 */


--Sig_/5eqP1pUXe3.+ouPUAHeIhJ5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3kDuDnsnt1WYoG5AQI88Q//T3kCx7Nl7/V/r9rLysUD0DEe2yfleiIE
ssCoGhJq9Rzj1irU6aHSZ1L0mc4D6rqzjdfZE6ao+l4xjijEj0IJEt4XB/poyWDs
GeEKJcfZ/K91aZS+00jovwG1zOqbqpDgzOLFq0k85wFbbAJrerodqiiE6hPbsbpe
/RM3/2vIKbQ+N4KOrHfeWRa6bcFqvxO09HylJ8AQTIAXh11Mqg5zdbGn/OJdVj/W
KfYpjOG+moQnIuvVhtiLmiN+X2GDEIIVGJBnclyWii/Xba7mTjmAqzQMV8PnQ7we
UgwHbBvhh8QbAOXlU5QmXm7DdWQ1U9vJFtb5tIECET/phxFzp8BsJeJRniSzKy7B
GX6T4yhaY7aImIhIr2sKc3g5PlbFHYUo3Cp969YZPn3TZiSKpOgpR2yo1Mw8He2X
4jDXI2jiBKpZ81MtqUA+d2f58AcdOh0F1BDWCpJaj39EsJfGh9ITLwO9nobczGGQ
pNwHUdseD83eRbJ706f3FKZlNXZLjWK2Lt3m5U4Io5t3fTDvtWp/P6d4+uYzbM9M
9/WoTE+V6sv3fveMvAe+7kBwUK9e1GPCthyvJgzzjH5jdJzrE1j7f6rwfzvViAjj
Et1JPF2mi7vHEqZO8YtafmAX5oqK+/s6/sDWNGh4TYZKAU0jF6vthQzxS+NEmJR3
Noyh/A3RRV4=
=TXI9
-----END PGP SIGNATURE-----

--Sig_/5eqP1pUXe3.+ouPUAHeIhJ5--
