From: "Adam J Morand" <Adam.Morand@midnightmoon.ca>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 19:54:22 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <028701c2cb38$4cce70c0$6701a8c0@bc.hsia.telus.net>
References: <Pine.LNX.4.33.0302021621110.17543-100000@router.windsormachine.com> <014f01c2cb00$375d5fe0$6701a8c0@bc.hsia.telus.net> <3E3D9695.7040900@ratnet.stw.uni-erlangen.de> <025d01c2cb35$69630f00$6701a8c0@bc.hsia.telus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Adam J Morand <Adam.Morand@illuminatedtechnologies.com>, schmidt@naa.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry,
to add to the previous message, when I specify the filesystem type I ge=
t:
[root@r2d2 part1]# mount -t ext3 /dev/md2 /mnt/raid/part2
mount: wrong fs type, bad option, bad superblock on /dev/md2,
       or too many mounted file systems
[root@r2d2 part1]#
[root@r2d2 part1]# mount -t ext2 /dev/md2 /mnt/raid/part2
mount: wrong fs type, bad option, bad superblock on /dev/md2,
       or too many mounted file systems





----- Original Message -----
=46rom: "Adam J Morand" <Adam.Morand@illuminatedtechnologies.com>
To: <schmidt@naa.net>; <linux-raid@vger.kernel.org>
Sent: Sunday, February 02, 2003 7:36 PM
Subject: Re: RAID 1 / Power Loss / No SuperBlock


Hello again,

this is using mdadm, I now have 1 of the 3 RAIDs kind of working,
I am open to any suggestions at this point,

this is the error I get now
# mount /dev/md2 /mnt/raid/part2
mount: you must specify the filesystem type

# mount /dev/md3 /mnt/raid/part3
mount: you must specify the filesystem type

/dev/md1 works just fine
# mount /dev/md1 /mnt/raid/part1

# df -h
=46ilesystem            Size  Used Avail Use% Mounted on
/dev/hda3              36G   26G  8.3G  76% /
/dev/hda1              23M  2.7M   18M  13% /boot
none                  502M     0  502M   0% /dev/shm
/dev/md1               19G  8.8G  9.5G  48% /mnt/raid/part1



[root@r2d2 part1]# cat /proc/mdstat
Personalities : [raid0] [raid1]
read_ahead 1024 sectors
md1 : active raid1 hdb2[0]
      20482752 blocks [2/1] [U_]

md2 : active raid0 hdb3[0] hdd3[1]
      26619520 blocks 64k chunks

md3 : active raid1 hdd1[1]
      5116544 blocks [2/1] [_U]

unused devices: <none>
[root@r2d2 part1]# cat /etc/mdadm.conf
DEVICE          /dev/hdb1 /dev/hdb2 /dev/hdb3 /dev/hdd1 /dev/hdd2 /dev/=
hdd3
ARRAY           /dev/md3 devices=3D/dev/hdb1,/dev/hdd1
ARRAY           /dev/md1 devices=3D/dev/hdb2,/dev/hdd2
ARRAY           /dev/md2 devices=3D/dev/hdb3,/dev/hdd3

[root@r2d2 part1]#



fdisk -l

Disk /dev/hda: 255 heads, 63 sectors, 4866 cylinders
Units =3D cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1         3     24066   83  Linux
/dev/hda2             4       134   1052257+  82  Linux swap
/dev/hda3           135      4866  38009790   83  Linux

Disk /dev/hdb: 255 heads, 63 sectors, 4866 cylinders
Units =3D cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdb1   *         1       637   5116671   83  Linux
/dev/hdb2           638      3187  20482875   83  Linux
/dev/hdb3          3188      4844  13309852+  83  Linux
/dev/hdb4          4845      4866    176715    f  Win95 Ext'd (LBA)
/dev/hdb5          4845      4866    176683+  82  Linux swap

Disk /dev/hdd: 255 heads, 63 sectors, 4866 cylinders
Units =3D cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdd1   *         1       637   5116671   83  Linux
/dev/hdd2           638      3187  20482875   83  Linux
/dev/hdd3          3188      4844  13309852+  83  Linux
/dev/hdd4          4845      4866    176715    f  Win95 Ext'd (LBA)
/dev/hdd5          4845      4866    176683+  82  Linux swap





----- Original Message -----
=46rom: "Norman Schmidt" <norman.schmidt@ratnet.stw.uni-erlangen.de>
To: <linux-raid@vger.kernel.org>
Cc: "Adam J Morand" <Adam.Morand@midnightmoon.ca>
Sent: Sunday, February 02, 2003 2:07 PM
Subject: Re: RAID 1 / Power Loss / No SuperBlock


Hi Adam!

My guesses:

1. When the computer was switched off hard (i.e. without shutting
down/disassemble the md devices first), they were not marked clean and
stayed dirty. During the next boot, the kernel driver found out about
this and only used the one of the two mirrors for each partition to wor=
k
(thus the entry in /proc/mdstat). Your arrays work in degraded mode.

2. Somewhere you mounted one of the underlying devices of /dev/md2,
namely /dev/hdd1, and did an fsck on it. That is a VERY bad idea. You
should NEVER mount any of the underlying devices, unless you mark it as
failed-disk and know exactly what you do.

To sort out your problem in the first place, it would be very helpful i=
f
you would provide the following outputs/files of the actual working
configuration (the one you get when you boot your computer now):

/etc/lilo.conf
/etc/fstab
/etc/mtab

And give the version number of lilo!

And state again exactly what your problem is, i.e. what doesn=B4t work =
how
it used to.

Another question: Why don=B4t you use mdadm instead of the raidtools?
Mdadm really is the successor of the raidtools, has a 1.0 version
number, and I LOVE mdadm (thanks Neil!).

Ah, yes: With the raidtools, some of the following should get you your
second drive back in sync: raidhotadd /dev/md2 /dev/hdd1 and the same
for the other disk:

Bye, Norman.

Adam J Morand schrieb:
> Mike,
>
> errors included:
> cannot determine md version: No such file or directory
> and
> mount: wrong fs type, bad option, bad superblock on /dev/md2,
>        or too many mounted file systems
>

> The error I get
> [aj@r2d2 aj]$ fsck /dev/hdd1
> Parallelizing fsck version 1.23 (15-Aug-2001)
> e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
> Couldn't find ext2 superblock, trying backup blocks...
> fsck.ext2: Bad magic number in super-block while trying to open /dev/=
hdd1
>
> The superblock could not be read or does not describe a correct ext2
> filesystem.  If the device is valid and it really contains an ext2
> filesystem (and not swap or ufs or something else), then the superblo=
ck
> is corrupt, and you might try running e2fsck with an alternate superb=
lock:
>     e2fsck -b 8193 <device>
>
> Exit 8
>
> Is there RAID tools available for a situation like this that can recr=
eate
> the superblocks?
> I have tried the backup blocks, I do not know how else or where to lo=
ok
for
> more information on reconstructed my dead RAID.
>
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
>
> md2 : active raid1 hdb1[0]
>       5116544 blocks [2/1] [_U]
>
> md1 : active raid1 hda2[1]
>       20482752 blocks [2/1] [U_]



--

--
Norman Schmidt             Universitaet Erlangen-Nuernberg            _
cand.chem.                 Sysadmin Wohnheimnetzwerk RatNET        _ //
mailto:schmidt@naa.net                                             \X/

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
