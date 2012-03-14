From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/23] md/raid1: handle merge_bvec_fn in member devices.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044040.7978.27509.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently we don't honour merge_bvec_fn in member devices so if there
is one, we force all requests to be single-page at most.
This is not ideal.

So create a raid1 merge_bvec_fn to check that function in children
as well.

This introduces a small problem.  There is no locking around calls
the ->merge_bvec_fn and subsequent calls to ->make_request.  So a
device added between these could end up getting a request which
violates its merge_bvec_fn.

Currently the best we can do is synchronize_sched().  This will work
providing no preemption happens.  If there is is preemption, we just
have to hope that new devices are largely consistent with old devices.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   77 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c0d3ffb..fa4d840 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -523,6 +523,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 		rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (r1_bio->bios[disk] == IO_BLOCKED
 		    || rdev == NULL
+		    || test_bit(Unmerged, &rdev->flags)
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
 		if (!test_bit(In_sync, &rdev->flags) &&
@@ -614,6 +615,39 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	return best_disk;
 }
 
+static int raid1_mergeable_bvec(struct request_queue *q,
+				struct bvec_merge_data *bvm,
+				struct bio_vec *biovec)
+{
+	struct mddev *mddev = q->queuedata;
+	struct r1conf *conf = mddev->private;
+	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
+	int max = biovec->bv_len;
+
+	if (mddev->merge_check_needed) {
+		int disk;
+		rcu_read_lock();
+		for (disk = 0; disk < conf->raid_disks * 2; disk++) {
+			struct md_rdev *rdev = rcu_dereference(
+				conf->mirrors[disk].rdev);
+			if (rdev && !test_bit(Faulty, &rdev->flags)) {
+				struct request_queue *q =
+					bdev_get_queue(rdev->bdev);
+				if (q->merge_bvec_fn) {
+					bvm->bi_sector = sector +
+						rdev->data_offset;
+					bvm->bi_bdev = rdev->bdev;
+					max = min(max, q->merge_bvec_fn(
+							  q, bvm, biovec));
+				}
+			}
+		}
+		rcu_read_unlock();
+	}
+	return max;
+
+}
+
 int md_raid1_congested(struct mddev *mddev, int bits)
 {
 	struct r1conf *conf = mddev->private;
@@ -1015,7 +1049,8 @@ read_again:
 			break;
 		}
 		r1_bio->bios[i] = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags)) {
+		if (!rdev || test_bit(Faulty, &rdev->flags)
+		    || test_bit(Unmerged, &rdev->flags)) {
 			if (i < conf->raid_disks)
 				set_bit(R1BIO_Degraded, &r1_bio->state);
 			continue;
@@ -1336,6 +1371,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct mirror_info *p;
 	int first = 0;
 	int last = conf->raid_disks - 1;
+	struct request_queue *q = bdev_get_queue(rdev->bdev);
 
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;
@@ -1343,23 +1379,17 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
+	if (q->merge_bvec_fn) {
+		set_bit(Unmerged, &rdev->flags);
+		mddev->merge_check_needed = 1;
+	}
+
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors+mirror;
 		if (!p->rdev) {
 
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
-			/* as we don't honour merge_bvec_fn, we must
-			 * never risk violating it, so limit
-			 * ->max_segments to one lying with a single
-			 * page, as a one page request is never in
-			 * violation.
-			 */
-			if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-				blk_queue_max_segments(mddev->queue, 1);
-				blk_queue_segment_boundary(mddev->queue,
-							   PAGE_CACHE_SIZE - 1);
-			}
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -1384,6 +1414,19 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			break;
 		}
 	}
+	if (err == 0 && test_bit(Unmerged, &rdev->flags)) {
+		/* Some requests might not have seen this new
+		 * merge_bvec_fn.  We must wait for them to complete
+		 * before merging the device fully.
+		 * First we make sure any code which has tested
+		 * our function has submitted the request, then
+		 * we wait for all outstanding requests to complete.
+		 */
+		synchronize_sched();
+		raise_barrier(conf);
+		lower_barrier(conf);
+		clear_bit(Unmerged, &rdev->flags);
+	}
 	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;
@@ -2628,15 +2671,6 @@ static int run(struct mddev *mddev)
 			continue;
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_segments to 1 lying within
-		 * a single page, as a one page request is never in violation.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-			blk_queue_max_segments(mddev->queue, 1);
-			blk_queue_segment_boundary(mddev->queue,
-						   PAGE_CACHE_SIZE - 1);
-		}
 	}
 
 	mddev->degraded = 0;
@@ -2670,6 +2704,7 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 		mddev->queue->backing_dev_info.congested_data = mddev;
+		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
 	}
 	return md_integrity_register(mddev);
 }


