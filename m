From: NeilBrown <neilb@suse.de>
Subject: Re: Check after raid6 failure
Date: Thu, 14 Jun 2012 22:52:39 +1000
Message-ID: <20120614225239.0dee7594@notabene.brown>
References: <20120614112955.286290@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tFGyFRWVgA+dA_xxqLQIhw6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120614112955.286290@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Kurt Schmitt <kurt_schmitt@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tFGyFRWVgA+dA_xxqLQIhw6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Jun 2012 13:29:55 +0200 "Kurt Schmitt" <kurt_schmitt@gmx.de> wro=
te:

> Hello,
>=20
> I am running a raid6 with 8 drives (no spares) and I am recovering after =
a controller failure that removed 3 of the drives (ATA Bus error). The stat=
e of the raid after this is obvious:
>=20
> md7 : active raid6 sdg1[2] sdf1[8] sdd1[1] sdn1[7] sde1[0]
>       11721071616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/5]=
 [UUU___UU]
>=20
> After exchanging the controller, I verified that the raid superblocks of =
the devices are still intact, but the superblock state was inconsistent. Th=
e removed drives were marked "active" and had a lower event count, whereas =
the other drives were "clean" with higher event count. I reassembled the ar=
ray with this command:
> mdadm --assemble --force /dev/md7 /dev/sd[befghijk]1
>=20
> This  removed the faulty flags and reset the event counts. I switched the=
 raid to --readonly immediately, and ran a filesystem check (which found a =
few non-critical errors, such as unused inodes, block bitmap differences an=
d wrong free block counts). The detail/examine of the current state is belo=
w [2].
>=20
> I have the following questions:
> 1. From the perspective of raid data integrity (parity), is it safe to co=
ntinue operating the raid now and fix the file system errors and verify the=
 actual data in the files?

Yes

> In particular, I have read at [1] that when skipping the initial sync, pa=
rity data on the disks will stay wrong even after it is rewritten. Does the=
 same apply when doing assemble --force ?

That applies to RAID5, but not RAID6 (in the current implementation)

>=20
> 2. I have been trying to run a "check" sync_action on the raid (in read-o=
nly mode), to find out if there are mismatches, but it does not start. The =
sync_action is "idle" immediately after the "echo checked > sync_action" an=
d /proc/mdstat does not report any change. There is nothing in dmesg either.

'check' will not work in read-only mode.  This is arguably a shortcoming.

>=20
> 3. What other steps can / should I take before continuing raid usage (rea=
d-write), especially repair on the file system level?

The file system and RAID can be repaired independently - just go ahead, all
looks good. (unless that 3.2.2 kernel is from Ubuntu - in that case you mig=
ht
need to be careful... What is the full "uname -a"?).

NeilBrown

>=20
>=20
> Thank you,
>=20
> Kurt
>=20
> [1] https://raid.wiki.kernel.org/index.php/Initial_Array_Creation#raid5
>=20
> [2] I am running a 3.2.2 kernel with mdadm 3.1.4.
>=20
> The current state of the raid is displayed below:
> md7 : active (read-only) raid6 sdf1[0] sdj1[7] sdg1[8] sdk1[6] sdb1[5] sd=
i1[4] sdh1[2] sde1[1]
>       11721071616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/8]=
 [UUUUUUUU]
>=20
> mdadm --detail /dev/md7=20
> /dev/md7:
>         Version : 1.2
>   Creation Time : <redacted>
>      Raid Level : raid6
>      Array Size : 11721071616 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 8
>   Total Devices : 8
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon Jun 11 19:18:33 2012
>           State : clean
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : <redacted>
>            UUID : <redacted>
>          Events : 79713
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       81        0      active sync   /dev/sdf1
>        1       8       65        1      active sync   /dev/sde1
>        2       8      113        2      active sync   /dev/sdh1
>        4       8      129        3      active sync   /dev/sdi1
>        5       8       17        4      active sync   /dev/sdb1
>        6       8      161        5      active sync   /dev/sdk1
>        8       8       97        6      active sync   /dev/sdg1
>        7       8      145        7      active sync   /dev/sdj1
>=20
>=20
>=20
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 10:13:08 2012
>        Checksum : d207eb78 - correct
>          Events : 79712
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 4
>    Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 19:18:33 2012
>        Checksum : cea4ea72 - correct
>          Events : 79713
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 1
>    Array State : AAA...AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 19:18:33 2012
>        Checksum : 73e3de3b - correct
>          Events : 79713
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 0
>    Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 19:18:33 2012
>        Checksum : b7ef499c - correct
>          Events : 79713
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 6
>    Array State : AAA...AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdh1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 19:18:33 2012
>        Checksum : c75d3da5 - correct
>          Events : 79713
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 2
>    Array State : AAA...AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdi1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 10:13:08 2012
>        Checksum : 1a292902 - correct
>          Events : 79712
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 3
>    Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 19:18:33 2012
>        Checksum : 6f7b11b7 - correct
>          Events : 79713
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 7
>    Array State : AAA...AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> /dev/sdk1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <redacted>
>            Name : <redacted>
>   Creation Time : <redacted>
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
>   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : <redacted>
>=20
>     Update Time : Mon Jun 11 10:13:08 2012
>        Checksum : a2773548 - correct
>          Events : 79712
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 5
>    Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20


--Sig_/tFGyFRWVgA+dA_xxqLQIhw6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9nelznsnt1WYoG5AQL02w/+PGB1Wvgs2RsRjQYKoopj5/wIQ1wN/3vg
g0EcZgUgPLbRakWMVC6Cr9lncsasgRNfE0cSLuiUOmo3Blt2OI5KRkJTJrNzUSp0
q7PmmbURIeC0VhpVnZLWxK+zoct1eihUzSzWeFLAOuoP0p+Bb7qc8QKmsumT5hKD
U5/g0HxKqtIaAARWUd/g1jpWcmKchNOZR3fXWYFYsD/fxWWwjLqBOFVGq4Q5pPrW
vdH2PwKBp6VYyvAvJ7Jn4jy7zbVvxaPPnt+JEWY01VNiAcQWak1d4pTMsfKnrtwy
ON0XPquXLhT9v1xAacyt5l84wGhX+gliuNtkoamFnKNMPTaNfBibA3ZwQxdQS5Nh
LFHUj/U05MExexRulMkfxpEiMz+aDJMvrjsPwRd/TxYZ82LcvBl/M4asch/iw95m
lRT+gBVaPn5NvgbmaioFcK15eAGdxAhYrxSWwQSbXboE1b8Cq1womkG6hRcZHHA2
zvj27Gx/jmKXwJsRYHJAPwfCYKJNsOEXpfH8rz2P1AmTi3Qfk3v3IktSVb+JphZN
c7XJlgB5BZBDeF+Z30E9AZsYIN9P0L6xpVIjOAIRM9gkG4nBODhhc2H1mQAPY1Y8
kxbEqTAhUubX9XT50XDjG+is/f+Mn+9wDYi8XaGW7xarRZ6bn/EQVwICa5/7rGKb
Ox7bGRjxMg8=
=K3MT
-----END PGP SIGNATURE-----

--Sig_/tFGyFRWVgA+dA_xxqLQIhw6--
