From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 5] md: Assorted minor fixes for mainline
Date: Fri, 8 Dec 2006 12:05:24 +1100
Message-ID: <20061208120132.21203.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are 5 patches for md in 2.6.19-rc6-mm2 that are suitable for 2.6.20.

Patch 4 might fix an outstanding bug against md which manifests as an
oops early in boot, but I don't have test results yet.

NeilBrown

 [PATCH 001 of 5] md: Remove some old ifdefed-out code from raid5.c
 [PATCH 002 of 5] md: Return a non-zero error to bi_end_io as appropriate in raid5.
 [PATCH 003 of 5] md: Assorted md and raid1 one-liners
 [PATCH 004 of 5] md: Close a race between destroying and recreating an md device.
 [PATCH 005 of 5] md: Allow mddevs to live a bit longer to avoid a loop with udev.
