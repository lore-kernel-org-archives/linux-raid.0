From: Michael Evans <mjevans1983@gmail.com>
Subject: Growing raid 5 to 6; /proc/mdstat reports a strange value?
Date: Sun, 24 Jan 2010 19:49:31 -0800
Message-ID: <4877c76c1001241949p20089932saae123a1c2871ac0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdX : active raid5 sdd1[8](S) sdb1[7](S) sdf8[0] sdl8[4] sdk2[5]
sdc1[6] sdj6[3] sdi8[1]
     Y blocks super 1.1 level 5, 128k chunk, algorithm 2 [6/6] [UUUUUU]

# mdadm --grow /dev/mdX --level=6 --raid-devices=8
--backup-file=/root/mdX.backupfile

mdX : active raid6 sdd1[8] sdb1[7] sdf8[0] sdl8[4] sdk2[5] sdc1[6]
sdj6[3] sdi8[1]
     Y blocks super 1.1 level 6, 128k chunk, algorithm 18 [8/9] [UUUUUU_U]
     [>....................]  reshape =  0.0% (33920/484971520)
finish=952.6min speed=8480K/sec

!!! mdadm 3.1.1 I wanted an 8 device raid-6;  Why do you show 9?

What is it showing me now???

blocks super 1.1 level 6, 128k chunk, algorithm 2 [8/10] [UUUUUUUU]

mdadm --detail /dev/mdX
/dev/mdX:
       Version : 1.01
    Raid Level : raid6
    Array Size : 6z ()
 Used Dev Size : z ()
  Raid Devices : 8
 Total Devices : 8
   Persistence : Superblock is persistent

   Update Time : Sun Jan 24 14:40:32 2010
         State : clean
Active Devices : 8
Working Devices : 8
Failed Devices : 0
 Spare Devices : 0

        Layout : left-symmetric
    Chunk Size : 128K

   Number   Major   Minor   RaidDevice State
      0       8        .        0      active sync   /dev/sdf
      1       8        .        1      active sync   /dev/sdi
      3       8        .        2      active sync   /dev/sdj
      6       8        .        3      active sync   /dev/sdc
      5       8        .        4      active sync   /dev/sdk
      4       8        .        5      active sync   /dev/sdl
      8       8        .        6      active sync   /dev/sdd
      7       8        .        7      active sync   /dev/sdb

... Did it actually do what I want but just show me the wrong result
with kernel 2.6.32-gentoo-r2
