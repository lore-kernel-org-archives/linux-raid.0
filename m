From: NeilBrown <neilb@suse.de>
Subject: Re: Can't add device to raid 1 array - no error message
Date: Sun, 4 Mar 2012 08:11:59 +1100
Message-ID: <20120304081159.14d3c937@notabene.brown>
References: <4F526930.1080509@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fM0aGaaaW.9a9K=uFgx5z1T"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F526930.1080509@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fM0aGaaaW.9a9K=uFgx5z1T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 03 Mar 2012 12:55:44 -0600 Larkin Lowrey <llowrey@nuclearwinter.com>
wrote:

> I am trying to replace the two small drives in my raid1 mirror with two
> larger drives. I failed and removed the first drive and am now trying to
> add a new larger drive to take its place. The add command completes
> without any obvious error but the new dive is not added to the array.
> What am I missing?
>=20
> A superblock is written on the new array partition but its role is
> 'spare' and it does not show up in /proc/mdstat.
>=20
> Kernel 3.2.7-1.fc16.x86_64
> mdadm - v3.2.3 - 23rd December 2011
>=20
> It appears that mdadm does detect an error but doesn't say anything
> about it:
>=20
> # mdadm --manage /dev/md0 --add /dev/sdz2 ; echo $?
> 1

Strange.
Does adding "--verbose" produce more messages?

Maybe run mdadm under 'strace' and see exactly what is failing.

NeilBrown





>=20
> I do see the following in the logs:
>=20
> [ 2913.075120] scsi_verify_blk_ioctl: 74 callbacks suppressed
> [ 2913.080708] mdadm: sending ioctl 1261 to a partition!
> ...
> [ 2913.137556] mdadm: sending ioctl 1261 to a partition!
>=20
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Tue Jan 10 20:28:20 2006
>      Raid Level : raid1
>      Array Size : 15634360 (14.91 GiB 16.01 GB)
>   Used Dev Size : 15634360 (14.91 GiB 16.01 GB)
>    Raid Devices : 2
>   Total Devices : 1
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Sat Mar  3 12:43:41 2012
>           State : active, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : ***.*****.***:0  (local to host ***.*****.***)
>            UUID : b5d9fcd0:5baaaff8:492c3e4b:22636aac
>          Events : 499
>=20
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8      130        1      active sync   /dev/sdi2
>=20
> # mdadm -E /dev/sdz2
> /dev/sdz2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : b5d9fcd0:5baaaff8:492c3e4b:22636aac
>            Name : ***.*****.***:0  (local to host ***.*****.***)
>   Creation Time : Tue Jan 10 20:28:20 2006
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 83884032 (40.00 GiB 42.95 GB)
>      Array Size : 31268720 (14.91 GiB 16.01 GB)
>   Used Dev Size : 31268720 (14.91 GiB 16.01 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 50670e17:d3e5fe82:e572e701:7460bcc4
>=20
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Sat Mar  3 12:41:18 2012
>        Checksum : 4bb687db - correct
>          Events : 0
>=20
>=20
>    Device Role : spare
>    Array State : .A ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> ]# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md2 : active raid5 sdv2[9] sdo2[1] sdx2[4] sdl2[5] sdw2[10] sdp2[2]
> sdk2[6] sdm2[8] sdq2[3] sdn2[7] sdr2[0]
>       6641912320 blocks level 5, 128k chunk, algorithm 2 [11/11]
> [UUUUUUUUUUU]
>=20
> md1 : active raid5 sdx1[6] sdb1[9] sdp1[7] sdl1[11] sdr1[4] sdg1[3]
> sdk1[10] sdq1[8] sdh1[0] sdv1[13] sdm1[14] sdw1[12] sdn1[2] sdf1[1] sdo1[=
5]
>       4375960064 blocks level 5, 64k chunk, algorithm 2 [15/15]
> [UUUUUUUUUUUUUUU]
>=20
> md0 : active raid1 sdi2[1]
>       15634360 blocks super 1.2 [2/1] [_U]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>=20
> unused devices: <none>
>=20
> --Larkin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/fM0aGaaaW.9a9K=uFgx5z1T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1KJHznsnt1WYoG5AQJbkRAAhbOvFMGZ49gcEMYorAaIjkeF4c3x/jov
N/yfooWzhx1auBwHR/QyXBVBn+aXkHFllCYlpZvkc6QLpRqQ5WWmM9vBzmybQzZl
KlHjUKEEcmwbOU0UI/J+mxuyrzBDxvpumsLEzL5BrVLJ/gDk259WIzukcPhgySh1
xx+TMojZSDZiVB5Qv3iZrL3kNoSRVJdN6mlGTTh7xCb9V4Qn+rKK77g1Fia91L4O
Maay96lKAahutMka69T2yG7XCtrlZY3kaRDVVYME6BaUUAg8G7QTuJMeRMcGlbLs
1+jQDS4tme7ACipCk7SE1wdKD6dvp7PYOkNeLqo9b3npZ3iP38hPtLOEyXQNhgSe
zagpkRjQjc+VBfo3LXqJZOi9jMMXX0g2rNNunU3ZSnLHUe+7T9c9vp4PQ9gVs0Pp
t5cZwNOhYRSMRo0ZxM+r3RlGi093sO5PHOPacPRPjzgL/takcd19nXYtjchz6dER
ZPIuKiD1PAsO6jY5LRI0/N/plLyqqbWrW5sO5tkJScxnRlIq1sYQM4aYzL+b8jAt
SKQpvJSQ18XMIU+eYlpDcxoNjPjXa7ulnTJDqPZfnfx2UCKMsPXoTfK2ThdAZ/nY
6fGUuuJdkkBYJ2jfbTrG/ilxBXKW95/XJSnkwCS/wuS+0qrM7PzkGZme5UnrsjzB
8Zr5YC+rt04=
=EzRD
-----END PGP SIGNATURE-----

--Sig_/fM0aGaaaW.9a9K=uFgx5z1T--
