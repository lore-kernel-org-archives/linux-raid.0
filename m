From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Locking bugs in 2.4 md.c
Date: Fri, 19 Sep 2003 12:08:29 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16234.25885.855209.372799@notabene.cse.unsw.edu.au>
References: <20030918152310.GD30852@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Marowsky-Bree on Thursday September 18
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@suse.de
List-Id: linux-raid.ids

On Thursday September 18, lmb@suse.de wrote:
> Hi Neil,
> 
> I can pretty reliably Oops the 2.4 md raid1 in md_update_sb with a
> 
> while true
> 	mdadm /dev/md0 -f /dev/foo -r /dev/foo
> 	mdadm /dev/md0 -a /dev/foo
> done &
> while true
> 	mdadm /dev/md1 -f /dev/bar -r /dev/bar
> 	mdadm /dev/md1 -a /dev/bar
> done &
> 
> in parallel on several md devices. It will finally die in md_update_sb,
> and appears to be related to some locking bugs.
> 
> (The above is a stress test and makes it occur faster; customers report
> it happens in the field too, that's why I went looking.)
> 
> In March (see http://www.spinics.net/lists/raid/msg02335.html) you wrote
> you had a patch which made the locking in 2.4 "better", even though it
> was rather ugly. Well, ugly it might be, but needed still ;-)
> 
> I assume you want to use the reconfig_sem for it? If you don't have a
> recent patch, could you sketch out what you wanted to do so I could
> start from there?

A patch against 2.4-current is below.  It probably works but I haven't
reviewed it in the context of other recent changes to md so I make no
promises.
> 
> (Or maybe you want to backport the 2.6 md to 2.4... ;-)

That might be nice, but it was lots of changes!!
NeilBrown

===============================
Improve locking of MD related structure, particularly when reconfiguring

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  212 +++++++++++++++++++++++++++++---------------
 ./drivers/md/multipath.c    |    8 +
 ./drivers/md/raid1.c        |    8 +
 ./drivers/md/raid5.c        |    8 +
 ./include/linux/raid/md_k.h |   23 +++-
 5 files changed, 174 insertions(+), 85 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-09-19 11:55:45.000000000 +1000
+++ ./drivers/md/md.c	2003-09-19 11:59:34.000000000 +1000
@@ -34,6 +34,7 @@
 #include <linux/sysctl.h>
 #include <linux/raid/xor.h>
 #include <linux/devfs_fs_kernel.h>
+#include <linux/rwsem.h>
 
 #include <linux/init.h>
 
@@ -130,16 +131,69 @@ static struct gendisk md_gendisk=
 
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
@@ -175,13 +229,19 @@ void del_mddev_mapping(mddev_t * mddev, 
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
@@ -199,20 +259,22 @@ static mddev_t * alloc_mddev(kdev_t dev)
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
 
@@ -744,18 +806,10 @@ static void free_mddev(mddev_t *mddev)
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
@@ -826,7 +880,9 @@ void md_print_devices(void)
 	printk("md:	**********************************\n");
 	printk("md:	* <COMPLETE RAID STATE PRINTOUT> *\n");
 	printk("md:	**********************************\n");
-	ITERATE_MDDEV(mddev,tmp) {
+
+	down_read(&all_mddevs_sem);
+	ITERATE_MDDEV/*_LOCK*/(mddev,tmp) {
 		printk("md%d: ", mdidx(mddev));
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
@@ -841,6 +897,7 @@ void md_print_devices(void)
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			print_rdev(rdev);
 	}
+	up_read(&all_mddevs_sem);
 	printk("md:	**********************************\n");
 	printk("\n");
 }
@@ -921,10 +978,6 @@ static int write_disk_sb(mdk_rdev_t * rd
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
@@ -1010,6 +1063,11 @@ int md_update_sb(mddev_t * mddev)
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
@@ -1825,6 +1883,9 @@ static int do_md_stop(mddev_t * mddev, i
 		if (mddev->recovery_running)
 			md_interrupt_thread(md_recovery_thread);
 
+		mddev->dying = 1; /* make sure nobody tries to use this */
+		unlock_mddev(mddev);
+
 		/*
 		 * This synchronizes with signal delivery to the
 		 * resync or reconstruction thread. It also nicely
@@ -1846,6 +1907,7 @@ static int do_md_stop(mddev_t * mddev, i
 			if (mddev->pers->stop(mddev)) {
 				if (mddev->ro)
 					set_device_ro(dev, 1);
+				mddev->dying = 0;
 				OUT(-EBUSY);
 			}
 			if (mddev->ro)
@@ -1863,8 +1925,11 @@ static int do_md_stop(mddev_t * mddev, i
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
@@ -1896,7 +1961,7 @@ int detect_old_array(mdp_super_t *sb)
 }
 
 
-static void autorun_array(mddev_t *mddev)
+static int autorun_array(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
 	struct md_list_head *tmp;
@@ -1904,7 +1969,8 @@ static void autorun_array(mddev_t *mddev
 
 	if (mddev->disks.prev == &mddev->disks) {
 		MD_BUG();
-		return;
+		unlock_mddev(mddev);
+		return 0;
 	}
 
 	printk(KERN_INFO "md: running: ");
@@ -1922,7 +1988,10 @@ static void autorun_array(mddev_t *mddev
 		 */
 		mddev->sb_dirty = 0;
 		do_md_stop (mddev, 0);
+		return err;
 	}
+	unlock_mddev(mddev);
+	return 0;
 }
 
 /*
@@ -1978,6 +2047,7 @@ static void autorun_devices(kdev_t count
 			       mdidx(mddev), partition_name(rdev0->dev));
 			ITERATE_RDEV_GENERIC(candidates,pending,rdev,tmp)
 				export_rdev(rdev);
+			atomic_dec(&mddev->active);
 			continue;
 		}
 		mddev = alloc_mddev(md_kdev);
@@ -1985,15 +2055,15 @@ static void autorun_devices(kdev_t count
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
@@ -2638,7 +2708,9 @@ static int md_ioctl(struct inode *inode,
 	 * Commands creating/starting a new array:
 	 */
 
-	mddev = kdev_to_mddev(dev);
+	mddev = kdev_to_mddev_lock_interruptible(dev, &err);
+	if (mddev == NULL && err)
+		goto abort;
 
 	switch (cmd)
 	{
@@ -2648,7 +2720,7 @@ static int md_ioctl(struct inode *inode,
 				printk(KERN_WARNING "md: array md%d already exists!\n",
 								mdidx(mddev));
 				err = -EEXIST;
-				goto abort;
+				goto abort_unlock;
 			}
 		default:;
 	}
@@ -2660,17 +2732,6 @@ static int md_ioctl(struct inode *inode,
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
@@ -2693,14 +2754,11 @@ static int md_ioctl(struct inode *inode,
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
 
@@ -2715,11 +2773,7 @@ static int md_ioctl(struct inode *inode,
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
@@ -2888,17 +2942,17 @@ static int md_open(struct inode *inode, 
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
+		atomic_dec(&mddev->active);
 		atomic_dec(&mddev->active);
+	}
 	return 0;
 }
 
@@ -3183,7 +3237,8 @@ static void *md_seq_next(struct seq_file
 {
 	struct list_head *tmp;
 	mddev_t *next_mddev, *mddev = v;
-	
+
+	down_read(&all_mddevs_sem);
 	++*pos;
 	if (v == (void*)2)
 		return NULL;
@@ -3205,7 +3260,7 @@ static void *md_seq_next(struct seq_file
 
 static void md_seq_stop(struct seq_file *seq, void *v)
 {
-
+	up_read(&all_mddevs_sem);
 }
 
 static int md_seq_show(struct seq_file *seq, void *v)
@@ -3233,6 +3288,8 @@ static int md_seq_show(struct seq_file *
 		status_unused(seq);
 		return 0;
 	}
+	if (mddev->dying)
+		return 0;
 
 	seq_printf(seq, "md%d : %sactive", mdidx(mddev),
 		   mddev->pers ? "" : "in");
@@ -3432,6 +3489,7 @@ int md_do_sync(mddev_t *mddev, mdp_disk_
 
 recheck:
 	serialize = 0;
+	down_read(&all_mddevs_sem);
 	ITERATE_MDDEV(mddev2,tmp) {
 		if (mddev2 == mddev)
 			continue;
@@ -3443,6 +3501,7 @@ recheck:
 			break;
 		}
 	}
+	up_read(&all_mddevs_sem);
 	if (serialize) {
 		interruptible_sleep_on(&resync_wait);
 		if (md_signal_pending(current)) {
@@ -3589,8 +3648,10 @@ void md_do_recovery(void *data)
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
@@ -3617,9 +3678,13 @@ restart:
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
@@ -3645,26 +3710,28 @@ restart:
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
@@ -3680,7 +3747,7 @@ int md_notify_reboot(struct notifier_blo
 
 		printk(KERN_INFO "md: stopping all md devices.\n");
 
-		ITERATE_MDDEV(mddev,tmp)
+		ITERATE_MDDEV_LOCK(mddev,tmp)
 			do_md_stop (mddev, 1);
 		/*
 		 * certain more exotic SCSI devices are known to be
@@ -4024,6 +4091,9 @@ void md__init md_setup_drive(void)
 			mddev->sb_dirty = 0;
 			do_md_stop(mddev, 0);
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
+		} else {
+			unlock_mddev(mddev);
+			atomic_dec(&mddev->active);
 		}
 	}
 }

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-09-19 11:55:45.000000000 +1000
+++ ./drivers/md/multipath.c	2003-09-19 11:53:09.000000000 +1000
@@ -700,8 +700,12 @@ static void multipathd (void *data)
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
 		

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-09-19 11:55:45.000000000 +1000
+++ ./drivers/md/raid1.c	2003-09-19 11:53:09.000000000 +1000
@@ -1160,8 +1160,12 @@ static void raid1d (void *data)
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

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-09-19 11:55:45.000000000 +1000
+++ ./drivers/md/raid5.c	2003-09-19 11:53:09.000000000 +1000
@@ -1301,8 +1301,12 @@ static void raid5d (void *data)
 
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

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-09-19 11:55:45.000000000 +1000
+++ ./include/linux/raid/md_k.h	2003-09-19 11:53:09.000000000 +1000
@@ -75,13 +75,6 @@ typedef struct dev_mapping_s {
 
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
@@ -207,6 +200,7 @@ struct mddev_s
 	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
 	char				*name;
 	int				recovery_running;
+	int				dying;
 	struct semaphore		reconfig_sem;
 	struct semaphore		recovery_sem;
 	struct semaphore		resync_sem;
@@ -310,7 +304,20 @@ extern mdp_disk_t *get_spare(mddev_t *md
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
