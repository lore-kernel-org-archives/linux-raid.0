From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 9] md: Assorted patches for the 2.5.26 merge window
Date: Tue, 29 Apr 2008 13:34:38 +1000
Message-ID: <20080429133104.20146.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Bernd Schubert <bernd-schubert@gmx.de>, Dan Williams <dan.j.williams@intel.com>, stable@kernel.org
List-Id: linux-raid.ids


Following 9 patches for md are suitable for 2.5.26.  
Yes, I really should have submitted them to -mm earlier, but I've been
on leave, sorry.

First patch is a bug fix that should go in 2.6.25.stable. 
It has been copied to stable@kernel.org. 

Others are mostly related to "external" metadata support.  i.e. a userspace
program does all the management of metadata, and needs to communicate
with the kernel to do its job properly.

NeilBrown


 [PATCH 001 of 9] md: Fix use after free when removing rdev via sysfs
 [PATCH 002 of 9] md: Skip all metadata update processing when using external metadata.
 [PATCH 003 of 9] md: Reinitialise more mddev fields in do_md_stop.
 [PATCH 004 of 9] md: Fix 'safemode' handling for external metadata.
 [PATCH 005 of 9] md: Fix up switching md arrays between read-only and read-write
 [PATCH 006 of 9] md: Remove a stray command from a copy and paste error in resync_start_store
 [PATCH 007 of 9] md: prevent duplicates in bind_rdev_to_array
 [PATCH 008 of 9] md: md: raid5 rate limit error printk
 [PATCH 009 of 9] md: md: support blocking writes to an array on device failure
