From: NeilBrown <neilb@suse.de>
Subject: Re: When allocating resync pages,judge the queue limit of mddev.
Date: Mon, 2 Apr 2012 11:23:13 +1000
Message-ID: <20120402112313.1fddcb27@notabene.brown>
References: <201203301352578438837@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AoC8ayPO3fK9IcId8OQYXTv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203301352578438837@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/AoC8ayPO3fK9IcId8OQYXTv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Mar 2012 13:53:05 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From d5c0ad3ac03c805747f71338d30282f9f8d8d953 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Fri, 30 Mar 2012 13:37:42 +0800
> Subject: [PATCH] md/raid1:When allocating resync pages,judge the queue li=
mit  of mddev.
>  When max_sectors of mddev is smaller than
>  RESYNC_PAGES(at present 64k),then: 1:alloc enough resync
>  pags. 2:when do bio_add_page can goto bio_fill.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..cd100e6 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -82,16 +82,19 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>  	struct r1bio *r1_bio;
>  	struct bio *bio;
>  	int i, j;
> +	int sync_pages;
> =20
>  	r1_bio =3D r1bio_pool_alloc(gfp_flags, pi);
>  	if (!r1_bio)
>  		return NULL;
> =20
> +	sync_pages =3D queue_max_sectors(pi->mddev->gendisk->queue) << 9;

I don't thing '<< 9' is correct.  Maybe '<< (PAGE_SHIFT - 9)'.

> +	sync_pages =3D min(RESYNC_PAGES, (sync_pages + PAGE_SIZE - 1) / PAGE_SI=
ZE);

And this is definitely wrong. you don't want to round up the number of page
to be a multiple of the number of bytes in a page....

What is the value of this patch?  It allocates a few fewer pages for the ra=
re
case where the device cannot accept 64K IO requests?

I don't think it is really worth it, and given the obvious bugs, I won't
apply it.

Thanks,
NeilBrown


>  	/*
>  	 * Allocate bios : 1 for reading, n-1 for writing
>  	 */
>  	for (j =3D pi->raid_disks ; j-- ; ) {
> -		bio =3D bio_kmalloc(gfp_flags, RESYNC_PAGES);
> +		bio =3D bio_kmalloc(gfp_flags, sync_pages);
>  		if (!bio)
>  			goto out_free_bio;
>  		r1_bio->bios[j] =3D bio;
> @@ -108,7 +111,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>  		j =3D 1;
>  	while(j--) {
>  		bio =3D r1_bio->bios[j];
> -		for (i =3D 0; i < RESYNC_PAGES; i++) {
> +		for (i =3D 0; i < sync_pages; i++) {
>  			page =3D alloc_page(gfp_flags);
>  			if (unlikely(!page))
>  				goto out_free_pages;
> @@ -119,8 +122,8 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>  	}
>  	/* If not user-requests, copy the page pointers to all bios */
>  	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
> -		for (i=3D0; i<RESYNC_PAGES ; i++)
> -			for (j=3D1; j<pi->raid_disks; j++)
> +		for (i =3D 0; i < sync_pages ; i++)
> +			for (j =3D 1; j < pi->raid_disks; j++)
>  				r1_bio->bios[j]->bi_io_vec[i].bv_page =3D
>  					r1_bio->bios[0]->bi_io_vec[i].bv_page;
>  	}
> @@ -147,7 +150,7 @@ static void r1buf_pool_free(void *__r1_bio, void *dat=
a)
>  	int i,j;
>  	struct r1bio *r1bio =3D __r1_bio;
> =20
> -	for (i =3D 0; i < RESYNC_PAGES; i++)
> +	for (i =3D 0; i < r1bio->bios[0]->bi_max_vecs; i++)
>  		for (j =3D pi->raid_disks; j-- ;) {
>  			if (j =3D=3D 0 ||
>  			    r1bio->bios[j]->bi_io_vec[i].bv_page !=3D
> @@ -2243,7 +2246,7 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr, int *skipp
>  	int write_targets =3D 0, read_targets =3D 0;
>  	sector_t sync_blocks;
>  	int still_degraded =3D 0;
> -	int good_sectors =3D RESYNC_SECTORS;
> +	int good_sectors;
>  	int min_bad =3D 0; /* number of sectors that are bad in all devices */
> =20
>  	if (!conf->r1buf_pool)
> @@ -2296,6 +2299,7 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr, int *skipp
>  	r1_bio =3D mempool_alloc(conf->r1buf_pool, GFP_NOIO);
>  	raise_barrier(conf);
> =20
> +	good_sectors =3D r1_bio->bios[0]->bi_max_vecs << 9;
>  	conf->next_resync =3D sector_nr;
> =20
>  	rcu_read_lock();
> @@ -2477,7 +2481,7 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr, int *skipp
>  		nr_sectors +=3D len>>9;
>  		sector_nr +=3D len>>9;
>  		sync_blocks -=3D (len>>9);
> -	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
> +	} while (r1_bio->bios[disk]->bi_vcnt < r1_bio->bios[0]->bi_max_vecs);
>   bio_full:
>  	r1_bio->sectors =3D nr_sectors;
> =20


--Sig_/AoC8ayPO3fK9IcId8OQYXTv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3j/gjnsnt1WYoG5AQL75g//WStGIw3olKQ/GIaTlBKb6mTvEE7utlf7
GGVaFNcCeYJA78/b9wa1lhkp5I3ahy4QtCgji+npApmAwFnXNWrKU+xoxBgvOmnv
O/S7EDJTp8C3UTKNMqW4tKsMiOee4m8H7E2NdlrwVZ+jm9dH4bEqhl3v/20+XItg
a9Z2S0J9YLSyUYgbLYIp16+sm4AEQVzhd3lViKqEZb6ZJE83Pv6YdXITal/+9rqF
6V8vNbyROzmeAb0kWWv7lK13sydFrwgVqRS2o9/i78ri5karCk6fm8/IpZ3hZY9q
YbkYtkGx4NOLORe55OmZTadppbI61z4DizSZdxx0Yuwd9ATje3EmgiB1QZt/5FH9
pofSG32+dGLsQcd3RS7mF0IQlr0dAnnDzDFjXkUG4X3ryooQoypNWosd4Vcih0dx
h/qGx683Vvan345wqTJqCBEDMMsY6G1FdnjSb6bH2XxJZv6py5DIVD053pa7WHj4
2st9Tt5SfVBO9zmzSDgqy8s2dRCMguH4+Fc5o91Im48lZlEEo8sEFkfr2JwvkR8h
joW8yzYLgkoQPbugmzRR5sanYTcn4bbICOSo08qklDf199XevxjFk4zpgXlY2dtJ
sRcCFWU+UcwHqU/l7aTdYZolhLp/9slacmjYaRnG973vJM0CJToNdFvwENE4pYBX
+VX4tGLzwA0=
=l3nY
-----END PGP SIGNATURE-----

--Sig_/AoC8ayPO3fK9IcId8OQYXTv--
