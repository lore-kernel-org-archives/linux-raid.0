From: Ferenc-Jan <ferenc@avz.xs4all.nl>
Subject: Ghost partition after raid1 rebuild? Baffled! State 'sync'?
Date: Sun, 19 Dec 2004 10:18:59 +0100
Message-ID: <41C54783.70704@avz.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

First off, kudo's to the linux sw raid + tools maintainers. You saved me 
this time.

I had a hd fail with several raid1 partitions. I replaced the hd, 
partitioned it and hotadded the partitions. /proc/mdstat reported 
syncing, so I guess my data is safe. But I  still get [U_] instead of 
[UU]. Help.

Also, mdadm -D results has me baffled. For instance:

# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.00
   Creation Time : Sun Dec 19 01:07:36 2004
      Raid Level : raid1
      Array Size : 293184 (286.31 MiB 300.22 MB)
     Device Size : 293184 (286.31 MiB 300.22 MB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Sun Dec 19 09:50:14 2004
           State : dirty
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 27601b2c:d3238813:6fb674c9:289bda1f
          Events : 0.380

     Number   Major   Minor   RaidDevice State
        0       3        6        0      active sync   /dev/hda6
        1       0        0        0      sync

        2      22        6        2      active sync   /dev/hdc6

And I'm out of wit here. Which partition/device relates to the line
"1  0  0  0  sync"? What is state 'sync'?

any help much appreciated,

cheers

Ferenc

