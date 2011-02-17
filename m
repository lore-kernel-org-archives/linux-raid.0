From: Matt Tehonica <matt.tehonica@mac.com>
Subject: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 19:24:41 -0500
Message-ID: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I converted my RAID5 from 8 disks to 6 disks using "mdadm --grow /dev/md0 --array-size" and then "mdadm --grow /dev/md0 --raid-devices=6" and after rebooting, it won't mount.  It has been running fine for about a year.  File system is XFS.  Here is some info on it....

mtehonica@ghostrider:~$ sudo mdadm -D /dev/md0 
/dev/md0:
        Version : 1.01
  Creation Time : Mon Dec 21 19:40:58 2009
     Raid Level : raid5
     Array Size : 7325690880 (6986.32 GiB 7501.51 GB)
  Used Dev Size : 1465138176 (1397.26 GiB 1500.30 GB)
   Raid Devices : 6
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Wed Feb 16 19:13:50 2011
          State : clean
 Active Devices : 6
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 512K

           Name : ghostrider:0  (local to host ghostrider)
           UUID : b4ba7316:08976ceb:3ab7af7b:430ff147
         Events : 327264

    Number   Major   Minor   RaidDevice State
       0       8       80        0      active sync   /dev/sdf
       1       8       16        1      active sync   /dev/sdb
       3       8       64        2      active sync   /dev/sde
       4       8       48        3      active sync   /dev/sdd
       5       8        0        4      active sync   /dev/sda
       8       8      112        5      active sync   /dev/sdh

       6       8      144        -      spare   /dev/sdj
       7       8      128        -      spare   /dev/sdi


mtehonica@ghostrider:~$ sudo mdadm -E /dev/sda 
/dev/sda:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : b4ba7316:08976ceb:3ab7af7b:430ff147
           Name : ghostrider:0  (local to host ghostrider)
  Creation Time : Mon Dec 21 19:40:58 2009
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 2930276904 (1397.26 GiB 1500.30 GB)
     Array Size : 14651381760 (6986.32 GiB 7501.51 GB)
  Used Dev Size : 2930276352 (1397.26 GiB 1500.30 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 83ff92c5:b7acdfcd:d3ace2b5:0ac3549a

    Update Time : Wed Feb 16 19:13:52 2011
       Checksum : 5053499e - correct
         Events : 327264

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing)


mtehonica@ghostrider:~$ sudo mount /dev/md0 /test
mount: /dev/md0: can't read superblock


I tried running xfs_repair and it will just run forever and says "............................found candidate secondary superblock...
error reading superblock 80 -- seek to offset 7501512704000 failed
unable to verify superblock, continuing...
..........................................................................................................................................".  

Any insight/help on this would be appreciated!

Thanks in advance!
Matt
