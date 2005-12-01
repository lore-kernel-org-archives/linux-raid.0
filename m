From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 14] Introduction
Date: Thu, 1 Dec 2005 14:22:47 +1100
Message-ID: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 14 more patches for md in 2.6.15-rc2-mm1

None are appropriate for 2.6.15 - all should wait for 2.6.16 to open.

With these the handling for read errors by overwriting with correct
data is supported for all relevant raid levels.  Also user-requested
checking of redundant information is supported for all levels, and
report the number of affect blocks in sysfs (though this number is
only approximate).

/proc/mdstat becomes pollable so that mdadm can get timely
notification of changes without polling at a high frequency.

There are also a substantial number of code cleanups.

 [PATCH md 001 of 14] Support check-without-repair of raid10 arrays
 [PATCH md 002 of 14] Allow raid1 to check consistency
 [PATCH md 003 of 14] Make sure read error on last working drive of raid1 actually returns failure.
 [PATCH md 004 of 14] auto-correct correctable read errors in raid10
 [PATCH md 005 of 14] raid10 read-error handling - resync and read-only
 [PATCH md 006 of 14] Make /proc/mdstat pollable.
 [PATCH md 007 of 14] Clean up 'page' related names in md
 [PATCH md 008 of 14] Convert md to use kzalloc throughout
 [PATCH md 009 of 14] Tidy up raid5/6 hash table code.
 [PATCH md 010 of 14] Convert various kmap calls to kmap_atomic
 [PATCH md 011 of 14] Convert recently exported symbol to GPL
 [PATCH md 012 of 14] Break out of a loop that doesn't need to run to completion.
 [PATCH md 013 of 14] Remove personality numbering from md.
 [PATCH md 014 of 14] Fix possible problem in raid1/raid10 error overwriting.
