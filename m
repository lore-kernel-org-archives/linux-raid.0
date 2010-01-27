From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Building RAID5 w/o a Hot Spare
Date: Wed, 27 Jan 2010 15:46:17 +0100
Message-ID: <1264603577.1928.4.camel@test.apertos.eu>
References: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B45X+rgv5W6pqu5l4q7v"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-B45X+rgv5W6pqu5l4q7v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-27, =C5=9Bro o godzinie 09:26 -0500, Carlos Williams pisze:
> I am building a Linux system which has 4 identical 'fd' partitions on
> each of the 4 drives. I don't want to use the 4th partition or disk if
> you would like to call it as a 'hot spare'. I would like to span the
> entire array over the 4 drives. My question is does my command look
> correct for doing so?

I'm not sure I understand what you want to achieve. A 'spare' disk is
one that isn't used until any of the other fail, then the spare replaces
the failed one. The term 'hot spare' is used to identify a disk that is
a mirror of one of the other drives, but there's no support for that in
Linux Software-RAID.

> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 /dev/sda2 /dev/sdb=
2
> /dev/sdc2 /dev/sdd2=20

This will create a RAID5 array of 4 devices, yes. Capacity will be 3 x
sd?2. Failure of any one of those disks will not harm the data.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz


--=-B45X+rgv5W6pqu5l4q7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktgUbkACgkQzQlUjpZYlbclIQCgyuVdMXZVtVd9jx0Y2J/K1R7m
iAYAn0dOUr5QHOB5BbYIGPOBOSg2ZvMV
=zx+T
-----END PGP SIGNATURE-----

--=-B45X+rgv5W6pqu5l4q7v--

