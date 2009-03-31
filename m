From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/14] md: allow number of drives in raid5 to be reduced
Date: Tue, 31 Mar 2009 15:54:43 +1100
Message-ID: <20090331045442.2589.14454.stgit@notabene.brown>
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

When reshaping a raid5 to have fewer devices, we work from the end of
the array to the beginning.
md_do_sync gives addresses to sync_request that go from the beginning
to the end.  So largely ignore them use the internal state variable
"reshape_progress" to keep track of what to do next.

Never allow the size to be reduced below the minimum (4 for raid6,
3 otherwise).

We require that the size of the array has already been reduced before
the array is reshaped to a smaller size.  This is because simply
reducing the size is an easily reversible operation, while the reshape
is immediately destructive and so is not reversible for the blocks at
the ends of the devices.
Thus to reshape an array to have fewer devices, you must first write
an appropriately small size to md/array_size.

When reshape finished, we remove any drives that are no longer
needed and fix up ->degraded.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  124 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 87 insertions(+), 37 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1023c4e..76eed59 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3725,6 +3725,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	int i;
 	int dd_idx;
 	sector_t writepos, safepos, gap;
+	sector_t stripe_addr;
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
@@ -3782,10 +3783,21 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		wake_up(&conf->wait_for_overlap);
 	}
 
+	if (mddev->delta_disks < 0) {
+		BUG_ON(conf->reshape_progress == 0);
+		stripe_addr = writepos;
+		BUG_ON((mddev->dev_sectors &
+			~((sector_t)mddev->chunk_size / 512 - 1))
+		       - (conf->chunk_size / 512) - stripe_addr
+		       != sector_nr);
+	} else {
+		BUG_ON(writepos != sector_nr + conf->chunk_size / 512);
+		stripe_addr = sector_nr;
+	}
 	for (i=0; i < conf->chunk_size/512; i+= STRIPE_SECTORS) {
 		int j;
 		int skipped = 0;
-		sh = get_active_stripe(conf, sector_nr+i, 0, 0);
+		sh = get_active_stripe(conf, stripe_addr+i, 0, 0);
 		set_bit(STRIPE_EXPANDING, &sh->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
@@ -3825,10 +3837,10 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * block on the destination stripes.
 	 */
 	first_sector =
-		raid5_compute_sector(conf, sector_nr*(new_data_disks),
+		raid5_compute_sector(conf, stripe_addr*(new_data_disks),
 				     1, &dd_idx, NULL);
 	last_sector =
-		raid5_compute_sector(conf, ((sector_nr+conf->chunk_size/512)
+		raid5_compute_sector(conf, ((stripe_addr+conf->chunk_size/512)
 					    *(new_data_disks) - 1),
 				     1, &dd_idx, NULL);
 	if (last_sector >= mddev->dev_sectors)
@@ -4366,12 +4378,6 @@ static int run(mddev_t *mddev)
 			       mdname(mddev));
 			return -EINVAL;
 		}
-		if (mddev->delta_disks <= 0) {
-			printk(KERN_ERR "raid5: %s: unsupported reshape "
-			       "(reduce disks) required - aborting.\n",
-			       mdname(mddev));
-			return -EINVAL;
-		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
 		/* reshape_position must be on a new-stripe boundary, and one
 		 * further up in new geometry must map after here in old
@@ -4648,6 +4654,10 @@ static int raid5_remove_disk(mddev_t *mddev, int number)
 	print_raid5_conf(conf);
 	rdev = p->rdev;
 	if (rdev) {
+		if (number >= conf->raid_disks &&
+		    conf->reshape_progress == MaxSector)
+			clear_bit(In_sync, &rdev->flags);
+
 		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
 			err = -EBUSY;
@@ -4657,7 +4667,8 @@ static int raid5_remove_disk(mddev_t *mddev, int number)
 		 * isn't possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
-		    mddev->degraded <= conf->max_degraded) {
+		    mddev->degraded <= conf->max_degraded &&
+		    number < conf->raid_disks) {
 			err = -EBUSY;
 			goto abort;
 		}
@@ -4745,16 +4756,26 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 static int raid5_check_reshape(mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	int err;
 
-	if (mddev->delta_disks < 0 ||
-	    mddev->new_level != mddev->level)
-		return -EINVAL; /* Cannot shrink array or change level yet */
 	if (mddev->delta_disks == 0)
 		return 0; /* nothing to do */
 	if (mddev->bitmap)
 		/* Cannot grow a bitmap yet */
 		return -EBUSY;
+	if (mddev->degraded > conf->max_degraded)
+		return -EINVAL;
+	if (mddev->delta_disks < 0) {
+		/* We might be able to shrink, but the devices must
+		 * be made bigger first.
+		 * For raid6, 4 is the minimum size.
+		 * Otherwise 2 is the minimum
+		 */
+		int min = 2;
+		if (mddev->level == 6)
+			min = 4;
+		if (mddev->raid_disks + mddev->delta_disks < min)
+			return -EINVAL;
+	}
 
 	/* Can only proceed if there are plenty of stripe_heads.
 	 * We need a minimum of one full stripe,, and for sensible progress
@@ -4771,14 +4792,7 @@ static int raid5_check_reshape(mddev_t *mddev)
 		return -ENOSPC;
 	}
 
-	err = resize_stripes(conf, conf->raid_disks + mddev->delta_disks);
-	if (err)
-		return err;
-
-	if (mddev->degraded > conf->max_degraded)
-		return -EINVAL;
-	/* looks like we might be able to manage this */
-	return 0;
+	return resize_stripes(conf, conf->raid_disks + mddev->delta_disks);
 }
 
 static int raid5_start_reshape(mddev_t *mddev)
@@ -4803,6 +4817,17 @@ static int raid5_start_reshape(mddev_t *mddev)
 		 */
 		return -EINVAL;
 
+	/* Refuse to reduce size of the array.  Any reductions in
+	 * array size must be through explicit setting of array_size
+	 * attribute.
+	 */
+	if (raid5_size(mddev, 0, conf->raid_disks + mddev->delta_disks)
+	    < mddev->array_sectors) {
+		printk(KERN_ERR "md: %s: array size must be reduced "
+		       "before number of disks\n", mdname(mddev));
+		return -EINVAL;
+	}
+
 	atomic_set(&conf->reshape_stripes, 0);
 	spin_lock_irq(&conf->device_lock);
 	conf->previous_raid_disks = conf->raid_disks;
@@ -4836,9 +4861,12 @@ static int raid5_start_reshape(mddev_t *mddev)
 				break;
 		}
 
-	spin_lock_irqsave(&conf->device_lock, flags);
-	mddev->degraded = (conf->raid_disks - conf->previous_raid_disks) - added_devices;
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	if (mddev->delta_disks > 0) {
+		spin_lock_irqsave(&conf->device_lock, flags);
+		mddev->degraded = (conf->raid_disks - conf->previous_raid_disks)
+			- added_devices;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	}
 	mddev->raid_disks = conf->raid_disks;
 	mddev->reshape_position = 0;
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -4863,6 +4891,9 @@ static int raid5_start_reshape(mddev_t *mddev)
 }
 #endif
 
+/* This is called from the reshape thread and should make any
+ * changes needed in 'conf'
+ */
 static void end_reshape(raid5_conf_t *conf)
 {
 
@@ -4886,25 +4917,44 @@ static void end_reshape(raid5_conf_t *conf)
 	}
 }
 
+/* This is called from the raid5d thread with mddev_lock held.
+ * It makes config changes to the device.
+ */
 static void raid5_finish_reshape(mddev_t *mddev)
 {
 	struct block_device *bdev;
 
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 
-		md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		mddev->changed = 1;
-		mddev->reshape_position = MaxSector;
-
-		bdev = bdget_disk(mddev->gendisk, 0);
-		if (bdev) {
-			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode,
-				     (loff_t)mddev->array_sectors << 9);
-			mutex_unlock(&bdev->bd_inode->i_mutex);
-			bdput(bdev);
+		if (mddev->delta_disks > 0) {
+			md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
+			set_capacity(mddev->gendisk, mddev->array_sectors);
+			mddev->changed = 1;
+
+			bdev = bdget_disk(mddev->gendisk, 0);
+			if (bdev) {
+				mutex_lock(&bdev->bd_inode->i_mutex);
+				i_size_write(bdev->bd_inode,
+					     (loff_t)mddev->array_sectors << 9);
+				mutex_unlock(&bdev->bd_inode->i_mutex);
+				bdput(bdev);
+			}
+		} else {
+			int d;
+			raid5_conf_t *conf = mddev_to_conf(mddev);
+			mddev->degraded = conf->raid_disks;
+			for (d = 0; d < conf->raid_disks ; d++)
+				if (conf->disks[d].rdev &&
+				    test_bit(In_sync,
+					     &conf->disks[d].rdev->flags))
+					mddev->degraded--;
+			for (d = conf->raid_disks ;
+			     d < conf->raid_disks - mddev->delta_disks;
+			     d++)
+				raid5_remove_disk(mddev, d);
 		}
+		mddev->reshape_position = MaxSector;
+		mddev->delta_disks = 0;
 	}
 }
 


