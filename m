From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 02 Feb 2003 23:07:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E3D9695.7040900@ratnet.stw.uni-erlangen.de>
References: <Pine.LNX.4.33.0302021621110.17543-100000@router.windsormachine.com> <014f01c2cb00$375d5fe0$6701a8c0@bc.hsia.telus.net>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Adam J Morand <Adam.Morand@midnightmoon.ca>
List-Id: linux-raid.ids

Hi Adam!

My guesses:

1. When the computer was switched off hard (i.e. without shutting=20
down/disassemble the md devices first), they were not marked clean and=20
stayed dirty. During the next boot, the kernel driver found out about=20
this and only used the one of the two mirrors for each partition to wor=
k=20
(thus the entry in /proc/mdstat). Your arrays work in degraded mode.

2. Somewhere you mounted one of the underlying devices of /dev/md2,=20
namely /dev/hdd1, and did an fsck on it. That is a VERY bad idea. You=20
should NEVER mount any of the underlying devices, unless you mark it as=
=20
failed-disk and know exactly what you do.

To sort out your problem in the first place, it would be very helpful i=
f=20
you would provide the following outputs/files of the actual working=20
configuration (the one you get when you boot your computer now):

/etc/lilo.conf
/etc/fstab
/etc/mtab

And give the version number of lilo!

And state again exactly what your problem is, i.e. what doesn=B4t work =
how=20
it used to.

Another question: Why don=B4t you use mdadm instead of the raidtools?=20
Mdadm really is the successor of the raidtools, has a 1.0 version=20
number, and I LOVE mdadm (thanks Neil!).

Ah, yes: With the raidtools, some of the following should get you your=20
second drive back in sync: raidhotadd /dev/md2 /dev/hdd1 and the same=20
for the other disk:

Bye, Norman.

Adam J Morand schrieb:
> Mike,
>=20
> errors included:
> cannot determine md version: No such file or directory
> and
> mount: wrong fs type, bad option, bad superblock on /dev/md2,
>        or too many mounted file systems
>=20

> The error I get
> [aj@r2d2 aj]$ fsck /dev/hdd1
> Parallelizing fsck version 1.23 (15-Aug-2001)
> e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
> Couldn't find ext2 superblock, trying backup blocks...
> fsck.ext2: Bad magic number in super-block while trying to open /dev/=
hdd1
>=20
> The superblock could not be read or does not describe a correct ext2
> filesystem.  If the device is valid and it really contains an ext2
> filesystem (and not swap or ufs or something else), then the superblo=
ck
> is corrupt, and you might try running e2fsck with an alternate superb=
lock:
>     e2fsck -b 8193 <device>
>=20
> Exit 8
>=20
> Is there RAID tools available for a situation like this that can recr=
eate
> the superblocks?
> I have tried the backup blocks, I do not know how else or where to lo=
ok for
> more information on reconstructed my dead RAID.
>=20
> Thank you for any information or hints possible,

 > /etc/raidtab
 >
> raiddev             /dev/md2
> raid-level                  1
> nr-raid-disks               2
> chunk-size                  64k
> persistent-superblock       1
> nr-spare-disks              0
>     device          /dev/hdd1
>     raid-disk     0
>     device          /dev/hdb1
>     raid-disk     1
> raiddev             /dev/md1
> raid-level                  1
> nr-raid-disks               2
> chunk-size                  64k
> persistent-superblock       1
> nr-spare-disks              0
>     device          /dev/hdd2
>     raid-disk     0
>     device          /dev/hdb2
>     raid-disk     1

> cat /proc/mdstat
> Personalities : [raid0] [raid1]
> read_ahead 1024 sectors
> md0 : active raid0 hda3[1] hdb3[0]
>       26619520 blocks 64k chunks
>=20
> md2 : active raid1 hdb1[0]
>       5116544 blocks [2/1] [_U]
>=20
> md1 : active raid1 hda2[1]
>       20482752 blocks [2/1] [U_]



--=20

--=20
Norman Schmidt             Universitaet Erlangen-Nuernberg            _
cand.chem.                 Sysadmin Wohnheimnetzwerk RatNET        _ //
mailto:schmidt@naa.net                                             \X/

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
