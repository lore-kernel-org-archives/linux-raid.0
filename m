From: Pol Hallen <raid1@fuckaround.org>
Subject: mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
Date: Sat, 11 Jun 2011 14:36:56 +0200
Message-ID: <201106111436.56379.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all :-)

after disks problems now I can't assemble my array:

mdadm -A --force /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sda
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

mdadm -S /dev/md0 and try to assemble same error..

mdadm -E /dev/sda
 
 Magic : a92b4efc
        Version : 0.90.00
           UUID : 9bd6372e:e2eab1d5:d2bdc3cb:ad12f41d
  Creation Time : Mon Sep 27 14:19:15 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Jun 11 13:59:43 2011
          State : active
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 99b0bd41 - correct
         Events : 701273

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       80        3      active sync   /dev/sdf

   0     0       0        0        0      removed
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       80        3      active sync   /dev/sdf
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       0        0        5      faulty removed
   6     6       8       49        6      spare   /dev/sdd1

how start my array?

thanks!

Pol
