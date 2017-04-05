From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 06/10] md/raid10: simplify the splitting of requests.
Date: Wed, 05 Apr 2017 14:05:51 +1000
Message-ID: <149136515100.25893.2855951479218319813.stgit@noble>
References: <149136485390.25893.1797855041954158826.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149136485390.25893.1797855041954158826.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

raid10 splits requests in two different ways for two different
reasons.

First, bio_split() is used to ensure the bio fits with a chunk.
Second, multiple r10bio structures are allocated to represent the
different sections that need to go to different devices, to avoid
known bad blocks.

This can be simplified to just use bio_split() once, and not to use
multiple r10bios.
We delay the split until we know a maximum bio size that can
be handled with a single r10bio, and then split the bio and queue
the remainder for later handling.

As with raid1, we allocate a new bio_set to help with the splitting.
It is not correct to use fs_bio_set in a device driver.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |  164 ++++++++++++++++-----------------------------------
 drivers/md/raid10.h |    1 
 2 files changed, 51 insertions(+), 114 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0f13d57ef646..ff02c058dbdd 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1127,7 +1127,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	struct bio *read_bio;
 	const int op = bio_op(bio);
 	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
-	int sectors_handled;
 	int max_sectors;
 	sector_t sectors;
 	struct md_rdev *rdev;
@@ -1140,7 +1139,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	wait_barrier(conf);
 
-	sectors = bio_sectors(bio);
+	sectors = r10_bio->sectors;
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
 	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
@@ -1157,17 +1156,23 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		wait_barrier(conf);
 	}
 
-read_again:
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (!rdev) {
 		raid_end_bio_io(r10_bio);
 		return;
 	}
+	if (max_sectors < bio_sectors(bio)) {
+		struct bio *split = bio_split(bio, max_sectors,
+					      GFP_NOIO, conf->bio_split);
+		bio_chain(split, bio);
+		generic_make_request(bio);
+		bio = split;
+		r10_bio->master_bio = bio;
+		r10_bio->sectors = max_sectors;
+	}
 	slot = r10_bio->read_slot;
 
 	read_bio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
-	bio_trim(read_bio, r10_bio->sector - bio->bi_iter.bi_sector,
-		 max_sectors);
 
 	r10_bio->devs[slot].bio = read_bio;
 	r10_bio->devs[slot].rdev = rdev;
@@ -1186,40 +1191,13 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	        trace_block_bio_remap(bdev_get_queue(read_bio->bi_bdev),
 	                              read_bio, disk_devt(mddev->gendisk),
 	                              r10_bio->sector);
-	if (max_sectors < r10_bio->sectors) {
-		/*
-		 * Could not read all from this device, so we will need another
-		 * r10_bio.
-		 */
-		sectors_handled = (r10_bio->sector + max_sectors
-				   - bio->bi_iter.bi_sector);
-		r10_bio->sectors = max_sectors;
-		inc_pending(conf);
-		bio_inc_remaining(bio);
-		/*
-		 * Cannot call generic_make_request directly as that will be
-		 * queued in __generic_make_request and subsequent
-		 * mempool_alloc might block waiting for it.  so hand bio over
-		 * to raid10d.
-		 */
-		reschedule_retry(r10_bio);
-
-		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
-
-		r10_bio->master_bio = bio;
-		r10_bio->sectors = bio_sectors(bio) - sectors_handled;
-		r10_bio->state = 0;
-		r10_bio->mddev = mddev;
-		r10_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
-		goto read_again;
-	} else
-		generic_make_request(read_bio);
+	generic_make_request(read_bio);
 	return;
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 				  struct bio *bio, bool replacement,
-				  int n_copy, int max_sectors)
+				  int n_copy)
 {
 	const int op = bio_op(bio);
 	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
@@ -1243,7 +1221,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 		rdev = conf->mirrors[devnum].rdev;
 
 	mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
-	bio_trim(mbio, r10_bio->sector - bio->bi_iter.bi_sector, max_sectors);
 	if (replacement)
 		r10_bio->devs[n_copy].repl_bio = mbio;
 	else
@@ -1294,7 +1271,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	int i;
 	struct md_rdev *blocked_rdev;
 	sector_t sectors;
-	int sectors_handled;
 	int max_sectors;
 
 	md_write_start(mddev, bio);
@@ -1306,7 +1282,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 	wait_barrier(conf);
 
-	sectors = bio_sectors(bio);
+	sectors = r10_bio->sectors;
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
 	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
@@ -1476,44 +1452,29 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	if (max_sectors < r10_bio->sectors)
 		r10_bio->sectors = max_sectors;
-	sectors_handled = r10_bio->sector + max_sectors -
-		bio->bi_iter.bi_sector;
+
+	if (r10_bio->sectors < bio_sectors(bio)) {
+		struct bio *split = bio_split(bio, r10_bio->sectors,
+					      GFP_NOIO, conf->bio_split);
+		bio_chain(split, bio);
+		generic_make_request(bio);
+		bio = split;
+		r10_bio->master_bio = bio;
+	}
 
 	atomic_set(&r10_bio->remaining, 1);
 	bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
 
 	for (i = 0; i < conf->copies; i++) {
 		if (r10_bio->devs[i].bio)
-			raid10_write_one_disk(mddev, r10_bio, bio, false,
-					      i, max_sectors);
+			raid10_write_one_disk(mddev, r10_bio, bio, false, i);
 		if (r10_bio->devs[i].repl_bio)
-			raid10_write_one_disk(mddev, r10_bio, bio, true,
-					      i, max_sectors);
-	}
-
-	/* Don't remove the bias on 'remaining' (one_write_done) until
-	 * after checking if we need to go around again.
-	 */
-
-	if (sectors_handled < bio_sectors(bio)) {
-		/* We need another r10_bio and it needs to be counted */
-		inc_pending(conf);
-		bio_inc_remaining(bio);
-		one_write_done(r10_bio);
-		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
-
-		r10_bio->master_bio = bio;
-		r10_bio->sectors = bio_sectors(bio) - sectors_handled;
-
-		r10_bio->mddev = mddev;
-		r10_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
-		r10_bio->state = 0;
-		goto retry_write;
+			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
 }
 
-static void __make_request(struct mddev *mddev, struct bio *bio)
+static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
@@ -1521,7 +1482,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
-	r10_bio->sectors = bio_sectors(bio);
+	r10_bio->sectors = sectors;
 
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
@@ -1538,54 +1499,26 @@ static void raid10_make_request(struct mddev *mddev, struct bio *bio)
 	struct r10conf *conf = mddev->private;
 	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
 	int chunk_sects = chunk_mask + 1;
-
-	struct bio *split;
+	int sectors = bio_sectors(bio);
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
 
-	do {
-
-		/*
-		 * If this request crosses a chunk boundary, we need to split
-		 * it.
-		 */
-		if (unlikely((bio->bi_iter.bi_sector & chunk_mask) +
-			     bio_sectors(bio) > chunk_sects
-			     && (conf->geo.near_copies < conf->geo.raid_disks
-				 || conf->prev.near_copies <
-				 conf->prev.raid_disks))) {
-			split = bio_split(bio, chunk_sects -
-					  (bio->bi_iter.bi_sector &
-					   (chunk_sects - 1)),
-					  GFP_NOIO, fs_bio_set);
-			bio_chain(split, bio);
-		} else {
-			split = bio;
-		}
-
-		/*
-		 * If a bio is splitted, the first part of bio will pass
-		 * barrier but the bio is queued in current->bio_list (see
-		 * generic_make_request). If there is a raise_barrier() called
-		 * here, the second part of bio can't pass barrier. But since
-		 * the first part bio isn't dispatched to underlaying disks
-		 * yet, the barrier is never released, hence raise_barrier will
-		 * alays wait. We have a deadlock.
-		 * Note, this only happens in read path. For write path, the
-		 * first part of bio is dispatched in a schedule() call
-		 * (because of blk plug) or offloaded to raid10d.
-		 * Quitting from the function immediately can change the bio
-		 * order queued in bio_list and avoid the deadlock.
-		 */
-		__make_request(mddev, split);
-		if (split != bio && bio_data_dir(bio) == READ) {
-			generic_make_request(bio);
-			break;
-		}
-	} while (split != bio);
+	/*
+	 * If this request crosses a chunk boundary, we need to split
+	 * it.
+	 */
+	if (unlikely((bio->bi_iter.bi_sector & chunk_mask) +
+		     sectors > chunk_sects
+		     && (conf->geo.near_copies < conf->geo.raid_disks
+			 || conf->prev.near_copies <
+			 conf->prev.raid_disks)))
+		sectors = chunk_sects -
+			(bio->bi_iter.bi_sector &
+			 (chunk_sects - 1));
+	__make_request(mddev, bio, sectors);
 
 	/* In case raid10d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
@@ -2873,13 +2806,8 @@ static void raid10d(struct md_thread *thread)
 			recovery_request_write(mddev, r10_bio);
 		else if (test_bit(R10BIO_ReadError, &r10_bio->state))
 			handle_read_error(mddev, r10_bio);
-		else {
-			/* just a partial read to be scheduled from a
-			 * separate context
-			 */
-			int slot = r10_bio->read_slot;
-			generic_make_request(r10_bio->devs[slot].bio);
-		}
+		else
+			WARN_ON_ONCE(1);
 
 		cond_resched();
 		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
@@ -3652,6 +3580,10 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	if (!conf->r10bio_pool)
 		goto out;
 
+	conf->bio_split = bioset_create(BIO_POOL_SIZE, 0);
+	if (!conf->bio_split)
+		goto out;
+
 	calc_sectors(conf, mddev->dev_sectors);
 	if (mddev->reshape_position == MaxSector) {
 		conf->prev = conf->geo;
@@ -3689,6 +3621,8 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 		mempool_destroy(conf->r10bio_pool);
 		kfree(conf->mirrors);
 		safe_put_page(conf->tmppage);
+		if (conf->bio_split)
+			bioset_free(conf->bio_split);
 		kfree(conf);
 	}
 	return ERR_PTR(err);
@@ -3898,6 +3832,8 @@ static void raid10_free(struct mddev *mddev, void *priv)
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
+	if (conf->bio_split)
+		bioset_free(conf->bio_split);
 	kfree(conf);
 }
 
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 3162615e57bd..735ce1a3d260 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -82,6 +82,7 @@ struct r10conf {
 	mempool_t		*r10bio_pool;
 	mempool_t		*r10buf_pool;
 	struct page		*tmppage;
+	struct bio_set		*bio_split;
 
 	/* When taking over an array from a different personality, we store
 	 * the new thread here until we fully activate the array.


