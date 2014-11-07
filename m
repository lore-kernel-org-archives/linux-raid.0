From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: --no-degraded does not work
Date: Fri, 07 Nov 2014 17:43:07 +0100
Message-ID: <545CF69B.6040307@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As far as I understand the documentation --assemble --no-degraded should not start a degraded array.
However on my system (kubuntu 14.10)

# mdadm --assemble --no-degraded /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
mdadm: /dev/md0 has been started with 4 drives (out of 5).

# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Tue Nov  4 15:26:46 2014
      Raid Level : raid5
      Array Size : 599469328 (571.70 GiB 613.86 GB)
   Used Dev Size : 149867332 (142.92 GiB 153.46 GB)
    Raid Devices : 5
   Total Devices : 4
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Fri Nov  7 17:22:53 2014
           State : clean, degraded
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 4K

            Name : 0
            UUID : c7465b19:c149b2d1:5b4d88ce:8c6ce432
          Events : 642

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        3       8       65        3      active sync   /dev/sde1
        5       8       81        4      active sync   /dev/sdf1

the array IS started when removing one disk, stopping it, reconnecting the disk and then assemble the array.
Is this the supposed behavior?

Patrick
