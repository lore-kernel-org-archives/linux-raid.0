From: Gerd Knops <gerti@bitart.com>
Subject: RAID5 drive failure, please verify my commands
Date: Sun, 16 Jan 2005 12:14:39 -0600
Message-ID: <7C8198B3-67EA-11D9-9A87-00039363AEBE@bitart.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

One of the dreaded Maxtor SATA drives in my RAID5 failed, after just 3 
months of light use. Anyhow I neither have the disk capacity nor the 
money to buy it to make a backup. To make sure I do it correctly, could 
you folks please double-check my intended course of action? I would 
really appreciate that.

Current state:

xanadu:~# uname -a
Linux xanadu 2.6.8-1-386 #1 Mon Sep 13 23:29:55 EDT 2004 i686 GNU/Linux
xanadu:~# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.01
   Creation Time : Fri Oct  8 13:01:49 2004
      Raid Level : raid5
      Array Size : 490223104 (467.51 GiB 501.99 GB)
     Device Size : 245111552 (233.76 GiB 250.99 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sun Jan 16 06:25:31 2005
           State : clean, degraded
  Active Devices : 2
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            UUID : 0c758197:f3af8f3b:d68050c0:04ea429e
          Events : 0.221727

     Number   Major   Minor   RaidDevice State
        0       0        0        -      removed
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1

        3       8        1        -      faulty   /dev/sda1


Here is what I think I should be doing:

- Remove failed disk from array:

	mdadm /dev/md0 --remove /dev/sda1

- Physically remove disk from system
- Add new disk to system, partition
- Add to array:

	mdadm /dev/md0 --add /dev/sda1

Anything else to trigger rebuilding of the disk?

That should be it, correct? Also since I lost all confidence in the 
Maxtor drives (had a long history of problems with that brand, I don't 
think any Maxtor drive I ever owned made it to retirement) I probably 
will buy a new drive immediately and replace the broken one. Then when 
the broken one is repaired/exchanged, I would like to add it as spare. 
To do so, would the sequence be

	mdadm /dev/md0 --add /dev/sdd1

Is that it?

Also one last question: Foolishly I allocated all available space in 
the Maxtors for the RAID. Now, should the replacement drive have a 
slightly smaller capacity, is there some way to deal with that? I think 
i can use resize2fs to reduce the size of the filesystem (does this 
work with ext3 file systems?). Assuming that works, is there some way 
to convince the RAID to accept a smaller partition and adjust it's size 
accordingly?

Thanks all

Gerd

