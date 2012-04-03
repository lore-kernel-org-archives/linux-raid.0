From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/10] md/raid5: allow for change in data_offset while
 managing a reshape.
Date: Tue, 03 Apr 2012 15:53:01 +1000
Message-ID: <20120403055301.19495.18368.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The important issue here is incorporating the different in data_offset
into calculations concerning when we might need to over-write data
that is still thought to be valid.

To this end we find the minimum offset difference across all devices
and add that where appropriate.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  109 ++++++++++++++++++++++++++++++++++++----------------
 drivers/md/raid5.h |    6 +++
 2 files changed, 82 insertions(+), 33 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 71d1de9..0172bdd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4165,13 +4165,11 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	else
 		reshape_sectors = mddev->chunk_sectors;
 
-	/* we update the metadata when there is more than 3Meg
-	 * in the block range (that is rather arbitrary, should
-	 * probably be time based) or when the data about to be
-	 * copied would over-write the source of the data at
-	 * the front of the range.
-	 * i.e. one new_stripe along from reshape_progress new_maps
-	 * to after where reshape_safe old_maps to
+	/* We update the metadata at least every 10 seconds, or when
+	 * the data about to be copied would over-write the source of
+	 * the data at the front of the range.  i.e. one new_stripe
+	 * along from reshape_progress new_maps to after where
+	 * reshape_safe old_maps to
 	 */
 	writepos = conf->reshape_progress;
 	sector_div(writepos, new_data_disks);
@@ -4189,11 +4187,29 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		safepos -= min_t(sector_t, reshape_sectors, safepos);
 	}
 
+	/* Having calculated the 'writepos' possibly use it
+	 * to set 'stripe_addr' which is where we will write to.
+	 */
+	if (mddev->reshape_backwards) {
+		BUG_ON(conf->reshape_progress == 0);
+		stripe_addr = writepos;
+		BUG_ON((mddev->dev_sectors &
+			~((sector_t)reshape_sectors - 1))
+		       - reshape_sectors - stripe_addr
+		       != sector_nr);
+	} else {
+		BUG_ON(writepos != sector_nr + reshape_sectors);
+		stripe_addr = sector_nr;
+	}
+
 	/* 'writepos' is the most advanced device address we might write.
 	 * 'readpos' is the least advanced device address we might read.
 	 * 'safepos' is the least address recorded in the metadata as having
 	 *     been reshaped.
-	 * If 'readpos' is behind 'writepos', then there is no way that we can
+	 * If there is a min_offset_diff, these are adjusted either by
+	 * increasing the safepos/readpos if diff is negative, or
+	 * increasing writepos if diff is positive.
+	 * If 'readpos' is then behind 'writepos', there is no way that we can
 	 * ensure safety in the face of a crash - that must be done by userspace
 	 * making a backup of the data.  So in that case there is no particular
 	 * rush to update metadata.
@@ -4206,6 +4222,12 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	 * Maybe that number should be configurable, but I'm not sure it is
 	 * worth it.... maybe it could be a multiple of safemode_delay???
 	 */
+	if (conf->min_offset_diff < 0) {
+		safepos += -conf->min_offset_diff;
+		readpos += -conf->min_offset_diff;
+	} else
+		writepos += conf->min_offset_diff;
+
 	if ((mddev->reshape_backwards
 	     ? (safepos > writepos && readpos < writepos)
 	     : (safepos < writepos && readpos > writepos)) ||
@@ -4227,17 +4249,6 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
 
-	if (mddev->reshape_backwards) {
-		BUG_ON(conf->reshape_progress == 0);
-		stripe_addr = writepos;
-		BUG_ON((mddev->dev_sectors &
-			~((sector_t)reshape_sectors - 1))
-		       - reshape_sectors - stripe_addr
-		       != sector_nr);
-	} else {
-		BUG_ON(writepos != sector_nr + reshape_sectors);
-		stripe_addr = sector_nr;
-	}
 	INIT_LIST_HEAD(&stripes);
 	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS) {
 		int j;
@@ -4984,16 +4995,42 @@ static int run(struct mddev *mddev)
 	struct md_rdev *rdev;
 	sector_t reshape_offset = 0;
 	int i;
+	long long min_offset_diff = 0;
+	int first = 1;
 
 	if (mddev->recovery_cp != MaxSector)
 		printk(KERN_NOTICE "md/raid:%s: not clean"
 		       " -- starting background reconstruction\n",
 		       mdname(mddev));
+
+	rdev_for_each(rdev, mddev) {
+		long long diff;
+		if (rdev->raid_disk < 0)
+			continue;
+		diff = (rdev->new_data_offset - rdev->data_offset);
+		if (first) {
+			min_offset_diff = diff;
+			first = 0;
+		} else if (mddev->reshape_backwards &&
+			 diff < min_offset_diff)
+			min_offset_diff = diff;
+		else if (!mddev->reshape_backwards &&
+			 diff > min_offset_diff)
+			min_offset_diff = diff;
+	}
+
 	if (mddev->reshape_position != MaxSector) {
 		/* Check that we can continue the reshape.
-		 * Currently only disks can change, it must
-		 * increase, and we must be past the point where
-		 * a stripe over-writes itself
+		 * Difficulties arise if the stripe we would write to
+		 * next is at or after the stripe we would read from next.
+		 * For a reshape that changes the number of devices, this
+		 * is only possible for a very short time, and mdadm makes
+		 * sure that time appears to have past before assembling
+		 * the array.  So we fail if that time hasn't passed.
+		 * For a reshape that keeps the number of devices the same
+		 * mdadm must be monitoring the reshape can keeping the
+		 * critical areas read-only and backed up.  It will start
+		 * the array in read-only mode, so we check for that.
 		 */
 		sector_t here_new, here_old;
 		int old_disks;
@@ -5025,26 +5062,34 @@ static int run(struct mddev *mddev)
 		/* here_old is the first stripe that we might need to read
 		 * from */
 		if (mddev->delta_disks == 0) {
+			if ((here_new * mddev->new_chunk_sectors !=
+			     here_old * mddev->chunk_sectors)) {
+				printk(KERN_ERR "md/raid:%s: reshape position is"
+				       " confused - aborting\n", mdname(mddev));
+				return -EINVAL;
+			}
 			/* We cannot be sure it is safe to start an in-place
-			 * reshape.  It is only safe if user-space if monitoring
+			 * reshape.  It is only safe if user-space is monitoring
 			 * and taking constant backups.
 			 * mdadm always starts a situation like this in
 			 * readonly mode so it can take control before
 			 * allowing any writes.  So just check for that.
 			 */
-			if ((here_new * mddev->new_chunk_sectors != 
-			     here_old * mddev->chunk_sectors) ||
-			    mddev->ro == 0) {
-				printk(KERN_ERR "md/raid:%s: in-place reshape must be started"
-				       " in read-only mode - aborting\n",
+			if (abs(min_offset_diff) >= mddev->chunk_sectors &&
+			    abs(min_offset_diff) >= mddev->new_chunk_sectors)
+				/* not really in-place - so OK */;
+			else if (mddev->ro == 0) {
+				printk(KERN_ERR "md/raid:%s: in-place reshape "
+				       "must be started in read-only mode "
+				       "- aborting\n",
 				       mdname(mddev));
 				return -EINVAL;
 			}
 		} else if (mddev->reshape_backwards
-		    ? (here_new * mddev->new_chunk_sectors <=
+		    ? (here_new * mddev->new_chunk_sectors + min_offset_diff <=
 		       here_old * mddev->chunk_sectors)
 		    : (here_new * mddev->new_chunk_sectors >=
-		       here_old * mddev->chunk_sectors)) {
+		       here_old * mddev->chunk_sectors + (-min_offset_diff))) {
 			/* Reading from the same stripe as writing to - bad */
 			printk(KERN_ERR "md/raid:%s: reshape_position too early for "
 			       "auto-recovery - aborting.\n",
@@ -5069,6 +5114,7 @@ static int run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
+	conf->min_offset_diff = min_offset_diff;
 	mddev->thread = conf->thread;
 	conf->thread = NULL;
 	mddev->private = conf;
@@ -5541,9 +5587,6 @@ static int raid5_start_reshape(struct mddev *mddev)
 		return -ENOSPC;
 
 	rdev_for_each(rdev, mddev) {
-		/* Don't support changing data_offset yet */
-		if (rdev->new_data_offset != rdev->data_offset)
-			return -EINVAL;
 		if (!test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags))
 			spares++;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 8d8e139..c6bdfa0 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -385,6 +385,12 @@ struct r5conf {
 	short			generation; /* increments with every reshape */
 	unsigned long		reshape_checkpoint; /* Time we last updated
 						     * metadata */
+	long long		min_offset_diff; /* minimum difference between
+						  * data_offset and
+						  * new_data_offset across all
+						  * devices.  May be negative,
+						  * but is closest to zero.
+						  */
 
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	hold_list; /* preread ready stripes */


