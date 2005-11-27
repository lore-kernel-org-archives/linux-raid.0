From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 18] Introduction
Date: Mon, 28 Nov 2005 10:39:35 +1100
Message-ID: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 18 patches against md/raid in 2.6.15-rc2-mm1

The first 5 are bug fixes against recent additions to 2.6.15-rc.
They should preferrable go to Linus for inclusion in 2.6.15.

The remaining 13 are code cleanups and new functionality.  These
should sit in -mm until 2.6.16-rc opens up.

The main elements of functionality I have been working on are
 - bitmap based write intent logging
      This is now available in all raid levels (where useful).
 - better handling of read errors
      This is now available for raid5, raid6, raid1
      raid10 is still outstanding
 - Support 'check' action which checks redundancy but doesn't repair.
      This is now available in raid5 and raid6
      raid10 and raid1 are still outstanding.

Future work includes
  - enhancements to the sysfs interface
  - improve raid5/6 read speed by bypassing cache

Thanks,
NeilBrown

2.6.15 material
 [PATCH md 001 of 18] Improve read speed to raid10 arrays using 'far copies'.
 [PATCH md 002 of 18] Fix locking problem in r5/r6
 [PATCH md 003 of 18] Fix problem with raid6 intent bitmap
 [PATCH md 004 of 18] Set default_bitmap_offset properly in set_array_info
 [PATCH md 005 of 18] Fix --re-add for raid1 and raid6
2.6.16 material
 [PATCH md 006 of 18] Improve raid1 "IO Barrier" concept.
 [PATCH md 007 of 18] Improve raid10 "IO Barrier" concept.
 [PATCH md 008 of 18] Small cleanups for raid5
 [PATCH md 009 of 18] Allow dirty raid[456] arrays to be started at boot.
 [PATCH md 010 of 18] Move bitmap_create to after md array has been initialised.
 [PATCH md 011 of 18] Write intent bitmap support for raid10
 [PATCH md 012 of 18] Fix raid6 resync check/repair code.
 [PATCH md 013 of 18] Improve handing of read errors with raid6
 [PATCH md 014 of 18] Attempt to auto-correct read errors in raid1.
 [PATCH md 015 of 18] Tidyup some issues with raid1 resync and prepare for catching read errors.
 [PATCH md 016 of 18] Better handling for read error in raid1 during resync
 [PATCH md 017 of 18] Handle errors when read-only
 [PATCH md 018 of 18] Fix up some rdev rcu locking in raid5/6
