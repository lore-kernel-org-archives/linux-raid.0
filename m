From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 3] md: Introduction - assorted fixed for 2.6.16
Date: Thu, 30 Mar 2006 16:52:33 +1100
Message-ID: <20060330164933.25210.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751070AbWC3FyS@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are three patches for md.  The first fixes a problem that
can cause corruption in fairly unusual circumstances (re-adding a
device to a raid1 and suffering write-errors that are subsequntly
fixed and the device is re-added again).

The other two fix minor problems

The are suitable to go straight in to 2.6.17-rc.

NeilBrown

 [PATCH 001 of 3] md: Don't clear bits in bitmap when writing to one device fails during recovery.
 [PATCH 002 of 3] md: Remove some code that can sleep from under a spinlock.
 [PATCH 003 of 3] md: Raid-6 did not create sysfs entries for stripe cache
