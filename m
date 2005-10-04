From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 5] Introduction
Date: Tue, 4 Oct 2005 15:23:15 +1000
Message-ID: <20051004151922.28715.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Following are 5 patches that start by adding sysfs support to 'md',
and then proceed to add functionality that makes use if it.

For example:
  The raid5 stripe cache can be resized with
    echo NNN > /sys/block/mdX/md/raid5/stripe_cache_size
  An array can resync'ed with
    echo repair > /sys/block/mdX/md/scan_mode

  On raid5, the number of parity mismatches found will be reported in
    /sys/block/mdX/md/mismatch_cnd

You will note that raid5 has got the most new functionality.  Matching
functionality for other md personalities will follow.

These patches should be suitable for merging after 2.6.14 is released.

NeilBrown


 [PATCH md 001 of 5] Initial sysfs support for md
 [PATCH md 002 of 5] Extend md sysfs support to component devices.
 [PATCH md 003 of 5] Add kobject/sysfs support to raid5
 [PATCH md 004 of 5] Allow a manual resync with md
 [PATCH md 005 of 5] Teach raid5 the difference between 'check' and 'repair'.
