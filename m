From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 9] md: Introduction - assorted cleanup and minor fixes
Date: Mon, 31 Jul 2006 17:31:34 +1000
Message-ID: <20060731172842.24323.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are 9 patches for md in 2.6-mm-latest that should be
targeted for 2.6.19 (not 2.6.18 material).

Nothing really remarkable, so I'll leave to speak for themselves.

NeilBrown


 [PATCH 001 of 9] md: The scheduled removal of the START_ARRAY ioctl for md
 [PATCH 002 of 9] md: Fix a comment that is wrong in raid5.h
 [PATCH 003 of 9] md: Factor out part of raid1d into a separate function.
 [PATCH 004 of 9] md: Factor out part of raid10d into a separate function.
 [PATCH 005 of 9] md: Replace magic numbers in sb_dirty with well defined bit flags
 [PATCH 006 of 9] md: Remove the working_disks and failed_disks from raid5 state data.
 [PATCH 007 of 9] md: Remove 'working_disks' from raid10 state
 [PATCH 008 of 9] md: Remove working_disks from raid1 state data
 [PATCH 009 of 9] md: Improve locking around error handling.
