From: John Obaterspok <john.obaterspok@gmail.com>
Subject: Several problems with RAID-5 array
Date: Wed, 17 Aug 2011 22:18:32 +0200
Message-ID: <CAOscVdKqkHat3OkwG+NNmvjMMW88D0Viz-pPhJ1sRLVwXBMRYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Powercable to a disk in the 3 disk RAID-5 array got detached and
afterwards mdadm -D shows this drive to be removed. dmesg says it got
kicked out.

I tried to "mdadm /dev/md1 --add /dev/sdb2" and got following message:

mdadm: /dev/sdb2 reports being an active member for /dev/md1, but a
--re-add fails.
mdadm: not performing --add as that would convert /dev/sdb2 in to a spare.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdb2" first.

I then tried "mdadm --zero-superblock /dev/sdb2" and then add again
and this time it says "mdadm: add new device failed for /dev/sdb2 as
4: Invalid argument"

Doing --zero-superblock was perhaps a mistake?

Below are output from -D, -E & dmesg.

Any suggestions on how to fix this is appreciated!

mdadm -D /dev/md1:
==========================================
/dev/md1:
        Version : 1.1
  Creation Time : Thu Jul 28 04:42:34 2011
     Raid Level : raid5
  Used Dev Size : 76798464 (73.24 GiB 78.64 GB)
   Raid Devices : 3
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Wed Aug 17 19:56:26 2011
          State : active, degraded, Not Started
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : Emperor:1
           UUID : 1476569d:f3ed4cbd:8857b4ef:963a1365
         Events : 4535

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       0        0        1      removed
       3       8       34        2      active sync   /dev/sdc2



Examine shows:
==========================================
/dev/sda2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 1476569d:f3ed4cbd:8857b4ef:963a1365
           Name : Emperor:1
  Creation Time : Thu Jul 28 04:42:34 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 153597952 (73.24 GiB 78.64 GB)
     Array Size : 307193856 (146.48 GiB 157.28 GB)
  Used Dev Size : 153596928 (73.24 GiB 78.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : be3c9d27:9bde4921:898c4f41:0ba4d437

    Update Time : Wed Aug 17 19:56:26 2011
       Checksum : 6893fe2a - correct
         Events : 4535

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.A ('A' == active, '.' == missing)
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 1476569d:f3ed4cbd:8857b4ef:963a1365
           Name : Emperor:1
  Creation Time : Thu Jul 28 04:42:34 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 153597952 (73.24 GiB 78.64 GB)
     Array Size : 307193856 (146.48 GiB 157.28 GB)
  Used Dev Size : 153596928 (73.24 GiB 78.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : a9070bf2:7c54f5f1:746375ce:de2dd0d1

    Update Time : Wed Aug 17 19:56:26 2011
       Checksum : 2ace8e05 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.A ('A' == active, '.' == missing)
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 1476569d:f3ed4cbd:8857b4ef:963a1365
           Name : Emperor:1
  Creation Time : Thu Jul 28 04:42:34 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 153597952 (73.24 GiB 78.64 GB)
     Array Size : 307193856 (146.48 GiB 157.28 GB)
  Used Dev Size : 153596928 (73.24 GiB 78.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 5da77abe:0a563117:a281547e:25912628

    Update Time : Wed Aug 17 19:56:26 2011
       Checksum : 22afc26f - correct
         Events : 4535

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.A ('A' == active, '.' == missing)


Dmesg shows this from first md output:
==========================================
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.40-4.fc15.x86_64
(mockbuild@x86-13.phx2.fedoraproject.org) (gcc version 4.6.0 20110530
(Red Hat
..... snip ....
[    2.545929] dracut: Autoassembling MD Raid
[    2.552088] md: md0 stopped.
[    2.553163] md: bind<sdb1>
[    2.553274] md: bind<sdc1>
[    2.553393] md: bind<sda1>
[    2.554462] md: raid1 personality registered for level 1
[    2.555139] bio: create slab <bio-1> at 1
[    2.555205] md/raid1:md0: active with 3 out of 3 mirrors
[    2.555223] md0: detected capacity change from 0 to 314560512
[    2.555448] dracut: mdadm: /dev/md0 has been started with 3 drives.
[    2.555551]  md0: unknown partition table
[    2.573019] md: md1 stopped.
[    2.574614] dracut: mdadm: device 3 in /dev/md1 has wrong state in
superblock, but /dev/sdb2 seems ok
[    2.574718] md: bind<sdc2>
[    2.574806] md: bind<sdb2>
[    2.574946] md: bind<sda2>
[    2.575857] async_tx: api initialized (async)
[    2.576017] xor: automatically using best checksumming function: generic_sse
[    2.580220]    generic_sse: 11108.000 MB/sec
[    2.580222] xor: using function: generic_sse (11108.000 MB/sec)
[    2.597212] raid6: int64x1   2609 MB/s
[    2.614196] raid6: int64x2   2554 MB/s
[    2.631185] raid6: int64x4   2433 MB/s
[    2.648139] raid6: int64x8   1523 MB/s
[    2.665126] raid6: sse2x1    6742 MB/s
[    2.682096] raid6: sse2x2    8253 MB/s
[    2.699074] raid6: sse2x4    9433 MB/s
[    2.699075] raid6: using algorithm sse2x4 (9433 MB/s)
[    2.699671] md: raid6 personality registered for level 6
[    2.699672] md: raid5 personality registered for level 5
[    2.699674] md: raid4 personality registered for level 4
[    2.699840] md/raid:md1: not clean -- starting background reconstruction
[    2.699847] md/raid:md1: device sda2 operational as raid disk 0
[    2.699849] md/raid:md1: device sdc2 operational as raid disk 2
[    2.700190] md/raid:md1: allocated 3230kB
[    2.700252] md/raid:md1: cannot start dirty degraded array.
[    2.700257] RAID conf printout:
[    2.700259]  --- level:5 rd:3 wd:2
[    2.700261]  disk 0, o:1, dev:sda2
[    2.700262]  disk 2, o:1, dev:sdc2
[    2.700431] md/raid:md1: failed to run raid set.
[    2.700432] md: pers->run() failed ...
[    2.700581] dracut: mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
[    2.700629] dracut: mdadm: Not enough devices to start the array
while not clean - consider --force.
[   23.380066] dracut Warning: No root device
"block:/dev/disk/by-uuid/b1972b2e-cf42-4f49-be51-07fd32467000" found
