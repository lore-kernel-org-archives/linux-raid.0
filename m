From: seth vidal <skvidal@phy.duke.edu>
Subject: a couple of mdadm questions
Date: 06 Sep 2003 16:24:56 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1062879895.8172.20.camel@opus>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 I'm running Red Hat Linux 7.3 - with the 2.4.20-20.7 kernels.

I have a raid array of 7 73GB u160 scsi disks.

I had a disk failure on one disk. This is in a dell powervault 220S
drive array. 

I ran:
mdadm /dev/md1 --remove /dev/sdd1


I removed the failed disk. Inserted the new disk. Partitioned it and
ran:

mdadm /dev/md1 --add /dev/sdd1

the drive reconstructed and everything seems happy.

This has happened on 2 separate disks at different times and it has
recovered both times.

When I do a mdadm -D /dev/md1 it lists out very oddly:

mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Wed Nov  6 11:09:01 2002
     Raid Level : raid5
     Array Size : 430091520 (410.17 GiB 440.41 GB)
    Device Size : 71681920 (68.36 GiB 73.40 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 1
    Persistence : Superblock is persistent
 
    Update Time : Sat Sep  6 14:53:58 2003
          State : dirty, no-errors
 Active Devices : 7
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
 
         Layout : left-asymmetric
     Chunk Size : 64K
 
    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       5       8       97        5      active sync   /dev/sdg1
       6       8      113        6      active sync   /dev/sdh1
           UUID : 3b48fd52:94bb97fd:89437dea:126fd0fc
         Events : 0.82

So why does this say - 5 working devices, 2 failed devices and 7 active
devices?


It seems like it should read:
7 active devices and 7 working devices.
In addition, I can't get State: dirty, no-errors to go away.

I considered recreating this array with:

mdadm -C /dev/md1 -l 5 -n 7 -c 64 /dev/sdb1 /dev/sdc1 /dev/sdd1 \
/dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1

but I was a little leery that I might screw something up. There is a lot
of important data on this array.


The only other thing that is very odd is that on boot the system always
claims to fail to start the array, that there are too few drives. But
then it starts, mounts and the data all looks good. I've compared big
chunks of the data with md5sum and it's valid. So I think it has
something to do with the Working Device counts.

Is that the case?

This is on mdadm 1.2.0.

Thanks
-sv




