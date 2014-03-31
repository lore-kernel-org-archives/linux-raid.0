From: bobzer <bobzer@gmail.com>
Subject: strange status raid 5
Date: Mon, 31 Mar 2014 10:08:30 -0400
Message-ID: <CADzS=apR=2D=t47wS9PBHzEdeOS96LE-CbTEBxnd9BLj_=f7jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

My raid 5 is in a strange state. the mdstat tell me is degraded, but
when i check the disk that should be in the raid anymore it tell me
everything is right ... I'm lost

#cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdc1[3] sdd1[1]
     3907021568 blocks super 1.2 level 5, 128k chunk, algorithm 2 [3/2] [UU_]

unused devices: <none>


so my third disk is unused i check with :

#mdadm -D /dev/md0
/dev/md0:
       Version : 1.2
 Creation Time : Sun Mar  4 22:49:14 2012
    Raid Level : raid5
    Array Size : 3907021568 (3726.03 GiB 4000.79 GB)
 Used Dev Size : 1953510784 (1863.01 GiB 2000.40 GB)
  Raid Devices : 3
 Total Devices : 2
   Persistence : Superblock is persistent

   Update Time : Sun Mar 30 23:01:35 2014
         State : clean, degraded
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

        Layout : left-symmetric
    Chunk Size : 128K
          Name : debian:0
          UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
        Events : 255801

   Number   Major   Minor   RaidDevice State
      3       8       33        0      active sync   /dev/sdc1
      1       8       49        1      active sync   /dev/sdd1
      2       0        0        2      removed


after verify what says the disk i got confuse :


#mdadm --examine /dev/sdb1
/dev/sdb1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
          Name : debian:0
 Creation Time : Sun Mar  4 22:49:14 2012
    Raid Level : raid5
  Raid Devices : 3

Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
    Array Size : 7814043136 (3726.03 GiB 4000.79 GB)
 Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : f9059dfb:74af1ab7:bc1465b1:e2ff30ba

   Update Time : Sun Jan  5 04:11:41 2014
 Bad Block Log : 512 entries available at offset 2032 sectors
      Checksum : 7df1fefc - correct
        Events : 436
        Layout : left-symmetric
    Chunk Size : 128K

  Device Role : Active device 2
  Array State : AAA ('A' == active, '.' == missing)


so there i tried to re-add the disk that doesn't works
so i tred to stop the raid and assemble it again but it doesn't work either

#mdadm --stop /dev/md0
#mdadm --assemble --force /dev/md0 /dev/sd[bcd]1
mdadm: /dev/md0 has been started with 2 drives (out of 3).


can you help me guys ?


Thanks by advance

ps: i've got mdadm 3.3-devel i would update it but don't how to do ...
