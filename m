From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 8 of 27 - Get rid of find_rdev_all
Date: Thu, 18 Jul 2002 23:32:58 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133258.4824@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Get rid of find_rdev_all

find_rdev_all is now only used to check if a device is already
used in an md array.

We change lock_rdev so that it claims the bdev for
the specific rdev rather than for rdevs in general.
Now lock_rdev will check if the bdev is inuse by another array
or not, so the find_rdev_all check isn't needed and is removed,
along with find_rdev_all itself.

We also make sure that the error code from lock_rdev is
propagated up properly.






 ----------- Diffstat output ------------
 ./drivers/md/md.c |   34 ++++++----------------------------
 1 files changed, 6 insertions(+), 28 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:00:37	1.3
+++ ./drivers/md/md.c	2002/07/18 12:00:45	1.4
@@ -603,7 +603,7 @@ static int lock_rdev(mdk_rdev_t *rdev)
 	err = blkdev_get(bdev, FMODE_READ|FMODE_WRITE, 0, BDEV_RAW);
 	if (err)
 		return err;
-	err = bd_claim(bdev, lock_rdev);
+	err = bd_claim(bdev, rdev);
 	if (err) {
 		blkdev_put(bdev, BDEV_RAW);
 		return err;
@@ -819,19 +819,6 @@ static int uuid_equal(mdk_rdev_t *rdev1,
 	return 0;
 }
 
-static mdk_rdev_t * find_rdev_all(kdev_t dev)
-{
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
-
-	list_for_each(tmp, &all_raid_disks) {
-		rdev = list_entry(tmp, mdk_rdev_t, all);
-		if (kdev_same(rdev->dev, dev))
-			return rdev;
-	}
-	return NULL;
-}
-
 static int write_disk_sb(mdk_rdev_t * rdev)
 {
 	kdev_t dev = rdev->dev;
@@ -1007,9 +994,6 @@ static mdk_rdev_t *md_import_device(kdev
 	mdk_rdev_t *rdev;
 	unsigned int size;
 
-	if (find_rdev_all(newdev))
-		return ERR_PTR(-EEXIST);
-
 	rdev = (mdk_rdev_t *) kmalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
 		printk(KERN_ERR "md: could not alloc mem for %s!\n", partition_name(newdev));
@@ -1021,10 +1005,10 @@ static mdk_rdev_t *md_import_device(kdev
 		goto abort_free;
 
 	rdev->dev = newdev;
-	if (lock_rdev(rdev)) {
-		printk(KERN_ERR "md: could not lock %s, zero-size? Marking faulty.\n",
+	err = lock_rdev(rdev);
+	if (err) {
+		printk(KERN_ERR "md: could not lock %s.\n",
 			partition_name(newdev));
-		err = -EINVAL;
 		goto abort_free;
 	}
 	rdev->desc_nr = -1;
@@ -2103,18 +2087,12 @@ static int add_new_disk(mddev_t * mddev,
 	unsigned int nr;
 	kdev_t dev;
 	dev = mk_kdev(info->major,info->minor);
-
-	if (find_rdev_all(dev)) {
-		printk(KERN_WARNING "md: device %s already used in a RAID array!\n",
-		       partition_name(dev));
-		return -EBUSY;
-	}
 	if (!mddev->sb) {
 		/* expecting a device which has a superblock */
 		rdev = md_import_device(dev, 1);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING "md: md_import_device returned %ld\n", PTR_ERR(rdev));
-			return -EINVAL;
+			return PTR_ERR(rdev);
 		}
 		if (!list_empty(&mddev->disks)) {
 			mdk_rdev_t *rdev0 = list_entry(mddev->disks.next,
@@ -2153,7 +2131,7 @@ static int add_new_disk(mddev_t * mddev,
 		rdev = md_import_device (dev, 0);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
-			return -EINVAL;
+			return PTR_ERR(rdev);
 		}
 		rdev->old_dev = dev;
 		rdev->desc_nr = info->number;
