From: Farkas Levente <lfarkas@bppiac.hu>
Subject: somthing wrong in raid5 or in mdadm
Date: Mon, 31 May 2004 15:47:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40BB377A.1030306@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
we try to setup a new server but something is wrong with raid5. although 
we has a few other servers with raid 5 but this start to getting 
strange. just look at this:
-----------------------------------
# cat /proc/mdstat
Personalities : [raid1] [raid5]
read_ahead 1024 sectors
Event: 13
md0 : active raid1 hda2[0] hdc2[1]
       39097664 blocks [2/2] [UU]

md1 : active raid1 hda1[0] hdc1[1]
       1048704 blocks [2/2] [UU]

md2 : active raid5 sde1[7] sdf1[6] sdd1[3] sdc1[2] sdb1[1] sda1[0]
       720321792 blocks level 5, 128k chunk, algorithm 2 [7/5] [UUUU__U]

unused devices: <none>
# mdadm --detail /dev/md2
/dev/md2:
         Version : 00.90.00
   Creation Time : Mon May 24 18:41:31 2004
      Raid Level : raid5
      Array Size : 720321792 (686.95 GiB 737.61 GB)
     Device Size : 120053632 (114.49 GiB 122.93 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Mon May 31 15:37:36 2004
           State : dirty, no-errors
  Active Devices : 5
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1
        3       8       49        3      active sync   /dev/sdd1
        4       0        0        4      faulty removed
        5       0        0        5      faulty removed
        6       8       81        6      active sync   /dev/sdf1
        7       8       65        7      spare   /dev/sde1
            UUID : 7fda241f:5a683e6e:4f22e751:036cd66e
          Events : 0.217
# uname -a; mdadm -V
Linux kek.int.mkk.hu 2.4.21-15.EL.c0 #1 Thu May 13 04:18:33 BST 2004 
i686 i686 i386 GNU/Linux
mdadm - v1.5.0 - 22 Jan 2004
-----------------------------------
why the device is not started sync?
how can be an active "dirty, no-errors" raid 5 from 7 disk working with 
5 disks?
and I can even mount /dev/md2!
what can I do in this case?

another realy strange thing with mdadm at all reboot we've got a 
NewArray and a SparesMissing message for all raid device. why???
yours.

-- 
   Levente                               "Si vis pacem para bellum!"

