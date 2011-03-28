From: Nathan Gamber <ngamber@liquidweb.com>
Subject: corrupted 600GiB md device
Date: Mon, 28 Mar 2011 17:09:39 -0400
Message-ID: <4D90F913.5060105@liquidweb.com>
Reply-To: ngamber@liquidweb.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm trying to create a soft RAID device from a remote LVM logical volume 
imported via iscsi and another, local logical volume. It works without 
issue most of the time, but I've found that if I specify a 600GiB 
partition with lvcreate, such as with 'lvcreate -L 600G -n test1 LVM' 
that /dev/md0 is "corrupted" until the device finishes syncing. For 
example, 'fsck /dev/md0'

fsck 1.39 (29-May-2006)
e2fsck 1.39 (29-May-2006)
The filesystem size (according to the superblock) is 157286400 blocks
The physical size of the device is 157286384 blocks
Either the superblock or the partition table is likely to be corrupt!

And the details of the array:

/dev/md0:
         Version : 0.90
   Creation Time : Mon Mar 28 20:56:00 2011
      Raid Level : raid1
      Array Size : 629145536 (600.00 GiB 644.25 GB)
   Used Dev Size : 629145536 (600.00 GiB 644.25 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Mar 28 20:56:34 2011
           State : active, resyncing
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

  Rebuild Status : 0% complete

            UUID : da6c0776:2f3beb8f:b13b8b58:8282847d
          Events : 0.3

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync   /dev/sdc
        1     253       10        1      active sync   /dev/LVM/npgtest1

With RAID 1.0 metadata, fsck returns the same error, though the size of 
the physical device varies from the filesystem by 34 blocks instead of 
16. With 1.1 and 1.2 metadata, I get the following error instead:

Couldn't find ext2 superblock, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

I seem to only have this problem when specifying a logical volume of 
600GiB. If I shrink the filesystem on the original volume (before 
exporting it via iscsi) slightly, I can't reproduce this. Am I seeing 
intended behavior? If so, what would be the appropriate way to work 
around it?

-Nathan

