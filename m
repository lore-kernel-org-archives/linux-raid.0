From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:remove unnecessary
 set_bit(MD_RECOVERY_INTR,&mddev->recovery).
Date: Mon, 2 Apr 2012 11:08:17 +1000
Message-ID: <20120402110817.461a4691@notabene.brown>
References: <201203282004424064858@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GGqrP4tONZa7GHrGRDh.So0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203282004424064858@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/GGqrP4tONZa7GHrGRDh.So0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 20:04:46 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 641d71c2c1acc15536c621e2aa9806fe42b9cb8a Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Wed, 28 Mar 2012 20:02:05 +0800
> Subject: [PATCH] md/raid1:remove unnecessary  set_bit(MD_RECOVERY_INTR,&m=
ddev->recovery).
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..81083f2 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1649,7 +1649,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>  			if (abort) {
>  				conf->recovery_disabled =3D
>  					mddev->recovery_disabled;
> -				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  				md_done_sync(mddev, r1_bio->sectors, 0);
>  				put_buf(r1_bio);
>  				return 0;

This one is unnecessary because md_done_sync set it for us,

> @@ -2403,7 +2402,6 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr, int *skipp
>  			 * fail the really bad ones ???
>  			 */
>  			conf->recovery_disabled =3D mddev->recovery_disabled;
> -			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  			return 0;
>  		} else
>  			return min_bad;

But why is this one unnecessary?  This is why including and explanation at
the top of the patch helps.

Not applied - but I will if you explain why it is needed.

Thanks,
NeilBrown

--Sig_/GGqrP4tONZa7GHrGRDh.So0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3j8ATnsnt1WYoG5AQIJSxAAsbpgdhzEkxbIBgpU1L1w2XiAmOULwcn2
i7SixeVmkTgJlh0R/7HToaLqmWuBe5AwA/RQXS8QBUZXAi2wSfA7ySbDOmxCHdfg
eOztis6FqfLICNUUek8LTlsC/cEOBKKkBq170hOud84nDAGbS0Eezi41Wbnw+zMv
fc6PoSgZVjtdum02efb1v8B+VZJ3iMJiNm8Sbwcz1xoV8kqwN0XMCdyANskVnp5P
yCXctHrqCCVfBzWlQCl7LFsi90vI9gDHbWWnIrPNmHefst4aUV6raZLBMCn2ey8A
yPc0Na9mr+JfRKTW5xUiQk1qSGEky8KLDEFNkyquFCCPy2SKDfC8xtfmv+sCCb0k
W6WlslU5eGdprG8OhX/TfN0+NJD4GW/c4nmDVHKDumdySArJiZKjU/ykKencojhN
NoSh9ykn8X+Rcgs4ikXK/tZNMR6mK6SxFwEsVlkkBhvyClxiMk6upE9SaYGO40uv
iIysFIixgX07VINpyGz1Am+BzOxol6+qDeTb0jebPJbwdMPwCmd8z2BgzN+L+mJt
gFCel1T5rf9W5wdSNYVpkPS5zflwhtIqlpz6d/qEJCC9DZXSQV0w7zImkkDsnUZv
8qSvZGltRe0Zti0oFZPRgkBMs0I9P0Ubehfw5jvpzmddAE2kq1pOUdCM8esrlq2w
dA6sWOuHZLY=
=7Jj+
-----END PGP SIGNATURE-----

--Sig_/GGqrP4tONZa7GHrGRDh.So0--
