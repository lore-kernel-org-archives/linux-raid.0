From: NeilBrown <neilb@suse.de>
Subject: Re: Wrong count of devices in /proc/mdstat after "want_replacement"
Date: Tue, 18 Sep 2012 15:18:26 +1000
Message-ID: <20120918151826.08af9e27@notabene.brown>
References: <20120918110436.0215e5ec@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/98==_DmRnpN+Su8_BGbEyEL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120918110436.0215e5ec@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/98==_DmRnpN+Su8_BGbEyEL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Sep 2012 11:04:36 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> Hello,
>=20
> Summary:
>=20
> After removing a disk via "want_replacement", disk count in /proc/mdstat =
is
> wrong ("[5/4]", not "[5/5]" as it should be).
>=20
> More details below:
>=20
> ----
>=20
> # mdadm --add /dev/md0 /dev/sdb1=20
> mdadm: added /dev/sdb1
>=20
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Wed May 25 00:07:38 2011
>      Raid Level : raid5
>      Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
>   Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
>    Raid Devices : 5
>   Total Devices : 6
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Tue Sep 18 01:01:38 2012
>           State : active=20
>  Active Devices : 5
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            Name : avdeb:0  (local to host avdeb)
>            UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
>          Events : 14135
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       65        0      active sync   /dev/sde1
>        6       8       33        1      active sync   /dev/sdc1
>        3       8       81        2      active sync   /dev/sdf1
>        4       8       49        3      active sync   /dev/sdd1
>        5       8       97        4      active sync   /dev/sdg1
>=20
>        7       8       17        -      spare   /dev/sdb1
>=20
> # echo want_replacement > /sys/block/md0/md/dev-sde1/state=20
>=20
> // It's rebuilding:
>=20
> # cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 sdb1[7](R) sde1[0] sdg1[5] sdd1[4] sdf1[3] sdc1[6]
>       3907003136 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] [=
UUUUU]
>       [>....................]  recovery =3D  0.1% (1724936/976750784) fin=
ish=3D150.7min speed=3D107808K/sec
>       bitmap: 0/4 pages [0KB], 131072KB chunk
>=20
> // Rebuild finished:
>=20
> # cat /proc/mdstat=20
> md0 : active raid5 sdb1[7] sde1[0](F) sdg1[5] sdd1[4] sdf1[3] sdc1[6]
>       3907003136 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/4] [=
UUUUU]
>       bitmap: 0/4 pages [0KB], 131072KB chunk
>=20
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Wed May 25 00:07:38 2011
>      Raid Level : raid5
>      Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
>   Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
>    Raid Devices : 5
>   Total Devices : 6
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Tue Sep 18 04:46:14 2012
>           State : active=20
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 1
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            Name : avdeb:0  (local to host avdeb)
>            UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
>          Events : 14231
>=20
>     Number   Major   Minor   RaidDevice State
>        7       8       17        0      active sync   /dev/sdb1
>        6       8       33        1      active sync   /dev/sdc1
>        3       8       81        2      active sync   /dev/sdf1
>        4       8       49        3      active sync   /dev/sdd1
>        5       8       97        4      active sync   /dev/sdg1
>=20
>        0       8       65        -      faulty spare   /dev/sde1
>=20
> // Removing sde1:
>=20
> # mdadm --remove /dev/md0 /dev/sde1=20
> mdadm: hot removed /dev/sde1 from /dev/md0
>=20
> // Removed ok:
>=20
> # mdadm --detail /dev/md0=20
> /dev/md0:
>         Version : 1.2
>   Creation Time : Wed May 25 00:07:38 2011
>      Raid Level : raid5
>      Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
>   Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Tue Sep 18 08:49:24 2012
>           State : active=20
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            Name : avdeb:0  (local to host avdeb)
>            UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
>          Events : 14234
>=20
>     Number   Major   Minor   RaidDevice State
>        7       8       17        0      active sync   /dev/sdb1
>        6       8       33        1      active sync   /dev/sdc1
>        3       8       81        2      active sync   /dev/sdf1
>        4       8       49        3      active sync   /dev/sdd1
>        5       8       97        4      active sync   /dev/sdg1
>=20
> // In the end /proc/mdstat shows "[5/4]", not "[5/5]":
>=20
> # cat /proc/mdstat=20
> md0 : active raid5 sdb1[7] sdg1[5] sdd1[4] sdf1[3] sdc1[6]
>       3907003136 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/4] [=
UUUUU]
>       bitmap: 0/4 pages [0KB], 131072KB chunk
>=20


Thanks for the report.
I think that's fixed by:

http://git.neil.brown.name/?p=3Dlinux.git;a=3Dcommitdiff;h=3D413c4a33cb3cd1=
a14431c61fd20904cdb1867d17

which I will hopefully be sending to Linus some time soon.

NeilBrown

--Sig_/98==_DmRnpN+Su8_BGbEyEL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFgEIjnsnt1WYoG5AQL5chAAxAxLhUM4CxD4ZNCmR2RS1QJkuF1oMhU9
d15i/rTtRyfBRM0TRu28/GsVzP21p2J04QzVZUrw1kNADaHNe4IRsEBpNulSUksc
iJs3UuI5mANAoNginzplUA423DPP/MRn+jXlzMO0GEbtea/XaxvWRZ0VA7QOikxu
B73yi40ZyFIY55KScyt+gQmqHBiiVrZa/cQWvJ90ionAPIbv6I7SRf4pTwTblj2u
ehr7C1x+Y1mz0TTSGQq5dEcIExlWCJDkdY5WVFG6j/IRwzvuK0HCWwum3DgiciIF
QU8ZOa82k1dJoy3Jh4IxHGYXsnXcqNJPh2y1ycj5vzpYykKxG+Kuu0jL1cqUvKlJ
NIvbEf1CH7Gmvmq5nnMkKyPpBYXjV1GIIn53k584MRE9gQONQgaaDrrF6FP05uEe
BX70K1me/wwrvWPqBwzxjqZA5mnafjavDOOnUYdnGKUI6LutaEP6SVv1BRopZb/+
/E2GZtSNMEUh5pBzhCijcG9mGhQjhWpIhxM4WWi7pBkx4JROokUykDDq9pHPj5ew
xQ3GJF/xDK7+QjoWAIuB3HFkodIiL8zYGOOh1Cvr+WFyHOpTK60viWMNL8NQnNcO
MnnRZ2r7R49I7pTqxTvER9ZDeGCtaB6WJmQ5XRZHrfo7cPGLhom2flyobvnhuIH4
o8pC0jDCy6w=
=cme+
-----END PGP SIGNATURE-----

--Sig_/98==_DmRnpN+Su8_BGbEyEL--
