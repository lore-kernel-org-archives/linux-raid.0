From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/23] md/raid10: handle merge_bvec_fn in member devices.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044040.7978.10047.stgit@notabene.brown>
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

So enhance the raid10 merge_bvec_fn to check that function in children
as well.

This introduces a small problem.  There is no locking around calls
the ->merge_bvec_fn and subsequent calls to ->make_request.  So a
device added between these could end up getting a request which
violates its merge_bvec_fn.

Currently the best we can do is synchronize_sched().  This will work
providing no preemption happens.  If there is preemption, we just
have to hope that new devices are largely consistent with old devices.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c     |    1 
 drivers/md/md.h     |    8 +++
 drivers/md/raid10.c |  122 ++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 90 insertions(+), 41 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 84796a5..3e8fcab 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5073,6 +5073,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->changed = 0;
 	mddev->degraded = 0;
 	mddev->safemode = 0;
+	mddev->merge_check_needed = 0;
 	mddev->bitmap_info.offset = 0;
 	mddev->bitmap_info.default_offset = 0;
 	mddev->bitmap_info.chunksize = 0;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a8d91fe..c797f5f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -128,6 +128,10 @@ struct md_rdev {
 enum flag_bits {
 	Faulty,			/* device is known to have a fault */
 	In_sync,		/* device is in_sync with rest of array */
+	Unmerged,		/* device is being added to array and should
+				 * be considerred for bvec_merge_fn but not
+				 * yet for actual IO
+				 */
 	WriteMostly,		/* Avoid reading if at all possible */
 	AutoDetected,		/* added by auto-detect */
 	Blocked,		/* An error occurred but has not yet
@@ -345,6 +349,10 @@ struct mddev {
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
+	int				merge_check_needed; /* at least one
+							     * member device
+							     * has a
+							     * merge_bvec_fn */
 
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9838f08..7b3346a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -586,25 +586,68 @@ static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
  *	@biovec: the request that could be merged to it.
  *
  *	Return amount of bytes we can accept at this offset
- *      If near_copies == raid_disk, there are no striping issues,
- *      but in that case, the function isn't called at all.
+ *	This requires checking for end-of-chunk if near_copies != raid_disks,
+ *	and for subordinate merge_bvec_fns if merge_check_needed.
  */
 static int raid10_mergeable_bvec(struct request_queue *q,
 				 struct bvec_merge_data *bvm,
 				 struct bio_vec *biovec)
 {
 	struct mddev *mddev = q->queuedata;
+	struct r10conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
-	if (max <= biovec->bv_len && bio_sectors == 0)
-		return biovec->bv_len;
-	else
-		return max;
+	if (conf->near_copies < conf->raid_disks) {
+		max = (chunk_sectors - ((sector & (chunk_sectors - 1))
+					+ bio_sectors)) << 9;
+		if (max < 0)
+			/* bio_add cannot handle a negative return */
+			max = 0;
+		if (max <= biovec->bv_len && bio_sectors == 0)
+			return biovec->bv_len;
+	} else
+		max = biovec->bv_len;
+
+	if (mddev->merge_check_needed) {
+		struct r10bio r10_bio;
+		int s;
+		r10_bio.sector = sector;
+		raid10_find_phys(conf, &r10_bio);
+		rcu_read_lock();
+		for (s = 0; s < conf->copies; s++) {
+			int disk = r10_bio.devs[s].devnum;
+			struct md_rdev *rdev = rcu_dereference(
+				conf->mirrors[disk].rdev);
+			if (rdev && !test_bit(Faulty, &rdev->flags)) {
+				struct request_queue *q =
+					bdev_get_queue(rdev->bdev);
+				if (q->merge_bvec_fn) {
+					bvm->bi_sector = r10_bio.devs[s].addr
+						+ rdev->data_offset;
+					bvm->bi_bdev = rdev->bdev;
+					max = min(max, q->merge_bvec_fn(
+							  q, bvm, biovec));
+				}
+			}
+			rdev = rcu_dereference(conf->mirrors[disk].replacement);
+			if (rdev && !test_bit(Faulty, &rdev->flags)) {
+				struct request_queue *q =
+					bdev_get_queue(rdev->bdev);
+				if (q->merge_bvec_fn) {
+					bvm->bi_sector = r10_bio.devs[s].addr
+						+ rdev->data_offset;
+					bvm->bi_bdev = rdev->bdev;
+					max = min(max, q->merge_bvec_fn(
+							  q, bvm, biovec));
+				}
+			}
+		}
+		rcu_read_unlock();
+	}
+	return max;
 }
 
 /*
@@ -668,11 +711,12 @@ retry:
 		disk = r10_bio->devs[slot].devnum;
 		rdev = rcu_dereference(conf->mirrors[disk].replacement);
 		if (rdev == NULL || test_bit(Faulty, &rdev->flags) ||
+		    test_bit(Unmerged, &rdev->flags) ||
 		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
 			rdev = rcu_dereference(conf->mirrors[disk].rdev);
-		if (rdev == NULL)
-			continue;
-		if (test_bit(Faulty, &rdev->flags))
+		if (rdev == NULL ||
+		    test_bit(Faulty, &rdev->flags) ||
+		    test_bit(Unmerged, &rdev->flags))
 			continue;
 		if (!test_bit(In_sync, &rdev->flags) &&
 		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
@@ -1134,12 +1178,14 @@ retry_write:
 			blocked_rdev = rrdev;
 			break;
 		}
-		if (rrdev && test_bit(Faulty, &rrdev->flags))
+		if (rrdev && (test_bit(Faulty, &rrdev->flags)
+			      || test_bit(Unmerged, &rrdev->flags)))
 			rrdev = NULL;
 
 		r10_bio->devs[i].bio = NULL;
 		r10_bio->devs[i].repl_bio = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags)) {
+		if (!rdev || test_bit(Faulty, &rdev->flags) ||
+		    test_bit(Unmerged, &rdev->flags)) {
 			set_bit(R10BIO_Degraded, &r10_bio->state);
 			continue;
 		}
@@ -1491,6 +1537,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int mirror;
 	int first = 0;
 	int last = conf->raid_disks - 1;
+	struct request_queue *q = bdev_get_queue(rdev->bdev);
 
 	if (mddev->recovery_cp < MaxSector)
 		/* only hot-add to in-sync arrays, as recovery is
@@ -1503,6 +1550,11 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
+	if (q->merge_bvec_fn) {
+		set_bit(Unmerged, &rdev->flags);
+		mddev->merge_check_needed = 1;
+	}
+
 	if (rdev->saved_raid_disk >= first &&
 	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
 		mirror = rdev->saved_raid_disk;
@@ -1522,11 +1574,6 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			err = 0;
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
-			if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-				blk_queue_max_segments(mddev->queue, 1);
-				blk_queue_segment_boundary(mddev->queue,
-							   PAGE_CACHE_SIZE - 1);
-			}
 			conf->fullsync = 1;
 			rcu_assign_pointer(p->replacement, rdev);
 			break;
@@ -1534,17 +1581,6 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
-		/* as we don't honour merge_bvec_fn, we must
-		 * never risk violating it, so limit
-		 * ->max_segments to one lying with a single
-		 * page, as a one page request is never in
-		 * violation.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-			blk_queue_max_segments(mddev->queue, 1);
-			blk_queue_segment_boundary(mddev->queue,
-						   PAGE_CACHE_SIZE - 1);
-		}
 
 		p->head_position = 0;
 		p->recovery_disabled = mddev->recovery_disabled - 1;
@@ -1555,7 +1591,19 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		rcu_assign_pointer(p->rdev, rdev);
 		break;
 	}
-
+	if (err == 0 && test_bit(Unmerged, &rdev->flags)) {
+		/* Some requests might not have seen this new
+		 * merge_bvec_fn.  We must wait for them to complete
+		 * before merging the device fully.
+		 * First we make sure any code which has tested
+		 * our function has submitted the request, then
+		 * we wait for all outstanding requests to complete.
+		 */
+		synchronize_sched();
+		raise_barrier(conf, 0);
+		lower_barrier(conf);
+		clear_bit(Unmerged, &rdev->flags);
+	}
 	md_integrity_add_rdev(rdev, mddev);
 	print_conf(conf);
 	return err;
@@ -2099,6 +2147,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
+			    !test_bit(Unmerged, &rdev->flags) &&
 			    test_bit(In_sync, &rdev->flags) &&
 			    is_badblock(rdev, r10_bio->devs[sl].addr + sect, s,
 					&first_bad, &bad_sectors) == 0) {
@@ -2152,6 +2201,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (!rdev ||
+			    test_bit(Unmerged, &rdev->flags) ||
 			    !test_bit(In_sync, &rdev->flags))
 				continue;
 
@@ -3274,15 +3324,6 @@ static int run(struct mddev *mddev)
 
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit max_segments to 1 lying
-		 * within a single page.
-		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-			blk_queue_max_segments(mddev->queue, 1);
-			blk_queue_segment_boundary(mddev->queue,
-						   PAGE_CACHE_SIZE - 1);
-		}
 
 		disk->head_position = 0;
 	}
@@ -3346,8 +3387,7 @@ static int run(struct mddev *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-	if (conf->near_copies < conf->raid_disks)
-		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
+	blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
 
 	if (md_integrity_register(mddev))
 		goto out_free_conf;


