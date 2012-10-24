From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Create new md devices consistently
Date: Wed, 24 Oct 2012 12:09:57 +1100
Message-ID: <20121024120957.65aa4318@notabene.brown>
References: <1351029840-5030-1-git-send-email-jmaggard10@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JcOR5+cw_xzXH/Q9.zTvnSv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1351029840-5030-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JcOR5+cw_xzXH/Q9.zTvnSv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Oct 2012 15:04:00 -0700 Justin Maggard <jmaggard10@gmail.com>
wrote:

>  Creating a new MD device with the name 'd-0' results in some
>  unexpected behavior, since mdadm sees that '-0' is a
>  non-negative integer and therefore makes a "partitionable"
>  device (/dev/md_d0).  This is not the expected behavior,
>  since the documentation mentions 'dN' several places, and a
>  reboot brings it up as /dev/md/d-0.  Make this consistent
>  by ensuring that the character immediately following 'd' is
>  a digit during creation.
>=20
> ---
>  mdopen.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/mdopen.c b/mdopen.c
> index 61eda81..24188df 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -207,7 +207,10 @@ int create_mddev(char *dev, char *name, int autof, i=
nt trustworthy,
>  			char *ep;
>  			if (cname[0] =3D=3D 'd')
>  				sp++;
> -			num =3D strtoul(sp, &ep, 10);
> +			if (isdigit(sp[0]))
> +				num =3D strtoul(sp, &ep, 10);
> +			else
> +				ep =3D sp;
>  			if (ep =3D=3D sp || *ep || num < 0)
>  				num =3D -1;
>  			else if (cname[0] =3D=3D 'd')

applied, thanks.

Will be in mdadm-3.2.6 which I plan to release tomorrow.

NeilBrown

--Sig_/JcOR5+cw_xzXH/Q9.zTvnSv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIc/5Tnsnt1WYoG5AQJaehAAvj5XofNtJSQIuz0SQiDbuTIWuUMfXYQM
lrV/p6E+45T2+xJYJJPAbi4ceMNtmWC9u55lfi/1ZggdYQT4WMBsDHMrCmpScAN+
ezIqvylOE3fVkXFJ6iB2auhvhU4cWmhyRzaQUrjoBkWMJQERyLEUzYBhIcuZoCTP
9VPtLvvVIwoBGT/+uwfj74GSwpqfB83jx3RzORjUyYUTcKrsB457QMnoPEr5G9u4
KTzuTqcS3ABd/kNdNKa/ugW+eN2k7lF5LrNgdmEW7fCVIEArLdpvNinfFaPg8us/
QykmyAEc/MjxB2a6xUk+gjIuPv0if/v8rsu9LYiHJdxU7OCyJAxKNrS6r4xWVivK
agtooE9Md3eVmgwLn1RjxPTrLnpLAnXHDUURsVKXvdTGB3jjevbJdFvXjI2/m8hd
uQX7b3RNNaE4xRls9PlijsW9C7zTpNSi5//ZH/kD7mCNZp/J1s0RcaC8EMuoowPl
CrNJSFXYKSawoQK7K8SyLXtLtKDdB3VLbIpNC1MIR5N4nygR+cNgabUTzAojOYSY
XdUJkREWFM1+xh4oxuGOsqB1JyUrmaV8KkeA8bmVH4483Sv2wT1MwpRg3azOVvp1
qVOAurDKrES9U/tz/cMwIik/Q1ixRRw4VMpk+UVNHaCRKHLjwl/nufVpf1pri0af
TWAx5qlJo1U=
=CYGk
-----END PGP SIGNATURE-----

--Sig_/JcOR5+cw_xzXH/Q9.zTvnSv--
