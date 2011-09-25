From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Mon, 26 Sep 2011 07:40:02 +1000
Message-ID: <20110926074002.6399de56@notabene.brown>
References: <4E7EDE58.3000804@yazzy.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vi1bt68b2SmWAe1dTO6xMFu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7EDE58.3000804@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Vi1bt68b2SmWAe1dTO6xMFu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Sep 2011 09:55:04 +0200 "Marcin M. Jessa" <lists@yazzy.org> wrot=
e:

> Hi guys.
>=20
>=20
> I have a RAID 6 setup with 5 2TB drives on Debian Wheezy [1] & [2].
> Yesterday 3 of the drives failed working leaving the RAID setup broken.
> Following [5] I managed to start the array and make it resync.

As has been noted, you seem to be quite lucky. [5] contains fairly bad advi=
ce
but it isn't obvious yet that you have lost everything.


> The problem I'm facing now is I cannot access any of the LVM partitions=20
> [3] I have on top of my md0. Fdisk says the disk doesn't contain a valid=
=20
> partition table [4].

You wouldn't expect an LV to contain a partition table.  You would expect it
to contain a filesystem.
What does
   fsck -f -n /dev/fridge/storage

show??

NeilBrown


> I tried to run fsck on the lvm devices without luck.
> Has any of you a suggestion, a method I could use to access my data pleas=
e?
>=20
>=20
>=20
> [1]:
> # mdadm -QD /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Sat Sep 24 23:59:02 2011
>       Raid Level : raid6
>       Array Size : 5860531200 (5589.04 GiB 6001.18 GB)
>    Used Dev Size : 1953510400 (1863.01 GiB 2000.39 GB)
>     Raid Devices : 5
>    Total Devices : 5
>      Persistence : Superblock is persistent
>=20
>      Update Time : Sun Sep 25 09:40:20 2011
>            State : clean, degraded, recovering
>   Active Devices : 3
> Working Devices : 5
>   Failed Devices : 0
>    Spare Devices : 2
>=20
>           Layout : left-symmetric
>       Chunk Size : 512K
>=20
>   Rebuild Status : 63% complete
>=20
>             Name : odin:0  (local to host odin)
>             UUID : be51de24:ebcc6eef:8fc41158:fc728448
>           Events : 10314
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8       65        0      active sync   /dev/sde1
>         1       8       81        1      active sync   /dev/sdf1
>         2       8       97        2      active sync   /dev/sdg1
>         5       8      129        3      spare rebuilding   /dev/sdi1
>         4       0        0        4      removed
>=20
>         6       8      113        -      spare   /dev/sdh1
>=20
>=20
> [2]:
> # cat /proc/mdstat
>=20
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md0 : active raid6 sdh1[6](S) sdi1[5] sdg1[2] sdf1[1] sde1[0]
>        5860531200 blocks super 1.2 level 6, 512k chunk, algorithm 2=20
> [5/3] [UUU__]
>        [=3D=3D=3D=3D=3D=3D=3D>.............]  recovery =3D 36.8% (7201853=
08/1953510400)=20
> finish=3D441.4min speed=3D46564K/sec
>=20
>=20
> [3]:
> # lvdisplay
>      Logging initialised at Sun Sep 25 09:49:11 2011
>      Set umask from 0022 to 0077
>      Finding all logical volumes
>    --- Logical volume ---
>    LV Name                /dev/fridge/storage
>    VG Name                fridge
>    LV UUID                kIhbSq-hePX-UIVv-uuiP-iK6w-djcz-iQ3cEI
>    LV Write Access        read/write
>    LV Status              available
>    # open                 0
>    LV Size                4.88 TiB
>    Current LE             1280000
>    Segments               1
>    Allocation             inherit
>    Read ahead sectors     auto
>    - currently set to     6144
>    Block device           253:0
>=20
>=20
> [4]:
>=20
> # fdisk  -l /dev/fridge/storage
>=20
> Disk /dev/fridge/storage: 5368.7 GB, 5368709120000 bytes
> 255 heads, 63 sectors/track, 652708 cylinders, total 10485760000 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 524288 bytes / 1572864 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/fridge/storage doesn't contain a valid partition table
>=20
>=20
>=20
> [5]:=20
> http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_superbl=
ock
>=20
>=20
>=20


--Sig_/Vi1bt68b2SmWAe1dTO6xMFu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOf5+yG5fc6gV+Wb0RAhVaAJ4+9Qex6a63NjULVVfGOcZiBTPqmACfTPfQ
5zIA09mp7fbimSDz4qq+0fo=
=3J2x
-----END PGP SIGNATURE-----

--Sig_/Vi1bt68b2SmWAe1dTO6xMFu--
