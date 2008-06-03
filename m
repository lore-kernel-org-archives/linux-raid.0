From: Jules Bean <jules@jellybean.co.uk>
Subject: After partition resize, RAID5 array does not assemble on boot
Date: Tue, 03 Jun 2008 07:49:56 +0100
Message-ID: <4844E994.8020808@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kernel: 2.6.24 i386
mdadm: 2.6.4

Hi,

I had a RAID5 array in the configuration 250/250/400/400 (so only
250/250/250/250 was actually being used)

After a partition rearrangement it was possible to increase the size
of the two 250 partitions to 400. I did the following:

mdadm --fail partition
mdadm --remove partition
cfdisk resize partition
mdadm --add partition
wait some hours for rebuild to complete

Twice, once for each 250G partition.

The new array was running fine. Here is its status:

champagne:/home/jules# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Tue Jan 30 21:28:07 2007
      Raid Level : raid5
      Array Size : 726732096 (693.07 GiB 744.17 GB)
   Used Dev Size : 242244032 (231.02 GiB 248.06 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Jun  2 22:46:33 2008
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 52252ae8:5d1fd858:31a51f4c:5ff55ddd
          Events : 0.1638776

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       50        2      active sync   /dev/sdd2
        3       8       34        3      active sync   /dev/sdc2

However I was under the impression --grow --size=max would grow it up
to the real limits of the partitions. This didn't work.

Thinking something was cached in internal tables with incorrect
partition sizes, I rebooted the machine.

Bad idea :(

The RAID array failed to reconstruct. The boot messages said there
were only two working devices, not enough to start array.

/dev/sdd2 and /dev/sd2 (which were the partitions I didn't touch) were
both there. /dev/sda2 and /dev/sdb2 didn't add.

I tried (mistake?) adding /dev/sda2 explicitly with --add but it added
as a spare, not as a proper member.

I tried assembling explicitly with --assemble /dev/sda2 /dev/sdb2
/dev/sdc2 /dev/sdd2 and it complained of no RAID superblock on
/dev/sdb2.

Help? What next ;) Is there enough information in /dev/sdd2 and 
/dev/sdc2 to reconstruct the apparently missing superblocks on /dev/sda2 
and /dev/sdb2? Do I need to try to resize my partitions back to their 
old size so it can find the old superblock? Even if by adding /dev/sda2 
as a spare I've corrupted its superblock entirely, sdb2 should still 
have enough to save my array with 3 out of 4 devices?


Many thanks,

Jules
