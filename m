From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 4] md: Introduction - some revised/reordered patches.
Date: Mon, 28 Aug 2006 09:49:12 +1000
Message-ID: <20060828092849.21292.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are revisions of 4 patches currently in -rc4-mm3
which reorder the last to be the first, as that first should
go to 2.6.18, but the others don't need to.

The patches are:

md-fix-issues-with-referencing-rdev-in-md-raid1.patch
md-factor-out-part-of-raid1d-into-a-separate-function.patch
md-remove-working_disks-from-raid1-state-data.patch
md-improve-locking-around-error-handling.patch

The first one listed above was at the end of the list, and should
go into 2.6.18.

Thanks,
NeilBrown
