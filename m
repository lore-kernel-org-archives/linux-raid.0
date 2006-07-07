From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Resizing RAID-1 arrays - some possible bugs and problems
Date: Sat, 08 Jul 2006 01:40:28 +1200
Message-ID: <44AE644C.9090408@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

I'm just in the process of upgrading the RAID-1 disks in my server, and have 
started to experiment with the RAID-1 --grow command.  The first phase of the 
change went well, I added the new disks to the old arrays and then increased the 
size of the arrays to include both the new and old disks.  This meant that I had 
a full and clean transfer of all the data.  Then took the old disks out...it all 
worked nicely.

However I've had two problems with the next phase which was the resizing of the 
arrays.

Firstly, after moving the array, the kernel still seems to think that the raid 
array is only as big as the older disks.  This is to be expected, however 
looking at the output of this:

[root@tornado /]# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Sat Nov  5 14:02:50 2005
      Raid Level : raid1
      Array Size : 24410688 (23.28 GiB 25.00 GB)
     Device Size : 24410688 (23.28 GiB 25.00 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Sat Jul  8 01:23:54 2006
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 24de08b7:e256a424:cca64cdd:638a1428
          Events : 0.5139442

     Number   Major   Minor   RaidDevice State
        0       8       34        0      active sync   /dev/sdc2
        1       8        2        1      active sync   /dev/sda2
[root@tornado /]#

We note that the "Device Size" according to the system is still 25.0 GB.  Except 
that the device size is REALLY 40Gb, as seen by the output of fdisk -l:

/dev/sda2               8        4871    39070080   fd  Linux raid autodetect

and

/dev/sdc2               8        4871    39070080   fd  Linux raid autodetect

Is that a bug?  My expectation is that this field should now reflect the size of 
the device/partition, with the *Array Size* still being the original, unresized 
size.

Secondly, I understand that I need to use the --grow command to bring the array 
up to the size of the device.
How do I know what size I should specify?  On my old disk, the size of the 
partition as read by fdisk was slightly larger than the array and device size as 
shown by mdadm.
How much difference should there be?
(Hint:  maybe this could be documented in the manpage (please), NeilB?)


And lastly, I felt brave and decided to plunge ahead, resize to 128 blocks 
smaller than the device size.  mdadm --grow /dev/md1 --size=

The kernel then went like this:

md: couldn't update array info. -28
VFS: busy inodes on changed media.
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)
md1: invalid bitmap page request: 150 (> 149)

...and kept going and going and going, every now and then the count incremented 
up until about 155 by which point I shut the box down.
The array then refused to come up on boot and after forcing it to reassemble it 
did a full dirty resync up:

md: bind<sda3>
md: md1 stopped.
md: unbind<sda3>
md: export_rdev(sda3)
md: bind<sda3>
md: bind<sdc3>
md: md1: raid array is not clean -- starting background reconstruction
raid1: raid set md1 active with 2 out of 2 mirrors
attempt to access beyond end of device
sdc3: rw=16, want=39086152, limit=39086145
attempt to access beyond end of device
sda3: rw=16, want=39086152, limit=39086145
md1: bitmap initialized from disk: read 23/38 pages, set 183740 bits, status: -5
md1: failed to create bitmap (-5)
md: pers->run() failed ...
md: array md1 already has disks!
raid1: raid set md1 active with 2 out of 2 mirrors
md1: bitmap file is out of date (0 < 4258299) -- forcing full recovery
md1: bitmap file is out of date, doing full recovery
md1: bitmap initialized from disk: read 10/10 pages, set 305359 bits, status: 0
created bitmap (150 pages) for device md1
md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) 
                                              for reconstruction.
md: using 128k window, over a total of 19542944 blocks.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
md: md1: sync done.
RAID1 conf printout:
  --- wd:2 rd:2
  disk 0, wo:0, o:1, dev:sdc3
  disk 1, wo:0, o:1, dev:sda3

That was not really what I expected to happen.

I am running mdadm-2.3.1 which is the current version shipped with Fedora Core 
right now, but I'm about to file a bug report to get this upgraded.  A cursory 
look through the Changelog didn't suggest anything about any of these things 
being changed.

I get the feeling I am treading unchartered waters here, has anyone else done 
this sort of this and/or seen this sort of problem before?

Reuben

