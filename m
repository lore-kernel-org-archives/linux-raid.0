From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 18] Fix problem with raid6 intent bitmap
Date: Mon, 28 Nov 2005 10:39:52 +1100
Message-ID: <1051127233952.14769@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When doing a recovery, we need to know whether the array will
still be degraded after the recovery has finished, so we can 
know whether bits can be clearred yet or not.  This patch
performs the required check.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid6main.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-11-28 10:08:33.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-11-28 10:09:27.000000000 +1100
@@ -1702,6 +1702,8 @@ static sector_t sync_request(mddev_t *md
 	int data_disks = raid_disks - 2;
 	sector_t max_sector = mddev->size << 1;
 	int sync_blocks;
+	int still_degraded = 0;
+	int i;
 
 	if (sector_nr >= max_sector) {
 		/* just being told to finish up .. nothing much to do */
@@ -1710,7 +1712,7 @@ static sector_t sync_request(mddev_t *md
 		if (mddev->curr_resync < max_sector) /* aborted */
 			bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
 					&sync_blocks, 1);
-		else /* compelted sync */
+		else /* completed sync */
 			conf->fullsync = 0;
 		bitmap_close_sync(mddev->bitmap);
 
@@ -1748,7 +1750,16 @@ static sector_t sync_request(mddev_t *md
 		 */
 		schedule_timeout_uninterruptible(1);
 	}
-	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 0);
+	/* Need to check if array will still be degraded after recovery/resync
+	 * We don't need to check the 'failed' flag as when that gets set,
+	 * recovery aborts.
+	 */
+	for (i=0; i<mddev->raid_disks; i++)
+		if (conf->disks[i].rdev == NULL)
+			still_degraded = 1;
+
+	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
+
 	spin_lock(&sh->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
