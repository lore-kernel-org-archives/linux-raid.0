From: Sam Bingner <sam@bingner.com>
Subject: Reshape Shrink Hung Again
Date: Fri, 19 Apr 2013 08:29:37 +0000
Message-ID: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <5E892D8EBF7CE84AAEAF7ED8A608E144@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'll start this off by saying that no data is in jeopardy, but I would like to track down the cause of this problem and fix it.  I originally thought it must have been due to the incorrect backup-file size with a raid array shrunk to smaller than the final size when it happened to me last time but this time this was not the case.

I initiated a shrink from a 4-drive RAID5 to a 3-drive RAID5, this shrink had no problems except that a drive failed right at the end of the reshape... then it hung at 99.9% and does not allow me to remove the failed drive from the array because it is "rebuilding".  I am not sure if the drive failed at the end, or if it was after it had gotten to 99.9% because I didn't see this until the next morning as it ran overnight.

Sam

root@fs:/var/log# uname -a
Linux fs 2.6.32-5-686 #1 SMP Mon Jan 16 16:04:25 UTC 2012 i686 GNU/Linux

Apr 17 22:37:41 fs kernel: [25860779.639762] md1: detected capacity change from 749122093056 to 499414728704
Apr 17 22:38:40 fs kernel: [25860837.912441] md: reshape of RAID array md1
Apr 17 22:38:40 fs kernel: [25860837.912447] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Apr 17 22:38:40 fs kernel: [25860837.912452] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
Apr 17 22:38:40 fs kernel: [25860837.912459] md: using 128k window, over a total of 243854848 blocks.
Apr 18 07:51:09 fs kernel: [25893987.273813] raid5: Disk failure on sda2, disabling device.
Apr 18 07:51:09 fs kernel: [25893987.273815] raid5: Operation continuing on 2 devices.
Apr 18 07:51:09 fs kernel: [25893987.287168] md: super_written gets error=-5, uptodate=0
Apr 18 07:51:10 fs kernel: [25893987.657039] md: md1: reshape done.
Apr 18 07:51:10 fs kernel: [25893987.781599] md: reshape of RAID array md1
Apr 18 07:51:10 fs kernel: [25893987.781607] md: minimum _guaranteed_  speed: 100 KB/sec/disk.
Apr 18 07:51:10 fs kernel: [25893987.781613] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
Apr 18 07:51:10 fs kernel: [25893987.781620] md: using 128k window, over a total of 243854848 blocks.


md1 : active raid5 sdd2[3] sda2[0](F) sdc2[2] sdb2[4]
      487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [_UU]
      [===================>.]  reshape = 99.9% (243853824/243854848) finish=343.6min speed=0K/sec


root@fs:/# mdadm --remove /dev/md1 /dev/sda2
mdadm: hot remove failed for /dev/sda2: Device or resource busy

root@fs:/# mdadm --manage /dev/md1 --force --remove /dev/sda2
mdadm: hot remove failed for /dev/sda2: Device or resource busy

root@fs:/var/log# ls -l /boot/backup.md 
-rw------- 1 root root 3146240 Apr 17 22:38 /boot/backup.md

root@fs:/var/log# hexdump /boot/backup.md 
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0300200


root@fs:/# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Fri Feb 10 21:45:46 2012
     Raid Level : raid5
     Array Size : 487709696 (465.12 GiB 499.41 GB)
  Used Dev Size : 243854848 (232.56 GiB 249.71 GB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Thu Apr 18 21:37:48 2013
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

 Reshape Status : 99% complete
  Delta Devices : -1, (3->2)

           Name : fs:1  (local to host fs)
           UUID : 9d7e8a08:030af4f8:e653c46c:af2c84fe
         Events : 33773764

    Number   Major   Minor   RaidDevice State
       0       8        2        0      faulty spare rebuilding   /dev/sda2
       4       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2

       3       8       50        3      active sync   /dev/sdd2


/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 9d7e8a08:030af4f8:e653c46c:af2c84fe
           Name : fs:1  (local to host fs)
  Creation Time : Fri Feb 10 21:45:46 2012
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 487710720 (232.56 GiB 249.71 GB)
     Array Size : 975419392 (465.12 GiB 499.41 GB)
  Used Dev Size : 487709696 (232.56 GiB 249.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 13cefd7d:7bb42450:c229d326:a41b9ba7

  Reshape pos'n : 2048
  Delta Devices : -1 (4->3)

    Update Time : Fri Apr 19 04:22:40 2013
       Checksum : 2f033b35 - correct
         Events : 33786736

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .AAA ('A' == active, '.' == missing)

