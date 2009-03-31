From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/14] md/raid5: change reshape-progress measurement to
	cope with reshaping backwards.
Date: Tue, 31 Mar 2009 15:54:42 +1100
Message-ID: <20090331045442.2589.20308.stgit@notabene.brown>
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

When reducing the number of devices in a raid4/5/6, the reshape
process has to start at the end of the array and work down to the
beginning.  So we need to handle expand_progress and expand_lo
differently.

This patch renames "expand_progress" and "expand_lo" to avoid the
implication that anything is getting bigger (expand->reshape) and
every place they are used, we make sure that they are used the right
way depending on whether delta_disks is positive or negative.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   94 ++++++++++++++++++++++++++++++++++------------------
 drivers/md/raid5.h |   15 ++++++--
 2 files changed, 71 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a0f22dd..1023c4e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3593,24 +3593,28 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	retry:
 		previous = 0;
 		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
-		if (likely(conf->expand_progress == MaxSector))
+		if (likely(conf->reshape_progress == MaxSector))
 			disks = conf->raid_disks;
 		else {
-			/* spinlock is needed as expand_progress may be
+			/* spinlock is needed as reshape_progress may be
 			 * 64bit on a 32bit platform, and so it might be
 			 * possible to see a half-updated value
-			 * Ofcourse expand_progress could change after
+			 * Ofcourse reshape_progress could change after
 			 * the lock is dropped, so once we get a reference
 			 * to the stripe that we think it is, we will have
 			 * to check again.
 			 */
 			spin_lock_irq(&conf->device_lock);
 			disks = conf->raid_disks;
-			if (logical_sector >= conf->expand_progress) {
+			if (mddev->delta_disks < 0
+			    ? logical_sector < conf->reshape_progress
+			    : logical_sector >= conf->reshape_progress) {
 				disks = conf->previous_raid_disks;
 				previous = 1;
 			} else {
-				if (logical_sector >= conf->expand_lo) {
+				if (mddev->delta_disks < 0
+				    ? logical_sector < conf->reshape_safe
+				    : logical_sector >= conf->reshape_safe) {
 					spin_unlock_irq(&conf->device_lock);
 					schedule();
 					goto retry;
@@ -3630,7 +3634,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 		sh = get_active_stripe(conf, new_sector, previous,
 				       (bi->bi_rw&RWA_MASK));
 		if (sh) {
-			if (unlikely(conf->expand_progress != MaxSector)) {
+			if (unlikely(conf->reshape_progress != MaxSector)) {
 				/* expansion might have moved on while waiting for a
 				 * stripe, so we must do the range check again.
 				 * Expansion could still move past after this
@@ -3641,8 +3645,10 @@ static int make_request(struct request_queue *q, struct bio * bi)
 				 */
 				int must_retry = 0;
 				spin_lock_irq(&conf->device_lock);
-				if (logical_sector <  conf->expand_progress &&
-				    disks == conf->previous_raid_disks)
+				if ((mddev->delta_disks < 0
+				     ? logical_sector >= conf->reshape_progress
+				     : logical_sector < conf->reshape_progress)
+				    && disks == conf->previous_raid_disks)
 					/* mismatch, need to try again */
 					must_retry = 1;
 				spin_unlock_irq(&conf->device_lock);
@@ -3720,13 +3726,20 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	int dd_idx;
 	sector_t writepos, safepos, gap;
 
-	if (sector_nr == 0 &&
-	    conf->expand_progress != 0) {
-		/* restarting in the middle, skip the initial sectors */
-		sector_nr = conf->expand_progress;
+	if (sector_nr == 0) {
+		/* If restarting in the middle, skip the initial sectors */
+		if (mddev->delta_disks < 0 &&
+		    conf->reshape_progress < raid5_size(mddev, 0, 0)) {
+			sector_nr = raid5_size(mddev, 0, 0)
+				- conf->reshape_progress;
+		} else if (mddev->delta_disks > 0 &&
+			   conf->reshape_progress > 0)
+			sector_nr = conf->reshape_progress;
 		sector_div(sector_nr, new_data_disks);
-		*skipped = 1;
-		return sector_nr;
+		if (sector_nr) {
+			*skipped = 1;
+			return sector_nr;
+		}
 	}
 
 	/* we update the metadata when there is more than 3Meg
@@ -3734,28 +3747,37 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * probably be time based) or when the data about to be
 	 * copied would over-write the source of the data at
 	 * the front of the range.
-	 * i.e. one new_stripe forward from expand_progress new_maps
-	 * to after where expand_lo old_maps to
+	 * i.e. one new_stripe along from reshape_progress new_maps
+	 * to after where reshape_safe old_maps to
 	 */
-	writepos = conf->expand_progress +
-		conf->chunk_size/512*(new_data_disks);
+	writepos = conf->reshape_progress;
 	sector_div(writepos, new_data_disks);
-	safepos = conf->expand_lo;
+	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
-	gap = conf->expand_progress - conf->expand_lo;
+	if (mddev->delta_disks < 0) {
+		writepos -= conf->chunk_size/512;
+		safepos += conf->chunk_size/512;
+		gap = conf->reshape_safe - conf->reshape_progress;
+	} else {
+		writepos += conf->chunk_size/512;
+		safepos -= conf->chunk_size/512;
+		gap = conf->reshape_progress - conf->reshape_safe;
+	}
 
-	if (writepos >= safepos ||
+	if ((mddev->delta_disks < 0
+	     ? writepos < safepos
+	     : writepos > safepos) ||
 	    gap > (new_data_disks)*3000*2 /*3Meg*/) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes)==0);
-		mddev->reshape_position = conf->expand_progress;
+		mddev->reshape_position = conf->reshape_progress;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait, mddev->flags == 0 ||
 			   kthread_should_stop());
 		spin_lock_irq(&conf->device_lock);
-		conf->expand_lo = mddev->reshape_position;
+		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
 	}
@@ -3792,7 +3814,10 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		release_stripe(sh);
 	}
 	spin_lock_irq(&conf->device_lock);
-	conf->expand_progress = (sector_nr + i) * new_data_disks;
+	if (mddev->delta_disks < 0)
+		conf->reshape_progress -= i * new_data_disks;
+	else
+		conf->reshape_progress += i * new_data_disks;
 	spin_unlock_irq(&conf->device_lock);
 	/* Ok, those stripe are ready. We can start scheduling
 	 * reads on the source stripes.
@@ -3823,14 +3848,14 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes) == 0);
-		mddev->reshape_position = conf->expand_progress;
+		mddev->reshape_position = conf->reshape_progress;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		md_wakeup_thread(mddev->thread);
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_CHANGE_DEVS, &mddev->flags)
 			   || kthread_should_stop());
 		spin_lock_irq(&conf->device_lock);
-		conf->expand_lo = mddev->reshape_position;
+		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
 	}
@@ -4283,7 +4308,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		conf->max_degraded = 1;
 	conf->algorithm = mddev->new_layout;
 	conf->max_nr_stripes = NR_STRIPES;
-	conf->expand_progress = mddev->reshape_position;
+	conf->reshape_progress = mddev->reshape_position;
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
@@ -4441,9 +4466,9 @@ static int run(mddev_t *mddev)
 
 	print_raid5_conf(conf);
 
-	if (conf->expand_progress != MaxSector) {
+	if (conf->reshape_progress != MaxSector) {
 		printk("...ok start reshape thread\n");
-		conf->expand_lo = conf->expand_progress;
+		conf->reshape_safe = conf->reshape_progress;
 		atomic_set(&conf->reshape_stripes, 0);
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -4782,8 +4807,11 @@ static int raid5_start_reshape(mddev_t *mddev)
 	spin_lock_irq(&conf->device_lock);
 	conf->previous_raid_disks = conf->raid_disks;
 	conf->raid_disks += mddev->delta_disks;
-	conf->expand_progress = 0;
-	conf->expand_lo = 0;
+	if (mddev->delta_disks < 0)
+		conf->reshape_progress = raid5_size(mddev, 0, 0);
+	else
+		conf->reshape_progress = 0;
+	conf->reshape_safe = conf->reshape_progress;
 	spin_unlock_irq(&conf->device_lock);
 
 	/* Add some new drives, as many as will fit.
@@ -4825,7 +4853,7 @@ static int raid5_start_reshape(mddev_t *mddev)
 		mddev->recovery = 0;
 		spin_lock_irq(&conf->device_lock);
 		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
-		conf->expand_progress = MaxSector;
+		conf->reshape_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
 		return -EAGAIN;
 	}
@@ -4842,7 +4870,7 @@ static void end_reshape(raid5_conf_t *conf)
 
 		spin_lock_irq(&conf->device_lock);
 		conf->previous_raid_disks = conf->raid_disks;
-		conf->expand_progress = MaxSector;
+		conf->reshape_progress = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
 
 		/* read-ahead size must cover two whole stripes, which is
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index c2f37f2..b2edcc4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -337,11 +337,16 @@ struct raid5_private_data {
 	int			raid_disks;
 	int			max_nr_stripes;
 
-	/* used during an expand */
-	sector_t		expand_progress;	/* MaxSector when no expand happening */
-	sector_t		expand_lo; /* from here up to expand_progress it out-of-bounds
-					    * as we haven't flushed the metadata yet
-					    */
+	/* reshape_progress is the leading edge of a 'reshape'
+	 * It has value MaxSector when no reshape is happening
+	 * If delta_disks < 0, it is the last sector we started work on,
+	 * else is it the next sector to work on.
+	 */
+	sector_t		reshape_progress;
+	/* reshape_safe is the trailing edge of a reshape.  We know that
+	 * before (or after) this address, all reshape has completed.
+	 */
+	sector_t		reshape_safe;
 	int			previous_raid_disks;
 
 	struct list_head	handle_list; /* stripes needing handling */


