From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 faild while in degraded mode, need help
Date: Mon, 9 Jul 2012 10:12:08 +1000
Message-ID: <20120709101208.49528808@notabene.brown>
References: <CACMY3vC=iAbKCssHH8CQ=msqNtmE1zF1muoZTusfRd989HvD_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qrSTN29ra7i_smGCA1XKfIL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACMY3vC=iAbKCssHH8CQ=msqNtmE1zF1muoZTusfRd989HvD_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dietrich Heise <dh@dhde.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qrSTN29ra7i_smGCA1XKfIL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Jul 2012 21:05:02 +0200 Dietrich Heise <dh@dhde.de> wrote:

> Hi,
>=20
> the following Problem,
> One of four drives has S.M.A.R.T. errors, so I removed it and
> replaced, with a new one.
>=20
> In the time the drive was rebuilding, one of the three left devices
> has an I/O error (sdd1) (sdc1 was the replaced drive an was syncing).
>=20
> Now the following happends (two drives are spare drives :( )

It looks like you tried to --add /dev/sdd1 back in after it failed, and mda=
dm
let new.  Newer versions of mdadm will refuse as that is not a good thing to
do but it shouldn't stop you getting your data back.

First thing to realise is that you could have data corruption.  There is at
least one block in the array which cannot be recovered, possibly more.  i.e.
any block on sdd1 which is bad, and any block at the same offset in sdc1.
These blocks may not be in files which would be lucky, or they may contain
important metadata which might mean you've lost lots of files.

If you hadn't tried to --add /dev/sdd1 you could just force-assemble the
array back to degraded mode (without sdc1) and back up any critical data.
As sdd1 now thinks it is a spare you need to re-create the array instead:

 mdadm -S /dev/md1
 mdadm -C /dev/md1 -l5 -n4 -e 1.2 -c 512 /dev/sdf1 /dev/sde1 /dev/sdd1 miss=
ing
or
 mdadm -C /dev/md1 -l5 -n4 -e 1.2 -c 512 /dev/sdf1 /dev/sde1 missing /dev/s=
dd1

depending on whether sdd1 as the 3rd or 4th device in the array - I cannot
tell from the output here.

You should then be able to mount the array and backup stuff.

You then want to use 'ddrescue' to copy sdd1 onto a device with no bad
blocks, and assemble  the array using the device instead of sdd1.

Finally, you can add the new spare (sdc1) to the array and it should rebuild
successfully - providing there are no bad blocks on sdf1 or sde1.

I hope that makes sense.  Do ask if anything is unclear.

NeilBrown


>=20
> p3 disks # mdadm -D /dev/md1
> /dev/md1:
>         Version : 1.2
>   Creation Time : Mon Feb 28 19:57:56 2011
>      Raid Level : raid5
>   Used Dev Size : 1465126400 (1397.25 GiB 1500.29 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sun Jul  8 20:37:12 2012
>           State : active, FAILED, Not Started
>  Active Devices : 2
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 2
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : p3:0  (local to host p3)
>            UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
>          Events : 121205
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       81        0      active sync   /dev/sdf1
>        1       8       65        1      active sync   /dev/sde1
>        2       0        0        2      removed
>        3       0        0        3      removed
>=20
>        4       8       49        -      spare   /dev/sdd1
>        5       8       33        -      spare   /dev/sdc1
>=20
> here is more information:
>=20
> p3 disks # mdadm -E /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
>            Name : p3:0  (local to host p3)
>   Creation Time : Mon Feb 28 19:57:56 2011
>      Raid Level : raid5
>    Raid Devices : 4
>=20
>  Avail Dev Size : 2930275057 (1397.26 GiB 1500.30 GB)
>      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
>   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : caefb029:526187ef:2051f578:db2b82b7
>=20
>     Update Time : Sun Jul  8 20:37:12 2012
>        Checksum : 18e2bfe1 - correct
>          Events : 121205
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : spare
>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)
> p3 disks # mdadm -E /dev/sdd1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
>            Name : p3:0  (local to host p3)
>   Creation Time : Mon Feb 28 19:57:56 2011
>      Raid Level : raid5
>    Raid Devices : 4
>=20
>  Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
>      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
>   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 4231e244:60e27ed4:eff405d0:2e615493
>=20
>     Update Time : Sun Jul  8 20:37:12 2012
>        Checksum : 4bec6e25 - correct
>          Events : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : spare
>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)
> p3 disks # mdadm -E /dev/sde1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
>            Name : p3:0  (local to host p3)
>   Creation Time : Mon Feb 28 19:57:56 2011
>      Raid Level : raid5
>    Raid Devices : 4
>=20
>  Avail Dev Size : 2930253889 (1397.25 GiB 1500.29 GB)
>      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
>   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 28b08f44:4cc24663:84d39337:94c35d67
>=20
>     Update Time : Sun Jul  8 20:37:12 2012
>        Checksum : 15faa8a1 - correct
>          Events : 121205
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 1
>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)
> p3 disks # mdadm -E /dev/sdf1
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
>            Name : p3:0  (local to host p3)
>   Creation Time : Mon Feb 28 19:57:56 2011
>      Raid Level : raid5
>    Raid Devices : 4
>=20
>  Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
>      Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
>   Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 78d5600a:91927758:f78a1cea:3bfa3f5b
>=20
>     Update Time : Sun Jul  8 20:37:12 2012
>        Checksum : 7767cb10 - correct
>          Events : 121205
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 0
>    Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> Is there a way to repair the raid?
>=20
> thanks!
> Dietrich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/qrSTN29ra7i_smGCA1XKfIL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/oh2Dnsnt1WYoG5AQJDAQ/+OH2MWgZMmQNZTpigEezNiQfZ6+0UmeJ8
7yXhTaHYBHWQD+sa0whFrbNE2gXnsl/4cxYfKWzRDKGz8OqNsxwCUCaOTFO+GkNC
Kvnr6XG4ahJ/TDS424R9qgHKGJVHasfnhUnDwUC4iJIjk8A6/ccF6XX/nLDSC58U
UodxiphaUIWo06P8UeBi223kDeyCZxG5XjoztwcccxrGvAOlaaicYIc5/5A/NVwY
zBQ5KvsBx1/iF/Pybb8FssP1/KZx3WNsqZQc9jOrheCF+6H4qINxKSZfYp4mrHsR
UmypmlamWqyxW7kQJM8lhi3GlWn4FVcgUG28QtwIc8xZIXGA/fHCDkaJ5leX3oq0
NFYfNoig++aOnwhrJZbix/1PoTWXhoPRxodKzNVmOZPAWo8rDBZKeYUCt/c7pMRt
Pe2mdSzUSNU8PgvLey0SKLLUau525fr9s1YmYDbZ7prqC4Lc2LDNRkF0v2AwQtel
6jppnMGfR29IHId8qmEhz43rhLKWGeheeRrvTcSdzvOzf4R9SZbTA4ygk5LswWEm
l9GioMeN5PMZXqzmmZFW5JgC28kCcFGrQq9mUjuXU9bZperTXgXpxmh4MQG8tC/Z
H3Q5tqClFs6doLReW2Ikzc+Z8SyyGLymmZvV8Nt8kmFtBbciMXQYpQ60srGl8STd
Wi8yyclIxTo=
=PSLi
-----END PGP SIGNATURE-----

--Sig_/qrSTN29ra7i_smGCA1XKfIL--
