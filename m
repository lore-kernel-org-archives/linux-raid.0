From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 5/6] md: allow number of drives in raid5 to be reduced
Date: Tue, 24 Mar 2009 19:53:32 +1100
Message-ID: <20090324085332.15383.76701.stgit@notabene.brown>
References: <20090324084629.15383.10271.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090324084629.15383.10271.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When reshaping a raid5 to have fewer devices, we work from the end of
the array to the beginning.
md_do_sync gives addresses to sync_request that go from the beginning
to the end.  So largely ignore them use the internal state variable
"reshape_progress" to keep track of what to do next.

Never allow the size to be reduced below the minimum (4 doe raid6,
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

 drivers/md/raid5.c |  114 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 87 insertions(+), 27 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8447c9f..aaeb176 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3723,6 +3723,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	int i;
 	int dd_idx;
 	sector_t writepos, safepos, gap;
+	sector_t stripe_addr;
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
@@ -3779,10 +3780,21 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
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
+		stripe_addr = writepos;
+	}
 	for (i=0; i < conf->chunk_size/512; i+= STRIPE_SECTORS) {
 		int j;
 		int skipped = 0;
-		sh = get_active_stripe(conf, sector_nr+i, 0, 0);
+		sh = get_active_stripe(conf, stripe_addr+i, 0, 0);
 		set_bit(STRIPE_EXPANDING, &sh->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
@@ -3822,10 +3834,10 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
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
@@ -4640,6 +4652,10 @@ static int raid5_remove_disk(mddev_t *mddev, int number)
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
@@ -4649,7 +4665,8 @@ static int raid5_remove_disk(mddev_t *mddev, int number)
 		 * isn't possible.
 		 */
 		if (!test_bit(Faulty, &rdev->flags) &&
-		    mddev->degraded <= conf->max_degraded) {
+		    mddev->degraded <= conf->max_degraded &&
+		    number < conf->raid_disks) {
 			err = -EBUSY;
 			goto abort;
 		}
@@ -4738,14 +4755,25 @@ static int raid5_check_reshape(mddev_t *mddev)
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int err;
 
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
@@ -4762,12 +4790,13 @@ static int raid5_check_reshape(mddev_t *mddev)
 		return -ENOSPC;
 	}
 
-	err = resize_stripes(conf, conf->raid_disks + mddev->delta_disks);
-	if (err)
-		return err;
+	if (mddev->delta_disks > 0) {
+		err = resize_stripes(conf, (conf->raid_disks +
+					    mddev->delta_disks));
+		if (err)
+			return err;
+	}
 
-	if (mddev->degraded > conf->max_degraded)
-		return -EINVAL;
 	/* looks like we might be able to manage this */
 	return 0;
 }
@@ -4794,6 +4823,17 @@ static int raid5_start_reshape(mddev_t *mddev)
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
@@ -4827,9 +4867,12 @@ static int raid5_start_reshape(mddev_t *mddev)
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
@@ -4862,21 +4905,38 @@ static void raid5_finish_reshape(mddev_t *mddev)
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 
 		conf->previous_raid_disks = conf->raid_disks;
-		md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		mddev->changed = 1;
-
-		bdev = bdget_disk(mddev->gendisk, 0);
-		if (bdev) {
-			mutex_lock(&bdev->bd_inode->i_mutex);
-			i_size_write(bdev->bd_inode,
-				     (loff_t)mddev->array_sectors << 9);
-			mutex_unlock(&bdev->bd_inode->i_mutex);
-			bdput(bdev);
-		}
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
+		if (mddev->delta_disks > 0) {
+			conf->previous_raid_disks = conf->raid_disks;
+			md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
+			set_capacity(mddev->gendisk, mddev->array_sectors);
+			mddev->changed = 1;
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
+			mddev->degraded = conf->raid_disks;
+			for (d = 0; d < conf->raid_disks ; d++)
+				if (conf->disks[d].rdev &&
+				    test_bit(In_sync,
+					     &conf->disks[d].rdev->flags))
+					mddev->degraded--;
+			for (d = conf->raid_disks ;
+			     d < conf->previous_raid_disks ;
+			     d++)
+				raid5_remove_disk(mddev, d);
+
+			conf->previous_raid_disks = conf->raid_disks;
+		}
+		mddev->delta_disks = 0;
 		mddev->reshape_position = MaxSector;
 
 		/* read-ahead size must cover two whole stripes, which is


