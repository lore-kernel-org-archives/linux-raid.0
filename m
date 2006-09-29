From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 6] md: Introduction
Date: Fri, 29 Sep 2006 12:52:44 +1000
Message-ID: <20060929125047.14064.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are 6 bug fixes and minor improvements for md.
Patches are against 2.6.18-mm2 and are all suitable for
immediate inclusion in 2.6.19.

Thanks,
NeilBrown


 [PATCH 001 of 6] md: Fix duplicity of levels in md.txt
 [PATCH 002 of 6] md: Remove MAX_MD_DEVS which is an arbitrary limit.
 [PATCH 003 of 6] md: Remove 'experimental' classification from raid5 reshape.
 [PATCH 004 of 6] md: Use ffz instead of find_first_set to convert multiplier to shift.
 [PATCH 005 of 6] md: Allow SET_BITMAP_FILE to work on 64bit kernel with 32bit userspace.
 [PATCH 006 of 6] md: Add error reporting to superblock write failure
