From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 1 - Register mergeable function for linear so requests don't cross device boundries
Date: Wed, 16 Oct 2002 16:07:13 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E181hKr-0000Jx-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

We abstract out "which_dev" which finds which device a sector is on
and us it to make sure both ends of a to-be-merged request will
be on the same device.



 ----------- Diffstat output ------------
 ./drivers/md/linear.c |   69 +++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 52 insertions(+), 17 deletions(-)

--- ./drivers/md/linear.c	2002/10/16 04:48:24	1.1
+++ ./drivers/md/linear.c	2002/10/16 04:49:22	1.2
@@ -28,6 +28,45 @@
 #define MD_PERSONALITY
 #define DEVICE_NR(device) (minor(device))
 
+/*
+ * find which device holds a particular offset 
+ */
+static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
+{
+	struct linear_hash *hash;
+	linear_conf_t *conf = mddev_to_conf(mddev);
+	sector_t block = sector >> 1;
+
+	hash = conf->hash_table + sector_div(block, conf->smallest->size);
+
+	if ((sector>>1) >= (hash->dev0->size + hash->dev0->offset))
+		return hash->dev1;
+	else
+		return hash->dev0;
+}
+
+
+/**
+ *	linear_mergeable_bvec -- tell bio layer if a two requests can be merged
+ *	@q: request queue
+ *	@bio: the buffer head that's been built up so far
+ *	@biovec: the request that could be merged to it.
+ *
+ *	Return 1 if the merge is not permitted (because the
+ *	result would cross a device boundary), 0 otherwise.
+ */
+static int linear_mergeable_bvec(request_queue_t *q, struct bio *bio, struct bio_vec *biovec)
+{
+	mddev_t *mddev = q->queuedata;
+	dev_info_t *dev0, *dev1;
+
+	dev0 = which_dev(mddev, bio->bi_sector);
+	dev1 = which_dev(mddev, bio->bi_sector +
+			        ((bio->bi_size + biovec->bv_len - 1) >> 9));
+
+	return dev0 != dev1;
+}
+
 static int linear_run (mddev_t *mddev)
 {
 	linear_conf_t *conf;
@@ -110,6 +149,7 @@ static int linear_run (mddev_t *mddev)
 	if (table-conf->hash_table != nb_zone)
 		BUG();
 
+	blk_queue_merge_bvec(&mddev->queue, linear_mergeable_bvec);
 	return 0;
 
 out:
@@ -134,28 +174,23 @@ static int linear_stop (mddev_t *mddev)
 static int linear_make_request (request_queue_t *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	linear_conf_t *conf = mddev_to_conf(mddev);
-	struct linear_hash *hash;
 	dev_info_t *tmp_dev;
-	long block;
+	sector_t block;
 
+	tmp_dev = which_dev(mddev, bio->bi_sector);
 	block = bio->bi_sector >> 1;
-	hash = conf->hash_table + (block / conf->smallest->size);
   
-	if (block >= (hash->dev0->size + hash->dev0->offset)) {
-		if (!hash->dev1) {
-			printk ("linear_make_request : hash->dev1==NULL for block %ld\n",
-						block);
-			bio_io_error(bio, bio->bi_size);
-			return 0;
-		}
-		tmp_dev = hash->dev1;
-	} else
-		tmp_dev = hash->dev0;
+	if (unlikely(!tmp_dev)) {
+		printk ("linear_make_request : hash->dev1==NULL for block %llu\n",
+			(unsigned long long)block);
+		bio_io_error(bio, bio->bi_size);
+		return 0;
+	}
     
-	if (block >= (tmp_dev->size + tmp_dev->offset)
-				|| block < tmp_dev->offset) {
-		printk ("linear_make_request: Block %ld out of bounds on dev %s size %ld offset %ld\n", block, bdevname(tmp_dev->rdev->bdev), tmp_dev->size, tmp_dev->offset);
+	if (unlikely(block >= (tmp_dev->size + tmp_dev->offset)
+		     || block < tmp_dev->offset)) {
+		printk ("linear_make_request: Block %llu out of bounds on dev %s size %ld offset %ld\n",
+			(unsigned long long)block, bdevname(tmp_dev->rdev->bdev), tmp_dev->size, tmp_dev->offset);
 		bio_io_error(bio, bio->bi_size);
 		return 0;
 	}
