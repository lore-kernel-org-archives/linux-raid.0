From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Problem with mdadm 3.2.5
Date: Thu, 28 Mar 2013 10:25:33 +0000
Message-ID: <20130328102533.GA20110@cthulhu.home.robinhill.me.uk>
References: <11024273.158671364452562535.JavaMail.weblogic@epml26>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11024273.158671364452562535.JavaMail.weblogic@epml26>
Sender: linux-raid-owner@vger.kernel.org
To: Tarak Anumolu <tarak.anumolu@samsung.com>
Cc: Sam Bingner <sam@bingner.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, hpj@urpla.net
List-Id: linux-raid.ids


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 28, 2013 at 06:36:03AM +0000, Tarak Anumolu wrote:

>=20
> Hi
>=20
> FYI, We followed the below steps and At the end you can see the
> problem with the file system.
>=20
> RAID operation on 8 harddisks each of size 1TB with 7 harddisks as raid d=
evices and 1 hard disk as spare device got succeed.
>=20
> #parted -s /dev/md0 print
> Model: Linux Software RAID Array (md)
> Disk /dev/md0: 6001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> Number  Start   End     Size    File system  Name     Flags
>  1      1049kB  60.0GB  60.0GB  xfs          primary
>  2      60.0GB  6001GB  5941GB  xfs          primary
>=20
>=20
> Then We create 2 partitions md0p1 and md0p2.
>=20
> #cat /proc/partitions
> major minor  #blocks  name
>   31        0       8192 mtdblock0
>   31        1     131072 mtdblock1
>    8        0  976762584 sda
>    8        1  976760832 sda1
>    8       16  976762584 sdb
>    8       17  976760832 sdb1
>    8       32  976762584 sdc
>    8       33  976760832 sdc1
>    8       48  976762584 sdd
>    8       49  976760832 sdd1
>    8       64  976762584 sde
>    8       65  976760832 sde1
>    8       80  976762584 sdf
>    8       81  976760832 sdf1
>    8       96  976762584 sdg
>    8       97  976760832 sdg1
>    8      112  976762584 sdh
>    8      113  976760832 sdh1
>    9        0 5860563456 md0
>  259        0   58604544 md0p1
>  259        1 5801957376 md0p2
>=20
> *************************************************************************=
**************************
>                                                                          =
IT'S FINE UPTO HERE
> *************************************************************************=
**************************
>=20
> Now we failed harddisk-1
>=20
> # mdadm -f /dev/md0 /dev/sda1
>=20
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Wed Mar 27 11:10:24 2013
>      Raid Level : raid5
>      Array Size : 5860563456 (5589.07 GiB 6001.22 GB)
>   Used Dev Size : 976760576 (931.51 GiB 1000.20 GB)
>    Raid Devices : 7
>   Total Devices : 7
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>   Intent Bitmap : Internal
>     Update Time : Thu Mar 28 01:03:57 2013
>           State : active, degraded, recovering
>  Active Devices : 6
> Working Devices : 7
>  Failed Devices : 0
>   Spare Devices : 1
>          Layout : left-symmetric
>      Chunk Size : 256K
>  Rebuild Status : 0% complete
>            UUID : debadbe0:49b4fe90:24472787:29621eca (local to host mpc8=
536ds)
>          Events : 0.15
>     Number   Major   Minor   RaidDevice State
>        7       8      113        0      spare rebuilding   /dev/sdh1
>        1       8       17        1      active sync   /dev/sdb1
>        2       8       33        2      active sync   /dev/sdc1
>        3       8       49        3      active sync   /dev/sdd1
>        4       8       65        4      active sync   /dev/sde1
>        5       8       81        5      active sync   /dev/sdf1
>        6       8       97        6      active sync   /dev/sdg1
>=20
> Now harddisk-1 is revovering
>=20
> #cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
>       5860563456 blocks level 5, 256k chunk, algorithm 2 [7/6] [_UUUUUU]
>       [>....................]  recovery =3D  0.1% (1604164/976760576) fin=
ish=3D324.2min speed=3D50130K/sec
>       bitmap: 0/8 pages [0KB], 65536KB chunk
>=20
>=20
> #parted -s /dev/md0 print
> Model: Linux Software RAID Array (md)
> Disk /dev/md0: 6001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> Number  Start   End     Size    File system  Name     Flags
>  1      1049kB  60.0GB  60.0GB  xfs          primary
>  2      60.0GB  6001GB  5941GB  xfs          primary
>=20
>=20
> While recovering the harddisk, to test the power failure/ restarting situ=
ation, we unmount the partitions.
>=20
> #umount /dev/md0p[12]
>=20
>=20
> Again try to mount the partitions but failed.
>=20
>=20
> #mount /dev/md0p1 /mnt/md0p1
> UDF-fs: No partition found (1)
> Filesystem "md0p1": Disabling barriers, trial barrier write failed
>=20
> # mount /dev/md0p2 /mnt/md0p2
> grow_buffers: requested out-of-range block 18446744072428564479 for devic=
e md0p2
> grow_buffers: requested out-of-range block 18446744072428564223 for devic=
e md0p2
> grow_buffers: requested out-of-range block 18446744072428564478 for devic=
e md0p2
> grow_buffers: requested out-of-range block 18446744072428564222 for devic=
e md0p2
> grow_buffers: requested out-of-range block 18446744072428564480 for devic=
e md0p2
> grow_buffers: requested out-of-range block 18446744072428564224 for devic=
e md0p2
> grow_buffers: requested out-of-range block 18446744072428564477 for devic=
e md0p2
>=20
>=20
> #parted -s /dev/md0 print
> Model: Linux Software RAID Array (md)
> Disk /dev/md0: 6001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>=20
> Number  Start   End     Size    File system  Name     Flags
>  1      1049kB  60.0GB  60.0GB  xfs          primary
>  2      60.0GB  6001GB  5941GB               primary
>=20
> Filesystem is not shown.
>=20
>=20
> Harddisk Recovery is completed
>=20
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdh1[0] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
>       5860563456 blocks level 5, 256k chunk, algorithm 2 [7/7] [UUUUUUU]
>       bitmap: 1/8 pages [4KB], 65536KB chunk
>=20
> #parted -s /dev/md0 print
> Model: Linux Software RAID Array (md)
> Disk /dev/md0: 6001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>=20
> Number  Start   End     Size    File system  Name     Flags
>  1      1049kB  60.0GB  60.0GB  xfs          primary
>  2      60.0GB  6001GB  5941GB               primary
>=20
> Filesystem is empty.........
>=20
>=20
> Please tell me if I did any thing wrong.
>=20
That all looks perfectly valid to me. You're obviously getting some sort
of data corruption during the rebuild (the fact you're using a
partitioned RAID array is irrelevant - it's just highlighting the
issue). You are using the old 0.9 metadata, but you're not hitting any
of the limitations of that  here. I doubt mdadm itself has much to do
with this though, as it's just passing high-level instructions on to the
kernel, which will perform the low-level recovery process.  What kernel
version are you using?

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFUGp0ACgkQShxCyD40xBKW7wCgs/PzaY/6EiUMAVsJ9Oa/FV8M
8dQAn2TB/6v11PZpE28B2gtjxOaKnyS3
=3mBA
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
