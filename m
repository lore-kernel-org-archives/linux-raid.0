From: Michael Schmitt <mschmitt@unixkiste.org>
Subject: confusion about partitionable md arrays
Date: Tue, 26 Dec 2006 20:27:08 +0100
Message-ID: <1167161228.3918.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

since recent releases obviously it is possible to build an array and
partition that instead of building an array out of partitions. This was
somehow confusing but it worked in the first place. Now I moved the
array from one machine to another and... now it gets somehow strange. I
have nothing in /dev/md/ but /dev/md0. If I do fdisk -l it lists the
partitions /dev/md0p1 to /dev/md0p4, set to type 83 but there are no
devices under /dev/ or in /proc/partitions for them. I've read the
archives and googled around but there was no real solution just
different meanings on how it should be and how such things come. I'd
really appreciate a definite answer how that should work with
partitionable arrays and in best cases, what my problem may be here :)

At the end of this mail are the mdstat and mdadm outputs for reference

greetings and TIA
Michael

sinope:/home/mschmitt# mdadm --query /dev/md0
/dev/md0: 114.50GiB raid1 2 devices, 0 spares. Use mdadm --detail for
more detail.

sinope:/home/mschmitt# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid5] [raid4]
[raid6] [raid10]
md0 : active raid1 sda[0] sdb[1]
      120060800 blocks [2/2] [UU]

unused devices: <none>

sinope:/home/mschmitt# mdadm --examine /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4e832cd9:3e667457:cde5475c:8813896e
  Creation Time : Wed Oct  4 18:35:54 2006
     Raid Level : raid1
    Device Size : 120060800 (114.50 GiB 122.94 GB)
     Array Size : 120060800 (114.50 GiB 122.94 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Dec 26 01:43:01 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 1dea11f0 - correct
         Events : 0.236


      Number   Major   Minor   RaidDevice State
this     0       8        0        0      active sync   /dev/sda

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb

