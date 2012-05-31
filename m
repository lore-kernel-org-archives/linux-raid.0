From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/4] raid10: change the code layout of raid10_mergeable_bvec() to make it look a bit nicer
Date: Thu, 31 May 2012 18:18:46 +0800
Message-ID: <1338459528-24490-2-git-send-email-yuanhan.liu@linux.intel.com>
References: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

This don't fix anything but just make function raid10_mergeable_bvec
look a bit nicer.

Minro note: this make 3 lines exceed 80 a bit(81).

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid10.c |   74 ++++++++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 987db37..83d0e65 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -626,6 +626,8 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	unsigned int chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 	struct geom *geo = &conf->geo;
+	struct r10bio r10_bio;
+	int s;
 
 	chunk_sectors = (conf->geo.chunk_mask & conf->prev.chunk_mask) + 1;
 	if (conf->reshape_progress != MaxSector &&
@@ -644,48 +646,44 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	} else
 		max = biovec->bv_len;
 
-	if (mddev->merge_check_needed) {
-		struct r10bio r10_bio;
-		int s;
-		if (conf->reshape_progress != MaxSector) {
-			/* Cannot give any guidance during reshape */
-			if (max <= biovec->bv_len && bio_sectors == 0)
-				return biovec->bv_len;
-			return 0;
-		}
-		r10_bio.sector = sector;
-		raid10_find_phys(conf, &r10_bio);
-		rcu_read_lock();
-		for (s = 0; s < conf->copies; s++) {
-			int disk = r10_bio.devs[s].devnum;
-			struct md_rdev *rdev = rcu_dereference(
-				conf->mirrors[disk].rdev);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio.devs[s].addr
-						+ rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
+	if (!mddev->merge_check_needed)
+		return max;
+
+	if (conf->reshape_progress != MaxSector) {
+		/* Cannot give any guidance during reshape */
+		if (max <= biovec->bv_len && bio_sectors == 0)
+			return biovec->bv_len;
+		return 0;
+	}
+
+	r10_bio.sector = sector;
+	raid10_find_phys(conf, &r10_bio);
+	rcu_read_lock();
+	for (s = 0; s < conf->copies; s++) {
+		int disk = r10_bio.devs[s].devnum;
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
+			struct request_queue *q = bdev_get_queue(rdev->bdev);
+			if (q->merge_bvec_fn) {
+				bvm->bi_sector = r10_bio.devs[s].addr +
+						 rdev->data_offset;
+				bvm->bi_bdev = rdev->bdev;
+				max = min(max, q->merge_bvec_fn(q, bvm, biovec));
 			}
-			rdev = rcu_dereference(conf->mirrors[disk].replacement);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio.devs[s].addr
-						+ rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
+		}
+		rdev = rcu_dereference(conf->mirrors[disk].replacement);
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
+			struct request_queue *q = bdev_get_queue(rdev->bdev);
+			if (q->merge_bvec_fn) {
+				bvm->bi_sector = r10_bio.devs[s].addr +
+						 rdev->data_offset;
+				bvm->bi_bdev = rdev->bdev;
+				max = min(max, q->merge_bvec_fn(q, bvm, biovec));
 			}
 		}
-		rcu_read_unlock();
 	}
+	rcu_read_unlock();
+
 	return max;
 }
 
-- 
1.7.7.6

