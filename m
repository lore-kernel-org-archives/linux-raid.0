From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 5] md: Introduction - assorted fixes
Date: Tue, 24 Jan 2006 14:58:17 +1100
Message-ID: <20060124145516.28734.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The following 5 patches are assorted fixes for md in 2.6.16-whatever

Patch 4 isn't exactly a 'fix'.  It adds functionality to raid6 to match
raid5.

All should be suitable for 2.6.16-rc2

Thanks,
NeilBrown


 [PATCH 001 of 5] md: Fix device-size updates in md.
 [PATCH 002 of 5] md: Make sure array geometry changes persist with version-1 superblocks.
 [PATCH 003 of 5] md: Don't remove bitmap from md array when switching to read-only
 [PATCH 004 of 5] md: Add sysfs access to raid6 stripe cache size
 [PATCH 005 of 5] md: Make sure QUEUE_FLAG_CLUSTER is set properly for md.
