From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] md: Use new topology calls to indicate alignment and I/O sizes
Date: Tue, 09 Jun 2009 00:31:03 -0400
Message-ID: <yq1my8i6naw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Switch MD over to the new disk_stack_limits() function which checks for
aligment and adjusts preferred I/O sizes when stacking.

Also indicate preferred I/O sizes where applicable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 9f7cec4..de65208 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -142,9 +142,9 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		}
 
 		disk->rdev = rdev;
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset);
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index c1ca63f..0651a73 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -294,7 +294,8 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for (path = first; path <= last; path++)
 		if ((p=conf->multipaths+path)->rdev == NULL) {
 			q = rdev->bdev->bd_disk->queue;
-			blk_queue_stack_limits(mddev->queue, q);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+				rdev->data_offset);
 
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
@@ -460,9 +461,9 @@ static int multipath_run (mddev_t *mddev)
 
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset);
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, not that we ever expect a device with
 		 * a merge_bvec_fn to be involved in multipath */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f9e6073..c4687ea 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -164,8 +164,8 @@ static int create_strip_zones(mddev_t *mddev)
 		}
 		dev[j] = rdev1;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev1->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev1->bdev,
+				  rdev1->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -246,6 +246,11 @@ static int create_strip_zones(mddev_t *mddev)
 		       mddev->chunk_sectors << 9);
 		goto abort;
 	}
+
+	blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
+	blk_queue_io_opt(mddev->queue,
+			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
+
 	printk(KERN_INFO "raid0: done.\n");
 	mddev->private = conf;
 	return 0;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 89939a7..174c4dd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1123,8 +1123,8 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for (mirror = first; mirror <= last; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+						 rdev->data_offset);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -1988,9 +1988,8 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ae12cea..dfd18df 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1151,8 +1151,8 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for ( ; mirror <= last ; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -2044,7 +2044,7 @@ raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 static int run(mddev_t *mddev)
 {
 	conf_t *conf;
-	int i, disk_idx;
+	int i, disk_idx, chunk_size;
 	mirror_info_t *disk;
 	mdk_rdev_t *rdev;
 	int nc, fc, fo;
@@ -2130,6 +2130,10 @@ static int run(mddev_t *mddev)
 	spin_lock_init(&conf->device_lock);
 	mddev->queue->queue_lock = &conf->device_lock;
 
+	chunk_size = mddev->chunk_sectors << 9;
+	blk_queue_io_min(mddev->queue, chunk_size);
+	blk_queue_io_opt(mddev->queue, chunk_size * (mddev->raid_disks >> 1));
+
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2138,9 +2142,8 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 41dc36e..ea8d3fd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4451,7 +4451,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int working_disks = 0;
+	int working_disks = 0, chunk_size;
 	mdk_rdev_t *rdev;
 
 	if (mddev->recovery_cp != MaxSector)
@@ -4606,6 +4606,19 @@ static int run(mddev_t *mddev)
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
+	chunk_size = mddev->chunk_sectors << 9;
+	blk_queue_io_min(mddev->queue, chunk_size);
+
+	if (mddev->level == 5)
+		blk_queue_io_opt(mddev->queue,
+				 chunk_size * (mddev->raid_disks - 1));
+	else
+		blk_queue_io_opt(mddev->queue,
+				 chunk_size * (mddev->raid_disks - 2));
+
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset);
 
 	return 0;
 abort:

