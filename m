From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md:Add blk_plug in sync_thread.
Date: Wed, 27 Jun 2012 12:30:36 +1000
Message-ID: <20120627123036.53871345@notabene.brown>
References: <201206111716521256611@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qnFxeCPTyv/pnp/U/3HbJtF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206111716521256611@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/qnFxeCPTyv/pnp/U/3HbJtF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Jun 2012 17:16:55 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Add blk_plug in sync_thread will increase the performance of sync.
> Because sync_thread did not blk_plug,so when raid sync, the bio merge
> not well.
>=20
> Testing environment:
> SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI
> Controller.
> OS:Linux xxx 3.5.0-rc2+ #340 SMP Tue Jun 12 09:00:25 CST 2012
> x86_64 x86_64 x86_64 GNU/Linux.
> RAID5: four ST31000524NS disk.
>=20
> Without blk_plug:recovery speed about 63M/Sec;
> Add blk_plug:recovery speed about 120M/Sec.
>=20
> Using blktrace:
> blktrace -d /dev/sdb -w 60  -o -|blkparse -i -
>=20
> without blk_plug:
> Total (8,16):
>  Reads Queued:      309811,     1239MiB	 Writes Queued:           0,     =
   0KiB
>  Read Dispatches:   283583,     1189MiB	 Write Dispatches:        0,     =
   0KiB
>  Reads Requeued:         0		 Writes Requeued:         0
>  Reads Completed:   273351,     1149MiB	 Writes Completed:        0,     =
   0KiB
>  Read Merges:        23533,    94132KiB	 Write Merges:            0,     =
   0KiB
>  IO unplugs:             0        	 Timer unplugs:           0
>=20
> add blk_plug:
> Total (8,16):
>  Reads Queued:      428697,     1714MiB	 Writes Queued:           0,     =
   0KiB
>  Read Dispatches:     3954,     1714MiB	 Write Dispatches:        0,     =
   0KiB
>  Reads Requeued:         0		 Writes Requeued:         0
>  Reads Completed:     3956,     1715MiB	 Writes Completed:        0,     =
   0KiB
>  Read Merges:       424743,     1698MiB	 Write Merges:            0,     =
   0KiB
>  IO unplugs:             0        	 Timer unplugs:        3384
>=20
> The ratio of merge will be markedly increased.
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1c2f904..90bdc37 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7298,6 +7298,7 @@ void md_do_sync(struct mddev *mddev)
>  	int skipped =3D 0;
>  	struct md_rdev *rdev;
>  	char *desc;
> +	struct blk_plug plug;
> =20
>  	/* just incase thread restarts... */
>  	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
> @@ -7446,7 +7447,8 @@ void md_do_sync(struct mddev *mddev)
>  		mddev->curr_resync =3D j;
>  	}
>  	mddev->curr_resync_completed =3D j;
> -
> +
> +	blk_start_plug(&plug);
>  	while (j < max_sectors) {
>  		sector_t sectors;
> =20
> @@ -7586,6 +7588,7 @@ void md_do_sync(struct mddev *mddev)
>  	}
>   skip:
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
> +	blk_finish_plug(&plug);
> =20
>  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>  		/* We completed so min/max setting can be forgotten if used. */

Thanks again.

I've moved the call to "blk_finish_plug" up a bit to just after the
  out:
label, as it is possible to "goto skip" before calling blk_start_plug.

Thanks a lot,
NeilBrown

--Sig_/qnFxeCPTyv/pnp/U/3HbJtF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+pwTDnsnt1WYoG5AQI/cQ/+OkFXKNJpml5fBg0Kw0epP28f8gRBa+LA
8OkVlheDakkF6Z3O0qgQSQnEESCU5qXGGxWmfzPdu6/DAXvEcssNSwbJSwCKKhrQ
gR1ZW2hKcnY7yYjGcs9X7vB1tSb+DU3BzyDVVkARnCCVDUKKwA0BVOZb/YIl5F+j
7Dv1+hIW92g+aq4G6flQnloHwf6Xu5e37akyD3cCcKpJ4/HM+gbGVMZEYwXn7foc
ysZqZ0OZeO4jrnPpcH/ELer+DNPX38I831w+fllMDhje0yPZssAy0Ddq1d3SK1cr
uIE1y92ROACaPTehhz9HqXLNTVGjtbRjPlXJH8pH3rDQLQ75fnUkeO/xn6yPjnCP
QU11DhqoE1ek5sECGEbsCUC1yUuMRayDbLi/NMZcFQdVak5NjZqUwPOvHDh+WZXB
UeSTkNsyE4ZjEzedbteDqkmtV7npegWD4Zy+w2ngcfK/pok8xJsC9wF9D2sJmuqv
R15MX2XiAQ449/bebdH51AQdiWCaL9Db/MX7qrRptWqEnlKobLi4fzLvfdk68kIp
U0BUDNkbuz6OsLU117GxepfDodO3jyG6ZqfAcvpEYfpZdLASF7MmgVyHvOQp8/iU
80MSzD2vZ1lCPNTWZS6isl476aKlI+SgCijXB7LM4W/+rjiI+iLCVP5Jun5FMFAC
UXrTlWVV5ow=
=w4oC
-----END PGP SIGNATURE-----

--Sig_/qnFxeCPTyv/pnp/U/3HbJtF--
