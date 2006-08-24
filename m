From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 4] md: Fix recent breakage of md/raid1 array checking
Date: Thu, 24 Aug 2006 17:41:01 +1000
Message-ID: <1060824074101.19135@suse.de>
References: <20060824173647.19026.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750790AbWHXHlE@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


A recent patch broke the ability to do a 
user-request check of a raid1.
This patch fixes the breakage and also moves a comment that
was dislocated by the same patch.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2006-08-24 17:09:42.000000000 +1000
+++ ./drivers/md/raid1.c	2006-08-24 17:21:35.000000000 +1000
@@ -1644,15 +1644,16 @@ static sector_t sync_request(mddev_t *md
 		return 0;
 	}
 
-	/* before building a request, check if we can skip these blocks..
-	 * This call the bitmap_start_sync doesn't actually record anything
-	 */
 	if (mddev->bitmap == NULL &&
 	    mddev->recovery_cp == MaxSector &&
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    conf->fullsync == 0) {
 		*skipped = 1;
 		return max_sector - sector_nr;
 	}
+	/* before building a request, check if we can skip these blocks..
+	 * This call the bitmap_start_sync doesn't actually record anything
+	 */
 	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
 	    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		/* We can skip this block, and probably several more */
