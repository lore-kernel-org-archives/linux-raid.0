From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 04/10] md/raid1: simplify handle_read_error().
Date: Wed, 05 Apr 2017 14:05:50 +1000
Message-ID: <149136515075.25893.17575974134437994381.stgit@noble>
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

handle_read_error() duplicates a lot of the work that raid1_read_request()
does, so it makes sense to just use that function.
This doesn't quite work as handle_read_error() relies on the same r1bio
being re-used so that, in the case of a read-only array, setting
IO_BLOCKED in r1bio->bios[] ensures read_balance() won't re-use
that device.
So we need to allow a r1bio to be passed to raid1_read_request(), and to
have that function mostly initialise the r1bio, but leave the bios[]
array untouched.

Two parts of handle_read_error() that need to be preserved are the warning
message it prints, so they are conditionally added to raid1_read_request().

Note that this highlights a minor bug on alloc_r1bio().  It doesn't
initalise the bios[] array, so it is possible that old content is there,
which might cause read_balance() to ignore some devices with no good reason.

With this change, we no longer need inc_pending(), or the sectors_handled
arg to alloc_r1bio().


As handle_read_error() is called from raid1d() and allocates memory,
there is tiny chance of a deadlock.  All element of various pools
could be queued waiting for raid1 to handle them, and there may be no
extra memory free.
Achieving guaranteed forward progress would probably require a second
thread and another mempool.  Instead of that complexity, add
__GFP_HIGH to any allocations when read1_read_request() is called
from raid1d.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |  138 ++++++++++++++++++++++------------------------------
 1 file changed, 58 insertions(+), 80 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 06a13010f1b7..d15268fff052 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -988,16 +988,6 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	spin_unlock_irq(&conf->resync_lock);
 }
 
-static void inc_pending(struct r1conf *conf, sector_t bi_sector)
-{
-	/* The current request requires multiple r1_bio, so
-	 * we need to increment the pending count, and the corresponding
-	 * window count.
-	 */
-	int idx = sector_to_idx(bi_sector);
-	atomic_inc(&conf->nr_pending[idx]);
-}
-
 static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
 {
 	int idx = sector_to_idx(sector_nr);
@@ -1184,35 +1174,58 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	kfree(plug);
 }
 
+static void init_r1bio(struct r1bio *r1_bio, struct mddev *mddev, struct bio *bio)
+{
+	r1_bio->master_bio = bio;
+	r1_bio->sectors = bio_sectors(bio);
+	r1_bio->state = 0;
+	r1_bio->mddev = mddev;
+	r1_bio->sector = bio->bi_iter.bi_sector;
+}
+
 static inline struct r1bio *
-alloc_r1bio(struct mddev *mddev, struct bio *bio, sector_t sectors_handled)
+alloc_r1bio(struct mddev *mddev, struct bio *bio)
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
 
 	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
-
-	r1_bio->master_bio = bio;
-	r1_bio->sectors = bio_sectors(bio) - sectors_handled;
-	r1_bio->state = 0;
-	r1_bio->mddev = mddev;
-	r1_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
-
+	/* Ensure no bio records IO_BLOCKED */
+	memset(r1_bio->bios, 0, conf->raid_disks * sizeof(r1_bio->bios[0]));
+	init_r1bio(r1_bio, mddev, bio);
 	return r1_bio;
 }
 
 static void raid1_read_request(struct mddev *mddev, struct bio *bio,
-			       int max_read_sectors)
+			       int max_read_sectors, struct r1bio *r1_bio)
 {
 	struct r1conf *conf = mddev->private;
 	struct raid1_info *mirror;
-	struct r1bio *r1_bio;
 	struct bio *read_bio;
 	struct bitmap *bitmap = mddev->bitmap;
 	const int op = bio_op(bio);
 	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
 	int max_sectors;
 	int rdisk;
+	bool print_msg = !!r1_bio;
+	char b[BDEVNAME_SIZE];
+	/* If r1_bio is set, we are blocking the raid1d thread
+	 * so there is a tiny risk of deadlock.  So ask for
+	 * emergency memory if needed.
+	 */
+	gfp_t gfp = r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
+
+	if (print_msg) {
+		/* Need to get the block device name carefully */
+		struct md_rdev *rdev;
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->mirrors[r1_bio->read_disk].rdev);
+		if (rdev)
+			bdevname(rdev->bdev, b);
+		else
+			strcpy(b, "???");
+		rcu_read_unlock();
+	}
 
 	/*
 	 * Still need barrier for READ in case that whole
@@ -1220,7 +1233,10 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	wait_read_barrier(conf, bio->bi_iter.bi_sector);
 
-	r1_bio = alloc_r1bio(mddev, bio, 0);
+	if (!r1_bio)
+		r1_bio = alloc_r1bio(mddev, bio);
+	else
+		init_r1bio(r1_bio, mddev, bio);
 	r1_bio->sectors = max_read_sectors;
 
 	/*
@@ -1231,11 +1247,23 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	if (rdisk < 0) {
 		/* couldn't find anywhere to read from */
+		if (print_msg) {
+			pr_crit_ratelimited("md/raid1:%s: %s: unrecoverable I/O read error for block %llu\n",
+					    mdname(mddev),
+					    b,
+					    (unsigned long long)r1_bio->sector);
+		}
 		raid_end_bio_io(r1_bio);
 		return;
 	}
 	mirror = conf->mirrors + rdisk;
 
+	if (print_msg)
+		pr_info_ratelimited("md/raid1:%s: redirecting sector %llu to other mirror: %s\n",
+				    mdname(mddev),
+				    (unsigned long long)r1_bio->sector,
+				    bdevname(mirror->rdev->bdev, b));
+
 	if (test_bit(WriteMostly, &mirror->rdev->flags) &&
 	    bitmap) {
 		/*
@@ -1249,7 +1277,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
-					      GFP_NOIO, conf->bio_split);
+					      gfp, conf->bio_split);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
@@ -1259,7 +1287,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	r1_bio->read_disk = rdisk;
 
-	read_bio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
+	read_bio = bio_clone_fast(bio, gfp, mddev->bio_set);
 
 	r1_bio->bios[rdisk] = read_bio;
 
@@ -1332,7 +1360,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	}
 	wait_barrier(conf, bio->bi_iter.bi_sector);
 
-	r1_bio = alloc_r1bio(mddev, bio, 0);
+	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
 	if (conf->pending_count >= max_queued_requests) {
@@ -1552,7 +1580,7 @@ static void raid1_make_request(struct mddev *mddev, struct bio *bio)
 		bio->bi_iter.bi_sector, bio_sectors(bio));
 
 	if (bio_data_dir(bio) == READ)
-		raid1_read_request(mddev, bio, sectors);
+		raid1_read_request(mddev, bio, sectors, NULL);
 	else
 		raid1_write_request(mddev, bio, sectors);
 }
@@ -2442,11 +2470,8 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 
 static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
-	int disk;
-	int max_sectors;
 	struct mddev *mddev = conf->mddev;
 	struct bio *bio;
-	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
 	dev_t bio_dev;
 	sector_t bio_sector;
@@ -2462,7 +2487,6 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 */
 
 	bio = r1_bio->bios[r1_bio->read_disk];
-	bdevname(bio->bi_bdev, b);
 	bio_dev = bio->bi_bdev->bd_dev;
 	bio_sector = conf->mirrors[r1_bio->read_disk].rdev->data_offset + r1_bio->sector;
 	bio_put(bio);
@@ -2480,58 +2504,12 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 
 	rdev_dec_pending(rdev, conf->mddev);
+	allow_barrier(conf, r1_bio->sector);
+	bio = r1_bio->master_bio;
 
-read_more:
-	disk = read_balance(conf, r1_bio, &max_sectors);
-	if (disk == -1) {
-		pr_crit_ratelimited("md/raid1:%s: %s: unrecoverable I/O read error for block %llu\n",
-				    mdname(mddev), b, (unsigned long long)r1_bio->sector);
-		raid_end_bio_io(r1_bio);
-	} else {
-		const unsigned long do_sync
-			= r1_bio->master_bio->bi_opf & REQ_SYNC;
-		r1_bio->read_disk = disk;
-		bio = bio_clone_fast(r1_bio->master_bio, GFP_NOIO,
-				     mddev->bio_set);
-		bio_trim(bio, r1_bio->sector - bio->bi_iter.bi_sector,
-			 max_sectors);
-		r1_bio->bios[r1_bio->read_disk] = bio;
-		rdev = conf->mirrors[disk].rdev;
-		pr_info_ratelimited("md/raid1:%s: redirecting sector %llu to other mirror: %s\n",
-				    mdname(mddev),
-				    (unsigned long long)r1_bio->sector,
-				    bdevname(rdev->bdev, b));
-		bio->bi_iter.bi_sector = r1_bio->sector + rdev->data_offset;
-		bio->bi_bdev = rdev->bdev;
-		bio->bi_end_io = raid1_end_read_request;
-		bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
-		if (test_bit(FailFast, &rdev->flags) &&
-		    test_bit(R1BIO_FailFast, &r1_bio->state))
-			bio->bi_opf |= MD_FAILFAST;
-		bio->bi_private = r1_bio;
-		if (max_sectors < r1_bio->sectors) {
-			/* Drat - have to split this up more */
-			struct bio *mbio = r1_bio->master_bio;
-			int sectors_handled = (r1_bio->sector + max_sectors
-					       - mbio->bi_iter.bi_sector);
-			r1_bio->sectors = max_sectors;
-			bio_inc_remaining(mbio);
-			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
-					      bio, bio_dev, bio_sector);
-			generic_make_request(bio);
-			bio = NULL;
-
-			r1_bio = alloc_r1bio(mddev, mbio, sectors_handled);
-			set_bit(R1BIO_ReadError, &r1_bio->state);
-			inc_pending(conf, r1_bio->sector);
-
-			goto read_more;
-		} else {
-			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
-					      bio, bio_dev, bio_sector);
-			generic_make_request(bio);
-		}
-	}
+	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
+	r1_bio->state = 0;
+	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
 }
 
 static void raid1d(struct md_thread *thread)


