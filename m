From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 7] Rationalise issue_flush function in md personalities
Date: Wed, 08 Sep 2004 12:48:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C4sVF-0005dh-S0@notabene.cse.unsw.edu.au>
References: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The functions are all subtley different.  This patch makes them all
much the same.  In particular, EOPNOTSUPP gets returned by all is
appropriate.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c    |   11 ++++-------
 ./drivers/md/multipath.c |   13 +++++--------
 ./drivers/md/raid0.c     |   12 ++++--------
 ./drivers/md/raid1.c     |   12 ++++++------
 ./drivers/md/raid10.c    |   12 ++++++------
 ./drivers/md/raid5.c     |   22 ++++++----------------
 ./drivers/md/raid6main.c |   22 ++++++----------------
 7 files changed, 37 insertions(+), 67 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2004-09-08 11:56:53.000000000 +1000
+++ ./drivers/md/linear.c	2004-09-08 11:56:55.000000000 +1000
@@ -99,17 +99,14 @@ static int linear_issue_flush(request_qu
 	linear_conf_t *conf = mddev_to_conf(mddev);
 	int i, ret = 0;
 
-	for (i=0; i < mddev->raid_disks; i++) {
+	for (i=0; i < mddev->raid_disks && ret == 0; i++) {
 		struct block_device *bdev = conf->disks[i].rdev->bdev;
 		request_queue_t *r_queue = bdev_get_queue(bdev);
 
-		if (!r_queue->issue_flush_fn) {
+		if (!r_queue->issue_flush_fn)
 			ret = -EOPNOTSUPP;
-			break;
-		}
-		ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-		if (ret)
-			break;
+		else
+			ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
 	}
 	return ret;
 }

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-09-08 11:56:53.000000000 +1000
+++ ./drivers/md/multipath.c	2004-09-08 11:56:55.000000000 +1000
@@ -238,20 +238,17 @@ static int multipath_issue_flush(request
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	int i, ret = 0;
 
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
-			if (!r_queue->issue_flush_fn) {
+			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-				break;
-			}
-
-			ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-			if (ret)
-				break;
+			else
+				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
+							      error_sector);
 		}
 	}
 	return ret;

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2004-09-08 11:56:53.000000000 +1000
+++ ./drivers/md/raid0.c	2004-09-08 11:56:55.000000000 +1000
@@ -48,18 +48,14 @@ static int raid0_issue_flush(request_que
 	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
 	int i, ret = 0;
 
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		struct block_device *bdev = devlist[i]->bdev;
 		request_queue_t *r_queue = bdev_get_queue(bdev);
 
-		if (!r_queue->issue_flush_fn) {
+		if (!r_queue->issue_flush_fn)
 			ret = -EOPNOTSUPP;
-			break;
-		}
-
-		ret =r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-		if (ret)
-			break;
+		else
+			ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
 	}
 	return ret;
 }

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-09-08 11:56:53.000000000 +1000
+++ ./drivers/md/raid1.c	2004-09-08 11:57:08.000000000 +1000
@@ -459,17 +459,17 @@ static int raid1_issue_flush(request_que
 	int i, ret = 0;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
-			if (r_queue->issue_flush_fn) {
-				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-				if (ret)
-					break;
-			}
+			if (!r_queue->issue_flush_fn)
+				ret = -EOPNOTSUPP;
+			else
+				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
+							      error_sector);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2004-09-08 11:56:53.000000000 +1000
+++ ./drivers/md/raid10.c	2004-09-08 11:56:55.000000000 +1000
@@ -613,17 +613,17 @@ static int raid10_issue_flush(request_qu
 	int i, ret = 0;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
 			request_queue_t *r_queue = bdev_get_queue(bdev);
 
-			if (r_queue->issue_flush_fn) {
-				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-				if (ret)
-					break;
-			}
+			if (!r_queue->issue_flush_fn)
+				ret = -EOPNOTSUPP;
+			else
+				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
+							      error_sector);
 		}
 	}
 	spin_unlock_irqrestore(&conf->device_lock, flags);

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-09-08 11:56:53.000000000 +1000
+++ ./drivers/md/raid5.c	2004-09-08 11:56:55.000000000 +1000
@@ -1347,27 +1347,17 @@ static int raid5_issue_flush(request_que
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int i, ret = 0;
 
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
-			request_queue_t *r_queue;
+			request_queue_t *r_queue = bdev_get_queue(bdev);
 
-			if (!bdev)
-				continue;
-
-			r_queue = bdev_get_queue(bdev);
-			if (!r_queue)
-				continue;
-
-			if (!r_queue->issue_flush_fn) {
+			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-				break;
-			}
-
-			ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-			if (ret)
-				break;
+			else
+				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
+							      error_sector);
 		}
 	}
 	return ret;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-09-08 11:56:53.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-09-08 11:56:55.000000000 +1000
@@ -1509,27 +1509,17 @@ static int raid6_issue_flush(request_que
 	raid6_conf_t *conf = mddev_to_conf(mddev);
 	int i, ret = 0;
 
-	for (i=0; i<mddev->raid_disks; i++) {
+	for (i=0; i<mddev->raid_disks && ret == 0; i++) {
 		mdk_rdev_t *rdev = conf->disks[i].rdev;
 		if (rdev && !rdev->faulty) {
 			struct block_device *bdev = rdev->bdev;
-			request_queue_t *r_queue;
+			request_queue_t *r_queue = bdev_get_queue(bdev);
 
-			if (!bdev)
-				continue;
-
-			r_queue = bdev_get_queue(bdev);
-			if (!r_queue)
-				continue;
-
-			if (!r_queue->issue_flush_fn) {
+			if (!r_queue->issue_flush_fn)
 				ret = -EOPNOTSUPP;
-				break;
-			}
-
-			ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk, error_sector);
-			if (ret)
-				break;
+			else
+				ret = r_queue->issue_flush_fn(r_queue, bdev->bd_disk,
+							      error_sector);
 		}
 	}
 	return ret;
