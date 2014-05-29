From: NeilBrown <neilb@suse.de>
Subject: Re: How to identify a failed md array
Date: Thu, 29 May 2014 15:18:51 +1000
Message-ID: <20140529151851.2508bdb6@notabene.brown>
References: <20140526200711.000030e2@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iXGuE5U=Z0FAXX+w5+8tFhP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140526200711.000030e2@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iXGuE5U=Z0FAXX+w5+8tFhP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 May 2014 20:07:11 +0200 Sebastian Herbszt <herbszt@gmx.de> wrote:

> Hello,
>=20
> I am wondering how to identify a failed md array.
> Lets assume the following array
>=20
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon May 26 19:10:59 2014
>      Raid Level : raid1
>      Array Size : 10176 (9.94 MiB 10.42 MB)
>   Used Dev Size : 10176 (9.94 MiB 10.42 MB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon May 26 19:10:59 2014
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : test:0  (local to host test)
>            UUID : cac8fd48:44219a96:5de7e757:4e21a3e2
>          Events : 17
>=20
>     Number   Major   Minor   RaidDevice State
>        0     254        0        0      active sync   /dev/dm-0
>        1     254        1        1      active sync   /dev/dm-1
>=20
> with
>=20
> /sys/block/md0/md/array_state:clean
> /sys/block/md0/md/dev-dm-0/state:in_sync
> /sys/block/md0/md/dev-dm-1/state:in_sync
>=20
> and
>=20
> disk0: 0 20480 linear 7:0 0
> disk1: 0 20480 linear 7:1 0
>=20
> If dm-0 gets changed to "disk0: 0 20480 error" and we read from the
> array (dd if=3D/dev/md0 count=3D1 iflag=3Ddirect of=3D/dev/null) the brok=
en
> disk gets detected by md:
>=20
> [84688.483607] md/raid1:md0: dm-0: rescheduling sector 0
> [84688.483654] md/raid1:md0: redirecting sector 0 to other mirror: dm-1
> [84688.483670] md: super_written gets error=3D-5, uptodate=3D0
> [84688.483672] md/raid1:md0: Disk failure on dm-0, disabling device.
> md/raid1:md0: Operation continuing on 1 devices.
> [84688.483676] md: super_written gets error=3D-5, uptodate=3D0
> [84688.494174] RAID1 conf printout:
> [84688.494178]  --- wd:1 rd:2
> [84688.494181]  disk 0, wo:1, o:0, dev:dm-0
> [84688.494182]  disk 1, wo:0, o:1, dev:dm-1
> [84688.494183] RAID1 conf printout:
> [84688.494184]  --- wd:1 rd:2
> [84688.494184]  disk 1, wo:0, o:1, dev:dm-1
>=20
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon May 26 19:10:59 2014
>      Raid Level : raid1
>      Array Size : 10176 (9.94 MiB 10.42 MB)
>   Used Dev Size : 10176 (9.94 MiB 10.42 MB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon May 26 19:27:41 2014
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
>=20
>            Name : test:0  (local to host test)
>            UUID : cac8fd48:44219a96:5de7e757:4e21a3e2
>          Events : 20
>=20
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1     254        1        1      active sync   /dev/dm-1
>=20
>        0     254        0        -      faulty   /dev/dm-0
>=20
> md0 : active raid1 dm-1[1] dm-0[0](F)
>       10176 blocks super 1.2 [2/1] [_U]
>=20
> /sys/block/md0/md/array_state:clean
> /sys/block/md0/md/dev-dm-0/state:faulty,write_error
> /sys/block/md0/md/dev-dm-1/state:in_sync
> /sys/block/md0/md/degraded:1
>=20
> However if I also change dm-1 to "disk1: 0 20480 error" and read
> again there is no visible state change:
>=20
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon May 26 19:10:59 2014
>      Raid Level : raid1
>      Array Size : 10176 (9.94 MiB 10.42 MB)
>   Used Dev Size : 10176 (9.94 MiB 10.42 MB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon May 26 19:27:41 2014
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
>=20
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1     254        1        1      active sync   /dev/dm-1
>=20
>        0     254        0        -      faulty   /dev/dm-0
>=20
> md0 : active raid1 dm-1[1] dm-0[0](F)
>       10176 blocks super 1.2 [2/1] [_U]
>=20
> /sys/block/md0/md/array_state:clean
> /sys/block/md0/md/dev-dm-0/state:faulty,write_error
> /sys/block/md0/md/dev-dm-1/state:in_sync
> /sys/block/md0/md/degraded:1
>=20
> On write to the array we get
>=20
> [85498.660247] md: super_written gets error=3D-5, uptodate=3D0
> [85498.666464] quiet_error: 268 callbacks suppressed
> [85498.666470] Buffer I/O error on device md0, logical block 2528
> [85498.666476] Buffer I/O error on device md0, logical block 2528
> [85498.666486] Buffer I/O error on device md0, logical block 2542
> [85498.666490] Buffer I/O error on device md0, logical block 2542
> [85498.666496] Buffer I/O error on device md0, logical block 0
> [85498.666499] Buffer I/O error on device md0, logical block 0
> [85498.666508] Buffer I/O error on device md0, logical block 1
> [85498.666512] Buffer I/O error on device md0, logical block 1
> [85498.666518] Buffer I/O error on device md0, logical block 2543
> [85498.666524] Buffer I/O error on device md0, logical block 2543
> [85498.866388] md: super_written gets error=3D-5, uptodate=3D0
>=20
> and the only change is
>=20
> /sys/block/md0/md/dev-dm-1/state:in_sync,write_error,want_replacement
>=20
> How can I identify a failed array?
> array_state reports "clean", the last raid member stays "in_sync" and
> the value in degraded doesn't equal raid_disks.

You know the array is "failed" when you get an IO error.

When a RAID1 array gets down to just one drive remaining, it starts acting
like it is just one drive.
How do you tell if is single plain ordinary drive is failed?  You get an IO
error.  ditto with RAID1.

NeilBrown

--Sig_/iXGuE5U=Z0FAXX+w5+8tFhP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4bDOznsnt1WYoG5AQLUnxAAvocbTeTCJj5ARJTVAL+s3zWLs/rK63Pj
RHcF1Tvl2gc84EWe9+zr1y7Y9/DDjterFsuKCEp9+ad/JV0oZWT1S9Y1vCXgW6vi
wxyqXAVaW/j2OMT07oXoDrySoVCyV5I1Q6qiUWXH94g4LQ2/WfJ7M0uJc85b4d1O
p0VaI7bnnwfj/g7Uzw3yiEvOrzvI0+/GidjJtrXK8waYkjouDVf/RhMKgkELpUBi
PQzMgf0ggaLrVXy3Gh441JDEpS0+gQlFGFAbiweFTcawjhI8wvfw/QUpwipYV6mu
CKf6oe+0rsx8fB9SFgeiNgw9+fTo74zZBNVehh9C/nwORYNAKSWzpjYrphvM0SLv
4ytjortF85NHBwJuNDHKpa54QdLp/bBMu3Usj4F8ujLa6GsZlHbrZYGyqLqnEK7N
dNhmXaIUtOArfF6Gt3EcIBpbkipNXqn2xJwiYpwnFOe139fjcJNs8fRcb87p+Y0G
ixq61Ro5FE+agvURFbGvi9hOeFYeWiACBZkmyAty00WTgFjb5C+HoZ9cimzHk/+O
O+b7LyxK6t73tMzcFGSBBZb5xIXNoVFGFhUZZxEsuFzI9VOn+X86kEFtp3xe+If4
vD1rOwOFxo1sQ3xgUHQnMGMqgAzCURSyMoXPvUP/G5iDeWa2V39JgI/kDGYB/UvN
Z8/IqL1oF8g=
=6D+4
-----END PGP SIGNATURE-----

--Sig_/iXGuE5U=Z0FAXX+w5+8tFhP--
