From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/4] raid1: change the code layout of raid1_mergeable_bvec() to make it look a bit nicer
Date: Thu, 31 May 2012 18:18:45 +0800
Message-ID: <1338459528-24490-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
List-Id: linux-raid.ids

This don't fix anything but just make function raid1_mergeable_bvec
look a bit nicer.

Minro note: this make 2 lines exceed 80 a bit(81).

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/raid1.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 835de71..5829f46 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -623,27 +623,25 @@ static int raid1_mergeable_bvec(struct request_queue *q,
 	struct r1conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max = biovec->bv_len;
+	int disk;
 
-	if (mddev->merge_check_needed) {
-		int disk;
-		rcu_read_lock();
-		for (disk = 0; disk < conf->raid_disks * 2; disk++) {
-			struct md_rdev *rdev = rcu_dereference(
-				conf->mirrors[disk].rdev);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = sector +
-						rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
+	if (!mddev->merge_check_needed)
+		return max;
+
+	rcu_read_lock();
+	for (disk = 0; disk < conf->raid_disks * 2; disk++) {
+		struct md_rdev *rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
+			struct request_queue *q = bdev_get_queue(rdev->bdev);
+			if (q->merge_bvec_fn) {
+				bvm->bi_sector = sector + rdev->data_offset;
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

