From: NeilBrown <neilb@suse.de>
Subject: Re: md:Add break if find.
Date: Wed, 14 Mar 2012 13:06:15 +1100
Message-ID: <20120314130615.7e5dbd42@notabene.brown>
References: <201203131328071710700@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tFS6pWk/rMfn3h95lsJ.uKc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203131328071710700@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/tFS6pWk/rMfn3h95lsJ.uKc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Mar 2012 13:28:12 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 6e04c2374db7fc34ccbf9f37f85e735a349c816c Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Tue, 13 Mar 2012 13:26:25 +0800
> Subject: [PATCH] md:Add break if find.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 360f2b9..e05d9e5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4369,8 +4369,10 @@ static inline sector_t sync_request(struct mddev *=
mddev, sector_t sector_nr, int
>  	 * recovery aborts.
>  	 */
>  	for (i =3D 0; i < conf->raid_disks; i++)
> -		if (conf->disks[i].rdev =3D=3D NULL)
> +		if (conf->disks[i].rdev =3D=3D NULL) {
>  			still_degraded =3D 1;
> +			break;
> +		}
> =20
>  	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degrade=
d);
> =20

Thanks - however I don't think I'll apply this one.

It is a micro optimisation which only improve an uncommon case a little,
but it makes the source code long and the generated machine code longer (by
32 bytes on x86_64).
So I don't really think it is a win.

Thanks,
NeilBrown


--Sig_/tFS6pWk/rMfn3h95lsJ.uKc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1/9Fznsnt1WYoG5AQInDQ//adFAxCbEFcu4W6fmKVgPrs6qkZsRALMG
IoAEhRcz7f2J/S93w8FuzrdnoNfR0OeFb/+0vLAyGg9cEzJWkp5DwNZADZayaZ9+
kdlB5q05adrZxyht2EkDVXHZ3C8dxIxoTmi6SzHcCa95aZgY1FYVIliSApGMUKsr
AipAND2DdEmBOB/xJq3iYSHBkofPXwGKCz9qllghoYD4u3mRsUmfVzasSDpQ1zg6
bXxg7Iu9khrcGnGLGBIu/x8qZiIeBK0uY4iSFg6R73x1vrIucKMhs6Dl1QOsGnt0
lLQI87SwSzp1uk9QgqOpxYddyRpiSI8ffQtcCTK1XXL17xCEBa4OP1ZOxrsrAISr
vdOnNxm3k3Uvgdc9cDkPnLcwOKQdRW5ALoOT7aMBws5uTiAPX9n1nW4YFGVWoYp7
UOwG/ukjIDeUePjZv/qxcyt8N8mlyJL8SYzAxYhAGwswK3WrKTET0jj4Ml9cngoW
izJcJ/NUkV/1JMhZyWnmVP9esCU1j9tYJJ+KySyIuqpGSTgWnNDefiWF+VrbKOEy
X2vSzD05gQHbg4TjzXx/yqQM6P7Bs4BLlY257Rd6mTlGAF1Max6O9Gm7tJoDKfYk
Rg8bycpHt544+oBXUV3wXrYjWhBWXxhkN8Fk1Cnmm/OWuddm2VN/jMz7+oZ0z2vz
sFo1VqT1qHQ=
=CBaE
-----END PGP SIGNATURE-----

--Sig_/tFS6pWk/rMfn3h95lsJ.uKc--
