From: NeilBrown <neilb@suse.de>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 16:32:05 +1000
Message-ID: <20120628163205.2c6a1122@notabene.brown>
References: <4FE9BFC1.5070607@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Io.m0nAQYK3YHlmQl..KgRb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FE9BFC1.5070607@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Io.m0nAQYK3YHlmQl..KgRb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jun 2012 15:57:21 +0200 "Stefan G. Weichinger" <lists@xunil.at>
wrote:

>=20
> Greets,
>=20
> I currently try to re-add 2 disks to a RAID6 array.
>=20
> There were 4 disks in a Fujitsu Q800 NAS, the RAID6 was done via WebGUI.
>=20
> 2 disks have been removed from the array and I am not able to re-add the
> old disks or add new disks via WebGUI.
>=20
> The support told me to "re-insert disks, if it doesn't work, rebuild
> array" ... cool. What do I need a RAID for then ??
>=20
> Anway.
>=20
> Entered hacking mode ;-) at least in my terms.
>=20
> sshed into box.
>=20
> To get it short:
>=20
> Currently the RAID6 array /dev/md0 is:
>=20
> md0 : active raid6 sdc3[2] sdd3[3]
>       3903891200 blocks level 6, 64k chunk, algorithm 2 [4/2] [__UU]
>=20
> So I would like to re-add sda3 and sdb3 ...
>=20
> I get:
>=20
> # mdadm /dev/md0 -a /dev/sda3
> mdadm: /dev/sda3 not large enough to join array
>=20
> oops!
>=20
> But the comparison shows:
>=20
> [~] # fdisk -l /dev/sda
>=20
> Disk /dev/sda: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1          66      530125   83  Linux
> /dev/sda2              67         132      530142   83  Linux
> /dev/sda3             133      243138  1951945693   83  Linux
> /dev/sda4          243139      243200      498012   83  Linux
>=20
> [~] # fdisk -l /dev/sdc
>=20
> Disk /dev/sdc: 2000.3 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>=20
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1          66      530125   83  Linux
> /dev/sdc2              67         132      530142   83  Linux
> /dev/sdc3             133      243138  1951945693   83  Linux
> /dev/sdc4          243139      243200      498012   83  Linux
>=20
> -> identical partitions
>=20
> ---
>=20
> Could that relate to this issue:
>=20
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D500309

Nope.  It was an earlier bug fixed in 2.6.5 by

 http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D7a3be72fc621b4a758=
9e923cf065


>=20
> The NAS seems to run some ubuntu:
>=20
> # cat /proc/version
> Linux version 2.6.33.2 (root@NasX86-5) (gcc version 4.1.3 20070929
> (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Mon Sep 13 04:28:32 CST 2010

Does the "X86" in there suggest and x86 processor?  What does "uname -a" sh=
ow?


>=20
> and brings an older mdadm:
>=20
> # mdadm --version
> mdadm - v2.6.3 - 20th August 2007
>=20
>=20
> If that is the issue, is there a way to use some newer binary (magically
> transferred to me by mail or URL ;-) ) of mdadm to re-add disks?

You mean the NAS didn't come with a complete build environment and sources
for all programs?  Outrageous.

If you have a machine with the same arch at the NAS, you could

  git clone git://neil.brown.name/mdadm -b mdadm-2.6.5
  cd mdadm
  make mdadm.static CWFLAGS=3D-Wall

and then use the "mdadm.static" on the NAS.

NeilBrown


>=20
> I would really really like to avoid to rebuild that array ...
>=20
> Thanks in advance, looking forward to your hints, Stefan!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Io.m0nAQYK3YHlmQl..KgRb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+v6ZTnsnt1WYoG5AQKodw/8CiEC7vSzUDoa/aVqQlI+A4OuB6ExInuK
EmhGrT6iPdMagz8A7suIINeAxjNgOX35DEn8Kgfe6jMiBa9kS8NGNFUMC6MY9wUn
cHviZHrYwafEepZKu8+nxQWwrjdfyfjVkU7yZZpEJ0STkcUpZB0X4oejTus+sDWM
VWMyVaDW5BGCMEfbxf4F7pXNnOnN7XZeleSuAkhCGvloO5G3A54VnMcLPxxPgLsz
6RD57rC+wVeOCr2AgORfll3Eo1K9+wdwrbwBtx/KLNOECmKigl6iYsqls2Pnf3Zo
fvtT4qCFm6CcpgPvFwS7aEAMYMflwI3TkX8fFDdEHoS/HfvjwFyQ5kChxlvMCny/
pPz4sMBGacIJ1Ef/EvK3nMdcG+2+lizHk5XkS9cUZg0AT3pwPjrWQr0qy2Zn/+Ch
HXTyIEexfzWdQS2oCoKDfausLUvQCxCLK3tBfbh8IGnPQrbyQGGqCkJLcv5b4JgP
qZIsiDxjqDUyh/NtmaT9rfEv+X8h20qJcL59699K3XSGIFAkio9IciEaNyZ+PSgn
V01ggyrL5V4Y+8e/PhBdt8HjOeKw9rIDpupu9hFTQIqey72ApQ7V6o2QVObn3R+m
PZSY6U5nLkg+lwuN7348pnzMQzaONdCxJ2ESYOeDckv5fnadUts2jh8RJiJ3lhU/
t0mTWZsXXUc=
=ihOP
-----END PGP SIGNATURE-----

--Sig_/Io.m0nAQYK3YHlmQl..KgRb--
