From: Alex <mysqlstudent@gmail.com>
Subject: Assembling array with missing members
Date: Mon, 1 Aug 2011 00:51:12 -0400
Message-ID: <CAB1R3sjuUEVAPLgGNdnwnyHVir3bEGOT9iOSdYBz+QSs+2fhaA@mail.gmail.com>
References: <CAB1R3siG=FOXXq5kRx5N8O7ExCiM=0ic0xakYpfKZH1FOROXoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3siG=FOXXq5kRx5N8O7ExCiM=0ic0xakYpfKZH1FOROXoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I have an old fedora server with a raid1 and raid5 array comprised of
four disks. One of the disks just died, and in the process of trying
to replace the disk, the server will for some reason no longer boot. I
think it was a problem with my initrd. I've since replaced the
defective disk (sdd) with a new one and created the fd partitions the
same size as they were originally. Booting from a current rescue CDROM
and trying to use mdadm to reassmble the raid5 array, and I'm having a
problem:

% mdadm --assemble --auto=3Dyes =A0/dev/md1 /dev/sd[abcd]2
mdadm: no RAID superblock on /dev/sdd2
mdadm: /dev/sdd2 has no superblock - assembly aborted

% cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : inactive sda2[0](S) sdb2[2](S) sdc2[1](S)
=A0 =A0 =A02928978624 blocks

md0 : active raid1 sda1[0] sdb1[2] sdc1[1]
=A0 =A0 =A024000 blocks [3/3] [UUU]

It looks like the members of md1 are all (S)pares, correct?

% cat /etc/mdadm.conf
DEVICE /dev/sdb2 /dev/sdd2 /dev/sdc2 /dev/sda2 /dev/sdb1 /dev/sdd1
/dev/sdc1 /dev/sda1
ARRAY /dev/md1 level=3D5 num-devices=3D4
devices=3D/dev/sdd2,/dev/sdc2,/dev/sdb2,/dev/sda2

I recreated the mdadm.conf primarily from memory, but also from some
knowledge from mdadm:
% mdadm -Es
ARRAY /dev/md0 UUID=3D19fa0ce7:7733d970:be048336:6d8b5ba8
ARRAY /dev/md1 UUID=3D912aa422:617ee3db:df65aa69:42b7599e

Here is some information from sda2 in hopes it will provide details on
the array that will be helpful.

% mdadm --examine /dev/sda2
/dev/sda2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 912aa422:617ee3db:df65aa69:42b7599e
=A0Creation Time : Sat Jun 26 16:19:21 2010
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 976326208 (931.10 GiB 999.76 GB)
=A0 =A0 Array Size : 2928978624 (2793.29 GiB 2999.27 GB)
=A0 Raid Devices : 4
=A0Total Devices : 4
Preferred Minor : 1

=A0 =A0Update Time : Sun Jul 31 23:24:25 2011
=A0 =A0 =A0 =A0 =A0State : active
=A0Active Devices : 3
Working Devices : 3
=A0Failed Devices : 1
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 92905b9f - correct
=A0 =A0 =A0 =A0 Events : 1041521

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =
=A0active sync =A0 /dev/sda2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
=A0 3 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0faulty removed

I'm really not sure what to do next and obviously would like to do
everything possible to save the array.

How can I either have mdadm rebuild the array using the new disk or
start in degraded mode so I can rescue the data? Perhaps there's
another option?

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
