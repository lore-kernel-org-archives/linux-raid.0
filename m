From: "Kurt Schmitt" <kurt_schmitt@gmx.de>
Subject: Check after raid6 failure
Date: Thu, 14 Jun 2012 13:29:55 +0200
Message-ID: <20120614112955.286290@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am running a raid6 with 8 drives (no spares) and I am recovering after a controller failure that removed 3 of the drives (ATA Bus error). The state of the raid after this is obvious:

md7 : active raid6 sdg1[2] sdf1[8] sdd1[1] sdn1[7] sde1[0]
      11721071616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/5] [UUU___UU]

After exchanging the controller, I verified that the raid superblocks of the devices are still intact, but the superblock state was inconsistent. The removed drives were marked "active" and had a lower event count, whereas the other drives were "clean" with higher event count. I reassembled the array with this command:
mdadm --assemble --force /dev/md7 /dev/sd[befghijk]1

This  removed the faulty flags and reset the event counts. I switched the raid to --readonly immediately, and ran a filesystem check (which found a few non-critical errors, such as unused inodes, block bitmap differences and wrong free block counts). The detail/examine of the current state is below [2].

I have the following questions:
1. From the perspective of raid data integrity (parity), is it safe to continue operating the raid now and fix the file system errors and verify the actual data in the files?
In particular, I have read at [1] that when skipping the initial sync, parity data on the disks will stay wrong even after it is rewritten. Does the same apply when doing assemble --force ?

2. I have been trying to run a "check" sync_action on the raid (in read-only mode), to find out if there are mismatches, but it does not start. The sync_action is "idle" immediately after the "echo checked > sync_action" and /proc/mdstat does not report any change. There is nothing in dmesg either.

3. What other steps can / should I take before continuing raid usage (read-write), especially repair on the file system level?


Thank you,

Kurt

[1] https://raid.wiki.kernel.org/index.php/Initial_Array_Creation#raid5

[2] I am running a 3.2.2 kernel with mdadm 3.1.4.

The current state of the raid is displayed below:
md7 : active (read-only) raid6 sdf1[0] sdj1[7] sdg1[8] sdk1[6] sdb1[5] sdi1[4] sdh1[2] sde1[1]
      11721071616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]

mdadm --detail /dev/md7 
/dev/md7:
        Version : 1.2
  Creation Time : <redacted>
     Raid Level : raid6
     Array Size : 11721071616 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Mon Jun 11 19:18:33 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : <redacted>
           UUID : <redacted>
         Events : 79713

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       65        1      active sync   /dev/sde1
       2       8      113        2      active sync   /dev/sdh1
       4       8      129        3      active sync   /dev/sdi1
       5       8       17        4      active sync   /dev/sdb1
       6       8      161        5      active sync   /dev/sdk1
       8       8       97        6      active sync   /dev/sdg1
       7       8      145        7      active sync   /dev/sdj1



/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : <redacted>

    Update Time : Mon Jun 11 10:13:08 2012
       Checksum : d207eb78 - correct
         Events : 79712

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAA ('A' == active, '.' == missing)

/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : <redacted>

    Update Time : Mon Jun 11 19:18:33 2012
       Checksum : cea4ea72 - correct
         Events : 79713

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA...AA ('A' == active, '.' == missing)

/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : <redacted>

    Update Time : Mon Jun 11 19:18:33 2012
       Checksum : 73e3de3b - correct
         Events : 79713

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAA ('A' == active, '.' == missing)

/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : <redacted>

    Update Time : Mon Jun 11 19:18:33 2012
       Checksum : b7ef499c - correct
         Events : 79713

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAA...AA ('A' == active, '.' == missing)

/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : <redacted>

    Update Time : Mon Jun 11 19:18:33 2012
       Checksum : c75d3da5 - correct
         Events : 79713

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA...AA ('A' == active, '.' == missing)

/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : <redacted>

    Update Time : Mon Jun 11 10:13:08 2012
       Checksum : 1a292902 - correct
         Events : 79712

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAA ('A' == active, '.' == missing)

/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : <redacted>

    Update Time : Mon Jun 11 19:18:33 2012
       Checksum : 6f7b11b7 - correct
         Events : 79713

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAA...AA ('A' == active, '.' == missing)

/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : <redacted>
           Name : <redacted>
  Creation Time : <redacted>
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442143232 (11178.09 GiB 12002.38 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : <redacted>

    Update Time : Mon Jun 11 10:13:08 2012
       Checksum : a2773548 - correct
         Events : 79712

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAA ('A' == active, '.' == missing)

-- 
NEU: FreePhone 3-fach-Flat mit kostenlosem Smartphone!                                  
Jetzt informieren: http://mobile.1und1.de/?ac=OM.PW.PW003K20328T7073a
