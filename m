From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 10] Introduction
Date: Wed, 2 Nov 2005 21:14:42 +1100
Message-ID: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Greg KH <greg@kroah.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 10 patches for md against what is currently in -mm.
'8' probbly applied to 2.6.14, but the rest do not as they are 
fixes and improvements to stuff that is only in -mm.

The bulk of these patches are refining the new sysfs-based interface
to md devices (/sys/block/mdX/md/...) and fixing up some of the
functionality provided by that interface.  The interface is a long way
from complete, but at least with these patches it should be correct.

Notable patches include '4' which fixes some issues with module ref-counting
that I had missed, and protect against the possibility of a sysfs file
being openned with an array is active, and read after it has been stopped.
Also '10' is notable as it contains some documentation for the interface.

At Andrew's request I'm cc:ing some of these to Greg KH - those that specifically
involve sysfs stuff (and are marked with an '*').

With these in place, I think the md stuff in -mm is ready to go to Linus.

Thanks,
NeilBrown


*[PATCH md 001 of 10] Make sure /block link in /sys/.../md/ goes to correct devices.
 [PATCH md 002 of 10] Make manual repair work for raid1.
 [PATCH md 003 of 10] Make sure a user-request sync of raid5 ignores intent bitmap
*[PATCH md 004 of 10] Fix some locking and module refcounting issues with md's use of sysfs.
*[PATCH md 005 of 10] Split off some md attributes in sysfs to a separate group.
 [PATCH md 006 of 10] Only try to print recovery/resync status for personalities that support recovery
 [PATCH md 007 of 10] Ignore auto-readonly flag for arrays where it isn't meaningful.
 [PATCH md 008 of 10] Complete conversion of md to use kthreads.
*[PATCH md 009 of 10] Improve 'scan_mode' and rename it to 'sync_action'
*[PATCH md 010 of 10] Document sysfs usage of md, and make a couple of small refinements.
