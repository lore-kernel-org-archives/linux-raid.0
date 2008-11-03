From: Andre Noll <maan@systemlinux.org>
Subject: Re: linear : divide error: 0000
Date: Mon, 3 Nov 2008 15:15:01 +0100
Message-ID: <20081103141501.GK17966@skl-net.de>
References: <1346d4690811020803p47f62b3ak9868832969040759@mail.gmail.com> <20081103103221.GJ17966@skl-net.de> <1346d4690811030437t259c4f60rac29acd746c2acff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+RZeZVNR8VILNfK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1346d4690811030437t259c4f60rac29acd746c2acff@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Yongquan <weiyqlq@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:37, Wei Yongquan wrote:
> > This sector_div() is in linear_conf() while the call trace indicates
> > the bug happens in mddev_put(). I'll have a deeper look later today.
> >
> > Is this a recent regression?
>=20
> Sorry, I don't know.  2.6.24.4 has the some problem.

That's good to know because there has been a bit of churn in the
linear code recently. But this happened way after 2.6.24.4 and is
therefore not the source of the problem.

> the code linear.c :
>=20
> 158              min_spacing =3D conf->array_sectors / 2;
> 159              sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info=
 *));
>=20
> if the array size is less then 1024K and the system is 32 based,
> min_spacing will be ZERO.

nope, array_sectors in in 512 byte units. So the array size has to
be smaller than 1024 _bytes_ for min_spacing to become zero.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--x+RZeZVNR8VILNfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJDwdkWto1QDEAkw8RAiQMAJ4ha2r9QjNd39pADYxzaH/Ye7msvwCgorA7
t98xfjkhPHpJsQ8QynQvE0M=
=JBcI
-----END PGP SIGNATURE-----

--x+RZeZVNR8VILNfK--
