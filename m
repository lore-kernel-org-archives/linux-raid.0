From: Andre Noll <maan@systemlinux.org>
Subject: Re: linear : divide error: 0000
Date: Mon, 3 Nov 2008 17:43:10 +0100
Message-ID: <20081103164310.GL17966@skl-net.de>
References: <1346d4690811020803p47f62b3ak9868832969040759@mail.gmail.com> <20081103103221.GJ17966@skl-net.de> <1346d4690811030437t259c4f60rac29acd746c2acff@mail.gmail.com> <20081103141501.GK17966@skl-net.de> <1346d4690811030653s566d17a7mc6c31fadb0f533d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/GiYV45wF7IL3Iq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1346d4690811030653s566d17a7mc6c31fadb0f533d1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Yongquan <weiyqlq@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--9/GiYV45wF7IL3Iq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22:53, Wei Yongquan wrote:
> >> the code linear.c :
> >>
> >> 158              min_spacing =3D conf->array_sectors / 2;
> >> 159              sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_i=
nfo *));
> >>
> >> if the array size is less then 1024K and the system is 32 based,
> >> min_spacing will be ZERO.
> >
> > nope, array_sectors in in 512 byte units. So the array size has to

s/in in/ is in

> > be smaller than 1024 _bytes_ for min_spacing to become zero.
> Thanks.
> er,  "array_sectors in in 512 byte units" means  when array_sectors =3D
> 2048, the array size is actually 2048 * 512 =3D 1024K. Is that right?

Exactly.

> when min_spacing < 1024 at line 158, it becomes zero at line 159. is that=
 right?

Yes, that's true, provided that PAGE_SIZE is 4096 and sizeof(struct
dev_info *) is 4.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--9/GiYV45wF7IL3Iq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJDyoeWto1QDEAkw8RAlDpAJ4lze5NjUorxGk81NlWCJgIvUt43gCgqCZb
K9g5VryMRZ0osGtIaq4e9UM=
=JO5g
-----END PGP SIGNATURE-----

--9/GiYV45wF7IL3Iq--
