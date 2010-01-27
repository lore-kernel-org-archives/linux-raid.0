From: Carlos Williams <carloswill@gmail.com>
Subject: How To Grow Using 'mdadm' Utility
Date: Wed, 27 Jan 2010 13:56:07 -0500
Message-ID: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like to know what is the proper syntax for creating / growing
my RAID5 array with 3 disks and 0 spare to 4 disks and 0 spare? Right
now my RAID5 array on my system appears as follows:

/dev/md0:
        Version : 0.90
  Creation Time : Wed Jan 27 08:15:03 2010
     Raid Level : raid5
     Array Size : 480391552 (458.14 GiB 491.92 GB)
  Used Dev Size : 240195776 (229.07 GiB 245.96 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jan 27 13:47:49 2010
          State : clean, degraded, recovering
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 10% complete

           UUID : e3c1e8b3:5a1b141f:af88d4a5:584f0b5f
         Events : 0.347

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       3       8       34        2      spare rebuilding   /dev/sdc2

I have an identical drive and want to make /dev/sdd2 a active member
of the RAID5 array which should expand my disk storage capacity.

I checked out the 'man' page for 'mdadm' utility and I think I am
wanting to use the 'mdadm --grow' command but I don't really know what
I am doing here and the man page is a nice reference but I am looking
for more guidance. Can anyone please tell me what is the proper way to
get my desired result?

*PS*
I understand right now my RAID5 is syncing and should probably wait
until all three drives are synced.
