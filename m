From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 10] md: Introduction - assorted patches for -mm
Date: Thu, 1 Jun 2006 15:13:11 +1000
Message-ID: <20060601150955.27444.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are 10 patches for md in -mm.  None are appropriate for 2.6.17.

First 3 are fixes.
Next 2 are functionality improvements (people keep wanting their spare 
   drives to go to sleep, so now they can).
Remainder are more sysfs access.

Thanks,
NeilBrown


 [PATCH 001 of 10] md: md Kconfig speeling feex
 [PATCH 002 of 10] md: Fix Kconfig error
 [PATCH 003 of 10] md: Fix bug that stops raid5 resync from happening
 [PATCH 004 of 10] md: Allow re-add to work on array without bitmaps.
 [PATCH 005 of 10] md: Don't write dirty/clean update to spares - leave them alone
 [PATCH 006 of 10] md: Set/get state of array via sysfs
 [PATCH 007 of 10] md: Allow rdev state to be set via sysfs.
 [PATCH 008 of 10] md: Allow raid 'layout' to be read and set via sysfs.
 [PATCH 009 of 10] md: Allow resync_start to be set and queried via sysfs.
 [PATCH 010 of 10] md: Allow the write_mostly flag to be set via sysfs.
