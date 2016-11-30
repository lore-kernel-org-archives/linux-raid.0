From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH 2/2] md/raid10: Refactor raid10_make_request
Date: Wed, 30 Nov 2016 14:20:20 -0700
Message-ID: <20161130212020.15762-3-robert@leblancnet.us>
References: <20161130212020.15762-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161130212020.15762-1-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert LeBlanc <robert@leblancnet.us>
List-Id: linux-raid.ids

Refactor raid10_make_request into seperate read and write functions to
clean up the code.

Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
---
 drivers/md/raid10.c | 271 +++++++++++++++++++++++++++-------------------------
 1 file changed, 139 insertions(+), 132 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be1a9fc..d3bd756 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1046,150 +1046,89 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	kfree(plug);
 }
 
-static void __make_request(struct mddev *mddev, struct bio *bio)
+static void raid10_read_request(struct mddev *mddev, struct bio *bio,
+				struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
-	struct r10bio *r10_bio;
 	struct bio *read_bio;
-	int i;
 	const int op = bio_op(bio);
-	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
-	const unsigned long do_fua = (bio->bi_opf & REQ_FUA);
-	unsigned long flags;
-	struct md_rdev *blocked_rdev;
-	struct blk_plug_cb *cb;
-	struct raid10_plug_cb *plug = NULL;
 	int sectors_handled;
 	int max_sectors;
-	int sectors;
-
-	md_write_start(mddev, bio);
-
-	/*
-	 * Register the new request and wait if the reconstruction
-	 * thread has put up a bar for new requests.
-	 * Continue immediately if no resync is active currently.
-	 */
-	wait_barrier(conf);
-
-	sectors = bio_sectors(bio);
-	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    bio->bi_iter.bi_sector < conf->reshape_progress &&
-	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
-		/* IO spans the reshape position.  Need to wait for
-		 * reshape to pass
-		 */
-		allow_barrier(conf);
-		wait_event(conf->wait_barrier,
-			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
-			   conf->reshape_progress >= bio->bi_iter.bi_sector +
-			   sectors);
-		wait_barrier(conf);
-	}
-	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    bio_data_dir(bio) == WRITE &&
-	    (mddev->reshape_backwards
-	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
-		bio->bi_iter.bi_sector + sectors > conf->reshape_progress)
-	     : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
-		bio->bi_iter.bi_sector < conf->reshape_progress))) {
-		/* Need to update reshape_position in metadata */
-		mddev->reshape_position = conf->reshape_progress;
-		set_mask_bits(&mddev->flags, 0,
-			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
-		md_wakeup_thread(mddev->thread);
-		wait_event(mddev->sb_wait,
-			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+	struct md_rdev *rdev;
+	int slot;
 
-		conf->reshape_safe = mddev->reshape_position;
+read_again:
+	rdev = read_balance(conf, r10_bio, &max_sectors);
+	if (!rdev) {
+		raid_end_bio_io(r10_bio);
+		return;
 	}
+	slot = r10_bio->read_slot;
 
-	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
-
-	r10_bio->master_bio = bio;
-	r10_bio->sectors = sectors;
+	read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+	bio_trim(read_bio, r10_bio->sector - bio->bi_iter.bi_sector,
+		 max_sectors);
 
-	r10_bio->mddev = mddev;
-	r10_bio->sector = bio->bi_iter.bi_sector;
-	r10_bio->state = 0;
+	r10_bio->devs[slot].bio = read_bio;
+	r10_bio->devs[slot].rdev = rdev;
 
-	/* We might need to issue multiple reads to different
-	 * devices if there are bad blocks around, so we keep
-	 * track of the number of reads in bio->bi_phys_segments.
-	 * If this is 0, there is only one r10_bio and no locking
-	 * will be needed when the request completes.  If it is
-	 * non-zero, then it is the number of not-completed requests.
-	 */
-	bio->bi_phys_segments = 0;
-	bio_clear_flag(bio, BIO_SEG_VALID);
+	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
+		choose_data_offset(r10_bio, rdev);
+	read_bio->bi_bdev = rdev->bdev;
+	read_bio->bi_end_io = raid10_end_read_request;
+	bio_set_op_attrs(read_bio, op, do_sync);
+	read_bio->bi_private = r10_bio;
 
-	if (rw == READ) {
-		/*
-		 * read balancing logic:
+	if (max_sectors < r10_bio->sectors) {
+		/* Could not read all from this device, so we will
+		 * need another r10_bio.
 		 */
-		struct md_rdev *rdev;
-		int slot;
-
-read_again:
-		rdev = read_balance(conf, r10_bio, &max_sectors);
-		if (!rdev) {
-			raid_end_bio_io(r10_bio);
-			return;
-		}
-		slot = r10_bio->read_slot;
-
-		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		bio_trim(read_bio, r10_bio->sector - bio->bi_iter.bi_sector,
-			 max_sectors);
-
-		r10_bio->devs[slot].bio = read_bio;
-		r10_bio->devs[slot].rdev = rdev;
-
-		read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
-			choose_data_offset(r10_bio, rdev);
-		read_bio->bi_bdev = rdev->bdev;
-		read_bio->bi_end_io = raid10_end_read_request;
-		bio_set_op_attrs(read_bio, op, do_sync);
-		read_bio->bi_private = r10_bio;
+		sectors_handled = (r10_bio->sector + max_sectors
+				   - bio->bi_iter.bi_sector);
+		r10_bio->sectors = max_sectors;
+		spin_lock_irq(&conf->device_lock);
+		if (bio->bi_phys_segments == 0)
+			bio->bi_phys_segments = 2;
+		else
+			bio->bi_phys_segments++;
+		spin_unlock_irq(&conf->device_lock);
+		/* Cannot call generic_make_request directly
+		 * as that will be queued in __generic_make_request
+		 * and subsequent mempool_alloc might block
+		 * waiting for it.  so hand bio over to raid10d.
+		 */
+		reschedule_retry(r10_bio);
 
-		if (max_sectors < r10_bio->sectors) {
-			/* Could not read all from this device, so we will
-			 * need another r10_bio.
-			 */
-			sectors_handled = (r10_bio->sector + max_sectors
-					   - bio->bi_iter.bi_sector);
-			r10_bio->sectors = max_sectors;
-			spin_lock_irq(&conf->device_lock);
-			if (bio->bi_phys_segments == 0)
-				bio->bi_phys_segments = 2;
-			else
-				bio->bi_phys_segments++;
-			spin_unlock_irq(&conf->device_lock);
-			/* Cannot call generic_make_request directly
-			 * as that will be queued in __generic_make_request
-			 * and subsequent mempool_alloc might block
-			 * waiting for it.  so hand bio over to raid10d.
-			 */
-			reschedule_retry(r10_bio);
+		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
-			r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
+		r10_bio->master_bio = bio;
+		r10_bio->sectors = bio_sectors(bio) - sectors_handled;
+		r10_bio->state = 0;
+		r10_bio->mddev = mddev;
+		r10_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
+		goto read_again;
+	} else
+		generic_make_request(read_bio);
+	return;
+}
 
-			r10_bio->master_bio = bio;
-			r10_bio->sectors = bio_sectors(bio) - sectors_handled;
-			r10_bio->state = 0;
-			r10_bio->mddev = mddev;
-			r10_bio->sector = bio->bi_iter.bi_sector +
-				sectors_handled;
-			goto read_again;
-		} else
-			generic_make_request(read_bio);
-		return;
-	}
+static void raid10_write_request(struct mddev *mddev, struct bio *bio,
+				 struct r10bio *r10_bio)
+{
+	struct r10conf *conf = mddev->private;
+	int i;
+	const int op = bio_op(bio);
+	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
+	const unsigned long do_fua = (bio->bi_opf & REQ_FUA);
+	unsigned long flags;
+	struct md_rdev *blocked_rdev;
+	struct blk_plug_cb *cb;
+	struct raid10_plug_cb *plug = NULL;
+	int sectors_handled;
+	int max_sectors;
+	md_write_start(mddev, bio);
 
-	/*
-	 * WRITE:
-	 */
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
 		wait_event(conf->wait_barrier,
@@ -1249,8 +1188,7 @@ retry_write:
 			int bad_sectors;
 			int is_bad;
 
-			is_bad = is_badblock(rdev, dev_sector,
-					     max_sectors,
+			is_bad = is_badblock(rdev, dev_sector, max_sectors,
 					     &first_bad, &bad_sectors);
 			if (is_bad < 0) {
 				/* Mustn't write here until the bad block
@@ -1353,8 +1291,7 @@ retry_write:
 			r10_bio->devs[i].bio = mbio;
 
 			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr+
-					   choose_data_offset(r10_bio,
-							      rdev));
+					   choose_data_offset(r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			bio_set_op_attrs(mbio, op, do_sync | do_fua);
@@ -1395,8 +1332,7 @@ retry_write:
 			r10_bio->devs[i].repl_bio = mbio;
 
 			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
-					   choose_data_offset(
-						   r10_bio, rdev));
+					   choose_data_offset(r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
 			mbio->bi_end_io	= raid10_end_write_request;
 			bio_set_op_attrs(mbio, op, do_sync | do_fua);
@@ -1434,6 +1370,77 @@ retry_write:
 	one_write_done(r10_bio);
 }
 
+static void __make_request(struct mddev *mddev, struct bio *bio)
+{
+	struct r10conf *conf = mddev->private;
+	struct r10bio *r10_bio;
+	int sectors;
+
+	/*
+	 * Register the new request and wait if the reconstruction
+	 * thread has put up a bar for new requests.
+	 * Continue immediately if no resync is active currently.
+	 */
+	wait_barrier(conf);
+
+	sectors = bio_sectors(bio);
+	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	    bio->bi_iter.bi_sector < conf->reshape_progress &&
+	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
+		/* IO spans the reshape position.  Need to wait for
+		 * reshape to pass
+		 */
+		allow_barrier(conf);
+		wait_event(conf->wait_barrier,
+			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
+			   conf->reshape_progress >= bio->bi_iter.bi_sector +
+			   sectors);
+		wait_barrier(conf);
+	}
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	    bio_data_dir(bio) == WRITE &&
+	    (mddev->reshape_backwards
+	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
+		bio->bi_iter.bi_sector + sectors > conf->reshape_progress)
+	     : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
+		bio->bi_iter.bi_sector < conf->reshape_progress))) {
+		/* Need to update reshape_position in metadata */
+		mddev->reshape_position = conf->reshape_progress;
+		set_mask_bits(&mddev->flags, 0,
+			      BIT(MD_CHANGE_DEVS) | BIT(MD_CHANGE_PENDING));
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
+
+		conf->reshape_safe = mddev->reshape_position;
+	}
+
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
+
+	r10_bio->master_bio = bio;
+	r10_bio->sectors = sectors;
+
+	r10_bio->mddev = mddev;
+	r10_bio->sector = bio->bi_iter.bi_sector;
+	r10_bio->state = 0;
+
+	/* We might need to issue multiple reads to different
+	 * devices if there are bad blocks around, so we keep
+	 * track of the number of reads in bio->bi_phys_segments.
+	 * If this is 0, there is only one r10_bio and no locking
+	 * will be needed when the request completes.  If it is
+	 * non-zero, then it is the number of not-completed requests.
+	 */
+	bio->bi_phys_segments = 0;
+	bio_clear_flag(bio, BIO_SEG_VALID);
+
+	if (bio_data_dir(bio) == READ) {
+		raid10_read_request(mddev, bio, r10_bio);
+		return;
+	}
+	raid10_write_request(mddev, bio, r10_bio);
+}
+
 static void raid10_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
-- 
2.10.2

