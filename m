From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 13 of 22 - First step to tidying mddev recounting and locking.
Date: Wed, 19 Jun 2002 10:52:56 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54760.78699.569348@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



First step to tidying mddev recounting and locking.

This patches introduces
  mddev_get   which incs the refcount on an mddev
  mddev_put   which decs it and, if it becomes unused, frees it
  mddev_find  which finds or allocated an mddev for a given minor
              This is mostly the old alloc_mddev


free_mddev no longer actually frees it.  It just disconnects all drives
so that mddev_put will do the free.

Now the test for "does an mddev exist" is not "mddev != NULL"
but involves checking if the mddev has disks or a superblock
attached.

This makes the semantics of do_md_stop a bit cleaner.  Previously
if do_md_stop succeed for a real stop (not a read-only stop) then
you didn't have to unlock the mddev, otherwise you did.  Now
you always unlock the mddev after do_md_stop.


 ----------- Diffstat output ------------
 ./drivers/md/md.c |  125 +++++++++++++++++++++++++++---------------------------
 1 files changed, 63 insertions(+), 62 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:37:53	1.12
+++ ./drivers/md/md.c	2002/06/18 04:40:56	1.13
@@ -145,13 +145,30 @@
 	return 0;
 }
 
-static mddev_t * alloc_mddev(kdev_t dev)
+static inline mddev_t *mddev_get(mddev_t *mddev)
+{
+	atomic_inc(&mddev->active);
+	return mddev;
+}
+
+static void mddev_put(mddev_t *mddev)
+{
+	if (!atomic_dec_and_test(&mddev->active))
+		return;
+	if (!mddev->sb && list_empty(&mddev->disks)) {
+		list_del(&mddev->all_mddevs);
+		mddev_map[mdidx(mddev)] = NULL;
+		kfree(mddev);
+		MOD_DEC_USE_COUNT;
+	}
+}
+
+static mddev_t * mddev_find(int unit)
 {
 	mddev_t *mddev;
 
-	if (major(dev) != MD_MAJOR) {
-		MD_BUG();
-		return 0;
+	if ((mddev = mddev_map[unit])) {
+		return mddev_get(mddev);
 	}
 	mddev = (mddev_t *) kmalloc(sizeof(*mddev), GFP_KERNEL);
 	if (!mddev)
@@ -159,15 +176,15 @@
 
 	memset(mddev, 0, sizeof(*mddev));
 
-	mddev->__minor = minor(dev);
+	mddev->__minor = unit;
 	init_MUTEX(&mddev->reconfig_sem);
 	init_MUTEX(&mddev->recovery_sem);
 	init_MUTEX(&mddev->resync_sem);
 	INIT_LIST_HEAD(&mddev->disks);
 	INIT_LIST_HEAD(&mddev->all_mddevs);
-	atomic_set(&mddev->active, 0);
+	atomic_set(&mddev->active, 1);
 
-	mddev_map[mdidx(mddev)] = mddev;
+	mddev_map[unit] = mddev;
 	list_add(&mddev->all_mddevs, &all_mddevs);
 
 	MOD_INC_USE_COUNT;
@@ -631,11 +648,6 @@
 		schedule();
 	while (atomic_read(&mddev->recovery_sem.count) != 1)
 		schedule();
-
- 	mddev_map[mdidx(mddev)] = NULL;
-	list_del(&mddev->all_mddevs);
-	kfree(mddev);
-	MOD_DEC_USE_COUNT;
 }
 
 #undef BAD_CSUM
@@ -1803,8 +1815,6 @@
 	struct list_head *tmp;
 	mdk_rdev_t *rdev0, *rdev;
 	mddev_t *mddev;
-	kdev_t md_kdev;
-
 
 	printk(KERN_INFO "md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
@@ -1831,28 +1841,31 @@
 		 * mostly sane superblocks. It's time to allocate the
 		 * mddev.
 		 */
-		md_kdev = mk_kdev(MD_MAJOR, rdev0->sb->md_minor);
-		mddev = kdev_to_mddev(md_kdev);
-		if (mddev) {
+
+		mddev = mddev_find(rdev0->sb->md_minor);
+		if (!mddev) {
+			printk(KERN_ERR "md: cannot allocate memory for md drive.\n");
+			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
+				export_rdev(rdev);
+			break;
+		}
+		if (mddev->sb || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING "md: md%d already running, cannot run %s\n",
 			       mdidx(mddev), partition_name(rdev0->dev));
 			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
 				export_rdev(rdev);
+			mddev_put(mddev);
 			continue;
 		}
-		mddev = alloc_mddev(md_kdev);
-		if (!mddev) {
-			printk(KERN_ERR "md: cannot allocate memory for md drive.\n");
-			break;
-		}
-		if (kdev_same(md_kdev, countdev))
-			atomic_inc(&mddev->active);
 		printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
 		ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp) {
 			bind_rdev_to_array(rdev, mddev);
 			list_del_init(&rdev->pending);
 		}
 		autorun_array(mddev);
+		if (minor(countdev) != mdidx(mddev))
+		    mddev_put(mddev);
+		/* else put will happen at md_close time */
 	}
 	printk(KERN_INFO "md: ... autorun DONE.\n");
 }
@@ -2486,29 +2499,16 @@
 	 * Commands creating/starting a new array:
 	 */
 
-	mddev = kdev_to_mddev(dev);
+	mddev = mddev_find(minor);
 
-	switch (cmd)
-	{
-		case SET_ARRAY_INFO:
-		case START_ARRAY:
-			if (mddev) {
-				printk(KERN_WARNING "md: array md%d already exists!\n",
-								mdidx(mddev));
-				err = -EEXIST;
-				goto abort;
-			}
-		default:;
+	if (!mddev) {
+		err = -ENOMEM;
+		goto abort;
 	}
+
 	switch (cmd)
 	{
 		case SET_ARRAY_INFO:
-			mddev = alloc_mddev(dev);
-			if (!mddev) {
-				err = -ENOMEM;
-				goto abort;
-			}
-			atomic_inc(&mddev->active);
 
 			/*
 			 * alloc_mddev() should possibly self-lock.
@@ -2519,7 +2519,12 @@
 				       err, cmd);
 				goto abort;
 			}
-
+			if (!list_empty(&mddev->disks)) {
+				printk(KERN_WARNING "md: array md%d already has disks!\n",
+					mdidx(mddev));
+				err = -EBUSY;
+				goto abort_unlock;
+			}
 			if (mddev->sb) {
 				printk(KERN_WARNING "md: array md%d already has a superblock!\n",
 					mdidx(mddev));
@@ -2559,10 +2564,6 @@
 	 * Commands querying/configuring an existing array:
 	 */
 
-	if (!mddev) {
-		err = -ENODEV;
-		goto abort;
-	}
 	err = lock_mddev(mddev);
 	if (err) {
 		printk(KERN_INFO "md: ioctl lock interrupted, reason %d, cmd %d\n",err, cmd);
@@ -2592,8 +2593,7 @@
 			goto done_unlock;
 
 		case STOP_ARRAY:
-			if (!(err = do_md_stop (mddev, 0)))
-				mddev = NULL;
+			err = do_md_stop (mddev, 0);
 			goto done_unlock;
 
 		case STOP_ARRAY_RO:
@@ -2672,8 +2672,7 @@
 			 */
 			if (err) {
 				mddev->sb_dirty = 0;
-				if (!do_md_stop (mddev, 0))
-					mddev = NULL;
+				do_md_stop (mddev, 0);
 			}
 			goto done_unlock;
 		}
@@ -2688,8 +2687,8 @@
 
 done_unlock:
 abort_unlock:
-	if (mddev)
-		unlock_mddev(mddev);
+	unlock_mddev(mddev);
+	mddev_put(mddev);
 
 	return err;
 done:
@@ -2706,7 +2705,7 @@
 	 */
 	mddev_t *mddev = kdev_to_mddev(inode->i_rdev);
 	if (mddev)
-		atomic_inc(&mddev->active);
+		mddev_get(mddev);
 	return (0);
 }
 
@@ -2714,7 +2713,7 @@
 {
 	mddev_t *mddev = kdev_to_mddev(inode->i_rdev);
 	if (mddev)
-		atomic_dec(&mddev->active);
+		mddev_put(mddev);
 	return 0;
 }
 
@@ -3688,19 +3687,20 @@
 		if (!md_setup_args.device_set[minor])
 			continue;
 
-		if (mddev_map[minor]) {
-			printk(KERN_WARNING
-			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
-			       minor);
-			continue;
-		}
 		printk(KERN_INFO "md: Loading md%d: %s\n", minor, md_setup_args.device_names[minor]);
 
-		mddev = alloc_mddev(mk_kdev(MD_MAJOR,minor));
+		mddev = mddev_find(minor);
 		if (!mddev) {
 			printk(KERN_ERR "md: kmalloc failed - cannot start array %d\n", minor);
 			continue;
 		}
+		if (mddev->sb || !list_empty(&mddev->disks)) {
+			printk(KERN_WARNING
+			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
+			       minor);
+			mddev_put(mddev);
+			continue;
+		}
 		if (md_setup_args.pers[minor]) {
 			/* non-persistent */
 			mdu_array_info_t ainfo;
@@ -3752,6 +3752,7 @@
 			do_md_stop(mddev, 0);
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
 		}
+		mddev_put(mddev);
 	}
 }
 
