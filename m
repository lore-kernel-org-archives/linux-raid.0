From: Thomas Heilberg <theilberg42@gmail.com>
Subject: Raid 5 rebuild with only 2 spare devices
Date: Thu, 10 Feb 2011 19:03:30 +0100
Message-ID: <4D542872.3090102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Sorry for my bad English. I'm from Austria and this is also my first 
"mailinglist-post".

I have a problem with my RAID5. The raid has only 1 active devices out 
of 3. The other 2 devices are detected as spare.
This is what happens when I try to assemble the raid(I'm using loop 
devices because I'm working with backup files):

root@backup-server:/media# mdadm --assemble --force /dev/md2 /dev/loop0 
/dev/loop1 /dev/loop2
mdadm: /dev/md2 assembled from 1 drive and 2 spares - not enough to 
start the array.

root@backup-server:/media# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md2 : inactive loop1[0](S) loop2[4](S) loop0[3](S)
       4390443648 blocks

unused devices: <none>

root@backup-server:/media# mdadm -R /dev/md2
mdadm: failed to run array /dev/md2: Input/output error

root@backup-server:/media# mdadm -D /dev/md2
/dev/md2:
         Version : 0.90
   Creation Time : Thu Nov 19 21:09:37 2009
      Raid Level : raid5
   Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
    Raid Devices : 3
   Total Devices : 1
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Sun Nov 14 14:12:44 2010
           State : active, FAILED, Not Started
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 9665c475:31f17aa2:83a3570a:c5b3b84e
          Events : 0.3352467

     Number   Major   Minor   RaidDevice State
        0       7        1        0      active sync   /dev/loop1
        1       0        0        1      removed
        2       0        0        2      removed

root@backup-server:/media# mdadm /dev/md2 -a /dev/loop0
mdadm: re-added /dev/loop0
root@backup-server:/media# mdadm /dev/md2 -a /dev/loop2
mdadm: re-added /dev/loop2
root@backup-server:/media# mdadm -D /dev/md2
/dev/md2:
         Version : 0.90
   Creation Time : Thu Nov 19 21:09:37 2009
      Raid Level : raid5
   Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Sun Nov 14 14:12:44 2010
           State : active, FAILED, Not Started
  Active Devices : 1
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 9665c475:31f17aa2:83a3570a:c5b3b84e
          Events : 0.3352467

     Number   Major   Minor   RaidDevice State
        0       7        1        0      active sync   /dev/loop1
        1       0        0        1      removed
        2       0        0        2      removed

        3       7        0        -      spare   /dev/loop0
        4       7        2        -      spare   /dev/loop2

I also tried to recreate the raid:

root@backup-server:/media# mdadm -Cv /dev/md2 -n3 -l5 /dev/loop0 
/dev/loop1 /dev/loop2
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: /dev/loop0 appears to be part of a raid array:
     level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
mdadm: layout defaults to left-symmetric
mdadm: /dev/loop1 appears to be part of a raid array:
     level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
mdadm: layout defaults to left-symmetric
mdadm: /dev/loop2 appears to be part of a raid array:
     level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
mdadm: size set to 1463479808K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.

root@backup-server:/media# mdadm -D /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Fri Feb  4 17:05:18 2011
      Raid Level : raid5
      Array Size : 2926959616 (2791.37 GiB 2997.21 GB)
   Used Dev Size : 1463479808 (1395.68 GiB 1498.60 GB)
    Raid Devices : 3
   Total Devices : 3
     Persistence : Superblock is persistent

     Update Time : Fri Feb  4 17:05:18 2011
           State : clean, degraded
  Active Devices : 2
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 512K

            Name : backup-server:2  (local to host backup-server)
            UUID : c37336d0:9811f9d1:294aa588:a85a5096
          Events : 0

     Number   Major   Minor   RaidDevice State
        0       7        0        0      active sync   /dev/loop0
        1       7        1        1      active sync   /dev/loop1
        2       0        0        2      removed

        3       7        2        -      spare   /dev/loop2

root@backup-server:/media# mdadm /dev/md2 -r /dev/loop2
mdadm: hot removed /dev/loop2 from /dev/md2

root@backup-server:/media# mdadm /dev/md2 -a /dev/loop2
mdadm: re-added /dev/loop2
root@backup-server:/media# mdadm -D /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Fri Feb  4 17:05:18 2011
      Raid Level : raid5
      Array Size : 2926959616 (2791.37 GiB 2997.21 GB)
   Used Dev Size : 1463479808 (1395.68 GiB 1498.60 GB)
    Raid Devices : 3
   Total Devices : 3
     Persistence : Superblock is persistent

     Update Time : Fri Feb  4 17:15:25 2011
           State : clean, degraded, recovering
  Active Devices : 2
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 512K

  Rebuild Status : 0% complete

            Name : backup-server:2  (local to host backup-server)
            UUID : c37336d0:9811f9d1:294aa588:a85a5096
          Events : 6

     Number   Major   Minor   RaidDevice State
        0       7        0        0      active sync   /dev/loop0
        1       7        1        1      active sync   /dev/loop1
        3       7        2        2      spare rebuilding   /dev/loop2

root@backup-server:/media# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md2 : active raid5 loop2[3] loop0[0] loop1[1]
       2926959616 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[3/2] [UU_]
       [=>...................]  recovery =  5.0% (74496424/1463479808) 
finish=188.7min speed=122624K/sec

unused devices: <none>

When I to that I can't find the LVM that should be inside the raid. So I 
reloaded the Backup so I'm back at the beginning.
I know that my data is more or less intact because I can find a few 
files with testdisks photorec(after I rebuild the raid with the command 
above).

Best regards,

Thomas

