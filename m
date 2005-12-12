From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 20] Introduction
Date: Mon, 12 Dec 2005 14:10:16 +1100
Message-ID: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 20 patches for md/raid in 2.6.15-rc5-mm2

The  first 2 are suitable for 2.6.15.
The first fixes a use-after-free bug in raid1 which could only cause problems
with using raid1 with some devices in write-behind mode.
The second fixes a carelessness that could result in a deadlock
if raid5 stripe_cache_size were set too low.

3 through 8 are assorted minor cleanups or bugfixes only relevant to -mm
9 through 20 add a lot more information about md arrays to sysfs and allow
a lot of it to be settable.  This will ultimately make it possible to completely
configure an md array through sysfs without using the ioctl's at all.  This is
good because the ioctl's are limited and while I've manage to squeeze some 
extra functionality out of them, they've reached their limit.

One particular goal I am working towards here is to be able to have an 
md array where the metadata is completely managed by userspace.  A program would
read the superblock - fill in the correct information via sysfs, and start the 
array.
On device failure or other events, userspace gets notified and take necessary 
action like identifying a spare, passing it to md, and requesting a reconstruction. 

This means that e.g. DDF can be supported without adding complexity to the kernel.

Thanks,
NeilBrown


 [PATCH md 001 of 20] Fix a use-after-free bug in raid1
 [PATCH md 002 of 20] Use correct size of raid5 stripe cache when measuring how full it is.
 [PATCH md 003 of 20] Define and use safe_put_page for md.
 [PATCH md 004 of 20] Helper function to match commands written to sysfs files.
 [PATCH md 005 of 20] Fix typo in comment.
 [PATCH md 006 of 20] Make a couple of names in md.c static
 [PATCH md 007 of 20] Make sure bitmap updates are visible through filesystem.
 [PATCH md 008 of 20] Fix rdev->pending counts in raid1
 [PATCH md 009 of 20] Allow chunk_size to be settable through sysfs
 [PATCH md 010 of 20] Allow md array component size to be accessed and set via sysfs
 [PATCH md 011 of 20] Expose md metadata format in sysfs.
 [PATCH md 012 of 20] Allow array level to be set textually via sysfs.
 [PATCH md 013 of 20] Count corrected read errors per drive.
 [PATCH md 014 of 20] Allow md/raid_disks to be settable.
 [PATCH md 015 of 20] Keep better track of dev/array size when assembling md arrays.
 [PATCH md 016 of 20] Expose device slot information via sysfs
 [PATCH md 017 of 20] Export rdev->data_offset via sysfs
 [PATCH md 018 of 20] Allow available size of component devices to be set via sysfs.
 [PATCH md 019 of 20] Support adding new devices to md arrays via sysfs
 [PATCH md 020 of 20] Allow sync-speed to be controlled per-device
