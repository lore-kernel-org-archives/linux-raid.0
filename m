From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/17] md/raid10: preferentially read from replacement
 device if possible.
Date: Wed, 02 Nov 2011 16:25:43 +1100
Message-ID: <20111102052543.17566.52804.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When reading (for array reads, not for recovery etc) we read from the
replacement device if it has recovered far enough.
This requires storing the chosen rdev in the 'r10_bio' so we can make
sure to drop the ref on the right device when the read finishes.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 254a6ce..fffdc43 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -323,11 +323,13 @@ static void raid10_end_read_request(struct bio *bio, int error)
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
 	int slot, dev;
+	struct md_rdev *rdev;
 	struct r10conf *conf = r10_bio->mddev->private;
 
 
 	slot = r10_bio->read_slot;
 	dev = r10_bio->devs[slot].devnum;
+	rdev = r10_bio->devs[slot].rdev;
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
@@ -345,7 +347,7 @@ static void raid10_end_read_request(struct bio *bio, int error)
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 		raid_end_bio_io(r10_bio);
-		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
+		rdev_dec_pending(rdev, conf->mddev);
 	} else {
 		/*
 		 * oops, read error - keep the refcount on the rdev
@@ -354,7 +356,7 @@ static void raid10_end_read_request(struct bio *bio, int error)
 		printk_ratelimited(KERN_ERR
 				   "md/raid10:%s: %s: rescheduling sector %llu\n",
 				   mdname(conf->mddev),
-				   bdevname(conf->mirrors[dev].rdev->bdev, b),
+				   bdevname(rdev->bdev, b),
 				   (unsigned long long)r10_bio->sector);
 		set_bit(R10BIO_ReadError, &r10_bio->state);
 		reschedule_retry(r10_bio);
@@ -598,7 +600,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 	int sectors = r10_bio->sectors;
 	int best_good_sectors;
 	sector_t new_distance, best_dist;
-	struct md_rdev *rdev;
+	struct md_rdev *rdev, *best_rdev;
 	int do_balance;
 	int best_slot;
 
@@ -607,6 +609,7 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 retry:
 	sectors = r10_bio->sectors;
 	best_slot = -1;
+	best_rdev = NULL;
 	best_dist = MaxSector;
 	best_good_sectors = 0;
 	do_balance = 1;
@@ -628,10 +631,16 @@ retry:
 		if (r10_bio->devs[slot].bio == IO_BLOCKED)
 			continue;
 		disk = r10_bio->devs[slot].devnum;
-		rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		rdev = rcu_dereference(conf->mirrors[disk].replacement);
+		if (rdev == NULL || test_bit(Faulty, &rdev->flags) ||
+		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
+			rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (rdev == NULL)
 			continue;
-		if (!test_bit(In_sync, &rdev->flags))
+		if (test_bit(Faulty, &rdev->flags))
+			continue;
+		if (!test_bit(In_sync, &rdev->flags) &&
+		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
 			continue;
 
 		dev_sector = r10_bio->devs[slot].addr;
@@ -656,6 +665,7 @@ retry:
 				if (good_sectors > best_good_sectors) {
 					best_good_sectors = good_sectors;
 					best_slot = slot;
+					best_rdev = rdev;
 				}
 				if (!do_balance)
 					/* Must read from here */
@@ -684,16 +694,15 @@ retry:
 		if (new_distance < best_dist) {
 			best_dist = new_distance;
 			best_slot = slot;
+			best_rdev = rdev;
 		}
 	}
-	if (slot == conf->copies)
+	if (slot >= conf->copies) {
 		slot = best_slot;
+		rdev = best_rdev;
+	}
 
 	if (slot >= 0) {
-		disk = r10_bio->devs[slot].devnum;
-		rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		if (!rdev)
-			goto retry;
 		atomic_inc(&rdev->nr_pending);
 		if (test_bit(Faulty, &rdev->flags)) {
 			/* Cannot risk returning a device that failed
@@ -991,6 +1000,7 @@ read_again:
 			    max_sectors);
 
 		r10_bio->devs[slot].bio = read_bio;
+		r10_bio->devs[slot].rdev = rdev;
 
 		read_bio->bi_sector = r10_bio->devs[slot].addr +
 			rdev->data_offset;
@@ -2090,10 +2100,9 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	int slot = r10_bio->read_slot;
-	int mirror = r10_bio->devs[slot].devnum;
 	struct bio *bio;
 	struct r10conf *conf = mddev->private;
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
 	char b[BDEVNAME_SIZE];
 	unsigned long do_sync;
 	int max_sectors;
@@ -2111,7 +2120,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
 	}
-	rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
+	rdev_dec_pending(rdev, mddev);
 
 	bio = r10_bio->devs[slot].bio;
 	bdevname(bio->bi_bdev, b);
@@ -2146,6 +2155,7 @@ read_more:
 		    r10_bio->sector - bio->bi_sector,
 		    max_sectors);
 	r10_bio->devs[slot].bio = bio;
+	r10_bio->devs[slot].rdev = rdev;
 	bio->bi_sector = r10_bio->devs[slot].addr
 		+ rdev->data_offset;
 	bio->bi_bdev = rdev->bdev;


