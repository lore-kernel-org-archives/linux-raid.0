From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of RAID1 fails (added disks stays as spare)
Date: Sat, 17 Aug 2013 10:50:37 +1000
Message-ID: <20130817105037.3aea0b4f@notabene.brown>
References: <FC7EE784B0E13748AA4FF80E6D4CD67212E27E@w8kmail2.konzern.intern>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9xH+eOtgPynv3a8K9AvMv6G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FC7EE784B0E13748AA4FF80E6D4CD67212E27E@w8kmail2.konzern.intern>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias.Blaesing@persona.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9xH+eOtgPynv3a8K9AvMv6G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Aug 2013 09:09:40 +0000 <Matthias.Blaesing@persona.de> wrote:

> Hello,
>=20
> I'm currently fighting a server problem and have the feeling, that I'm ru=
nning into walls.
>=20
> Summary: On one of our servers we suffered from a hard disk error, that l=
ead to a degraded array.
> The hardware was replaced and the array was rebuild. On one of the RAID-S=
ets the newly added
> disk is not activated but stays as spare.
>=20
> System: SUSE Linux Enterprise Server 11 (x86_64) 11.2
>=20
> The current state:
>=20
> # cat /proc/mdstat
>=20
> Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4]
> md3 : active raid1 sda3[2](S) sdb3[0]
>       970888192 blocks [2/1] [U_]
>=20
> md1 : active raid1 sda1[0] sdb1[1]
>       3911680 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20
> # mdadm --detail /dev/md3
>=20
> /dev/md3:
>         Version : 0.90
>   Creation Time : Fri Feb  4 11:47:04 2011
>      Raid Level : raid1
>      Array Size : 970888192 (925.91 GiB 994.19 GB)
>   Used Dev Size : 970888192 (925.91 GiB 994.19 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 3
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Aug 15 10:22:07 2013
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>            UUID : e9d9c5f5:615c789e:3fb6082e:e5593158
>          Events : 0.18857541
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       19        0      active sync   /dev/sdb3
>        1       0        0        1      removed
>=20
>        2       8        3        -      spare   /dev/sda3
>=20
> I would expect the raid system to move /dev/sda3 to number 1 and mark it =
as active.
>=20
> Versions:
>=20
> # uname -a
> Linux 3.0.58-0.6.6-default #1 SMP Tue Feb 19 11:07:00 UTC 2013 (1576ecd) =
x86_64 x86_64 x86_64 GNU/Linux
> # mdadm -V
> mdadm - v3.2.2 - 17th June 2011
>=20
> I tried:
>=20
> * removing /dev/sda3 from the array and add it back
> * removing /dev/sda3 from the array, zero the root block and add it back =
(--zero-superblock)
> * removing /dev/sda3 from the array, reduce raid devices to one, add /dev=
/sda3 back
> * removing /dev/sda3 from the array, zero the first part of the disk (wit=
h dd) and add it back
>=20
> I would really appreciate ideas how to fix this (preferably while running=
 the system).
>=20

Strange.  I would definitely have expected one of those to start the recove=
ry.
Does anything appear in the kernel logs (e.g. output of 'dmesg')?
What does
  grep . /sys/block/md3/md/*
show?
I don't suppose
  echo recover > /sys/block/md3/md/sync_action
helps?
Is there still a kernel thread called
    md3_raid1
running?

NeilBrown

--Sig_/9xH+eOtgPynv3a8K9AvMv6G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUg7I3Tnsnt1WYoG5AQJcgw/8C3ctbhnMkOS5jXFcaBp3h/V9VdErFZ9o
LatA44GxyVEZ7EunbZm4XrPdoPhgjs8G1AK01sEhelT2zJpzTpJqQ0BOMf6NMQrF
OWKCBZrDt3eW+uCrFwNG+Hq2agnwlTygS0bflDtPtXCxCLvOpCvJBsrNoWg5zTID
YBlTnpvG6aXrzPa7dzWBfvnOGupddqa46Sk4rhyyf/X442bu/kkj9ZACxbDDlSKx
ly+NC17jvj1z54neAmg5F/8YvKEbnK6QTZzZRdFszr5O1WZGzhQeLazAFKtagmKS
ma1Tgz/Jxc1xsCXAkE+nFj0F3q33dh519R2GAdA4Rr865iNflrI0KITWs81GEMnq
lUAYeKbi1vq7lof94tk2jCnjGk2JLBJdFry+z2VoKfxBgrzZFi5fszWUWhnG0Coe
msRtgzXjrFMZVzPzW/YJMVl4RgTFtuyxampKTperDJS44nP/qcdNiuVRxK+HTZ/0
5r2I+xIGByPO6BrnpN1INc92YwXbVocg+OjYe9ZQPJB0IR0dc5ElLcsPp1Q65YSQ
AZHSEanKzHWrjBJUEybPD8Dfp32b08vxCZ3ymvsjpB4Y0qHZkM/JPN3AZ2gz0c0T
JDAJItsN3GBvAYX7QbMfVnt1BbJDhUtbuWP3WdUrDIEZScbknkDxK192cNlEb181
HfCYnczFuc0=
=0Doa
-----END PGP SIGNATURE-----

--Sig_/9xH+eOtgPynv3a8K9AvMv6G--
