From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Rotating RAID 1
Date: Mon, 15 Aug 2011 15:56:40 -0400
Message-ID: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good evening,

I'm currently working on a project in which I use md-raid RAID1 with
Bitmap to "clone" my data from one disk to another and I would like to
know if this could cause corruption:

The system has 2 SATA ports which are hotplug capable.
I created 2 partitions, 1 system (2GB), 1 data (1TB+).
I created to RAID1 using:
mdadm --create /dev/md0 --raid-devices=2 --bitmap=internal
--bitmap-chunk=4096 --metadata=1.0 /dev/sd[ab]1
mdadm --create /dev/md1 --raid-devices=2 --bitmap=internal
--bitmap-chunk=65536 --metadata=1.0 /dev/sd[ab]2
Forced sync_parallel on the system disk to be sure it rebuild first.
Formatted system ext3 and data ext4.
Both mounted using data=writeback.

This system doesn't contain critical data but it contains backups on
the data partition. Once the data is in sync, I removed a disk and let
udev fail and remove the disk from the array, this is ArchLinux and
udev is set to mount the array using the incremental option, I added
--run to make sure it mounts even when a disk is missing. As of now,
eveything works as expected.

Then what is different about a standard RAID1, I removed sdb and
replaced it with a brand new disk, copied the partition template from
the other one and added the new disk using mdadm -a on both arrays, it
synced and works, then swapping the other disk back only rebuilds
according to the bitmap, however sometimes it appears to make a full
rebuild which is alright. However once, after a day of modifications
and weeks after setting-up this RAID, at least 100 GB, it took seconds
to rebuild and days later it appeared to have encountered corruption,
the kernel complained about bad extents and fsck found errors in one
of the file I know it had modified that day.

So the question is; Am I right to use md-raid to do this kind of
stuff, rsync is too CPU heavy for what I need and I need to stay
compatible with Windows thus choosing metadata 1.0.
