From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 17 of 22 - Strengthen the locking of mddev.
Date: Wed, 19 Jun 2002 10:54:01 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54825.764468.367044@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Strengthen the locking of mddev.

mddev is only ever locked in md.c, so we move {,un}lock_mddev
out of the header and into md.c, and rename to mddev_{,un}lock
for consistancy with mddev_{get,put,find}.

When building arrays (typically at boot time) we now lock, and unlock
as it is the "right" thing to do.  The lock should never fail.

When generating /proc/mdstat, we lock each array before inspecting it.

In md_ioctl, we lock the mddev early and unlock at the end, rather than
locking in two different places.

In md_open we make sure we can get a lock before completing the open.  This 
ensures that we sync with do_md_stop properly.

In md_do_recovery, we lock each mddev before checking it's status. 

md_do_recovery must unlock while recovery happens, and a do_md_stop at this
point will deadlock when md_do_recovery tries to regain the lock.  This will be
fixed in a later patch.


 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  141 +++++++++++++++++++++++++++-----------------
 ./include/linux/raid/md_k.h |   10 ---
 2 files changed, 89 insertions(+), 62 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:56:12	1.16
+++ ./drivers/md/md.c	2002/06/18 05:08:46	1.17
@@ -185,6 +185,21 @@
 	return mddev;
 }
 
+static inline int mddev_lock(mddev_t * mddev)
+{
+	return down_interruptible(&mddev->reconfig_sem);
+}
+
+static inline int mddev_trylock(mddev_t * mddev)
+{
+	return down_trylock(&mddev->reconfig_sem);
+}
+
+static inline void mddev_unlock(mddev_t * mddev)
+{
+	up(&mddev->reconfig_sem);
+}
+
 mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
 {
 	mdk_rdev_t * rdev;
@@ -1838,24 +1853,29 @@
 		mddev = mddev_find(rdev0->sb->md_minor);
 		if (!mddev) {
 			printk(KERN_ERR "md: cannot allocate memory for md drive.\n");
-			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
-				export_rdev(rdev);
 			break;
 		}
-		if (mddev->sb || !list_empty(&mddev->disks)) {
+		if (mddev_lock(mddev)) 
+			printk(KERN_WARNING "md: md%d locked, cannot run\n",
+			       mdidx(mddev));
+		else if (mddev->sb || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING "md: md%d already running, cannot run %s\n",
 			       mdidx(mddev), partition_name(rdev0->dev));
-			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
-				export_rdev(rdev);
-			mddev_put(mddev);
-			continue;
-		}
-		printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
-		ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp) {
-			bind_rdev_to_array(rdev, mddev);
-			list_del_init(&rdev->pending);
+			mddev_unlock(mddev);
+		} else {
+			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
+			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp) {
+				bind_rdev_to_array(rdev, mddev);
+				list_del_init(&rdev->pending);
+			}
+			autorun_array(mddev);
+			mddev_unlock(mddev);
 		}
-		autorun_array(mddev);
+		/* on success, candidates will be empty, on error
+		 * it wont...
+		 */
+		ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
+			export_rdev(rdev);
 		mddev_put(mddev);
 	}
 	printk(KERN_INFO "md: ... autorun DONE.\n");
@@ -2453,7 +2473,7 @@
 		case PRINT_RAID_DEBUG:
 			err = 0;
 			md_print_devices();
-			goto done_unlock;
+			goto done;
 
 #ifndef MODULE
 		case RAID_AUTORUN:
@@ -2497,19 +2517,17 @@
 		goto abort;
 	}
 
+	err = mddev_lock(mddev);
+	if (err) {
+		printk(KERN_INFO "md: ioctl lock interrupted, reason %d, cmd %d\n",
+		       err, cmd);
+		goto abort;
+	}
+
 	switch (cmd)
 	{
 		case SET_ARRAY_INFO:
 
-			/*
-			 * alloc_mddev() should possibly self-lock.
-			 */
-			err = lock_mddev(mddev);
-			if (err) {
-				printk(KERN_WARNING "md: ioctl, reason %d, cmd %d\n",
-				       err, cmd);
-				goto abort;
-			}
 			if (!list_empty(&mddev->disks)) {
 				printk(KERN_WARNING "md: array md%d already has disks!\n",
 					mdidx(mddev));
@@ -2544,9 +2562,9 @@
 			if (err) {
 				printk(KERN_WARNING "md: autostart %s failed!\n",
 					partition_name(val_to_kdev(arg)));
-				goto abort;
+				goto abort_unlock;
 			}
-			goto done;
+			goto done_unlock;
 
 		default:;
 	}
@@ -2554,12 +2572,6 @@
 	/*
 	 * Commands querying/configuring an existing array:
 	 */
-
-	err = lock_mddev(mddev);
-	if (err) {
-		printk(KERN_INFO "md: ioctl lock interrupted, reason %d, cmd %d\n",err, cmd);
-		goto abort;
-	}
 	/* if we don't have a superblock yet, only ADD_NEW_DISK or STOP_ARRAY is allowed */
 	if (!mddev->sb && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY && cmd != RUN_ARRAY) {
 		err = -ENODEV;
@@ -2678,7 +2690,7 @@
 
 done_unlock:
 abort_unlock:
-	unlock_mddev(mddev);
+	mddev_unlock(mddev);
 
 	return err;
 done:
@@ -2694,12 +2706,21 @@
 	 * Succeed if we can find or allocate a mddev structure.
 	 */
 	mddev_t *mddev = mddev_find(minor(inode->i_rdev));
+	int err = -ENOMEM;
 
-	if (mddev) {
-		inode->i_bdev->bd_inode->u.generic_ip = mddev;
-		return 0; /* and we "own" a reference */
-	} else
-		return -ENOMEM;
+	if (!mddev)
+		goto out;
+
+	if ((err = mddev_lock(mddev)))
+		goto put;
+
+	err = 0;
+	mddev_unlock(mddev);
+	inode->i_bdev->bd_inode->u.generic_ip = mddev_get(mddev);
+ put:
+	mddev_put(mddev);
+ out:
+	return err;
 }
 
 static int md_release(struct inode *inode, struct file * file)
@@ -2987,7 +3008,7 @@
 
 	sz += sprintf(page+sz, "\n");
 
-	ITERATE_MDDEV(mddev,tmp) {
+	ITERATE_MDDEV(mddev,tmp) if (mddev_lock(mddev)==0) {
 		sz += sprintf(page + sz, "md%d : %sactive", mdidx(mddev),
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
@@ -3017,6 +3038,7 @@
 
 		if (!mddev->pers) {
 			sz += sprintf(page+sz, "\n");
+			mddev_unlock(mddev);
 			continue;
 		}
 
@@ -3030,6 +3052,7 @@
 				sz += sprintf(page + sz, "	resync=DELAYED");
 		}
 		sz += sprintf(page + sz, "\n");
+		mddev_unlock(mddev);
 	}
 	sz += status_unused(page + sz);
 
@@ -3306,36 +3329,38 @@
 	mdp_disk_t *spare;
 	struct list_head *tmp;
 
-	printk(KERN_INFO "md: recovery thread got woken up ...\n");
-restart:
-	ITERATE_MDDEV(mddev,tmp) {
+	dprintk(KERN_INFO "md: recovery thread got woken up ...\n");
+
+	ITERATE_MDDEV(mddev,tmp) if (mddev_lock(mddev)==0) {
 		sb = mddev->sb;
 		if (!sb)
-			continue;
+			goto unlock;
 		if (mddev->recovery_running)
-			continue;
+			goto unlock;
 		if (sb->active_disks == sb->raid_disks)
-			continue;
+			goto unlock;
 		if (!sb->spare_disks) {
 			printk(KERN_ERR "md%d: no spare disk to reconstruct array! "
 			       "-- continuing in degraded mode\n", mdidx(mddev));
-			continue;
+			goto unlock;
 		}
 		/*
 		 * now here we get the spare and resync it.
 		 */
 		spare = get_spare(mddev);
 		if (!spare)
-			continue;
+			goto unlock;
 		printk(KERN_INFO "md%d: resyncing spare disk %s to replace failed disk\n",
 		       mdidx(mddev), partition_name(mk_kdev(spare->major,spare->minor)));
 		if (!mddev->pers->diskop)
-			continue;
+			goto unlock;
 		if (mddev->pers->diskop(mddev, &spare, DISKOP_SPARE_WRITE))
-			continue;
+			goto unlock;
 		down(&mddev->recovery_sem);
 		mddev->recovery_running = 1;
+		mddev_unlock(mddev);
 		err = md_do_sync(mddev, spare);
+		mddev_lock(mddev); /* FIXME this can fail or deadlock with do_md_close */
 		if (err == -EIO) {
 			printk(KERN_INFO "md%d: spare disk %s failed, skipping to next spare.\n",
 			       mdidx(mddev), partition_name(mk_kdev(spare->major,spare->minor)));
@@ -3361,7 +3386,7 @@
 							 DISKOP_SPARE_INACTIVE);
 			up(&mddev->recovery_sem);
 			mddev->recovery_running = 0;
-			continue;
+			goto unlock;
 		} else {
 			mddev->recovery_running = 0;
 			up(&mddev->recovery_sem);
@@ -3379,9 +3404,10 @@
 		}
 		mddev->sb_dirty = 1;
 		md_update_sb(mddev);
-		goto restart;
+	unlock:
+		mddev_unlock(mddev);
 	}
-	printk(KERN_INFO "md: recovery thread finished ...\n");
+	dprintk(KERN_INFO "md: recovery thread finished ...\n");
 
 }
 
@@ -3397,7 +3423,8 @@
 		return NOTIFY_DONE;
 
 		ITERATE_MDDEV(mddev,tmp)
-			do_md_stop (mddev, 1);
+			if (mddev_trylock(mddev)==0)
+				do_md_stop (mddev, 1);
 		/*
 		 * certain more exotic SCSI devices are known to be
 		 * volatile wrt too early system reboots. While the
@@ -3693,10 +3720,19 @@
 			printk(KERN_ERR "md: kmalloc failed - cannot start array %d\n", minor);
 			continue;
 		}
+		if (mddev_lock(mddev)) {
+			printk(KERN_WARNING
+			       "md: Ignoring md=%d, cannot lock!\n",
+			       minor);
+			mddev_put(mddev);
+			continue;
+		}
+
 		if (mddev->sb || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING
 			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
 			       minor);
+			mddev_unlock(mddev);
 			mddev_put(mddev);
 			continue;
 		}
@@ -3751,6 +3787,7 @@
 			do_md_stop(mddev, 0);
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
 		}
+		mddev_unlock(mddev);
 		mddev_put(mddev);
 	}
 }
--- ./include/linux/raid/md_k.h	2002/06/18 04:37:53	1.6
+++ ./include/linux/raid/md_k.h	2002/06/18 05:08:46	1.7
@@ -283,16 +283,6 @@
 			tmp = tmp->next, tmp->prev != &all_mddevs	\
 		; )
 
-static inline int lock_mddev (mddev_t * mddev)
-{
-	return down_interruptible(&mddev->reconfig_sem);
-}
-
-static inline void unlock_mddev (mddev_t * mddev)
-{
-	up(&mddev->reconfig_sem);
-}
-
 #define xchg_values(x,y) do { __typeof__(x) __tmp = x; \
 				x = y; y = __tmp; } while (0)
 
