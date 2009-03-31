From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/14] md/raid5: allow layout and chunksize to be changed
	on active array.
Date: Tue, 31 Mar 2009 15:54:43 +1100
Message-ID: <20090331045443.2589.66653.stgit@notabene.brown>
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

If an array has 3 or more devices, we allow the chunksize or layout
to be changed and when a reshape starts, we use these as the 'new'
values.


Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   76 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f7fb2b8..4fdc6d0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4397,9 +4397,7 @@ static int run(mddev_t *mddev)
 		int old_disks;
 		int max_degraded = (mddev->level == 6 ? 2 : 1);
 
-		if (mddev->new_level != mddev->level ||
-		    mddev->new_layout != mddev->layout ||
-		    mddev->new_chunk != mddev->chunk_size) {
+		if (mddev->new_level != mddev->level) {
 			printk(KERN_ERR "raid5: %s: unsupported reshape "
 			       "required - aborting.\n",
 			       mdname(mddev));
@@ -4784,8 +4782,10 @@ static int raid5_check_reshape(mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
-	if (mddev->delta_disks == 0)
-		return 0; /* nothing to do */
+	if (mddev->delta_disks == 0 &&
+	    mddev->new_layout == mddev->layout &&
+	    mddev->new_chunk == mddev->chunk_size)
+		return -EINVAL; /* nothing to do */
 	if (mddev->bitmap)
 		/* Cannot grow a bitmap yet */
 		return -EBUSY;
@@ -4860,6 +4860,10 @@ static int raid5_start_reshape(mddev_t *mddev)
 	spin_lock_irq(&conf->device_lock);
 	conf->previous_raid_disks = conf->raid_disks;
 	conf->raid_disks += mddev->delta_disks;
+	conf->prev_chunk = conf->chunk_size;
+	conf->chunk_size = mddev->new_chunk;
+	conf->prev_algo = conf->algorithm;
+	conf->algorithm = mddev->new_layout;
 	if (mddev->delta_disks < 0)
 		conf->reshape_progress = raid5_size(mddev, 0, 0);
 	else
@@ -4952,6 +4956,7 @@ static void end_reshape(raid5_conf_t *conf)
 static void raid5_finish_reshape(mddev_t *mddev)
 {
 	struct block_device *bdev;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 
@@ -4970,7 +4975,6 @@ static void raid5_finish_reshape(mddev_t *mddev)
 			}
 		} else {
 			int d;
-			raid5_conf_t *conf = mddev_to_conf(mddev);
 			mddev->degraded = conf->raid_disks;
 			for (d = 0; d < conf->raid_disks ; d++)
 				if (conf->disks[d].rdev &&
@@ -4982,6 +4986,8 @@ static void raid5_finish_reshape(mddev_t *mddev)
 			     d++)
 				raid5_remove_disk(mddev, d);
 		}
+		mddev->layout = conf->algorithm;
+		mddev->chunk_size = conf->chunk_size;
 		mddev->reshape_position = MaxSector;
 		mddev->delta_disks = 0;
 	}
@@ -5080,11 +5086,10 @@ static void *raid5_takeover_raid6(mddev_t *mddev)
 
 static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 {
-	/* Currently the layout and chunk size can only be changed
-	 * for a 2-drive raid array, as in that case no data shuffling
-	 * is required.
-	 * Later we might validate these and set new_* so a reshape
-	 * can complete the change.
+	/* For a 2-drive array, the layout and chunk size can be changed
+	 * immediately as not restriping is needed.
+	 * For larger arrays we record the new value - after validation
+	 * to be used by a reshape pass.
 	 */
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
@@ -5103,19 +5108,49 @@ static int raid5_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
 
 	/* They look valid */
 
-	if (mddev->raid_disks != 2)
-		return -EINVAL;
+	if (mddev->raid_disks == 2) {
 
-	if (new_layout >= 0) {
-		conf->algorithm = new_layout;
-		mddev->layout = mddev->new_layout = new_layout;
+		if (new_layout >= 0) {
+			conf->algorithm = new_layout;
+			mddev->layout = mddev->new_layout = new_layout;
+		}
+		if (new_chunk > 0) {
+			conf->chunk_size = new_chunk;
+			mddev->chunk_size = mddev->new_chunk = new_chunk;
+		}
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+	} else {
+		if (new_layout >= 0)
+			mddev->new_layout = new_layout;
+		if (new_chunk > 0)
+			mddev->new_chunk = new_chunk;
 	}
+	return 0;
+}
+
+static int raid6_reconfig(mddev_t *mddev, int new_layout, int new_chunk)
+{
+	if (new_layout >= 0 && !algorithm_valid_raid6(new_layout))
+		return -EINVAL;
 	if (new_chunk > 0) {
-		conf->chunk_size = new_chunk;
-		mddev->chunk_size = mddev->new_chunk = new_chunk;
+		if (new_chunk & (new_chunk-1))
+			/* not a power of 2 */
+			return -EINVAL;
+		if (new_chunk < PAGE_SIZE)
+			return -EINVAL;
+		if (mddev->array_sectors & ((new_chunk>>9)-1))
+			/* not factor of array size */
+			return -EINVAL;
 	}
-	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	md_wakeup_thread(mddev->thread);
+
+	/* They look valid */
+
+	if (new_layout >= 0)
+		mddev->new_layout = new_layout;
+	if (new_chunk > 0)
+		mddev->new_chunk = new_chunk;
+
 	return 0;
 }
 
@@ -5216,6 +5251,7 @@ static struct mdk_personality raid6_personality =
 #endif
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
+	.reconfig	= raid6_reconfig,
 };
 static struct mdk_personality raid5_personality =
 {


