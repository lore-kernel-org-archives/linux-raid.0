From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 working correctly, error messages during boot
Date: Thu, 21 May 2015 21:20:49 +1000
Message-ID: <20150521212049.6f9cf650@notabene.brown>
References: <CE885044-F8E8-4286-9CAC-1D17560F1E79@me.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NrDJR=tTx.fdkgUEpVYR5cF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE885044-F8E8-4286-9CAC-1D17560F1E79@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Malissa <hmalissa@me.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NrDJR=tTx.fdkgUEpVYR5cF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 May 2015 14:29:23 -0600 Hans Malissa <hmalissa@me.com> wrote:

> I have a software-RAID1 that seems to be working correctly:
>=20
> # cat /proc/mdstat
> Personalities : [raid1]=20
> md0 : active raid1 sdc1[1] sdb1[0]
>       976629568 blocks super 1.2 [2/2] [UU]
>      =20
> unused devices: <none>
>=20
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sun May 17 15:21:30 2015
>      Raid Level : raid1
>      Array Size : 976629568 (931.39 GiB 1000.07 GB)
>   Used Dev Size : 976629568 (931.39 GiB 1000.07 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon May 18 10:28:36 2015
>           State : clean=20
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : eprb21:0  (local to host eprb21)
>            UUID : 0901fe50:444a29b6:d3caff14:e45ef9cc
>          Events : 19
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
>=20
> But, on the other hand, when the system boots, I briefly see the followin=
g messages:
>=20
> doing fast boot
> Creating device nodes with udev
> udevd[174]: failed to execute =E2=80=98/sbin/mdadm=E2=80=99 =E2=80=98/sbi=
n/mdadm --incremental /dev/sdb1
>=20
> udevd[175]: failed to execute =E2=80=98/sbin/mdadm=E2=80=99 =E2=80=98/sbi=
n/mdadm --incremental /dev/sdc1 --offroot=E2=80=99: No such file or directo=
ry
>=20
> But otherwise the system appears to run normally. After booting, /dev/md0=
 seems to be working correctly.
> What does it mean, and should I worry about it? What can I do about it? M=
y system is openSUSE 12.2.
> Thanks a lot,
>=20

I suspect that some udev scripts on the initrd say to run mdadm, but mdadm
isn't installed on the initrd.
/dev/md0 doesn't hold the root filesystem does it?  mdadm is only installed
on the initrd if it is needed for root, swap, or suspend-to-disk.

If you really wanted to get rid of the messages - which are definitely
harmless - you would need to recreate the initrd either without those udev
rules files, or with mdadm.
Adding the 'md' arg to the "mkinitrd" command might be sufficient, but I
don't have a 12.2 install lying around that I can play with.

NeilBrown

--Sig_/NrDJR=tTx.fdkgUEpVYR5cF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV2/kjnsnt1WYoG5AQK9HxAAl7VqAmqwUQfhkQx5OnarsnwnQweoF+9I
MWP+S3L2gM4BObcW2zm9XhiKkk9GMFBxpoYDxtpQTe0DctiC3vF1s9e61UimJUZW
7yCPvprA7Rempx9NDbpKCX8NA4K9axZnRimZ4ddp4tQg4qx3kuiaCtS7RVfqYsff
pjyTb1hC2P/KYGwMcMoLkEtrk8hprK0/I0d9lUvRITSBDtbX3fwAIRBOpmPLtcOp
C+8GPD9cHZbHil4QvpmwYztWN3c9kXIVV/FhUNVnkKIwtW+lduMJMSvpNQAFpQ2C
I2nTNmyzIIwq7azn3ZeqEMXpGViitId21gKpFI1HeRx9DGiGZw221Z+YnVbhsXrE
95wvG8DvSN3gW27UXQJ02Pwo1TG0pVe4QQlJv/vur5L5oYEyMGDBpXbXs5/C0nxI
5S17aBvku6Kgywglw1WhcXTGr63C/R7MTHJL4UQtRiBjIBCC0k/CoOiKhUjTJoU1
ulOYXF0qBqe7SGFDX0ZJPLoEAfsmG8O8qnNYxNCwL2GEolcyZlN+2t3vYSmD1PaR
eED0fus/RkK7V3yFRA2cvhUJ6mzn7voaEI9VIxJ+kWZ14x7Cq9ULm4L56fwKdCEj
vBlM6aPymn+zyq1rNYMw35ayxV/NffvIo9g902U795znBQ1Hq95l6zNVt450jIYK
BhqVWxzKF0Q=
=EHa7
-----END PGP SIGNATURE-----

--Sig_/NrDJR=tTx.fdkgUEpVYR5cF--
