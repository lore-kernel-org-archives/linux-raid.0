From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 2 - Limit max_sectors on md when merge_bvec_fn defined on underlying device.
Date: Fri, 21 Nov 2003 14:21:12 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AN1r6-0007lT-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Linus,
 I believe these to md patches are suitable for inclusion before 2.6.0,
 though neither fixes oops or data corruption.

 This first limits the maximum size of requests to raid devices if the 
 underlying device has some possible request alignment issues.

 The second increases max read_ahead on raid0 and raid5 to patch the 
 stripe size so that large sequential reads are more efficient.

NeilBrown
### Comments for ChangeSet

As no md personalities honour the merge_bvec_fn of underlying devices,
we must make sure never to submit a bio larger than 1 page when a 
merge_bvec_fn is defined.
raid5 already does this (it never submits bios larger than one page).
With this patch, all other raid personalities limit their 
max_sectors when a merge_bvec_fn is present.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c    |    9 +++++++++
 ./drivers/md/multipath.c |   19 +++++++++++++++++++
 ./drivers/md/raid0.c     |   10 ++++++++++
 ./drivers/md/raid1.c     |   18 ++++++++++++++++++
 4 files changed, 56 insertions(+)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-11-21 13:59:16.000000000 +1100
+++ ./drivers/md/linear.c	2003-11-21 14:10:24.000000000 +1100
@@ -113,8 +113,17 @@ static int linear_run (mddev_t *mddev)
 		}
 
 		disk->rdev = rdev;
+
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, so limit ->max_sector to one PAGE, as
+		 * a one page request is never in violation.
+		 */
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
+		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+			mddev->queue->max_sectors = (PAGE_SIZE>>9);
+
 		disk->size = rdev->size;
 		mddev->array_size += rdev->size;
 

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-11-21 13:59:16.000000000 +1100
+++ ./drivers/md/multipath.c	2003-11-21 14:10:24.000000000 +1100
@@ -273,6 +273,17 @@ static int multipath_add_disk(mddev_t *m
 			p->rdev = rdev;
 			blk_queue_stack_limits(mddev->queue,
 					       rdev->bdev->bd_disk->queue);
+
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, so limit ->max_sector to one PAGE, as
+		 * a one page request is never in violation.
+		 * (Note: it is very unlikely that a device with 
+		 * merge_bvec_fn will be involved in multipath.)
+		 */ 
+			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
+			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+				mddev->queue->max_sectors = (PAGE_SIZE>>9);
+
 			conf->working_disks++;
 			rdev->raid_disk = path;
 			rdev->in_sync = 1;
@@ -410,8 +421,16 @@ static int multipath_run (mddev_t *mddev
 
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
+
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, not that we ever expect a device with
+		 * a merge_bvec_fn to be involved in multipath */
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
+		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+			mddev->queue->max_sectors = (PAGE_SIZE>>9);
+
 		if (!rdev->faulty) 
 			conf->working_disks++;
 	}

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-11-21 13:59:18.000000000 +1100
+++ ./drivers/md/raid0.c	2003-11-21 14:10:24.000000000 +1100
@@ -112,8 +112,18 @@ static int create_strip_zones (mddev_t *
 			goto abort;
 		}
 		zone->dev[j] = rdev1;
+
 		blk_queue_stack_limits(mddev->queue,
 				       rdev1->bdev->bd_disk->queue);
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, so limit ->max_sector to one PAGE, as
+		 * a one page request is never in violation.
+		 */
+
+		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
+		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+			mddev->queue->max_sectors = (PAGE_SIZE>>9);
+
 		if (!smallest || (rdev1->size <smallest->size))
 			smallest = rdev1;
 		cnt++;

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-11-21 13:59:33.000000000 +1100
+++ ./drivers/md/raid1.c	2003-11-21 14:10:24.000000000 +1100
@@ -677,8 +677,17 @@ static int raid1_add_disk(mddev_t *mddev
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 			p->rdev = rdev;
+
 			blk_queue_stack_limits(mddev->queue,
 					       rdev->bdev->bd_disk->queue);
+			/* as we don't honour merge_bvec_fn, we must never risk
+			 * violating it, so limit ->max_sector to one PAGE, as
+			 * a one page request is never in violation.
+			 */
+			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
+			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+				mddev->queue->max_sectors = (PAGE_SIZE>>9);
+
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
@@ -1077,8 +1086,17 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
+
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+		/* as we don't honour merge_bvec_fn, we must never risk
+		 * violating it, so limit ->max_sector to one PAGE, as
+		 * a one page request is never in violation.
+		 */
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
+		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+			mddev->queue->max_sectors = (PAGE_SIZE>>9);
+
 		disk->head_position = 0;
 		if (!rdev->faulty && rdev->in_sync)
 			conf->working_disks++;
