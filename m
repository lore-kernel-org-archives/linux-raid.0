From: cvb@kruemel.org
Subject: Growing RAID-10 (near-2) array - which kernel
 =?UTF-8?Q?needed=3F?=
Date: Thu, 11 Dec 2014 19:31:31 +0100
Message-ID: <b906dbe55e09c7cf24abcacfbf97efed@kruemel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apologies for raising this topic again, but I can't seem to find 
anything googling, and man mdadm doesn't also give me a clue. Which 
kernel version is needed to grow a near-2 RAID 10 array?

I'm currently running kernel 3.13.0 with mdadm 3.2.5. But I could also 
use a live CD with a newer kernel, if needed.

I have replaced the 4 disks here with larger ones (2TB drives -> 4 TB 
drives), and this is what the array currently looks like:

# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Aug 20 08:15:07 2011
      Raid Level : raid10
      Array Size : 3906764800 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Thu Dec 11 08:31:15 2014
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=2
      Chunk Size : 512K

            Name : alpha:0  (local to host alpha)
            UUID : 8199e640:58fc3a04:99b52fe6:80a1574d
          Events : 918971

     Number   Major   Minor   RaidDevice State
        6       8        1        0      active sync   /dev/sda1
        5       8       33        1      active sync   /dev/sdc1
        7       8       17        2      active sync   /dev/sdb1
        4       8       49        3      active sync   /dev/sdd1

