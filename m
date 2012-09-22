From: Alexander =?iso-8859-1?b?S/xobg==?= <alexander.kuehn@nagilum.de>
Subject: sync action not working/ignored
Date: Sun, 23 Sep 2012 00:27:34 +0200
Message-ID: <20120923002734.Horde.j1X3SZk8pphQXjtWHRF5P_A@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
for some reason linux appears to be ignoring my sync_action requests:
root@nas:~# uname -a
Linux nas 3.5.4 #1 SMP Sat Sep 15 15:41:21 CEST 2012 x86_64 GNU/Linux
root@nas:~# echo /sys/block/md*/md/sync_action
/sys/block/md1/md/sync_action
root@nas:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6] sde[8]  
sdc[2] sda[1]
       11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2  
[7/7] [UUUUUUU]
       bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>
root@nas:~# echo check >/sys/block/md1/md/sync_action
root@nas:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6] sde[8]  
sdc[2] sda[1]
       11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2  
[7/7] [UUUUUUU]
       bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>
root@nas:~# echo repair >/sys/block/md1/md/sync_action
root@nas:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6] sde[8]  
sdc[2] sda[1]
       11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2  
[7/7] [UUUUUUU]
       bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>
root@nas:~# mdadm -Q --detail /dev/md1
/dev/md1:
         Version : 1.2
   Creation Time : Thu Sep  9 20:43:43 2010
      Raid Level : raid5
      Array Size : 11719408128 (11176.50 GiB 12000.67 GB)
   Used Dev Size : 1953234688 (1862.75 GiB 2000.11 GB)
    Raid Devices : 7
   Total Devices : 7
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Sat Sep 22 23:28:50 2012
           State : active
  Active Devices : 7
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : nas:1  (local to host nas)
            UUID : 5dbc572f:0e6b18bd:125db183:3511c054
          Events : 109708

     Number   Major   Minor   RaidDevice State
        5       8       16        0      active sync   /dev/sdb
        1       8        0        1      active sync   /dev/sda
        2       8       32        2      active sync   /dev/sdc
        8       8       64        3      active sync   /dev/sde
        6       8       80        4      active sync   /dev/sdf
        7       8       48        5      active sync   /dev/sdd
        9       8       96        6      active sync   /dev/sdg

Nothing in dmesg/syslog.
No idea what's going on. :(
Alex.
