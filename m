From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 4] Remove most calls to __bdevname from md.c
Date: Mon, 23 Aug 2004 13:10:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Bz5E3-0005C1-Ar@notabene.cse.unsw.edu.au>
References: <20040823130657.19914.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


__bdevname now only prints major/minor number which isn't
much help.  So remove most calls to it from md.c, replacing
those that are useful by calls to bdevname (often printing the
message when the error is first detected rather than higher
up the call tree).

Also discard hot_generate_error which doesn't do anything
useful and never has.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   96 +++++++++++-------------------------------------------
 1 files changed, 20 insertions(+), 76 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-08-23 12:28:43.000000000 +1000
+++ ./drivers/md/md.c	2004-08-23 12:41:57.000000000 +1000
@@ -1111,20 +1111,24 @@ static void unbind_rdev_from_array(mdk_r
 /*
  * prevent the device from being mounted, repartitioned or
  * otherwise reused by a RAID array (or any other kernel
- * subsystem), by opening the device. [simply getting an
- * inode is not enough, the SCSI module usage code needs
- * an explicit open() on the device]
+ * subsystem), by bd_claiming the device.
  */
 static int lock_rdev(mdk_rdev_t *rdev, dev_t dev)
 {
 	int err = 0;
 	struct block_device *bdev;
+	char b[BDEVNAME_SIZE];
 
 	bdev = open_by_devnum(dev, FMODE_READ|FMODE_WRITE);
-	if (IS_ERR(bdev))
+	if (IS_ERR(bdev)) {
+		printk(KERN_ERR "md: could not open %s.\n",
+			__bdevname(dev, b));
 		return PTR_ERR(bdev);
+	}
 	err = bd_claim(bdev, rdev);
 	if (err) {
+		printk(KERN_ERR "md: could not bd_claim %s.\n",
+			bdevname(bdev, b));
 		blkdev_put(bdev);
 		return err;
 	}
@@ -1186,10 +1190,7 @@ static void export_array(mddev_t *mddev)
 
 static void print_desc(mdp_disk_t *desc)
 {
-	char b[BDEVNAME_SIZE];
-
-	printk(" DISK<N:%d,%s(%d,%d),R:%d,S:%d>\n", desc->number,
-		__bdevname(MKDEV(desc->major, desc->minor), b),
+	printk(" DISK<N:%d,(%d,%d),R:%d,S:%d>\n", desc->number,
 		desc->major,desc->minor,desc->raid_disk,desc->state);
 }
 
@@ -1381,8 +1382,7 @@ static mdk_rdev_t *md_import_device(dev_
 
 	rdev = (mdk_rdev_t *) kmalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
-		printk(KERN_ERR "md: could not alloc mem for %s!\n", 
-			__bdevname(newdev, b));
+		printk(KERN_ERR "md: could not alloc mem for new device!\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	memset(rdev, 0, sizeof(*rdev));
@@ -1391,11 +1391,9 @@ static mdk_rdev_t *md_import_device(dev_
 		goto abort_free;
 
 	err = lock_rdev(rdev, newdev);
-	if (err) {
-		printk(KERN_ERR "md: could not lock %s.\n",
-			__bdevname(newdev, b));
+	if (err)
 		goto abort_free;
-	}
+
 	rdev->desc_nr = -1;
 	rdev->faulty = 0;
 	rdev->in_sync = 0;
@@ -1953,11 +1951,9 @@ static int autostart_array(dev_t startde
 	mdk_rdev_t *start_rdev = NULL, *rdev;
 
 	start_rdev = md_import_device(startdev, 0, 0);
-	if (IS_ERR(start_rdev)) {
-		printk(KERN_WARNING "md: could not import %s!\n",
-			__bdevname(startdev, b));
+	if (IS_ERR(start_rdev))
 		return err;
-	}
+
 
 	/* NOTE: this can only work for 0.90.0 superblocks */
 	sb = (mdp_super_t*)page_address(start_rdev->sb_page);
@@ -1988,12 +1984,9 @@ static int autostart_array(dev_t startde
 		if (MAJOR(dev) != desc->major || MINOR(dev) != desc->minor)
 			continue;
 		rdev = md_import_device(dev, 0, 0);
-		if (IS_ERR(rdev)) {
-			printk(KERN_WARNING "md: could not import %s,"
-				" trying to run array nevertheless.\n",
-				__bdevname(dev, b));
+		if (IS_ERR(rdev))
 			continue;
-		}
+
 		list_add(&rdev->same_set, &pending_raid_disks);
 	}
 
@@ -2225,42 +2218,6 @@ static int add_new_disk(mddev_t * mddev,
 	return 0;
 }
 
-static int hot_generate_error(mddev_t * mddev, dev_t dev)
-{
-	char b[BDEVNAME_SIZE];
-	struct request_queue *q;
-	mdk_rdev_t *rdev;
-
-	if (!mddev->pers)
-		return -ENODEV;
-
-	printk(KERN_INFO "md: trying to generate %s error in %s ... \n",
-		__bdevname(dev, b), mdname(mddev));
-
-	rdev = find_rdev(mddev, dev);
-	if (!rdev) {
-		/* MD_BUG(); */ /* like hell - it's not a driver bug */
-		return -ENXIO;
-	}
-
-	if (rdev->desc_nr == -1) {
-		MD_BUG();
-		return -EINVAL;
-	}
-	if (!rdev->in_sync)
-		return -ENODEV;
-
-	q = bdev_get_queue(rdev->bdev);
-	if (!q) {
-		MD_BUG();
-		return -ENODEV;
-	}
-	printk(KERN_INFO "md: okay, generating error!\n");
-//	q->oneshot_error = 1; // disabled for now
-
-	return 0;
-}
-
 static int hot_remove_disk(mddev_t * mddev, dev_t dev)
 {
 	char b[BDEVNAME_SIZE];
@@ -2269,9 +2226,6 @@ static int hot_remove_disk(mddev_t * mdd
 	if (!mddev->pers)
 		return -ENODEV;
 
-	printk(KERN_INFO "md: trying to remove %s from %s ... \n",
-		__bdevname(dev, b), mdname(mddev));
-
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return -ENXIO;
@@ -2299,9 +2253,6 @@ static int hot_add_disk(mddev_t * mddev,
 	if (!mddev->pers)
 		return -ENODEV;
 
-	printk(KERN_INFO "md: trying to hot-add %s to %s ... \n",
-		__bdevname(dev, b), mdname(mddev));
-
 	if (mddev->major_version != 0) {
 		printk(KERN_WARNING "%s: HOT_ADD may only be used with"
 			" version-0 superblocks.\n",
@@ -2561,7 +2512,6 @@ static int set_disk_faulty(mddev_t *mdde
 static int md_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
-	char b[BDEVNAME_SIZE];
 	int err = 0;
 	void __user *argp = (void __user *)arg;
 	struct hd_geometry __user *loc = argp;
@@ -2620,8 +2570,7 @@ static int md_ioctl(struct inode *inode,
 		}
 		err = autostart_array(new_decode_dev(arg));
 		if (err) {
-			printk(KERN_WARNING "md: autostart %s failed!\n",
-				__bdevname(arg, b));
+			printk(KERN_WARNING "md: autostart failed!\n");
 			goto abort;
 		}
 		goto done;
@@ -2762,9 +2711,7 @@ static int md_ioctl(struct inode *inode,
 				err = add_new_disk(mddev, &info);
 			goto done_unlock;
 		}
-		case HOT_GENERATE_ERROR:
-			err = hot_generate_error(mddev, new_decode_dev(arg));
-			goto done_unlock;
+
 		case HOT_REMOVE_DISK:
 			err = hot_remove_disk(mddev, new_decode_dev(arg));
 			goto done_unlock;
@@ -3780,7 +3727,6 @@ void md_autodetect_dev(dev_t dev)
 
 static void autostart_arrays(int part)
 {
-	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 	int i;
 
@@ -3790,11 +3736,9 @@ static void autostart_arrays(int part)
 		dev_t dev = detected_devices[i];
 
 		rdev = md_import_device(dev,0, 0);
-		if (IS_ERR(rdev)) {
-			printk(KERN_ALERT "md: could not import %s!\n",
-				__bdevname(dev, b));
+		if (IS_ERR(rdev))
 			continue;
-		}
+
 		if (rdev->faulty) {
 			MD_BUG();
 			continue;
