From: NeilBrown <neilb@suse.de>
Subject: Re: md:Add the judgement about the size of suspend_lo and
 suspend_hi.
Date: Mon, 2 Apr 2012 11:05:44 +1000
Message-ID: <20120402110544.0797cde1@notabene.brown>
References: <201203281949331251132@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u3PAB_BtoaBmcfFFcUpv_fs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203281949331251132@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/u3PAB_BtoaBmcfFFcUpv_fs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 19:49:38 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 7b8db5f9559feef49859056407a7cee656bcfc45 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Wed, 28 Mar 2012 19:43:58 +0800
> Subject: [PATCH] md:Add the judgement about the size of suspend_lo and
>  suspend_hi.
>=20
>=20


you patches could use a little more text explaining them too.

In this case I think it is wrong.  There is no reason at all why lo should
always be less than or equal to hi.  Imposing that is an unnecessary burden.

Not applied.

Thanks,
NeilBrown

> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b572e1e..7180ac3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4364,6 +4364,8 @@ suspend_lo_store(struct mddev *mddev, const char *b=
uf, size_t len)
>  		return -EINVAL;
>  	if (buf =3D=3D e || (*e && *e !=3D '\n'))
>  		return -EINVAL;
> +	if (new > mddev->suspend_hi)
> +		return -EINVAL;
> =20
>  	mddev->suspend_lo =3D new;
>  	if (new >=3D old)
> @@ -4398,6 +4400,8 @@ suspend_hi_store(struct mddev *mddev, const char *b=
uf, size_t len)
>  		return -EINVAL;
>  	if (buf =3D=3D e || (*e && *e !=3D '\n'))
>  		return -EINVAL;
> +	if (new < mddev->suspend_lo)
> +		return -EINVAL;
> =20
>  	mddev->suspend_hi =3D new;
>  	if (new <=3D old)


--Sig_/u3PAB_BtoaBmcfFFcUpv_fs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3j7aDnsnt1WYoG5AQJSNRAAoBNoiTe/qdt6eG47RavASjfHnmMmLB4l
OmnuUZHtq2X634V7lXs2J/SwOxBS0AiAhE2vd1KPJ2UK9+7VginK/LYpF5fWI7Ea
ggvWFehRjI1hLIddBXAuiNTgv1lCPQ4RXqs+nklK/FQye7X9bQR5dqay34T2cq+p
TuvRgDzjzrD0sg8OhdSHJL7TQfYglfA8gO3SBr0uDu3uCWmP4kIgfwDq7lk0y7O3
SFZetZ2bhqmdkptLcnIQbcd7SA/OxMUoDdrWQQI6nfzms6gBk/AnSCFEvCwGhFhb
pWquh6GadXrVlvzl1ixp3hlJXYD3/PBpKvT7//bvr6Ai06Ie8Cq4oQjsJ81XLTBO
knC9HbBIK1sICJd+gxgfxTfRwouLm9cFFuJZ1fLc9WSOX8HAzj4mgEKmHmTwkCbU
5KCPidYF2lOO4CJFoaI5aA0NzUnn/4eoGkKHQLlkXb4GhIUVmwgMlT5ke279/TxD
cPnbNTtxGXzsQWosZixA0+u69BVQsCmfcptNPuewh1S9Mu4WShvTuS80JO7XY0W9
VJFTP0KdLr9xTrmuoNcxvndvH9ucW5eDCcTRFNpwoN+6bg0MvdzFae8d1ktTOfTG
GyaZwMQQbPrpGJyzb3oah7xqGc6ADd7Ali5jW5BlaZXH3es7lcek3ahxfj2zhn5v
MJWAm9/bG2A=
=jKGm
-----END PGP SIGNATURE-----

--Sig_/u3PAB_BtoaBmcfFFcUpv_fs--
