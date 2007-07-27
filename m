From: Cry Regarder <cry_regarder@yahoo.com>
Subject: RAID on partitions and partitions on RAID
Date: Fri, 27 Jul 2007 21:10:12 +0000 (UTC)
Message-ID: <loom.20070727T225545-192@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sentient Beings,

RAID on parititions vs. raw disks:

I built a raid-5 array with six 500gb SATA disks.  For some reason which I can
no longer remember but related I suspect to hubris, I built the array directly
on the drive devices rather than making a fullsize partition.  As a consequence,
I assemble the array from /dev/sd[bcdefg] instead of /dev/sd[bcdefg]1.  In
reality, because my motherboard seems to like to shuffle the order of
recognition, my boot drive isn't always /dev/sda so in practice I do:

mdadm -Ac partitions -m 0 /dev/md0

When I built the array, some of the drives were virgin, some had a factory NTFS
format, and some were previously partitioned by me for linux use.  The problem I
have now is twofold: 

1.  There are remnants of the partition tables still on the drives, despite
those partitions being meaningless.

2.  I'd actually like to have clean /dev/sd?1 partitions on each drive in the
array marked with the raid identifier.  

Is there away to non-destructively adjust the partition tables, or resize the
array to allow for 2.?  If not, is there a good way to clean up 1. so that there
are no longer any partition tables on the drive?

Partitions on RAID:

Back to when I constructed the array, I placed an ext3 partition directly on
/dev/md0.  Since construction, I have expanded the array by two disks, but have
not at this time resized the ext3 partition.  

What I would like to do is put a swap partition and XFS partition into that 1TB
free space.  However, I have no idea how to go about doing that.  If I had
originally used LVM, it would be easy, but I had read about some performance
hits re ext3 on lvm on raid so I decided to be "simple".  Any advice?

Thanks!

Cry

