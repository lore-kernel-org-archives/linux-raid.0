From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 2 - Fix "bio too big" problem with md
Date: Fri, 15 Aug 2003 11:41:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19nTac-0002sa-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Two patches for md in 2.6.0-test3
First propagates various limits from slave device to md array to
avoid "bio too big" errors.
Second makes md related modules unloadable.

### Comments for ChangeSet

Whenever a device is attached to an md device, we make sure the 
sector limits of the md device do not exceed those of the added device.

Ofcourse, if the attached device then changes its limits (as an md device
mighth) we'll never know....

 ----------- Diffstat output ------------
 ./drivers/block/ll_rw_blk.c |   15 +++++++++++++++
 ./drivers/md/linear.c       |    2 ++
 ./drivers/md/multipath.c    |    4 ++++
 ./drivers/md/raid0.c        |    3 ++-
 ./drivers/md/raid1.c        |    4 ++++
 ./include/linux/blkdev.h    |    1 +
 6 files changed, 28 insertions(+), 1 deletion(-)

diff ./drivers/block/ll_rw_blk.c~current~ ./drivers/block/ll_rw_blk.c
--- ./drivers/block/ll_rw_blk.c~current~	2003-08-15 11:34:02.000000000 +1000
+++ ./drivers/block/ll_rw_blk.c	2003-08-15 11:34:02.000000000 +1000
@@ -370,6 +370,20 @@ void blk_queue_hardsect_size(request_que
 }
 
 /**
+ * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
+ * @t:	the stacking driver (top)
+ * @b:  the underlying device (bottom)
+ **/
+void blk_queue_stack_limits(request_queue_t *t, request_queue_t *b)
+{
+	t->max_sectors = min(t->max_sectors,b->max_sectors);
+	t->max_phys_segments = min(t->max_phys_segments,b->max_phys_segments);
+	t->max_hw_segments = min(t->max_hw_segments,b->max_hw_segments);
+	t->max_segment_size = min(t->max_segment_size,b->max_segment_size);
+	t->hardsect_size = max(t->hardsect_size,b->hardsect_size);
+}
+
+/**
  * blk_queue_segment_boundary - set boundary rules for segment merging
  * @q:  the request queue for the device
  * @mask:  the memory boundary mask
@@ -2804,6 +2818,7 @@ EXPORT_SYMBOL(blk_queue_max_phys_segment
 EXPORT_SYMBOL(blk_queue_max_hw_segments);
 EXPORT_SYMBOL(blk_queue_max_segment_size);
 EXPORT_SYMBOL(blk_queue_hardsect_size);
+EXPORT_SYMBOL(blk_queue_stack_limits);
 EXPORT_SYMBOL(blk_queue_segment_boundary);
 EXPORT_SYMBOL(blk_queue_dma_alignment);
 EXPORT_SYMBOL(blk_rq_map_sg);

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-08-15 11:34:02.000000000 +1000
+++ ./drivers/md/linear.c	2003-08-15 11:34:02.000000000 +1000
@@ -114,6 +114,8 @@ static int linear_run (mddev_t *mddev)
 		}
 
 		disk->rdev = rdev;
+		blk_queue_stack_limits(mddev->queue,
+				       rdev->bdev->bd_disk->queue);
 		disk->size = rdev->size;
 		mddev->array_size += rdev->size;
 

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-08-15 11:34:02.000000000 +1000
+++ ./drivers/md/multipath.c	2003-08-15 11:34:02.000000000 +1000
@@ -272,6 +272,8 @@ static int multipath_add_disk(mddev_t *m
 	for (path=0; path<mddev->raid_disks; path++) 
 		if ((p=conf->multipaths+path)->rdev == NULL) {
 			p->rdev = rdev;
+			blk_queue_stack_limits(mddev->queue,
+					       rdev->bdev->bd_disk->queue);
 			conf->working_disks++;
 			rdev->raid_disk = path;
 			rdev->in_sync = 1;
@@ -409,6 +411,8 @@ static int multipath_run (mddev_t *mddev
 
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
+		blk_queue_stack_limits(mddev->queue,
+				       rdev->bdev->bd_disk->queue);
 		if (!rdev->faulty) 
 			conf->working_disks++;
 	}

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-08-15 11:34:02.000000000 +1000
+++ ./drivers/md/raid0.c	2003-08-15 11:34:02.000000000 +1000
@@ -113,6 +113,8 @@ static int create_strip_zones (mddev_t *
 			goto abort;
 		}
 		zone->dev[j] = rdev1;
+		blk_queue_stack_limits(mddev->queue,
+				       rdev1->bdev->bd_disk->queue);
 		if (!smallest || (rdev1->size <smallest->size))
 			smallest = rdev1;
 		cnt++;
@@ -293,7 +295,6 @@ static int raid0_run (mddev_t *mddev)
 		conf->hash_spacing++;
 	}
 
-	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	return 0;
 

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-08-15 11:34:02.000000000 +1000
+++ ./drivers/md/raid1.c	2003-08-15 11:34:02.000000000 +1000
@@ -678,6 +678,8 @@ static int raid1_add_disk(mddev_t *mddev
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 			p->rdev = rdev;
+			blk_queue_stack_limits(mddev->queue,
+					       rdev->bdev->bd_disk->queue);
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
@@ -1076,6 +1078,8 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
+		blk_queue_stack_limits(mddev->queue,
+				       rdev->bdev->bd_disk->queue);
 		disk->head_position = 0;
 		if (!rdev->faulty && rdev->in_sync)
 			conf->working_disks++;

diff ./include/linux/blkdev.h~current~ ./include/linux/blkdev.h
--- ./include/linux/blkdev.h~current~	2003-08-15 11:34:02.000000000 +1000
+++ ./include/linux/blkdev.h	2003-08-15 11:34:02.000000000 +1000
@@ -547,6 +547,7 @@ extern void blk_queue_max_phys_segments(
 extern void blk_queue_max_hw_segments(request_queue_t *, unsigned short);
 extern void blk_queue_max_segment_size(request_queue_t *, unsigned int);
 extern void blk_queue_hardsect_size(request_queue_t *, unsigned short);
+extern void blk_queue_stack_limits(request_queue_t *t, request_queue_t *b);
 extern void blk_queue_segment_boundary(request_queue_t *, unsigned long);
 extern void blk_queue_prep_rq(request_queue_t *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(request_queue_t *, merge_bvec_fn *);
