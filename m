From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Locking bugs in 2.4 md.c
Date: Fri, 19 Sep 2003 16:18:29 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030919141828.GP3143@marowsky-bree.de>
References: <20030918152310.GD30852@marowsky-bree.de> <16234.25885.855209.372799@notabene.cse.unsw.edu.au> <20030919072610.GB3143@marowsky-bree.de> <20030919083639.GE3143@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jousvV0MzM2p6OtC"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030919083639.GE3143@marowsky-bree.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2003-09-19T10:36:40,
   Lars Marowsky-Bree <lmb@suse.de> said:

OK. Some good news, some bad news.

The patch by Neil (my version of it is attached) does fix the bugs I
saw, if combined with my additional change to raid1.c to not output
empty slots (which is completely pointless to do, and I only added it to
reduce useless debugging output).

That this second change is required suggests that the timing is the
critical part. (I was logging to serial console, so this change changed
the timing immensely)

Alas, I can no longer reproduce the bug on an 8 way HT machine. I was
not fully able to figure out where it occured, but at least the attached
patch is a partial fix for the bug...


Sincerely,
    Lars Marowsky-Brée <lmb@suse.de>

-- 
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=md-locking

diff -x '*~' -x '*.rej' -x '*.orig' -x CVS -x '*.o' -x '.*' -ruN linux-2.4.21-SP3.orig/include/linux/raid/md_k.h linux-2.4.21-SP3.lmb/include/linux/raid/md_k.h
--- linux-2.4.21-SP3.orig/include/linux/raid/md_k.h	2003-09-18 12:07:48.000000000 +0200
+++ linux-2.4.21-SP3.lmb/include/linux/raid/md_k.h	2003-09-19 09:49:41.000000000 +0200
@@ -75,13 +75,6 @@
 
 extern dev_mapping_t mddev_map [MAX_MD_DEVS];
 
-static inline mddev_t * kdev_to_mddev (kdev_t dev)
-{
-	if (MAJOR(dev) != MD_MAJOR)
-		BUG();
-        return mddev_map[MINOR(dev)].mddev;
-}
-
 /*
  * options passed in raidrun:
  */
@@ -214,6 +210,7 @@
 	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
 	char				*name;
 	int				recovery_running;
+	int				dying;
 	struct semaphore		reconfig_sem;
 	struct semaphore		recovery_sem;
 	struct semaphore		resync_sem;
@@ -317,7 +314,20 @@
 			tmp = tmp->next, tmp->prev != &all_mddevs	\
 		; )
 
-static inline int lock_mddev (mddev_t * mddev)
+#define ITERATE_MDDEV_LOCK(mddev,tmp)					\
+									\
+	for (tmp = all_mddevs.next;					\
+		mddev = md_list_entry(tmp, mddev_t, all_mddevs),	\
+			tmp = tmp->next, tmp->prev != &all_mddevs 	\
+			 && (down(&mddev->reconfig_sem), 1)		\
+		; up(&mddev->reconfig_sem)) if (!mddev->dying)
+
+static inline void lock_mddev (mddev_t * mddev)
+{
+	return down(&mddev->reconfig_sem);
+}
+
+static inline int lock_mddev_interruptible (mddev_t * mddev)
 {
 	return down_interruptible(&mddev->reconfig_sem);
 }
diff -x '*~' -x '*.rej' -x '*.orig' -x CVS -x '*.o' -x '.*' -ruN linux-2.4.21-SP3.orig/drivers/md/md.c linux-2.4.21-SP3.lmb/drivers/md/md.c
--- linux-2.4.21-SP3.orig/drivers/md/md.c	2003-09-18 12:08:06.000000000 +0200
+++ linux-2.4.21-SP3.lmb/drivers/md/md.c	2003-09-19 10:16:05.000000000 +0200
@@ -34,6 +34,7 @@
 #include <linux/sysctl.h>
 #include <linux/raid/xor.h>
 #include <linux/devfs_fs_kernel.h>
+#include <linux/rwsem.h>
 
 #include <linux/init.h>
 
@@ -130,16 +131,69 @@
 
 /*
  * Enables to iterate over all existing md arrays
+ *
+ * Locking rules:
+ * - access to all_mddevs requires all_mddevs_sem.
+ * - an mddev can be locked while all_mddevs_sem is held.
+ * - When removing an mddev, we
+ *     lock the mddev
+ *     check that ->active is 1 (us).
+ *     set "dying"
+ *     unlock the mddev
+ *     claim all_mddevs_sem
+ *     actually remove device
+ *     release all_mddevs_sem
+ * - to get a reference to an mddev, we
+ *     claim all_mddevs_sem
+ *     find the mddev in the list
+ *     check that it isn't "dying"
+ *     increase ->active or take a lock
  */
 static MD_LIST_HEAD(all_mddevs);
+static DECLARE_RWSEM(all_mddevs_sem);
 
 /*
- * The mapping between kdev and mddev is not necessary a simple
+ * The mapping between kdev and mddev is not necessarily a simple
  * one! Eg. HSM uses several sub-devices to implement Logical
  * Volumes. All these sub-devices map to the same mddev.
  */
 dev_mapping_t mddev_map[MAX_MD_DEVS];
 
+
+static inline mddev_t * kdev_to_mddev (kdev_t dev)
+{
+	mddev_t *mddev;
+	if (MAJOR(dev) != MD_MAJOR)
+		BUG();
+	down_read(&all_mddevs_sem);
+        mddev = mddev_map[MINOR(dev)].mddev;
+	if (mddev &&  !mddev->dying)
+		atomic_inc(&mddev->active);
+	else
+		mddev = NULL;
+	up_read(&all_mddevs_sem);
+	return mddev;
+}
+
+static inline mddev_t * kdev_to_mddev_lock_interruptible (kdev_t dev, int *err)
+{
+	mddev_t *mddev;
+	if (MAJOR(dev) != MD_MAJOR)
+		BUG();
+	down_read(&all_mddevs_sem);
+        mddev = mddev_map[MINOR(dev)].mddev;
+	*err = 0;
+	if (mddev) {
+		if (mddev->dying) {
+			*err = -EBUSY;
+			mddev = NULL;
+		} else
+			*err = lock_mddev_interruptible(mddev);
+	}
+	up_read(&all_mddevs_sem);
+	return mddev;
+}
+
 void add_mddev_mapping(mddev_t * mddev, kdev_t dev, void *data)
 {
 	unsigned int minor = MINOR(dev);
@@ -175,13 +229,19 @@
 static int md_make_request(request_queue_t *q, int rw, struct buffer_head * bh)
 {
 	mddev_t *mddev = kdev_to_mddev(bh->b_rdev);
+	int rv;
 
 	if (mddev && mddev->pers)
-		return mddev->pers->make_request(mddev, rw, bh);
+		rv =  mddev->pers->make_request(mddev, rw, bh);
 	else {
 		buffer_IO_error(bh);
-		return 0;
+		rv = 0;
 	}
+	if (mddev)
+		/* should really drop count when request completes... */
+		if (atomic_dec_and_test(&mddev->active))
+			BUG();
+	return rv;
 }
 
 static mddev_t * alloc_mddev(kdev_t dev)
@@ -199,20 +259,22 @@
 	memset(mddev, 0, sizeof(*mddev));
 
 	mddev->__minor = MINOR(dev);
-	init_MUTEX(&mddev->reconfig_sem);
+	init_MUTEX_LOCKED(&mddev->reconfig_sem);
 	init_MUTEX(&mddev->recovery_sem);
 	init_MUTEX(&mddev->resync_sem);
 	MD_INIT_LIST_HEAD(&mddev->disks);
 	MD_INIT_LIST_HEAD(&mddev->all_mddevs);
-	atomic_set(&mddev->active, 0);
+	atomic_set(&mddev->active, 1);
 
 	/*
 	 * The 'base' mddev is the one with data NULL.
 	 * personalities can create additional mddevs
 	 * if necessary.
 	 */
+	down_write(&all_mddevs_sem);
 	add_mddev_mapping(mddev, dev, 0);
 	md_list_add(&mddev->all_mddevs, &all_mddevs);
+	up_write(&all_mddevs_sem);
 
 	MOD_INC_USE_COUNT;
 
@@ -745,18 +807,10 @@
 	md_size[mdidx(mddev)] = 0;
 	md_hd_struct[mdidx(mddev)].nr_sects = 0;
 
-	/*
-	 * Make sure nobody else is using this mddev
-	 * (careful, we rely on the global kernel lock here)
-	 */
-	while (sem_getcount(&mddev->resync_sem) != 1)
-		schedule();
-	while (sem_getcount(&mddev->recovery_sem) != 1)
-		schedule();
-
+	down_write(&all_mddevs_sem);
 	del_mddev_mapping(mddev, MKDEV(MD_MAJOR, mdidx(mddev)));
 	md_list_del(&mddev->all_mddevs);
-	MD_INIT_LIST_HEAD(&mddev->all_mddevs);
+	up_write(&all_mddevs_sem);
 	kfree(mddev);
 	MOD_DEC_USE_COUNT;
 }
@@ -827,7 +881,10 @@
 	printk("md:	**********************************\n");
 	printk("md:	* <COMPLETE RAID STATE PRINTOUT> *\n");
 	printk("md:	**********************************\n");
-	ITERATE_MDDEV(mddev,tmp) {
+
+	down_read(&all_mddevs_sem);
+	/* XXX Review whether locking is needed for the mddev here or not */
+	ITERATE_MDDEV_LOCK(mddev,tmp) {
 		printk("md%d: ", mdidx(mddev));
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
@@ -842,6 +899,7 @@
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			print_rdev(rdev);
 	}
+	up_read(&all_mddevs_sem);
 	printk("md:	**********************************\n");
 	printk("\n");
 }
@@ -922,10 +980,6 @@
 		MD_BUG();
 		return 1;
 	}
-	if (rdev->faulty) {
-		MD_BUG();
-		return 1;
-	}
 	if (rdev->sb->md_magic != MD_SB_MAGIC) {
 		MD_BUG();
 		return 1;
@@ -1011,6 +1065,11 @@
 	struct md_list_head *tmp;
 	mdk_rdev_t *rdev;
 
+	if (!mddev->dying && !down_trylock(&mddev->reconfig_sem)) {
+		up(&mddev->reconfig_sem);
+		BUG();
+	}
+		
 	if (!mddev->sb_dirty) {
 		printk("hm, md_update_sb() called without ->sb_dirty == 1, from %p.\n", __builtin_return_address(0));
 		return 0;
@@ -1047,8 +1106,13 @@
 		printk(KERN_INFO "md: %s ", 
 				partition_name(rdev->dev));
 		
-		if (rdev->faulty) {
+		if (!rdev) {
+			MD_BUG();
+			printk("(rdev == NULL)\n");
+		} else if (rdev->faulty) {
 			printk("(skipping faulty)\n");
+		} else if (!rdev->sb) {
+			printk("(rdev->sb == NULL)\n");
 		} else if (rdev_is_alias(rdev)) {
 			printk("(skipping alias)\n");
 		} else if (disk_faulty(&rdev->sb->this_disk)) {
@@ -1815,6 +1879,9 @@
 		if (mddev->recovery_running)
 			md_interrupt_thread(md_recovery_thread);
 
+		mddev->dying = 1; /* make sure nobody tries to use this */
+		unlock_mddev(mddev);
+
 		/*
 		 * This synchronizes with signal delivery to the
 		 * resync or reconstruction thread. It also nicely
@@ -1836,6 +1903,7 @@
 			if (mddev->pers->stop(mddev)) {
 				if (mddev->ro)
 					set_device_ro(dev, 1);
+				mddev->dying = 0;
 				OUT(-EBUSY);
 			}
 			if (mddev->ro)
@@ -1853,8 +1921,11 @@
 			mddev->sb_dirty = 1;
 			md_update_sb(mddev);
 		}
-		if (ro)
+		if (ro) {
 			set_device_ro(dev, 1);
+			lock_mddev(mddev);
+			mddev->dying = 0;
+		}
 	}
 
 	/*
@@ -1886,7 +1957,7 @@
 }
 
 
-static void autorun_array(mddev_t *mddev)
+static int autorun_array(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
 	struct md_list_head *tmp;
@@ -1894,7 +1965,7 @@
 
 	if (mddev->disks.prev == &mddev->disks) {
 		MD_BUG();
-		return;
+		goto out_unlock;
 	}
 
 	printk(KERN_INFO "md: running: ");
@@ -1912,6 +1983,7 @@
 		 */
 		mddev->sb_dirty = 0;
 		do_md_stop (mddev, 0);
+		return err;
 	} else {
 		/* Create an rdev for the freshly started md device
 		 * and add to the end of the list */
@@ -1924,17 +1996,21 @@
 			 * imported the device! */
 			if (!rdev) {
 				MD_BUG();
-				return;
+				goto out_unlock;
 			}
 			if (rdev->faulty) {
 				MD_BUG();
-				return;
+				goto out_unlock;
 			}
 			printk("md: added md%d to the autodetection\n",
 				mdidx(mddev));
 			md_list_add(&rdev->pending, pending_raid_disks.prev);
 		}
 	}
+
+out_unlock:
+ 	unlock_mddev(mddev);
+ 	return 0;
 }
 
 /*
@@ -1990,6 +2066,7 @@
 			       mdidx(mddev), partition_name(rdev0->dev));
 			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
 				export_rdev(rdev);
+			atomic_dec(&mddev->active);
 			continue;
 		}
 		mddev = alloc_mddev(md_kdev);
@@ -1997,15 +2074,15 @@
 			printk(KERN_ERR "md: cannot allocate memory for md drive.\n");
 			break;
 		}
-		if (md_kdev == countdev)
-			atomic_inc(&mddev->active);
 		printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
 		ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp) {
 			bind_rdev_to_array(rdev, mddev);
 			md_list_del(&rdev->pending);
 			MD_INIT_LIST_HEAD(&rdev->pending);
 		}
-		autorun_array(mddev);
+		if (autorun_array(mddev)== 0
+		    && md_kdev != countdev)
+			atomic_dec(&mddev->active);
 	}
 	printk(KERN_INFO "md: ... autorun DONE.\n");
 }
@@ -2697,7 +2774,9 @@
 	 * Commands creating/starting a new array:
 	 */
 
-	mddev = kdev_to_mddev(dev);
+	mddev = kdev_to_mddev_lock_interruptible(dev, &err);
+	if (mddev == NULL && err)
+		goto abort;
 
 	switch (cmd)
 	{
@@ -2707,7 +2786,7 @@
 				printk(KERN_WARNING "md: array md%d already exists!\n",
 								mdidx(mddev));
 				err = -EEXIST;
-				goto abort;
+				goto abort_unlock;
 			}
 		default:;
 	}
@@ -2719,17 +2798,6 @@
 				err = -ENOMEM;
 				goto abort;
 			}
-			atomic_inc(&mddev->active);
-
-			/*
-			 * alloc_mddev() should possibly self-lock.
-			 */
-			err = lock_mddev(mddev);
-			if (err) {
-				printk(KERN_WARNING "md: ioctl, reason %d, cmd %d\n",
-				       err, cmd);
-				goto abort;
-			}
 
 			if (mddev->sb) {
 				printk(KERN_WARNING "md: array md%d already has a superblock!\n",
@@ -2752,14 +2820,11 @@
 			goto done_unlock;
 
 		case START_ARRAY:
-			/*
-			 * possibly make it lock the array ...
-			 */
 			err = autostart_array((kdev_t)arg, dev);
 			if (err) {
 				printk(KERN_WARNING "md: autostart %s failed!\n",
 					partition_name((kdev_t)arg));
-				goto abort;
+				goto abort_unlock;
 			}
 			goto done;
 
@@ -2774,11 +2839,7 @@
 		err = -ENODEV;
 		goto abort;
 	}
-	err = lock_mddev(mddev);
-	if (err) {
-		printk(KERN_INFO "md: ioctl lock interrupted, reason %d, cmd %d\n",err, cmd);
-		goto abort;
-	}
+
 	/* if we don't have a superblock yet, only ADD_NEW_DISK or STOP_ARRAY is allowed */
 	if (!mddev->sb && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY && cmd != RUN_ARRAY) {
 		err = -ENODEV;
@@ -2948,17 +3009,17 @@
 	/*
 	 * Always succeed, but increment the usage count
 	 */
-	mddev_t *mddev = kdev_to_mddev(inode->i_rdev);
-	if (mddev)
-		atomic_inc(&mddev->active);
+	kdev_to_mddev(inode->i_rdev);
 	return (0);
 }
 
 static int md_release(struct inode *inode, struct file * file)
 {
 	mddev_t *mddev = kdev_to_mddev(inode->i_rdev);
-	if (mddev)
+	if (mddev) {
 		atomic_dec(&mddev->active);
+		atomic_dec(&mddev->active);
+	}
 	return 0;
 }
 
@@ -3239,7 +3300,8 @@
 {
 	struct list_head *tmp;
 	mddev_t *next_mddev, *mddev = v;
-	
+
+	down_read(&all_mddevs_sem);
 	++*pos;
 	if (v == (void*)2)
 		return NULL;
@@ -3261,7 +3323,7 @@
 
 static void md_seq_stop(struct seq_file *seq, void *v)
 {
-
+	up_read(&all_mddevs_sem);
 }
 
 static int md_seq_show(struct seq_file *seq, void *v)
@@ -3289,6 +3351,8 @@
 		status_unused(seq);
 		return 0;
 	}
+	if (mddev->dying)
+		return 0;
 
 	seq_printf(seq, "md%d : %sactive", mdidx(mddev),
 		   mddev->pers ? "" : "in");
@@ -3489,6 +3553,7 @@
 
 recheck:
 	serialize = 0;
+	down_read(&all_mddevs_sem);
 	ITERATE_MDDEV(mddev2,tmp) {
 		if (mddev2 == mddev)
 			continue;
@@ -3500,6 +3565,7 @@
 			break;
 		}
 	}
+	up_read(&all_mddevs_sem);
 	if (serialize) {
 		interruptible_sleep_on(&resync_wait);
 		if (md_signal_pending(current)) {
@@ -3638,8 +3704,10 @@
 	struct md_list_head *tmp;
 
 	printk(KERN_INFO "md: recovery thread got woken up ...\n");
-restart:
-	ITERATE_MDDEV(mddev,tmp) {
+
+ restart:
+	down_read(&all_mddevs_sem);
+	ITERATE_MDDEV_LOCK(mddev,tmp) {
 		sb = mddev->sb;
 		if (!sb)
 			continue;
@@ -3668,9 +3736,13 @@
 			continue;
 		if (mddev->pers->diskop(mddev, &spare, DISKOP_SPARE_WRITE))
 			continue;
+		unlock_mddev(mddev);
+		up_read(&all_mddevs_sem);
 		down(&mddev->recovery_sem);
 		mddev->recovery_running = 1;
 		err = md_do_sync(mddev, spare);
+
+		lock_mddev(mddev);
 		if (err == -EIO) {
 			printk(KERN_INFO "md%d: spare disk %s failed, skipping to next spare.\n",
 			       mdidx(mddev), partition_name(MKDEV(spare->major,spare->minor)));
@@ -3696,26 +3768,28 @@
 							 DISKOP_SPARE_INACTIVE);
 			up(&mddev->recovery_sem);
 			mddev->recovery_running = 0;
-			continue;
 		} else {
 			mddev->recovery_running = 0;
 			up(&mddev->recovery_sem);
+
+			if (!disk_faulty(spare)) {
+				/*
+				 * the SPARE_ACTIVE diskop possibly changes the
+				 * pointer too
+				 */
+				mddev->pers->diskop(mddev, &spare, DISKOP_SPARE_ACTIVE);
+				mark_disk_sync(spare);
+				mark_disk_active(spare);
+				sb->active_disks++;
+				sb->spare_disks--;
+			}
+			mddev->sb_dirty = 1;
+			md_update_sb(mddev);
 		}
-		if (!disk_faulty(spare)) {
-			/*
-			 * the SPARE_ACTIVE diskop possibly changes the
-			 * pointer too
-			 */
-			mddev->pers->diskop(mddev, &spare, DISKOP_SPARE_ACTIVE);
-			mark_disk_sync(spare);
-			mark_disk_active(spare);
-			sb->active_disks++;
-			sb->spare_disks--;
-		}
-		mddev->sb_dirty = 1;
-		md_update_sb(mddev);
+		unlock_mddev(mddev);
 		goto restart;
 	}
+	up_read(&all_mddevs_sem);
 	printk(KERN_INFO "md: recovery thread finished ...\n");
 
 }
@@ -3731,7 +3805,7 @@
 
 		printk(KERN_INFO "md: stopping all md devices.\n");
 
-		ITERATE_MDDEV(mddev,tmp)
+		ITERATE_MDDEV_LOCK(mddev,tmp)
 			do_md_stop (mddev, 1);
 		/*
 		 * certain more exotic SCSI devices are known to be
@@ -4075,6 +4149,9 @@
 			mddev->sb_dirty = 0;
 			do_md_stop(mddev, 0);
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
+		} else {
+			unlock_mddev(mddev);
+			atomic_dec(&mddev->active);
 		}
 	}
 }
diff -x '*~' -x '*.rej' -x '*.orig' -x CVS -x '*.o' -x '.*' -ruN linux-2.4.21-SP3.orig/drivers/md/multipath.c linux-2.4.21-SP3.lmb/drivers/md/multipath.c
--- linux-2.4.21-SP3.orig/drivers/md/multipath.c	2003-09-18 12:07:48.000000000 +0200
+++ linux-2.4.21-SP3.lmb/drivers/md/multipath.c	2003-09-19 09:49:41.000000000 +0200
@@ -971,8 +971,12 @@
 		md_spin_unlock_irqrestore(&retry_list_lock, flags);
 
 		mddev = mp_bh->mddev;
-		if (mddev->sb_dirty)
-			md_update_sb(mddev);
+		if (mddev->sb_dirty) {
+			lock_mddev(mddev);
+			if (mddev->sb_dirty)
+				md_update_sb(mddev);
+			unlock_mddev(mddev);
+		}
 		bh = &mp_bh->bh_req;
 		dev = bh->b_dev;
 		
diff -x '*~' -x '*.rej' -x '*.orig' -x CVS -x '*.o' -x '.*' -ruN linux-2.4.21-SP3.orig/drivers/md/raid1.c linux-2.4.21-SP3.lmb/drivers/md/raid1.c
--- linux-2.4.21-SP3.orig/drivers/md/raid1.c	2003-09-18 12:07:20.000000000 +0200
+++ linux-2.4.21-SP3.lmb/drivers/md/raid1.c	2003-09-19 10:46:42.000000000 +0200
@@ -823,6 +823,9 @@
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->mirrors + i;
+		/* lmb: Skip completely empty slots */
+		if (tmp->spare || tmp->operational || tmp->number ||
+				tmp->raid_disk || tmp->used_slot)
 		printk(" disk %d, s:%d, o:%d, n:%d rd:%d us:%d dev:%s\n",
 			i, tmp->spare,tmp->operational,
 			tmp->number,tmp->raid_disk,tmp->used_slot,
@@ -1161,8 +1164,12 @@
 	mddev_t *mddev = conf->mddev;
 	kdev_t dev;
 
-	if (mddev->sb_dirty)
-		md_update_sb(mddev);
+	if (mddev->sb_dirty) {
+		lock_mddev(mddev);
+		if (mddev->sb_dirty)
+			md_update_sb(mddev);
+		unlock_mddev(mddev);
+	}
 
 	for (;;) {
 		md_spin_lock_irqsave(&retry_list_lock, flags);
diff -x '*~' -x '*.rej' -x '*.orig' -x CVS -x '*.o' -x '.*' -ruN linux-2.4.21-SP3.orig/drivers/md/raid5.c linux-2.4.21-SP3.lmb/drivers/md/raid5.c
--- linux-2.4.21-SP3.orig/drivers/md/raid5.c	2003-09-18 12:07:58.000000000 +0200
+++ linux-2.4.21-SP3.lmb/drivers/md/raid5.c	2003-09-19 09:49:41.000000000 +0200
@@ -1294,8 +1294,12 @@
 
 	handled = 0;
 
-	if (mddev->sb_dirty)
-		md_update_sb(mddev);
+	if (mddev->sb_dirty) {
+		lock_mddev(mddev);
+		if (mddev->sb_dirty)
+			md_update_sb(mddev);
+		unlock_mddev(mddev);
+	}
 	md_spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct list_head *first;

--jousvV0MzM2p6OtC--
