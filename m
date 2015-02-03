From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/26] md: make merge_bvec_fn more robust in face of
 personality changes.
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.79885.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is no locking around calls to merge_bvec_fn(), so
it is possible that calls which coincide with a level (or personality)
change could go wrong.

So create a central dispatch point for these functions and use
rcu_read_lock().
If the array is suspended, reject any merge that can be rejected.
If not, we know it is safe to call the function.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/linear.c |    6 ++----
 drivers/md/md.c     |   24 ++++++++++++++++++++++++
 drivers/md/md.h     |    4 ++++
 drivers/md/raid0.c  |    7 +++----
 drivers/md/raid1.c  |    6 ++----
 drivers/md/raid10.c |    7 +++----
 drivers/md/raid5.c  |    8 ++++----
 7 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 05108510d9cd..4c2a92ce2b0b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -60,11 +60,10 @@ static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
  *
  *	Return amount of bytes we can take at this offset
  */
-static int linear_mergeable_bvec(struct request_queue *q,
+static int linear_mergeable_bvec(struct mddev *mddev,
 				 struct bvec_merge_data *bvm,
 				 struct bio_vec *biovec)
 {
-	struct mddev *mddev = q->queuedata;
 	struct dev_info *dev0;
 	unsigned long maxsectors, bio_sectors = bvm->bi_size >> 9;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
@@ -213,8 +212,6 @@ static int linear_run (struct mddev *mddev)
 	mddev->private = conf;
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 
-	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
-
 	ret =  md_integrity_register(mddev);
 	if (ret) {
 		kfree(conf);
@@ -361,6 +358,7 @@ static struct md_personality linear_personality =
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
 	.congested	= linear_congested,
+	.mergeable_bvec	= linear_mergeable_bvec,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d45f52edb314..9f0ff7187136 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -339,6 +339,29 @@ static int md_congested(void *data, int bits)
 	return mddev_congested(mddev, bits);
 }
 
+static int md_mergeable_bvec(struct request_queue *q,
+			     struct bvec_merge_data *bvm,
+			     struct bio_vec *biovec)
+{
+	struct mddev *mddev = q->queuedata;
+	int ret;
+	rcu_read_lock();
+	if (mddev->suspended) {
+		/* Must always allow one vec */
+		if (bvm->bi_size == 0)
+			ret = biovec->bv_len;
+		else
+			ret = 0;
+	} else {
+		struct md_personality *pers = mddev->pers;
+		if (pers && pers->mergeable_bvec)
+			ret = pers->mergeable_bvec(mddev, bvm, biovec);
+		else
+			ret = biovec->bv_len;
+	}
+	rcu_read_unlock();
+	return ret;
+}
 /*
  * Generic flush handling for md
  */
@@ -4925,6 +4948,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->queue) {
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		mddev->queue->backing_dev_info.congested_fn = md_congested;
+		blk_queue_merge_bvec(mddev->queue, md_mergeable_bvec);
 	}
 	if (mddev->pers->sync_request) {
 		if (mddev->kobj.sd &&
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f2602280fac1..bee5b852c33f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -499,6 +499,10 @@ struct md_personality
 	/* congested implements bdi.congested_fn().
 	 * Will not be called while array is 'suspended' */
 	int (*congested)(struct mddev *mddev, int bits);
+	/* mergeable_bvec is use to implement ->merge_bvec_fn */
+	int (*mergeable_bvec)(struct mddev *mddev,
+			      struct bvec_merge_data *bvm,
+			      struct bio_vec *biovec);
 };
 
 struct md_sysfs_entry {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 4b521eac5b69..3770c9675b17 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -350,17 +350,16 @@ static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
 
 /**
  *	raid0_mergeable_bvec -- tell bio layer if two requests can be merged
- *	@q: request queue
+ *	@mddev: the md device
  *	@bvm: properties of new bio
  *	@biovec: the request that could be merged to it.
  *
  *	Return amount of bytes we can accept at this offset
  */
-static int raid0_mergeable_bvec(struct request_queue *q,
+static int raid0_mergeable_bvec(struct mddev *mddev,
 				struct bvec_merge_data *bvm,
 				struct bio_vec *biovec)
 {
-	struct mddev *mddev = q->queuedata;
 	struct r0conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	sector_t sector_offset = sector;
@@ -465,7 +464,6 @@ static int raid0_run(struct mddev *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
 
 	ret = md_integrity_register(mddev);
@@ -724,6 +722,7 @@ static struct md_personality raid0_personality=
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
 	.congested	= raid0_congested,
+	.mergeable_bvec	= raid0_mergeable_bvec,
 };
 
 static int __init raid0_init (void)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9ad7ce7091be..45c512a4b75d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -701,11 +701,10 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	return best_disk;
 }
 
-static int raid1_mergeable_bvec(struct request_queue *q,
+static int raid1_mergeable_bvec(struct mddev *mddev,
 				struct bvec_merge_data *bvm,
 				struct bio_vec *biovec)
 {
-	struct mddev *mddev = q->queuedata;
 	struct r1conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max = biovec->bv_len;
@@ -2946,8 +2945,6 @@ static int run(struct mddev *mddev)
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	if (mddev->queue) {
-		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
-
 		if (discard_supported)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
 						mddev->queue);
@@ -3183,6 +3180,7 @@ static struct md_personality raid1_personality =
 	.quiesce	= raid1_quiesce,
 	.takeover	= raid1_takeover,
 	.congested	= raid1_congested,
+	.mergeable_bvec	= raid1_mergeable_bvec,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fb6b88674e87..407c81a820f4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -674,7 +674,7 @@ static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
 
 /**
  *	raid10_mergeable_bvec -- tell bio layer if a two requests can be merged
- *	@q: request queue
+ *	@mddev: the md device
  *	@bvm: properties of new bio
  *	@biovec: the request that could be merged to it.
  *
@@ -682,11 +682,10 @@ static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
  *	This requires checking for end-of-chunk if near_copies != raid_disks,
  *	and for subordinate merge_bvec_fns if merge_check_needed.
  */
-static int raid10_mergeable_bvec(struct request_queue *q,
+static int raid10_mergeable_bvec(struct mddev *mddev,
 				 struct bvec_merge_data *bvm,
 				 struct bio_vec *biovec)
 {
-	struct mddev *mddev = q->queuedata;
 	struct r10conf *conf = mddev->private;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max;
@@ -3756,7 +3755,6 @@ static int run(struct mddev *mddev)
 		stripe /= conf->geo.near_copies;
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
-		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
 	}
 
 	if (md_integrity_register(mddev))
@@ -4717,6 +4715,7 @@ static struct md_personality raid10_personality =
 	.start_reshape	= raid10_start_reshape,
 	.finish_reshape	= raid10_finish_reshape,
 	.congested	= raid10_congested,
+	.mergeable_bvec	= raid10_mergeable_bvec,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 502a908149c6..2d4a2cc85eb2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4170,11 +4170,10 @@ static int raid5_congested(struct mddev *mddev, int bits)
 /* We want read requests to align with chunks where possible,
  * but write requests don't need to.
  */
-static int raid5_mergeable_bvec(struct request_queue *q,
+static int raid5_mergeable_bvec(struct mddev *mddev,
 				struct bvec_merge_data *bvm,
 				struct bio_vec *biovec)
 {
-	struct mddev *mddev = q->queuedata;
 	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
@@ -6237,8 +6236,6 @@ static int run(struct mddev *mddev)
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 
-		blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
-
 		chunk_size = mddev->chunk_sectors << 9;
 		blk_queue_io_min(mddev->queue, chunk_size);
 		blk_queue_io_opt(mddev->queue, chunk_size *
@@ -7113,6 +7110,7 @@ static struct md_personality raid6_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 	.congested	= raid5_congested,
+	.mergeable_bvec	= raid5_mergeable_bvec,
 };
 static struct md_personality raid5_personality =
 {
@@ -7136,6 +7134,7 @@ static struct md_personality raid5_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.congested	= raid5_congested,
+	.mergeable_bvec	= raid5_mergeable_bvec,
 };
 
 static struct md_personality raid4_personality =
@@ -7160,6 +7159,7 @@ static struct md_personality raid4_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid4_takeover,
 	.congested	= raid5_congested,
+	.mergeable_bvec	= raid5_mergeable_bvec,
 };
 
 static int __init raid5_init(void)


