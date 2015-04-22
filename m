From: Stefan Lamby <webmaster@peter-speer.de>
Subject: mdadm.conf issue after updating system
Date: Wed, 22 Apr 2015 11:56:30 +0200 (CEST)
Message-ID: <2008592931.14931.1429696590806.JavaMail.open-xchange@app01.ox.hosteurope.de>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello list.
=20
I just updated my ubuntu system. The update provided a new kernel image=
 also.
Here is what I got back:
=20
update-initramfs: Generating /boot/initrd.img-3.13.0-49-generic
W: mdadm: the array /dev/md/kvm15:10 with UUID
c4540426:9c668fe2:479513f2:42d233b4
W: mdadm: is currently active, but it is not listed in mdadm.conf. if
W: mdadm: it is needed for boot, then YOUR SYSTEM IS NOW UNBOOTABLE!
W: mdadm: please inspect the output of /usr/share/mdadm/mkconf, compare
W: mdadm: it to /etc/mdadm/mdadm.conf, and make the necessary changes.
=20
Is ist OK to just edit mdadm.conf and replace
ARRAY /dev/md/0 metadata=3D1.2 UUID=3D75079a2f:acb8c475:85f8ca43:0ad85c=
4c
name=3Dkvm15:0
with:
ARRAY /dev/md/127 metadata=3D1.2 UUID=3Dc4540426:9c668fe2:479513f2:42d2=
33b4
name=3Dkvm15:10
=20
Or is there any other action recommended?
=20
Thank you for your help.
Stefan
=20
=20
Here is some additonal information about the system:

root@kvm15:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid10] [raid6] [=
raid5]
[raid4]
md127 : active raid10 sdc1[1] sdb1[5] sdd1[3] sda1[4]
      3808330752 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU=
]
     =20
unused devices: <none>


root@kvm15:~# lsblk
NAME                        MAJ:MIN RM   SIZE RO TYPE   MOUNTPOINT
sda                           8:0    0   1,8T  0 disk  =20
=E2=94=94=E2=94=80sda1                        8:1    0   1,8T  0 part  =
=20
  =E2=94=94=E2=94=80md127                     9:127  0   3,6T  0 raid10
    =E2=94=9C=E2=94=80vg_raid10-home (dm-0) 252:0    0   1,2T  0 lvm   =
 /home
    =E2=94=9C=E2=94=80vg_raid10-root (dm-1) 252:1    0  93,1G  0 lvm   =
 /
    =E2=94=9C=E2=94=80vg_raid10-var (dm-2)  252:2    0 393,1G  0 lvm   =
 /var
    =E2=94=9C=E2=94=80vg_raid10-tmp (dm-3)  252:3    0  46,6G  0 lvm   =
 /tmp
    =E2=94=94=E2=94=80vg_raid10-swap (dm-4) 252:4    0  23,3G  0 lvm   =
 [SWAP]
sdb                           8:16   0   1,8T  0 disk  =20
=E2=94=94=E2=94=80sdb1                        8:17   0   1,8T  0 part  =
=20
  =E2=94=94=E2=94=80md127                     9:127  0   3,6T  0 raid10
    =E2=94=9C=E2=94=80vg_raid10-home (dm-0) 252:0    0   1,2T  0 lvm   =
 /home
    =E2=94=9C=E2=94=80vg_raid10-root (dm-1) 252:1    0  93,1G  0 lvm   =
 /
    =E2=94=9C=E2=94=80vg_raid10-var (dm-2)  252:2    0 393,1G  0 lvm   =
 /var
    =E2=94=9C=E2=94=80vg_raid10-tmp (dm-3)  252:3    0  46,6G  0 lvm   =
 /tmp
    =E2=94=94=E2=94=80vg_raid10-swap (dm-4) 252:4    0  23,3G  0 lvm   =
 [SWAP]
sdc                           8:32   0   1,8T  0 disk  =20
=E2=94=94=E2=94=80sdc1                        8:33   0   1,8T  0 part  =
=20
  =E2=94=94=E2=94=80md127                     9:127  0   3,6T  0 raid10
    =E2=94=9C=E2=94=80vg_raid10-home (dm-0) 252:0    0   1,2T  0 lvm   =
 /home
    =E2=94=9C=E2=94=80vg_raid10-root (dm-1) 252:1    0  93,1G  0 lvm   =
 /
    =E2=94=9C=E2=94=80vg_raid10-var (dm-2)  252:2    0 393,1G  0 lvm   =
 /var
    =E2=94=9C=E2=94=80vg_raid10-tmp (dm-3)  252:3    0  46,6G  0 lvm   =
 /tmp
    =E2=94=94=E2=94=80vg_raid10-swap (dm-4) 252:4    0  23,3G  0 lvm   =
 [SWAP]
sdd                           8:48   0   1,8T  0 disk  =20
=E2=94=94=E2=94=80sdd1                        8:49   0   1,8T  0 part  =
=20
  =E2=94=94=E2=94=80md127                     9:127  0   3,6T  0 raid10
    =E2=94=9C=E2=94=80vg_raid10-home (dm-0) 252:0    0   1,2T  0 lvm   =
 /home
    =E2=94=9C=E2=94=80vg_raid10-root (dm-1) 252:1    0  93,1G  0 lvm   =
 /
    =E2=94=9C=E2=94=80vg_raid10-var (dm-2)  252:2    0 393,1G  0 lvm   =
 /var
    =E2=94=9C=E2=94=80vg_raid10-tmp (dm-3)  252:3    0  46,6G  0 lvm   =
 /tmp
    =E2=94=94=E2=94=80vg_raid10-swap (dm-4) 252:4    0  23,3G  0 lvm   =
 [SWAP]
sr0                          11:0    1   3,7G  0 rom   =20


   Ger=C3=A4t  boot.     Anfang        Ende     Bl=C3=B6cke   Id  Syste=
m
/dev/sda1   *    98435072  3907028991  1904296960   fd  Linux raid auto=
detect

root@kvm15:~# cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan=
, using
# wildcards if desired.
#DEVICE partitions containers

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md/0 metadata=3D1.2 UUID=3D75079a2f:acb8c475:85f8ca43:0ad85c=
4c
name=3Dkvm15:0

# This file was auto-generated on Tue, 17 Feb 2015 15:57:16 +0100
# by mkconf $Id$

root@kvm15:~# mdadm --detail /dev/md/kvm15\:10
/dev/md/kvm15:10:
        Version : 1.2
  Creation Time : Fri Mar  6 10:18:15 2015
     Raid Level : raid10
     Array Size : 3808330752 (3631.91 GiB 3899.73 GB)
  Used Dev Size : 1904165376 (1815.95 GiB 1949.87 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Wed Apr 22 11:42:28 2015
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=3D2
     Chunk Size : 512K

           Name : kvm15:10  (local to host kvm15)
           UUID : c4540426:9c668fe2:479513f2:42d233b4
         Events : 14870

    Number   Major   Minor   RaidDevice State
       5       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       4       8        1        2      active sync   /dev/sda1
       3       8       49        3      active sync   /dev/sdd1
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
