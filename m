From: Mirko <mirko76@arcor.de>
Subject: Need help with my raid5
Date: Fri, 22 Mar 2013 07:57:42 +0000 (UTC)
Message-ID: <loom.20130322T084406-543@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i wanted to reassemble my Raid5.
Last week i added a new device to my raid5 with 6 devices.
After the reshape, mdadm said, device 7 is failed. I tested the device and 
there are a lot of bad blocks.
So i removed the device from the raid, resized the filesystem and during the
reshape, device #3 was removed from the raid and the reshape was canceled.
                                                                                
Yesterday i removed the 7th device from the computer and now, 
the raid doesnt start.

mdadm --assemble --verbose /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
/dev/sde1/dev/sdf1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
mdadm: device 7 in /dev/md0 has wrong state in superblock, but /dev/sdc1 seems
ok
mdadm:/dev/md0 has an active reshape - checking if critical section needs to be
restored
mdadm: added /dev/sda1 to /dev/md0 as 1
mdadm: added /dev/sdf1 to /dev/md0 as 2
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: added /dev/sde1 to /dev/md0 as 4
mdadm: added /dev/sdb1 to /dev/md0 as 5
mdadm: no uptodate device for slot 6 of /dev/md0
mdadm: added /dev/sdc1 to /dev/md0 as -1
mdadm: added /dev/sdd1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 5 drives and 1 spare - not enough to start the
array.

mdadm --run /dev/md0
mdadm: failed to run array /dev/md0: Input/output error

mdadm -D /dev/md0
/dev/md0:

        Version : 1.2
  Creation Time : Fri Feb 22 22:08:12 2013
     Raid Level : raid5
  Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Thu Mar 21 15:50:39 2013
          State : active, degraded, Not Started
 Active Devices : 5
 Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

  Delta Devices : -1, (7->6)

           Name : server:0  (local to host server)
           UUID : 1db312ca:48cd4f30:e8607949:0c721b94
         Events : 38267

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8        1        1      active sync   /dev/sda1
       3       8       81        2      active sync   /dev/sdf1
       3       0        0        3      removed
       5       8       65        4      active sync   /dev/sde1
       6       8       17        5      active sync   /dev/sdb1
       7       8       33        -      spare   /dev/sdc1

What can i do to rescue my data?

Thx

