From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 01/10] md/raid1: simplify the splitting of requests.
Date: Wed, 05 Apr 2017 14:05:50 +1000
Message-ID: <149136515036.25893.6104641096406491275.stgit@noble>
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

raid1 currently splits requests in two different ways for
two different reasons.

First, bio_split() is used to ensure the bio fits within a
resync accounting region.
Second, multiple r1bios are allocated for each bio to handle
the possiblity of known bad blocks on some devices.

This can be simplified to just use bio_split() once, and not
use multiple r1bios.
We delay the split until we know a maximum bio size that can
be handled with a single r1bio, and then split the bio and
queue the remainder for later handling.

This avoids all loops inside raid1.c request handling.  Just
a single read, or a single set of writes, is submitted to
lower-level devices for each bio that comes from
generic_make_request().

When the bio needs to be split, generic_make_request() will
do the necessary looping and call md_make_request() multiple
times.

raid1_make_request() no longer queues request for raid1 to handle,
so we can remove that branch from the 'if'.

This patch also creates a new private bio_set
(conf->bio_split) for splitting bios.  Using fs_bio_set
is wrong, as it is meant to be used by filesystems, not
block devices.  Using it inside md can lead to deadlocks
under high memory pressure.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |  138 ++++++++++++++++++----------------------------------
 drivers/md/raid1.h |    2 +
 2 files changed, 51 insertions(+), 89 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7d6723558fd8..83853f65462a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1202,7 +1202,8 @@ alloc_r1bio(struct mddev *mddev, struct bio *bio, sector_t sectors_handled)
 	return r1_bio;
 }
 
-static void raid1_read_request(struct mddev *mddev, struct bio *bio)
+static void raid1_read_request(struct mddev *mddev, struct bio *bio,
+			       int max_read_sectors)
 {
 	struct r1conf *conf = mddev->private;
 	struct raid1_info *mirror;
@@ -1211,7 +1212,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio)
 	struct bitmap *bitmap = mddev->bitmap;
 	const int op = bio_op(bio);
 	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
-	int sectors_handled;
 	int max_sectors;
 	int rdisk;
 
@@ -1222,12 +1222,12 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio)
 	wait_read_barrier(conf, bio->bi_iter.bi_sector);
 
 	r1_bio = alloc_r1bio(mddev, bio, 0);
+	r1_bio->sectors = max_read_sectors;
 
 	/*
 	 * make_request() can abort the operation when read-ahead is being
 	 * used and no empty request is available.
 	 */
-read_again:
 	rdisk = read_balance(conf, r1_bio, &max_sectors);
 
 	if (rdisk < 0) {
@@ -1247,11 +1247,20 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio)
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
+
+	if (max_sectors < bio_sectors(bio)) {
+		struct bio *split = bio_split(bio, max_sectors,
+					      GFP_NOIO, conf->bio_split);
+		bio_chain(split, bio);
+		generic_make_request(bio);
+		bio = split;
+		r1_bio->master_bio = bio;
+		r1_bio->sectors = max_sectors;
+	}
+
 	r1_bio->read_disk = rdisk;
 
 	read_bio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
-	bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
-		 max_sectors);
 
 	r1_bio->bios[rdisk] = read_bio;
 
@@ -1270,30 +1279,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio)
 	                              read_bio, disk_devt(mddev->gendisk),
 	                              r1_bio->sector);
 
-	if (max_sectors < r1_bio->sectors) {
-		/*
-		 * could not read all from this device, so we will need another
-		 * r1_bio.
-		 */
-		sectors_handled = (r1_bio->sector + max_sectors
-				   - bio->bi_iter.bi_sector);
-		r1_bio->sectors = max_sectors;
-		bio_inc_remaining(bio);
-
-		/*
-		 * Cannot call generic_make_request directly as that will be
-		 * queued in __make_request and subsequent mempool_alloc might
-		 * block waiting for it.  So hand bio over to raid1d.
-		 */
-		reschedule_retry(r1_bio);
-
-		r1_bio = alloc_r1bio(mddev, bio, sectors_handled);
-		goto read_again;
-	} else
-		generic_make_request(read_bio);
+	generic_make_request(read_bio);
 }
 
-static void raid1_write_request(struct mddev *mddev, struct bio *bio)
+static void raid1_write_request(struct mddev *mddev, struct bio *bio,
+				int max_write_sectors)
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
@@ -1304,7 +1294,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
 	int first_clone;
-	int sectors_handled;
 	int max_sectors;
 	sector_t offset;
 
@@ -1345,6 +1334,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 	wait_barrier(conf, bio->bi_iter.bi_sector);
 
 	r1_bio = alloc_r1bio(mddev, bio, 0);
+	r1_bio->sectors = max_write_sectors;
 
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
@@ -1443,10 +1433,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 		goto retry_write;
 	}
 
-	if (max_sectors < r1_bio->sectors)
+	if (max_sectors < bio_sectors(bio)) {
+		struct bio *split = bio_split(bio, max_sectors,
+					      GFP_NOIO, conf->bio_split);
+		bio_chain(split, bio);
+		generic_make_request(bio);
+		bio = split;
+		r1_bio->master_bio = bio;
 		r1_bio->sectors = max_sectors;
-
-	sectors_handled = r1_bio->sector + max_sectors - bio->bi_iter.bi_sector;
+	}
 
 	atomic_set(&r1_bio->remaining, 1);
 	atomic_set(&r1_bio->behind_remaining, 0);
@@ -1470,7 +1465,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {
 				mbio = alloc_behind_master_bio(r1_bio, bio,
-							       offset << 9,
+							       0,
 							       max_sectors << 9);
 			}
 
@@ -1486,10 +1481,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 				mbio = bio_clone_fast(r1_bio->behind_master_bio,
 						      GFP_NOIO,
 						      mddev->bio_set);
-			else {
+			else
 				mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
-				bio_trim(mbio, offset, max_sectors);
-			}
 		}
 
 		if (r1_bio->behind_master_bio) {
@@ -1536,19 +1529,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 		if (!plug)
 			md_wakeup_thread(mddev->thread);
 	}
-	/* Mustn't call r1_bio_write_done before this next test,
-	 * as it could result in the bio being freed.
-	 */
-	if (sectors_handled < bio_sectors(bio)) {
-		/* We need another r1_bio, which must be counted */
-		sector_t sect = bio->bi_iter.bi_sector + sectors_handled;
-
-		inc_pending(conf, sect);
-		bio_inc_remaining(bio);
-		r1_bio_write_done(r1_bio);
-		r1_bio = alloc_r1bio(mddev, bio, sectors_handled);
-		goto retry_write;
-	}
 
 	r1_bio_write_done(r1_bio);
 
@@ -1558,7 +1538,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 
 static void raid1_make_request(struct mddev *mddev, struct bio *bio)
 {
-	struct bio *split;
 	sector_t sectors;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
@@ -1566,43 +1545,19 @@ static void raid1_make_request(struct mddev *mddev, struct bio *bio)
 		return;
 	}
 
-	/* if bio exceeds barrier unit boundary, split it */
-	do {
-		sectors = align_to_barrier_unit_end(
-				bio->bi_iter.bi_sector, bio_sectors(bio));
-		if (sectors < bio_sectors(bio)) {
-			split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
-			bio_chain(split, bio);
-		} else {
-			split = bio;
-		}
-
-		if (bio_data_dir(split) == READ) {
-			raid1_read_request(mddev, split);
+	/* There is a limit to the maximum size, but
+	 * the read/write handler might find a lower limit
+	 * due to bad blocks.  To avoid multiple splits,
+	 * we pass the maximum number of sectors down
+	 * and let the lower level perform the split.
+	 */
+	sectors = align_to_barrier_unit_end(
+		bio->bi_iter.bi_sector, bio_sectors(bio));
 
-			/*
-			 * If a bio is splitted, the first part of bio will
-			 * pass barrier but the bio is queued in
-			 * current->bio_list (see generic_make_request). If
-			 * there is a raise_barrier() called here, the second
-			 * part of bio can't pass barrier. But since the first
-			 * part bio isn't dispatched to underlaying disks yet,
-			 * the barrier is never released, hence raise_barrier
-			 * will alays wait. We have a deadlock.
-			 * Note, this only happens in read path. For write
-			 * path, the first part of bio is dispatched in a
-			 * schedule() call (because of blk plug) or offloaded
-			 * to raid10d.
-			 * Quitting from the function immediately can change
-			 * the bio order queued in bio_list and avoid the deadlock.
-			 */
-			if (split != bio) {
-				generic_make_request(bio);
-				break;
-			}
-		} else
-			raid1_write_request(mddev, split);
-	} while (split != bio);
+	if (bio_data_dir(bio) == READ)
+		raid1_read_request(mddev, bio, sectors);
+	else
+		raid1_write_request(mddev, bio, sectors);
 }
 
 static void raid1_status(struct seq_file *seq, struct mddev *mddev)
@@ -2645,10 +2600,7 @@ static void raid1d(struct md_thread *thread)
 		else if (test_bit(R1BIO_ReadError, &r1_bio->state))
 			handle_read_error(conf, r1_bio);
 		else
-			/* just a partial read to be scheduled from separate
-			 * context
-			 */
-			generic_make_request(r1_bio->bios[r1_bio->read_disk]);
+			WARN_ON_ONCE(1);
 
 		cond_resched();
 		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
@@ -3036,6 +2988,10 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->r1bio_pool)
 		goto abort;
 
+	conf->bio_split = bioset_create(BIO_POOL_SIZE, 0);
+	if (!conf->bio_split)
+		goto abort;
+
 	conf->poolinfo->mddev = mddev;
 
 	err = -EINVAL;
@@ -3117,6 +3073,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 		kfree(conf->nr_waiting);
 		kfree(conf->nr_queued);
 		kfree(conf->barrier);
+		if (conf->bio_split)
+			bioset_free(conf->bio_split);
 		kfree(conf);
 	}
 	return ERR_PTR(err);
@@ -3222,6 +3180,8 @@ static void raid1_free(struct mddev *mddev, void *priv)
 	kfree(conf->nr_waiting);
 	kfree(conf->nr_queued);
 	kfree(conf->barrier);
+	if (conf->bio_split)
+		bioset_free(conf->bio_split);
 	kfree(conf);
 }
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 4271cd7ac2de..b0ab0da6e39e 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -107,6 +107,8 @@ struct r1conf {
 	mempool_t		*r1bio_pool;
 	mempool_t		*r1buf_pool;
 
+	struct bio_set		*bio_split;
+
 	/* temporary buffer to synchronous IO when attempting to repair
 	 * a read error.
 	 */


