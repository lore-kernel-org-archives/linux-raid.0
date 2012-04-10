From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid1,raid10:If r1bio->sectors % 8 != 0,then the
 memcmp  and latermemcpy will omit the last bio_vec.
Date: Tue, 10 Apr 2012 16:17:28 +1000
Message-ID: <20120410161728.2005ca5e@notabene.brown>
References: <201204051448360781921@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Tlx+KrOztxej_EKr9qfrlqa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204051448360781921@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Tlx+KrOztxej_EKr9qfrlqa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Apr 2012 14:48:39 +0800 "majianpeng" <majianpeng@gmail.com> wrote:

> >From a4e76f125fd277ed5a72bf0e2fffde8b210a9603 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Thu, 5 Apr 2012 14:42:12 +0800
> Subject: [PATCH] md/raid1,raid10:If r1bio->sectors % 8 !=3D 0,then the me=
mcmp
>  and latermemcpy will omit the last bio_vec.
>=20

Applied,
Thanks.

NeilBrown



>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c  |    3 ++-
>  drivers/md/raid10.c |    4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d35e4c9..15dd59b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1712,6 +1712,7 @@ static int process_checks(struct r1bio *r1_bio)
>  	struct r1conf *conf =3D mddev->private;
>  	int primary;
>  	int i;
> +	int vcnt;
> =20
>  	for (primary =3D 0; primary < conf->raid_disks * 2; primary++)
>  		if (r1_bio->bios[primary]->bi_end_io =3D=3D end_sync_read &&
> @@ -1721,9 +1722,9 @@ static int process_checks(struct r1bio *r1_bio)
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
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index fff7821..c8dbb84 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1788,6 +1788,7 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>  	struct r10conf *conf =3D mddev->private;
>  	int i, first;
>  	struct bio *tbio, *fbio;
> +	int vcnt;
> =20
>  	atomic_set(&r10_bio->remaining, 1);
> =20
> @@ -1802,10 +1803,10 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>  	first =3D i;
>  	fbio =3D r10_bio->devs[i].bio;
> =20
> +	vcnt =3D (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
>  	/* now find blocks with errors */
>  	for (i=3D0 ; i < conf->copies ; i++) {
>  		int  j, d;
> -		int vcnt =3D r10_bio->sectors >> (PAGE_SHIFT-9);
> =20
>  		tbio =3D r10_bio->devs[i].bio;
> =20
> @@ -1871,7 +1872,6 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>  	 */
>  	for (i =3D 0; i < conf->copies; i++) {
>  		int j, d;
> -		int vcnt =3D r10_bio->sectors >> (PAGE_SHIFT-9);
> =20
>  		tbio =3D r10_bio->devs[i].repl_bio;
>  		if (!tbio || !tbio->bi_end_io)


--Sig_/Tlx+KrOztxej_EKr9qfrlqa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4PQeDnsnt1WYoG5AQLqoRAAjOiTTsW0g0i10846xxw3QnmYSaGEIfIK
/2KM1ODeK+8d3209Sehna3yDMBmXrIEDGzFEGs7bCQx99KaByxlxA63KmirGI/J7
XCi/tB+3nCprglUJNU8LBP2LFkSXMD3ywztznczc9esKEodFyoDx0B92H3RBtgEn
Q8eXT/ktAdNl2vq85anidINgbIKd1CFf10WB5Nf4B9cOK7eLl+R0NQny/6WSoUPO
fAG/9weTE8BxOIfcQPDjjxvsL9GXJUNnVeiEAkYkWpNzmwgTiFhcr6rfz8Ib2j9l
C4ZUQI2iOtScGAZfd0aHwvSGf3tRHJK0+6EuPU2Gq34abrWjGajsbRp/mVORhZXB
nII47GFgi8jMUlS8uonrcoH2hUpCQcrgQjg0jivPxVmyUK0PkpW1uXErBBX3SPii
VEYJJe1LQ7cB6FiktDRctTjDCahmHe6k6wNbYCttd285nVYd0++L5erYICfAH1vz
g433eFpZ+8fCPrfq7ZHjAt6f2l4wjd4Ej9kXzE/JQrhuXDHsyAY/nChyst0vLYPd
EIrQH+0qUMbL6XfN29t4PcwBvUCtPQ86MYX1aS4qEED6XIkiv0PnvwVMBzYIbvbU
z1QD++vK2RWHUvH11V87rCeIcixYIyaGcWLxQSbh5nxoUD4ZEQhoSyn4VGyYIL22
QEW67oce52k=
=CQ7d
-----END PGP SIGNATURE-----

--Sig_/Tlx+KrOztxej_EKr9qfrlqa--
