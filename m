From: Claude Nobs <claudenobs@blunet.cc>
Subject: Likely forced assemby with wrong disk during raid5 grow. Recoverable?
Date: Sun, 20 Feb 2011 04:23:09 +0100
Message-ID: <AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I was wondering if someone might be willing to share if this array is
recoverable.

I had a clean, running raid5 using 4 block devices (two of those were
2 disk raid0 md devices) in RAID 5. Last night I decided it was safe
to grow the array by one disk. But then a) a disk failed, b) a power
loss occured, c) i probably switched the wrong disk and forced
assembly, resulting in an inconsistent state. Here is a complete set
of actions taken :

> bernstein@server:~$ sudo mdadm --grow --raid-devices=3D5 --backup-fil=
e=3D/raid.grow.backupfile /dev/md2
> mdadm: Need to backup 768K of critical section..
> mdadm: ... critical section passed.
> bernstein@server:~$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
> md1 : active raid0 sdg1[1] sdf1[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chunks
>
> md2 : active raid5 sda1[5] md0[4] md1[3] sdd1[1] sdc1[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2930281920 blocks super 1.2 level 5, 6=
4k chunk, algorithm 2 [5/5] [UUUUU]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [>....................]=C2=A0 reshape =
=3D=C2=A0 1.6% (16423164/976760640) finish=3D902.2min speed=3D17739K/se=
c
>
> md0 : active raid0 sdh1[0] sdb1[1]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chunks
>
> unused devices: <none>


now i thought /dev/sdg1 failed. unfortunately i have no log for this
one, just my memory of seeing this changed to the one above :

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2930281920 blocks super 1.2 level 5, 6=
4k chunk, algorithm 2 [4/5] [UU_UU]

some 10 minutes later a power loss occurred, thanks to an ups the
server shut down as with 'shutdown -h now'. now i exchanged /dev/sdg1,
rebooted and in a lapse of judgement forced assembly:

> bernstein@server:~$ sudo mdadm --assemble --run /dev/md2 /dev/md0 /de=
v/sda1 /dev/sdc1 /dev/sdd1
> mdadm: Could not open /dev/sda1 for write - cannot Assemble array.
> mdadm: Failed to restore critical section for reshape, sorry.
>
> bernstein@server:~$ sudo mdadm --detail /dev/md2
> /dev/md2:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 01.02
> =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
> =C2=A0 Used Dev Size : 976760640 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0 Raid Devices : 5
> =C2=A0 Total Devices : 3
> Preferred Minor : 3
> =C2=A0=C2=A0=C2=A0 Persistence : Superblock is persistent
>
> =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : active=
, degraded, Not Started
> =C2=A0Active Devices : 3
> Working Devices : 3
> =C2=A0Failed Devices : 0
> =C2=A0 Spare Devices : 0
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmet=
ric
> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>
> =C2=A0 Delta Devices : 1, (4->5)
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : m=
aster:public
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 UUID : c=
3b6db19:b61c3ba9:0a74b12b:3041a523
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>
> =C2=A0=C2=A0=C2=A0 Number=C2=A0=C2=A0 Major=C2=A0=C2=A0 Minor=C2=A0=C2=
=A0 RaidDevice State
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 33=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=A0=
 /dev/sdc1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removed
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 removed
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 9=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=
=A0 /dev/block/9:0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 4=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=
=A0 /dev/sda1

so i reattached the old disk, got /dev/md1 back and did the
investigation i should have done before :

> bernstein@server:~$ sudo mdadm --examine /dev/sdd1
> /dev/sdd1:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4e=
fc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
> =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041=
a523
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : m=
aster:public
> =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
> =C2=A0=C2=A0 Raid Devices : 5
>
> =C2=A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 4000.81=
 GB)
> =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
> =C2=A0=C2=A0 Super Offset : 8 sectors
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
> =C2=A0=C2=A0=C2=A0 Device UUID : 5e37fc7c:50ff3b50:de3755a1:6bdbebc6
>
> =C2=A0 Reshape pos'n : 489510400 (466.83 GiB 501.26 GB)
> =C2=A0 Delta Devices : 1 (4->5)
>
> =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:23:09 2011
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : fd0c1794 - correct
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133567
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmet=
ric
> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>
> =C2=A0=C2=A0=C2=A0 Array Slot : 1 (0, 1, failed, 2, 3, 4)
> =C2=A0=C2=A0 Array State : uUuuu 1 failed
> bernstein@server:~$ sudo mdadm --examine /dev/sda1
> /dev/sda1:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4e=
fc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
> =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041=
a523
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : m=
aster:public
> =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
> =C2=A0=C2=A0 Raid Devices : 5
>
> =C2=A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 4000.81=
 GB)
> =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
> =C2=A0=C2=A0 Super Offset : 8 sectors
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
> =C2=A0=C2=A0=C2=A0 Device UUID : baebd175:e4128e4c:f768b60f:4df18f77
>
> =C2=A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
> =C2=A0 Delta Devices : 1 (4->5)
>
> =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 12c832c6 - correct
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmet=
ric
> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>
> =C2=A0=C2=A0=C2=A0 Array Slot : 5 (0, failed, failed, failed, 3, 4)
> =C2=A0=C2=A0 Array State : u__uU 3 failed
> bernstein@server:~$ sudo mdadm --examine /dev/sdc1
> /dev/sdc1:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4e=
fc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
> =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041=
a523
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : m=
aster:public
> =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
> =C2=A0=C2=A0 Raid Devices : 5
>
> =C2=A0Avail Dev Size : 1953521392 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 4000.81=
 GB)
> =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
> =C2=A0=C2=A0 Super Offset : 8 sectors
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
> =C2=A0=C2=A0=C2=A0 Device UUID : 82f5284a:2bffb837:19d366ab:ef2e3d94
>
> =C2=A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
> =C2=A0 Delta Devices : 1 (4->5)
>
> =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 8aa7d094 - correct
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmet=
ric
> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>
> =C2=A0=C2=A0=C2=A0 Array Slot : 0 (0, failed, failed, failed, 3, 4)
> =C2=A0=C2=A0 Array State : U__uu 3 failed
> bernstein@server:~$ sudo mdadm --examine /dev/md0
> /dev/md0:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4e=
fc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
> =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041=
a523
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : m=
aster:public
> =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
> =C2=A0=C2=A0 Raid Devices : 5
>
> =C2=A0Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)
> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 4000.81=
 GB)
> =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
> =C2=A0=C2=A0 Super Offset : 8 sectors
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
> =C2=A0=C2=A0=C2=A0 Device UUID : 83ecd60d:f3947a5e:a69c4353:3c4a0893
>
> =C2=A0 Reshape pos'n : 502815488 (479.52 GiB 514.88 GB)
> =C2=A0 Delta Devices : 1 (4->5)
>
> =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:32:04 2011
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 1bbf913b - correct
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133609
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmet=
ric
> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>
> =C2=A0=C2=A0=C2=A0 Array Slot : 4 (0, failed, failed, failed, 3, 4)
> =C2=A0=C2=A0 Array State : u__Uu 3 failed
> bernstein@server:~$ sudo mdadm --examine /dev/md1
> /dev/md1:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Magic : a92b4e=
fc
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1.2
> =C2=A0=C2=A0=C2=A0 Feature Map : 0x4
> =C2=A0=C2=A0=C2=A0=C2=A0 Array UUID : c3b6db19:b61c3ba9:0a74b12b:3041=
a523
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Name : m=
aster:public
> =C2=A0 Creation Time : Sat Jan 22 00:15:43 2011
> =C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid5
> =C2=A0=C2=A0 Raid Devices : 5
>
> =C2=A0Avail Dev Size : 1953541616 (931.52 GiB 1000.21 GB)
> =C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 7814085120 (3726.05 GiB 4000.81=
 GB)
> =C2=A0 Used Dev Size : 1953521280 (931.51 GiB 1000.20 GB)
> =C2=A0=C2=A0=C2=A0 Data Offset : 272 sectors
> =C2=A0=C2=A0 Super Offset : 8 sectors
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 State : clean
> =C2=A0=C2=A0=C2=A0 Device UUID : 3c7e2c3f:8b6c7c43:a0ce7e33:ad680bed
>
> =C2=A0 Reshape pos'n : 502809856 (479.52 GiB 514.88 GB)
> =C2=A0 Delta Devices : 1 (4->5)
>
> =C2=A0=C2=A0=C2=A0 Update Time : Sat Feb 19 22:30:29 2011
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Checksum : 6c591e90 - correct
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Events : 133603
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Layout : left-symmet=
ric
> =C2=A0=C2=A0=C2=A0=C2=A0 Chunk Size : 64K
>
> =C2=A0=C2=A0=C2=A0 Array Slot : 3 (0, failed, failed, 2, 3, 4)
> =C2=A0=C2=A0 Array State : u_Uuu 2 failed

so obviously not /dev/sdd1 failed. however (due to that silly forced
assembly?!) the reshape pos'n field of md0, sd[ac]1 differs from md1 a
few bytes, resulting in an inconsistent state...

> bernstein@server:~$ sudo mdadm --assemble /dev/md2 /dev/sda1 /dev/md0=
 /dev/md1 /dev/sdd1 /dev/sdc1
>
> mdadm: /dev/md2 assembled from 3 drives - not enough to start the arr=
ay.
> bernstein@server:~$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
> md2 : inactive sdc1[0](S) sda1[5](S) md0[4](S) md1[3](S) sdd1[1](S)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4883823704 blocks super 1.2
>
> md1 : active raid0 sdf1[0] sdg1[1]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chunks
>
> md0 : active raid0 sdb1[1] sdh1[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 976770944 blocks super 1.2 64k chunks
>
> unused devices: <none>

i do have a backup but since recovery from it takes a few days, i'd
like to know if there is a way to recover the array or if it's
completely lost.

Any suggestions gratefully received,

claude
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
