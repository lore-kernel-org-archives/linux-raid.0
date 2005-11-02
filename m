From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 10] Make manual repair work for raid1.
Date: Wed, 2 Nov 2005 21:14:57 +1100
Message-ID: <1051102101457.23860@suse.de>
References: <20051102205640.22689.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Raid1 currently optimises resync using the intent bitmap etc.
This optimisation is not wanted when we explicitly request a
repair through sysfs, so add appropriate checks.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-02 17:32:28.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-02 17:32:48.000000000 +1100
@@ -1314,7 +1314,7 @@ static sector_t sync_request(mddev_t *md
 	 * This call the bitmap_start_sync doesn't actually record anything
 	 */
 	if (!bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
-	    !conf->fullsync) {
+	    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		/* We can skip this block, and probably several more */
 		*skipped = 1;
 		return sync_blocks;
@@ -1391,7 +1391,8 @@ static sector_t sync_request(mddev_t *md
 			still_degraded = 1;
 			continue;
 		} else if (!test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
-			   sector_nr + RESYNC_SECTORS > mddev->recovery_cp) {
+			   sector_nr + RESYNC_SECTORS > mddev->recovery_cp   ||
+			   test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
@@ -1425,8 +1426,9 @@ static sector_t sync_request(mddev_t *md
 			break;
 		if (sync_blocks == 0) {
 			if (!bitmap_start_sync(mddev->bitmap, sector_nr,
-					&sync_blocks, still_degraded) &&
-					!conf->fullsync)
+					       &sync_blocks, still_degraded) &&
+			    !conf->fullsync &&
+			    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 				break;
 			if (sync_blocks < (PAGE_SIZE>>9))
 				BUG();
