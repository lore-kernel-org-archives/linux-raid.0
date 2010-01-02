From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: RAID5 broke during reshape...
Date: Sat, 02 Jan 2010 17:55:47 +0100
Message-ID: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aZYb+wcYwEKTuRx6aJy2"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-aZYb+wcYwEKTuRx6aJy2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

I have quite a big problem, I had a clean 4 disk RAID5 array, wanted to
reshape it to 5 disks, building a degraded array (I know, I shouldn't
have done that). One of the disks (sdh) failed and the array is
currently broken:

> md5 : active raid5 sdh1[1](S) sdf1[4](S) sdc1[3] sdg1[2]
>       2930279424 blocks super 1.1 level 5, 256k chunk, algorithm 2 [4/2] =
[U_U_]

sdh1 was initially marked F, it changed to S when I removed it and
readded it to the array. The filesystem shut down instantly so no write
operations were performed.

What I can't understand is why sdf1 also got marked as a spare.

Is there any way I can recover the data? SMART only reports 3 unreadable
sectors, so most of the data should be recoverable... I will provide any
additional information needed to get as much of the data back.

--=20
Regards
Micha=C5=82 (Saviq) Sawicz

--=-aZYb+wcYwEKTuRx6aJy2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAks/epMACgkQzQlUjpZYlbf+lACfbMhU9TKr8eNhMRhKxMv10e17
g9oAnR7RbEz2R2b3QFJL2efZgvD0oVw9
=iVYT
-----END PGP SIGNATURE-----

--=-aZYb+wcYwEKTuRx6aJy2--

