From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Building RAID5 w/o a Hot Spare
Date: Wed, 27 Jan 2010 16:34:50 +0100
Message-ID: <1264606490.1928.5.camel@test.apertos.eu>
References: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com>
	 <1264603005.1928.3.camel@test.apertos.eu>
	 <d80f793f1001270641k29430f12r59b9f9fa02966ea0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2y32oxjPP9pZ4Mzj7WiQ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1001270641k29430f12r59b9f9fa02966ea0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Williams <carloswill@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-2y32oxjPP9pZ4Mzj7WiQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-27, =C5=9Bro o godzinie 09:41 -0500, Carlos Williams pisze:
> 2010/1/27 Micha=C5=82 Sawicz <michal@sawicz.net>:
> > I'm not sure I understand what you want to achieve. A 'spare' disk
> is
> > one that isn't used until any of the other fail, then the spare
> replaces
> > the failed one. The term 'hot spare' is used to identify a disk that
> is
> > a mirror of one of the other drives, but there's no support for that
> in
> > Linux Software-RAID.
>=20
> I am sorry because I think I was using the wrong terminology then. I
> want to use all 4 disks to be an active member or the RAID5 /dev/md0.
> I wanted to make sure the command I posted in my original post was not
> going to use 3 partitions for active members of RAID5 on /dev/md0 and
> use the 4th drive as a 'spare device' in case one of the three drives
> fail. I don't want that. I just want 4 active / working devices for
> /dev/md0.
>=20
> >> mdadm --create /dev/md0 --level=3D5
> --raid-devices=3D4 /dev/sda2 /dev/sdb2
> >> /dev/sdc2 /dev/sdd2
> >
> > This will create a RAID5 array of 4 devices, yes. Capacity will be 3
> x
> > sd?2. Failure of any one of those disks will not harm the data.
>=20
> OK. I think that answers my questions. Thanks for your help!

Great.

Please keep the mailing list in the loop.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-2y32oxjPP9pZ4Mzj7WiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktgXRoACgkQzQlUjpZYlbcRSQCgh0xnDorOIxtKUZw6+a9xWkq/
85cAoKYuaYRufPYoPj3uoU0BmWD8Njx3
=o7Ks
-----END PGP SIGNATURE-----

--=-2y32oxjPP9pZ4Mzj7WiQ--

