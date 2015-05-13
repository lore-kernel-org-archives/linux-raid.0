From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DDF: _write_super_to_disk: fix anchor header type
Date: Wed, 13 May 2015 10:34:15 +1000
Message-ID: <20150513103415.0bf79e71@notabene.brown>
References: <1431353384-8637-1-git-send-email-martin.wilck@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QBqYnDsLaZpDO=n_5Tbea8H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431353384-8637-1-git-send-email-martin.wilck@ts.fujitsu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QBqYnDsLaZpDO=n_5Tbea8H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 May 2015 16:09:44 +0200 Martin Wilck <martin.wilck@ts.fujitsu.co=
m>
wrote:

> Since commit 30bee0201, the anchor is updated from the active
> DDF header. This requires fixing the header type before the
> anchor is written.
>=20
> The LSI Software RAID code will reject DDF meta data with wrong
> anchor type and will erase all meta data when it encounters
> such a broken anchor. Thus starting Linux md once on a system
> with LSI RAID BIOS may cause the meta data to get destroyed.
> ---
>  super-ddf.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index d0b2ac7..faaf0a7 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -3158,6 +3158,7 @@ static int _write_super_to_disk(struct ddf_super *d=
df, struct dl *d)
>  	memcpy(&ddf->primary, &ddf->anchor, 512);
>  	memcpy(&ddf->secondary, &ddf->anchor, 512);
> =20
> +	ddf->anchor.type =3D DDF_HEADER_ANCHOR;
>  	ddf->anchor.openflag =3D 0xFF; /* 'open' means nothing */
>  	ddf->anchor.seq =3D cpu_to_be32(0xFFFFFFFF); /* no sequencing in anchor=
 */
>  	ddf->anchor.crc =3D calc_crc(&ddf->anchor, 512);


Thanks Martin!
Applied,
NeilBrown

--Sig_/QBqYnDsLaZpDO=n_5Tbea8H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVKcBznsnt1WYoG5AQKRDw//e3uWhduf6FdAz819mJxb/2NRKKeglFOX
hjUbi2N6kFMvLl799gFAl6wyCKkiez2MYfmEtfjJg6tg2u2fsQtgrRQrjOP2Oea9
lI9rBkNgXuVcgBSghUITpu7yrV5592EDswReSXmw7DWRTnRNP8R59GNFRdByLfzX
Z/qjQwYW/wqv5xvVgpVFaE+CebjmzyPbtaKgskdbgq70UFq1PuqI/GrRiAGY2kDt
SBebhL5GyhlVoHAAoL+qVL+OsXNEbOZjdgyBo8PGoui4tyfXr+n8KwciLIj0RKCU
yq6xXZlD21r5YJsJAV2pQOAQJSrvhbKVYJJPlV5yEWJY4Ky2JBBszU4WExFjo2vB
H0E9GfI53TMSD/kJEtPvdKxscmqi5yvjLn2nxHZE2/e6V3Ilgc1OiXs9vuA4oO5d
/3kkmgG50olrV1GkLvOP8GyTLdhGIlFI8qLvdjtzV/0cwQRmJWNH9DqagKkEhcHC
YRew1AoQEGwp3mo+NjIpWnaw3Ho5DBsJ0SaiWM2dh/LAZuXEpkMm3jkMFPmHFaXA
PXnP0L8LU+9puZ1QGPcr8wpSBWaGw66rIWvPh1ISe9H3w8ImpAop1FLZqgDt6uyV
OzW65ANiXvflGeqr0hHj57FdR0kU5ijI3z40Ze/rydzsGs0roLWf5HJdSg3iy9lX
50M0V5zCH0w=
=dCMn
-----END PGP SIGNATURE-----

--Sig_/QBqYnDsLaZpDO=n_5Tbea8H--
