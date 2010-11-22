From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Superblocks out-of-sync on a RAID5 array
Date: Tue, 23 Nov 2010 00:09:29 +0100
Message-ID: <1290467369.28581.14.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fpfzryuRZXcMYIxUDDHt"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-fpfzryuRZXcMYIxUDDHt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
I have recovered (forced assembly) my array after some power issues and
it works quite fine (parity and fsck are fine), except for the fact
superblocks seem to be out of sync...

/proc/mdstat says:

> md2 : active raid5 sdf1[9](S) sdj1[0] sdb1[8] sdd1[5] sda1[7] sde1[3] sdc=
1[2] sdh1[4]
>       5860558848 blocks super 1.1 level 5, 256k chunk, algorithm 2 [7/7] =
[UUUUUUU]

And that's correct - 7 active devices and one spare. Superblocks for
sdb1 and sdf1 (spare) look fine, too, totaling at 6TB, except they're
both marked as spares... event count and checksums are also off...:

> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x0
>      Array UUID : 9ce41f94:7489a7f2:6897e4b5:269c8b3b
>            Name : media:2  (local to host media)
>   Creation Time : Sun Jan 24 22:32:58 2010
>      Raid Level : raid5
>    Raid Devices : 7
>=20
>  Avail Dev Size : 1953519738 (931.51 GiB 1000.20 GB)
>      Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
>   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : ee806dee:ccd5281f:733506c5:6db54b07
>=20
>     Update Time : Mon Nov 22 23:53:38 2010
>        Checksum : a0e54380 - correct
>          Events : 4325711
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>    Device Role : spare
>    Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x0
>      Array UUID : 9ce41f94:7489a7f2:6897e4b5:269c8b3b
>            Name : media:2  (local to host media)
>   Creation Time : Sun Jan 24 22:32:58 2010
>      Raid Level : raid5
>    Raid Devices : 7
>=20
>  Avail Dev Size : 1953519738 (931.51 GiB 1000.20 GB)
>      Array Size : 11721117696 (5589.06 GiB 6001.21 GB)
>   Used Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : active
>     Device UUID : 97945e4f:9f439aec:951cb289:47862ad7
>=20
>     Update Time : Mon Nov 22 23:53:38 2010
>        Checksum : 63d27cf9 - correct
>          Events : 4325710
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>    Device Role : spare
>    Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

The rest are clearly wrong, must even be from an array that was there
earlier (like two years ago!) on these devices:

> /dev/sda1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : eadb0d2c:827ea119:462a36bb:f8f383a4 (local to host medi=
a)
>   Creation Time : Fri Nov 12 21:00:47 2010
>      Raid Level : raid5
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 4883799040 (4657.55 GiB 5001.01 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>=20
>     Update Time : Fri Nov 12 21:00:47 2010
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 299a20a8 - expected 299a2120
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>       Number   Major   Minor   RaidDevice State
> this     5       8      177        5      active sync
>=20
>    0     0       8      145        0      active sync   /dev/sdj1
>    1     1       8      113        1      active sync   /dev/sdh1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      active sync   /dev/sdf1
>    5     5       8       49        5      active sync   /dev/sdd1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : eadb0d2c:827ea119:462a36bb:f8f383a4 (local to host medi=
a)
>   Creation Time : Fri Nov 12 21:00:47 2010
>      Raid Level : raid5
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 4883799040 (4657.55 GiB 5001.01 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>=20
>     Update Time : Fri Nov 12 21:00:47 2010
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 299a208a - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>       Number   Major   Minor   RaidDevice State
> this     2       8       33        2      active sync   /dev/sdc1
>=20
>    0     0       8      145        0      active sync   /dev/sdj1
>    1     1       8      113        1      active sync   /dev/sdh1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      active sync   /dev/sdf1
>    5     5       8       49        5      active sync   /dev/sdd1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : eadb0d2c:827ea119:462a36bb:f8f383a4 (local to host medi=
a)
>   Creation Time : Fri Nov 12 21:00:47 2010
>      Raid Level : raid5
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 4883799040 (4657.55 GiB 5001.01 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>=20
>     Update Time : Fri Nov 12 21:00:47 2010
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 299a20a0 - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>       Number   Major   Minor   RaidDevice State
> this     5       8       49        5      active sync   /dev/sdd1
>=20
>    0     0       8      145        0      active sync   /dev/sdj1
>    1     1       8      113        1      active sync   /dev/sdh1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      active sync   /dev/sdf1
>    5     5       8       49        5      active sync   /dev/sdd1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : eadb0d2c:827ea119:462a36bb:f8f383a4 (local to host medi=
a)
>   Creation Time : Fri Nov 12 21:00:47 2010
>      Raid Level : raid5
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 4883799040 (4657.55 GiB 5001.01 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>=20
>     Update Time : Fri Nov 12 21:00:47 2010
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 299a20ac - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>       Number   Major   Minor   RaidDevice State
> this     3       8       65        3      active sync   /dev/sde1
>=20
>    0     0       8      145        0      active sync   /dev/sdj1
>    1     1       8      113        1      active sync   /dev/sdh1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      active sync   /dev/sdf1
>    5     5       8       49        5      active sync   /dev/sdd1
> /dev/sdh1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : eadb0d2c:827ea119:462a36bb:f8f383a4 (local to host medi=
a)
>   Creation Time : Fri Nov 12 21:00:47 2010
>      Raid Level : raid5
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 4883799040 (4657.55 GiB 5001.01 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>=20
>     Update Time : Fri Nov 12 21:00:47 2010
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 299a20d8 - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>       Number   Major   Minor   RaidDevice State
> this     1       8      113        1      active sync   /dev/sdh1
>=20
>    0     0       8      145        0      active sync   /dev/sdj1
>    1     1       8      113        1      active sync   /dev/sdh1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      active sync   /dev/sdf1
>    5     5       8       49        5      active sync   /dev/sdd1
> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : eadb0d2c:827ea119:462a36bb:f8f383a4 (local to host medi=
a)
>   Creation Time : Fri Nov 12 21:00:47 2010
>      Raid Level : raid5
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 4883799040 (4657.55 GiB 5001.01 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>=20
>     Update Time : Fri Nov 12 21:00:47 2010
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 299a20f6 - correct
>          Events : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 256K
>=20
>       Number   Major   Minor   RaidDevice State
> this     0       8      145        0      active sync   /dev/sdj1
>=20
>    0     0       8      145        0      active sync   /dev/sdj1
>    1     1       8      113        1      active sync   /dev/sdh1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8       65        3      active sync   /dev/sde1
>    4     4       8       81        4      active sync   /dev/sdf1
>    5     5       8       49        5      active sync   /dev/sdd1

Can anyone please tell me what's going on here? Should I worry? How can
I make the superblocks contain proper data again? Should I recreate the
array with --zero-superblock --assume-clean or is there some less
dangerous way?

Best regards
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>

--=-fpfzryuRZXcMYIxUDDHt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkzq+CkACgkQzQlUjpZYlbcNPACg0u8XNYsJn21YDrkhLZXb/ueK
TewAnjUciX+R0e8t3Cu9FTqKaPrh1wYf
=DrBl
-----END PGP SIGNATURE-----

--=-fpfzryuRZXcMYIxUDDHt--

