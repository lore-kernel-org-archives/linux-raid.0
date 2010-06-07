From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/16] md: simplify raid10 read_balance
Date: Mon, 07 Jun 2010 10:07:54 +1000
Message-ID: <20100607000754.13302.41439.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

raid10 read balance as two different loop for looking through
possible devices to chose the best.
Collapse those into one loop and generally make the code more
readable.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid10.c |  114 +++++++++++++++++++++------------------------------
 1 files changed, 48 insertions(+), 66 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 20da258..01a75d2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -497,13 +497,21 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 static int read_balance(conf_t *conf, r10bio_t *r10_bio)
 {
 	const sector_t this_sector = r10_bio->sector;
-	int disk, slot, nslot;
 	const int sectors = r10_bio->sectors;
-	sector_t new_distance, current_distance;
+	int disk, slot;
+	sector_t new_distance, best_dist;
 	mdk_rdev_t *rdev;
+	int do_balance;
+	int best_disk, best_slot;
 
 	raid10_find_phys(conf, r10_bio);
 	rcu_read_lock();
+retry:
+	disk = -1;
+	best_disk = -1;
+	best_slot = -1;
+	best_dist = MaxSector;
+	do_balance = 1;
 	/*
 	 * Check if we can balance. We can balance on the whole
 	 * device if no resync is going on (recovery is ok), or below
@@ -511,86 +519,60 @@ static int read_balance(conf_t *conf, r10bio_t *r10_bio)
 	 * above the resync window.
 	 */
 	if (conf->mddev->recovery_cp < MaxSector
-	    && (this_sector + sectors >= conf->next_resync)) {
-		/* make sure that disk is operational */
-		slot = 0;
-		disk = r10_bio->devs[slot].devnum;
-
-		while ((rdev = rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
-		       r10_bio->devs[slot].bio == IO_BLOCKED ||
-		       !test_bit(In_sync, &rdev->flags)) {
-			slot++;
-			if (slot == conf->copies) {
-				slot = 0;
-				disk = -1;
-				break;
-			}
-			disk = r10_bio->devs[slot].devnum;
-		}
-		goto rb_out;
-	}
-
+	    && (this_sector + sectors >= conf->next_resync))
+		do_balance = 0;
 
-	/* make sure the disk is operational */
-	slot = 0;
-	disk = r10_bio->devs[slot].devnum;
-	while ((rdev=rcu_dereference(conf->mirrors[disk].rdev)) == NULL ||
-	       r10_bio->devs[slot].bio == IO_BLOCKED ||
-	       !test_bit(In_sync, &rdev->flags)) {
-		slot ++;
-		if (slot == conf->copies) {
-			disk = -1;
-			goto rb_out;
-		}
+	for (slot = 0; slot < conf->copies ; slot++) {
+		if (r10_bio->devs[slot].bio == IO_BLOCKED)
+			continue;
 		disk = r10_bio->devs[slot].devnum;
-	}
-
-
-	current_distance = abs(r10_bio->devs[slot].addr -
-			       conf->mirrors[disk].head_position);
-
-	/* Find the disk whose head is closest,
-	 * or - for far > 1 - find the closest to partition beginning */
-
-	for (nslot = slot; nslot < conf->copies; nslot++) {
-		int ndisk = r10_bio->devs[nslot].devnum;
-
-
-		if ((rdev=rcu_dereference(conf->mirrors[ndisk].rdev)) == NULL ||
-		    r10_bio->devs[nslot].bio == IO_BLOCKED ||
-		    !test_bit(In_sync, &rdev->flags))
+		rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		if (rdev == NULL)
+			continue;
+		if (!test_bit(In_sync, &rdev->flags))
 			continue;
 
+		if (!do_balance)
+			break;
+
 		/* This optimisation is debatable, and completely destroys
 		 * sequential read speed for 'far copies' arrays.  So only
 		 * keep it for 'near' arrays, and review those later.
 		 */
-		if (conf->near_copies > 1 && !atomic_read(&rdev->nr_pending)) {
-			disk = ndisk;
-			slot = nslot;
+		if (conf->near_copies > 1 && !atomic_read(&rdev->nr_pending))
 			break;
-		}
 
 		/* for far > 1 always use the lowest address */
 		if (conf->far_copies > 1)
-			new_distance = r10_bio->devs[nslot].addr;
+			new_distance = r10_bio->devs[slot].addr;
 		else
-			new_distance = abs(r10_bio->devs[nslot].addr -
-					   conf->mirrors[ndisk].head_position);
-		if (new_distance < current_distance) {
-			current_distance = new_distance;
-			disk = ndisk;
-			slot = nslot;
+			new_distance = abs(r10_bio->devs[slot].addr -
+					   conf->mirrors[disk].head_position);
+		if (new_distance < best_dist) {
+			best_dist = new_distance;
+			best_disk = disk;
+			best_slot = slot;
 		}
 	}
+	if (slot == conf->copies) {
+		disk = best_disk;
+		slot = best_slot;
+	}
 
-rb_out:
-	r10_bio->read_slot = slot;
-/*	conf->next_seq_sect = this_sector + sectors;*/
-
-	if (disk >= 0 && (rdev=rcu_dereference(conf->mirrors[disk].rdev))!= NULL)
-		atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
-	else
+	if (disk >= 0) {
+		rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		if (!rdev)
+			goto retry;
+		atomic_inc(&rdev->nr_pending);
+		if (test_bit(Faulty, &rdev->flags)) {
+			/* Cannot risk returning a device that failed
+			 * before we inc'ed nr_pending
+			 */
+			rdev_dec_pending(rdev, conf->mddev);
+			goto retry;
+		}
+		r10_bio->read_slot = slot;
+	} else
 		disk = -1;
 	rcu_read_unlock();
 


