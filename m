From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Grow error - WTF!?
Date: Sat, 17 Jul 2010 16:38:36 -0500
Message-ID: <38.F8.07625.5E2224C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


OK, this is bizarre:

Backup:/# mdadm -G -v -n 10 --backup-file=/GrowRAID.fil /dev/md0
mdadm: Need to backup 4503599627313152K of critical section..
mdadm: /dev/md0: Something wrong - reshape aborted

A 4 Million Terabyte critical section?  I don't think so.  This isn't the
first time the array have been grown - indeed it has been grown quite a few
times.  It is, however, the first time the array has been grown since
upgrading to mdadm 3.1.2 and kernel 2.6.32-3 on this machine.  Did I forget
something on the command line?  The CV:

Backup:~# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Mon May 31 16:23:10 2010
     Raid Level : raid6
     Array Size : 10255960064 (9780.85 GiB 10502.10 GB)
  Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)
   Raid Devices : 9
  Total Devices : 10
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Jul 17 16:34:57 2010
          State : active
 Active Devices : 9
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 1024K

           Name : Backup:0  (local to host Backup)
           UUID : 431244d6:45d9635a:e88b3de5:92f30255
         Events : 132701

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       6       8       96        6      active sync   /dev/sdg
       7       8      112        7      active sync   /dev/sdh
       8       8      128        8      active sync   /dev/sdi

       9       8      144        -      spare   /dev/sdj


Backup:~# mdadm --examine /dev/sdj
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 431244d6:45d9635a:e88b3de5:92f30255
           Name : Backup:0  (local to host Backup)
  Creation Time : Mon May 31 16:23:10 2010
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 20511920128 (9780.85 GiB 10502.10 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 70ebdc42:491186dc:0e72e7ef:504363af

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Jul 17 16:35:06 2010
       Checksum : 640783ec - correct
         Events : 132703

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : spare
   Array State : AAAAAAAAA ('A' == active, '.' == missing)

