From: Neil Brown <neilb@suse.com>
Subject: Re: md127 auto created when use "-B" to build a legacy array without superblocks
Date: Fri, 02 Oct 2015 17:55:46 +1000
Message-ID: <87k2r5iu0t.fsf@notabene.neil.brown.name>
References: <597548646.22274436.1441628869039.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <597548646.22274436.1441628869039.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yi Zhang <yizhan@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Yi Zhang <yizhan@redhat.com> writes:

> Hi Neil
>
> When testing 00raid1, found the md127 auto created when use "-B" to build=
 a legacy array without superblocks, is it reasonable?

This happens because udev notices a new device has appeared, looks
inside it, sees that it could be part of an md array, and so runs
"mdadm --incremental" on it.

Sometimes we want udev to do that.  Sometimes we don't.
There is no easy way for udev to know what we want.

NeilBrown


> pls check below detailed info:
>
> + mdadm -CR /dev/md0 --level=3Draid1 -n3 /dev/loop0 /dev/loop1 /dev/loop2
> mdadm: /dev/loop0 appears to contain an ext2fs file system
>        size=3D58368K  mtime=3DThu Jan  1 08:00:00 1970
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=3D0.90
> mdadm: /dev/loop1 appears to contain an ext2fs file system
>        size=3D38912K  mtime=3DThu Jan  1 08:00:00 1970
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> + mdadm --wait /dev/md0
> + cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]=20
> md0 : active raid1 loop2[2] loop1[1] loop0[0]
>       19968 blocks super 1.2 [3/3] [UUU]
>=20=20=20=20=20=20=20
> unused devices: <none>
> + mdadm -S /dev/md0
> mdadm: stopped /dev/md0
> + mdadm -B /dev/md0 -l raid1 -n2 /dev/loop0 /dev/loop1
> mdadm: array /dev/md0 built and started.
> + sleep 2
> + cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]=20
> md127 : inactive md0[0](S)
>       19968 blocks super 1.2
>=20=20=20=20=20=20=20=20
> md0 : active raid1 loop1[1] loop0[0]
>       20000 blocks super non-persistent [2/2] [UU]
>=20=20=20=20=20=20=20
> unused devices: <none>
> [root@dhcp-12-171 bug]# uname -r
> 4.2.0
> [root@dhcp-12-171 bug]# mdadm -D /dev/md0=20
> /dev/md0:
>         Version :=20
>   Creation Time : Mon Sep  7 20:21:20 2015
>      Raid Level : raid1
>      Array Size : 20000 (19.53 MiB 20.48 MB)
>   Used Dev Size : 20000 (19.53 MiB 20.48 MB)
>    Raid Devices : 2
>   Total Devices : 2
>
>           State : clean=20
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       7        0        0      active sync   /dev/loop0
>        1       7        1        1      active sync   /dev/loop1
> [root@dhcp-12-171 bug]# mdadm -D /dev/md127=20
> /dev/md127:
>         Version : 1.2
>      Raid Level : raid0
>   Total Devices : 1
>     Persistence : Superblock is persistent
>
>           State : inactive
>
>            Name : dhcp-12-171.nay.redhat.com:0  (local to host dhcp-12-17=
1.nay.redhat.com)
>            UUID : 40ace956:a9dd0793:f4984d2b:8431b92b
>          Events : 17
>
>     Number   Major   Minor   RaidDevice
>
>        -       9        0        -        /dev/md0=20
>
> Best Regards,
>   Yi Zhang

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWDjiCAAoJEDnsnt1WYoG5xrEQAJDBkjlOnzWIJNtyHFjoaySa
aUbZopwSBGJCAg+MhfBVZtvnJjGzdPjiyUHRnBfS9mBnzFg2IxXDu1NUotscjl3j
Rewhbl7bKT39HckKle18KYkij5aE2JpCfWJcL4HnZbAVJNH2ha7MEkXWCfOjSLVr
DBKdfmn8laNzU9CwvHTwQSCCwJ4/LnPQvO+1Y1dSaEie+koH3uilOf0qjufU0CV7
PiENroVXYSCXLhvtR84FQmNWjGJQsWrIxbIQuShgosKI72G2Rdb/BIR88zabzKrf
L7WAskoNrpBSVDH9gy/dFtH/fT1KsnBAFw9tJwHVaE6beulS6TqpOSwToFQMHmfB
6M44WHkI48miZf08+GWpsPBeKmxOrmmDaDvqv/RDjZF32IdUA0MSiuR/5/UJuxXB
BBVY1U+w4scRyRdBcWuuJ1HkNrpcLLpNVBEfqPhhh5+VlCMONBHGe1aXjTr7OeEm
fVHN+N6o6tZb8btrlBvkEz+2Tq9JpZNfe9gyHXi/SrIOAkP5TnlTCXKHXN2Rt06L
0+S90bKs4HCJkD1+I5riF2p3JoehXEKvXhAQ8SCwli6XutfdG0w+2a7PSkKGjDuX
CpEbVICDKUd4okyagr4VccTwUqEkY5oiSkyJvam0YCfi26+kZjj/bGtDMvi6b6vz
K8x0+Y7uAtzTRmCm+ngZ
=enPU
-----END PGP SIGNATURE-----
--=-=-=--
