From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 07/10] md/raid10: simplify handle_read_error()
Date: Wed, 05 Apr 2017 14:05:51 +1000
Message-ID: <149136515112.25893.8093301032925333665.stgit@noble>
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

handle_read_error() duplicates a lot of the work that raid10_read_request()
does, so it makes sense to just use that function.

handle_read_error() relies on the same r10bio being re-used so that,
in the case of a read-only array, setting IO_BLOCKED in r1bio->devs[].bio
ensures read_balance() won't re-use that device.
So when called from raid10_make_request() we clear that array, but not
when called from handle_read_error().

Two parts of handle_read_error() that need to be preserved are the warning
message it prints, so they are conditionally added to
raid10_read_request().  If the failing rdev can be found, messages
are printed.  Otherwise they aren't.

Not that as rdev_dec_pending() has already been called on the failing
rdev, we need to use rcu_read_lock() to get a new reference from
the conf.  We only use this to get the name of the failing block device.

With this change, we no longer need inc_pending().

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |  120 +++++++++++++++++++--------------------------------
 1 file changed, 45 insertions(+), 75 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ff02c058dbdd..ca722570bd38 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1008,15 +1008,6 @@ static void wait_barrier(struct r10conf *conf)
 	spin_unlock_irq(&conf->resync_lock);
 }
 
-static void inc_pending(struct r10conf *conf)
-{
-	/* The current request requires multiple r10_bio, so
-	 * we need to increment the pending count.
-	 */
-	WARN_ON(!atomic_read(&conf->nr_pending));
-	atomic_inc(&conf->nr_pending);
-}
-
 static void allow_barrier(struct r10conf *conf)
 {
 	if ((atomic_dec_and_test(&conf->nr_pending)) ||
@@ -1130,8 +1121,36 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	sector_t sectors;
 	struct md_rdev *rdev;
-	int slot;
+	char b[BDEVNAME_SIZE];
+	int slot = r10_bio->read_slot;
+	struct md_rdev *err_rdev = NULL;
+	gfp_t gfp = GFP_NOIO;
+
+	if (r10_bio->devs[slot].rdev) {
+		/* This is an error retry, but we cannot
+		 * safely dereference the rdev in the r10_bio,
+		 * we must use the one in conf.
+		 * If it has already been disconnected (unlikely)
+		 * we lose the device name in error messages.
+		 */
+		int disk;
+		/* As we are blocking raid10, it is a little safer to
+		 * use __GFP_HIGH.
+		 */
+		gfp = GFP_NOIO | __GFP_HIGH;
 
+		rcu_read_lock();
+		disk = r10_bio->devs[slot].devnum;
+		err_rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		if (err_rdev)
+			bdevname(err_rdev->bdev, b);
+		else {
+			strcpy(b, "???");
+			/* This never gets dereferenced */
+			err_rdev = r10_bio->devs[slot].rdev;
+		}
+		rcu_read_unlock();
+	}
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
@@ -1158,12 +1177,22 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (!rdev) {
+		if (err_rdev) {
+			pr_crit_ratelimited("md/raid10:%s: %s: unrecoverable I/O read error for block %llu\n",
+					    mdname(mddev), b,
+					    (unsigned long long)r10_bio->sector);
+		}
 		raid_end_bio_io(r10_bio);
 		return;
 	}
+	if (err_rdev)
+		pr_err_ratelimited("md/raid10:%s: %s: redirecting sector %llu to another mirror\n",
+				   mdname(mddev),
+				   bdevname(rdev->bdev, b),
+				   (unsigned long long)r10_bio->sector);
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
-					      GFP_NOIO, conf->bio_split);
+					      gfp, conf->bio_split);
 		bio_chain(split, bio);
 		generic_make_request(bio);
 		bio = split;
@@ -1172,7 +1201,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	read_bio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
+	read_bio = bio_clone_fast(bio, gfp, mddev->bio_set);
 
 	r10_bio->devs[slot].bio = read_bio;
 	r10_bio->devs[slot].rdev = rdev;
@@ -1487,6 +1516,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
+	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
 
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio);
@@ -2556,9 +2586,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	struct bio *bio;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
-	char b[BDEVNAME_SIZE];
-	unsigned long do_sync;
-	int max_sectors;
 	dev_t bio_dev;
 	sector_t bio_last_sector;
 
@@ -2571,7 +2598,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * frozen.
 	 */
 	bio = r10_bio->devs[slot].bio;
-	bdevname(bio->bi_bdev, b);
 	bio_dev = bio->bi_bdev->bd_dev;
 	bio_last_sector = r10_bio->devs[slot].addr + rdev->data_offset + r10_bio->sectors;
 	bio_put(bio);
@@ -2587,65 +2613,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 		md_error(mddev, rdev);
 
 	rdev_dec_pending(rdev, mddev);
-
-read_more:
-	rdev = read_balance(conf, r10_bio, &max_sectors);
-	if (rdev == NULL) {
-		pr_crit_ratelimited("md/raid10:%s: %s: unrecoverable I/O read error for block %llu\n",
-				    mdname(mddev), b,
-				    (unsigned long long)r10_bio->sector);
-		raid_end_bio_io(r10_bio);
-		return;
-	}
-
-	do_sync = (r10_bio->master_bio->bi_opf & REQ_SYNC);
-	slot = r10_bio->read_slot;
-	pr_err_ratelimited("md/raid10:%s: %s: redirecting sector %llu to another mirror\n",
-			   mdname(mddev),
-			   bdevname(rdev->bdev, b),
-			   (unsigned long long)r10_bio->sector);
-	bio = bio_clone_fast(r10_bio->master_bio, GFP_NOIO, mddev->bio_set);
-	bio_trim(bio, r10_bio->sector - bio->bi_iter.bi_sector, max_sectors);
-	r10_bio->devs[slot].bio = bio;
-	r10_bio->devs[slot].rdev = rdev;
-	bio->bi_iter.bi_sector = r10_bio->devs[slot].addr
-		+ choose_data_offset(r10_bio, rdev);
-	bio->bi_bdev = rdev->bdev;
-	bio_set_op_attrs(bio, REQ_OP_READ, do_sync);
-	if (test_bit(FailFast, &rdev->flags) &&
-	    test_bit(R10BIO_FailFast, &r10_bio->state))
-		bio->bi_opf |= MD_FAILFAST;
-	bio->bi_private = r10_bio;
-	bio->bi_end_io = raid10_end_read_request;
-	trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
-			      bio, bio_dev,
-			      bio_last_sector - r10_bio->sectors);
-
-	if (max_sectors < r10_bio->sectors) {
-		/* Drat - have to split this up more */
-		struct bio *mbio = r10_bio->master_bio;
-		int sectors_handled =
-			r10_bio->sector + max_sectors
-			- mbio->bi_iter.bi_sector;
-		r10_bio->sectors = max_sectors;
-		bio_inc_remaining(mbio);
-		inc_pending(conf);
-		generic_make_request(bio);
-
-		r10_bio = mempool_alloc(conf->r10bio_pool,
-					GFP_NOIO);
-		r10_bio->master_bio = mbio;
-		r10_bio->sectors = bio_sectors(mbio) - sectors_handled;
-		r10_bio->state = 0;
-		set_bit(R10BIO_ReadError,
-			&r10_bio->state);
-		r10_bio->mddev = mddev;
-		r10_bio->sector = mbio->bi_iter.bi_sector
-			+ sectors_handled;
-
-		goto read_more;
-	} else
-		generic_make_request(bio);
+	allow_barrier(conf);
+	r10_bio->state = 0;
+	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
 }
 
 static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)


