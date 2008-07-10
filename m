From: Christopher Hicks <chicks@chicks.net>
Subject: Can't recover half of a raid1
Date: Thu, 10 Jul 2008 10:00:05 -0400 (EDT)
Message-ID: <alpine.LRH.1.10.0807100956020.4684@skippy.fini.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We had a drive die in a RAID1 array.  I've tried to bring it back so we 
can migrate the data to a new machine and it keeps telling me "/dev/md0 
assembled from 1 drive - not enough to start the array."  I've tried 
everything I've found in the FAQ and wiki to no avail.  What am I missing?
Here's the log of what I've tried:

# mdadm -E /dev/hdb1
/dev/hdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : f8055b6f:766f7a3f:ad80d985:eb77d033
   Creation Time : Thu Feb 19 10:57:42 2004
      Raid Level : raid0
     Device Size : 102398208 (97.65 GiB 104.86 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Sat Feb  3 22:56:54 2007
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 3cadf274 - correct
          Events : 0.44

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       3       65        1      active sync   /dev/hdb1

    0     0       3        2        0      active sync   /dev/hda2
    1     1       3       65        1      active sync   /dev/hdb1
Personalities : [raid0] [raid1] [raid5] [raid6] 
# mdadm  -Af /dev/md0 /dev/hdb1
mdadm: /dev/md0 assembled from 1 drive - not enough to start the array.
# cat /proc/mdstat
md0 : inactive hdb1[1]
       102398208 blocks
unused devices: <none>


-- 
</chris>

If trees could scream, would we be so cavalier about cutting them down?
We might, if they screamed all the time, for no good reason.
