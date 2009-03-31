From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/14] md/raid5: reshape using largest of old and new chunk
	size
Date: Tue, 31 Mar 2009 15:54:43 +1100
Message-ID: <20090331045443.2589.70639.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This ensures that even when old and new stripes are overlapping,
we will try to read all of the old before having to write any
of the new.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 80ec9a6..f7fb2b8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3738,6 +3738,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	int dd_idx;
 	sector_t writepos, safepos, gap;
 	sector_t stripe_addr;
+	int reshape_sectors;
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
@@ -3755,6 +3756,15 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		}
 	}
 
+	/* We need to process a full chunk at a time.
+	 * If old and new chunk sizes differ, we need to process the
+	 * largest of these
+	 */
+	if (mddev->new_chunk > mddev->chunk_size)
+		reshape_sectors = mddev->new_chunk / 512;
+	else
+		reshape_sectors = mddev->chunk_size / 512;
+
 	/* we update the metadata when there is more than 3Meg
 	 * in the block range (that is rather arbitrary, should
 	 * probably be time based) or when the data about to be
@@ -3768,12 +3778,12 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
 	if (mddev->delta_disks < 0) {
-		writepos -= conf->chunk_size/512;
-		safepos += conf->chunk_size/512;
+		writepos -= reshape_sectors;
+		safepos += reshape_sectors;
 		gap = conf->reshape_safe - conf->reshape_progress;
 	} else {
-		writepos += conf->chunk_size/512;
-		safepos -= conf->chunk_size/512;
+		writepos += reshape_sectors;
+		safepos -= reshape_sectors;
 		gap = conf->reshape_progress - conf->reshape_safe;
 	}
 
@@ -3799,14 +3809,14 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		BUG_ON(conf->reshape_progress == 0);
 		stripe_addr = writepos;
 		BUG_ON((mddev->dev_sectors &
-			~((sector_t)conf->chunk_size / 512 - 1))
-		       - (conf->chunk_size / 512) - stripe_addr
+			~((sector_t)reshape_sectors - 1))
+		       - reshape_sectors - stripe_addr
 		       != sector_nr);
 	} else {
-		BUG_ON(writepos != sector_nr + conf->chunk_size / 512);
+		BUG_ON(writepos != sector_nr + reshape_sectors);
 		stripe_addr = sector_nr;
 	}
-	for (i=0; i < conf->chunk_size/512; i+= STRIPE_SECTORS) {
+	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS) {
 		int j;
 		int skipped = 0;
 		sh = get_active_stripe(conf, stripe_addr+i, 0, 0);
@@ -3839,9 +3849,9 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	}
 	spin_lock_irq(&conf->device_lock);
 	if (mddev->delta_disks < 0)
-		conf->reshape_progress -= i * new_data_disks;
+		conf->reshape_progress -= reshape_sectors * new_data_disks;
 	else
-		conf->reshape_progress += i * new_data_disks;
+		conf->reshape_progress += reshape_sectors * new_data_disks;
 	spin_unlock_irq(&conf->device_lock);
 	/* Ok, those stripe are ready. We can start scheduling
 	 * reads on the source stripes.
@@ -3867,7 +3877,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	/* If this takes us to the resync_max point where we have to pause,
 	 * then we need to write out the superblock.
 	 */
-	sector_nr += conf->chunk_size>>9;
+	sector_nr += reshape_sectors;
 	if (sector_nr >= mddev->resync_max) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
@@ -3883,7 +3893,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
 	}
-	return conf->chunk_size>>9;
+	return reshape_sectors;
 }
 
 /* FIXME go_faster isn't used */


