From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Multiple disk failure, but slot numbers are corrupt and preventing assembly.
Date: Mon, 23 Apr 2007 19:17:21 +0200
Message-ID: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

it's recovery time again. Problem at hand: raid5 consisting of four
partitions, each on a drive. Two disks have failed. Assembly fails
because the slot numbers of the array components seem to be corrupt.

/dev/md0 consisting of /dev/sd[abcd]1, of which b,c failed and of
which c seems really bad in SMART, b looks reasonably OK judging from
SMART.

Checksum of the failed component superblocks was bad.

Using mdadm.conf we have already tried updating the superblocks. This
partly succeeded in the sense that checksums came up ok, the slot
numbers did not.

mdadm refuses to assemble, even with --force.

Could you guys peek over the array configuration (mdadm --examine) and
see if there is a non-destructive way to try and mount the array. If
not, what is the least intrusive way to do a non-syncing (re)create?

Data recovery is our prime concern here.

Below the uname -a, --examine output of all four drives, mdadm.conf of
what we think the array should look like and finally, the mdadm
--assemble command and output.

Note the slot numbers on /dev/sd[bc].

Thanks for any help,

with kind regards,

Leon Woestenberg




Linux localhost 2.6.16.14-axon1 #1 SMP PREEMPT Mon May 8 17:01:33 CEST
2006 i486 pentium4 i386 GNU/Linux

[root@localhost ~]# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 51a95144:00af4c77:c1cd173b:94cb1446
  Creation Time : Mon Sep  5 13:16:42 2005
     Raid Level : raid5
    Device Size : 390620352 (372.52 GiB 400.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Apr 17 07:03:46 2007
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f98ed71b - correct
         Events : 0.115909229

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
[root@localhost ~]# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 51a95144:00af4c77:c1cd173b:94cb1446
  Creation Time : Mon Sep  5 13:16:42 2005
     Raid Level : raid5
    Device Size : 390620352 (372.52 GiB 400.00 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Tue Apr 17 07:03:46 2007
          State : clean
 Active Devices : 5
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e6d35288 - correct
         Events : 0.115909230

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this -11221199   -1288577935    -1551230943    2035285809      faulty
active removed

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
[root@localhost ~]# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 51a95144:00af4c77:c1cd173b:94cb1446
  Creation Time : Mon Sep  5 13:16:42 2005
     Raid Level : raid5
    Device Size : 390620352 (372.52 GiB 400.00 GB)
   Raid Devices : 4
  Total Devices : 9
Preferred Minor : 0

    Update Time : Tue Apr 17 07:03:46 2007
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 33e911c - correct
         Events : 0.115909230

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this 1038288281   293191225    29538921    -2128142983      faulty
active write-mostly

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
[root@localhost ~]# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 51a95144:00af4c77:c1cd173b:94cb1446
  Creation Time : Mon Sep  5 13:16:42 2005
     Raid Level : raid5
    Device Size : 390620352 (372.52 GiB 400.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Apr 17 07:03:46 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 7779c2 - correct
         Events : 0.115909230

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
[root@localhost ~]#

[root@localhost ~]# cat /tmp/mdadm.conf
DEVICE /dev/sda1 /dev/sdb1/ /dev/sdc1 /dev/sdd1
ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1

[root@localhost ~]# mdadm -v --assemble --scan --config=/tmp/mdadm.conf --force
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 2035285809.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot -2128142983.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 3.
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: added /dev/sdd1 to /dev/md0 as 3
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.




-- 
Leon
