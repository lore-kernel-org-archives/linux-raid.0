From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 8 - Rationalise device selection in md/multipath.
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002TU-AC@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md/multipath has two separate pieces of code for choosing a device
to use, one when a request is first made and the other when a
request is being re-tried after failure.
This patch discards multipath_read_balance and uses multipath_map
in both situations.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/multipath.c |   45 ++++++++++++---------------------------------
 1 files changed, 12 insertions(+), 33 deletions(-)

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-05-28 15:47:47.000000000 +1000
+++ ./drivers/md/multipath.c	2004-05-28 15:47:47.000000000 +1000
@@ -54,9 +54,8 @@ static void mp_pool_free(void *mpb, void
 	kfree(mpb);
 }
 
-static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdevp)
+static int multipath_map (multipath_conf_t *conf)
 {
-	multipath_conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = conf->raid_disks;
 
 	/*
@@ -68,10 +67,9 @@ static int multipath_map (mddev_t *mddev
 	for (i = 0; i < disks; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
 		if (rdev && rdev->in_sync) {
-			*rdevp = rdev;
 			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
-			return 0;
+			return i;
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
@@ -137,24 +135,6 @@ int multipath_end_request(struct bio *bi
 	return 0;
 }
 
-/*
- * This routine returns the disk from which the requested read should
- * be done.
- */
-
-static int multipath_read_balance (multipath_conf_t *conf)
-{
-	int disk;
-
-	for (disk = 0; disk < conf->raid_disks; disk++) {
-		mdk_rdev_t *rdev = conf->multipaths[disk].rdev;
-		if (rdev && rdev->in_sync)
-			return disk;
-	}
-	BUG();
-	return 0;
-}
-
 static void unplug_slaves(mddev_t *mddev)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
@@ -204,14 +184,14 @@ static int multipath_make_request (reque
 		disk_stat_inc(mddev->gendisk, reads);
 		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bio));
 	}
-	/*
-	 * read balancing logic:
-	 */
-	spin_lock_irq(&conf->device_lock);
-	mp_bh->path = multipath_read_balance(conf);
+
+	mp_bh->path = multipath_map(conf);
+	if (mp_bh->path < 0) {
+		bio_endio(bio, bio->bi_size, -EIO);
+		mempool_free(mp_bh, conf->pool);
+		return 0;
+	}
 	multipath = conf->multipaths + mp_bh->path;
-	atomic_inc(&multipath->rdev->nr_pending);
-	spin_unlock_irq(&conf->device_lock);
 
 	mp_bh->bio = *bio;
 	mp_bh->bio.bi_bdev = multipath->rdev->bdev;
@@ -400,7 +380,7 @@ static void multipathd (mddev_t *mddev)
 	struct multipath_bh *mp_bh;
 	struct bio *bio;
 	unsigned long flags;
-	mdk_rdev_t *rdev;
+	multipath_conf_t *conf = mddev_to_conf(mddev);
 
 	md_check_recovery(mddev);
 	for (;;) {
@@ -416,8 +396,7 @@ static void multipathd (mddev_t *mddev)
 		bio = &mp_bh->bio;
 		bio->bi_sector = mp_bh->master_bio->bi_sector;
 		
-		rdev = NULL;
-		if (multipath_map (mddev, &rdev)<0) {
+		if ((mp_bh->path = multipath_map (conf))<0) {
 			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
 				" error for block %llu\n",
 				bdevname(bio->bi_bdev,b),
@@ -428,7 +407,7 @@ static void multipathd (mddev_t *mddev)
 				" to another IO path\n",
 				bdevname(bio->bi_bdev,b),
 				(unsigned long long)bio->bi_sector);
-			bio->bi_bdev = rdev->bdev;
+			bio->bi_bdev = conf->multipaths[mp_bh->path].rdev->bdev;
 			generic_make_request(bio);
 		}
 	}
