From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 2] Add interface to md driver for userspace monitoring of events.
Date: Fri, 03 Sep 2004 12:27:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C33nX-00040i-9v@notabene.cse.unsw.edu.au>
References: <20040903122034.15346.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Every interesting md event (device failure, rebuild, add,remove etc) gets treated 
as an 'urgent data' on /proc/mdstat and cause select to return if waiting for exceptions, 
and poll to return if waiting PRIority data.

To collect an event, the program must re-read /proc/mdstat from start to finish,
and then must select/poll on the file descriptor (or close it).

Events aren't returned as a list of individual events, only as a notification
that something might have happened, and reading /proc/mdstat should show what 
it was.

If a program opens /proc/mdstat with O_RDWR it signals that it intends
to handle events.  In some cases the md driver might want to wait for
an event to be handled before deciding what to do next.  For example
when the last path of a multipath fails, the md driver could either
fail all requests, or could wait for a working path to be provided.
It can do this by waiting for the failure event to be handled, and
then making the decission.  A program that is handling events should
read /proc/mdstat to determine new state, and then handle any events
before either calling select/poll.  By doing this, or by closing the
file, the program indicates that it has done all that it plans to do
about the event.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c                |  125 +++++++++++++++++++++++++++++++++++++--
 ./drivers/md/multipath.c         |   81 +++++++++++++++----------
 ./include/linux/raid/md_k.h      |    4 +
 ./include/linux/raid/multipath.h |    1 
 4 files changed, 173 insertions(+), 38 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-09-03 11:34:26.000000000 +1000
+++ ./drivers/md/md.c	2004-09-03 11:37:25.000000000 +1000
@@ -37,6 +37,7 @@
 #include <linux/devfs_fs_kernel.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/suspend.h>
+#include <linux/poll.h>
 
 #include <linux/init.h>
 
@@ -124,6 +125,48 @@ static ctl_table raid_root_table[] = {
 
 static struct block_device_operations md_fops;
 
+
+/*
+ * We have a system wide 'event count' that is incremented
+ * on any 'interesting' event, and readers of /proc/mdstat 
+ * can use 'poll' or 'select' to find out when the event
+ * count increases
+ *
+ * Events are:
+ *  start array, stop array, error, add device, remove device, 
+ *  start build, activate spare
+ */
+DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
+EXPORT_SYMBOL(md_event_waiters);
+static atomic_t md_event_count;
+int md_new_event(void) 
+{
+	atomic_inc(&md_event_count);
+	wake_up(&md_event_waiters);
+	return atomic_read(&md_event_count);
+}
+EXPORT_SYMBOL(md_new_event);
+struct mdstat_info {
+	struct list_head list;	/* all active files linked together */
+	unsigned long	seen, reading, acknowledged;
+};
+static LIST_HEAD(readers);
+static spinlock_t readers_lock = SPIN_LOCK_UNLOCKED;
+
+int md_event_reached(unsigned long ev)
+{
+	/* returns true when all readers have acknowledged event 'ev' */
+	struct mdstat_info *mi;
+	int rv  = 1;
+	spin_lock(&readers_lock);
+	list_for_each_entry(mi, &readers, list)
+		if (mi->reading > 0 && mi->acknowledged < ev)
+			rv = 0;
+	spin_unlock(&readers_lock);
+	return rv;
+}
+EXPORT_SYMBOL(md_event_reached);
+
 /*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
@@ -1717,6 +1760,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->queue->issue_flush_fn = md_flush_all;
 
 	mddev->changed = 1;
+	md_new_event();
 	return 0;
 }
 
@@ -1821,6 +1865,7 @@ static int do_md_stop(mddev_t * mddev, i
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
 	err = 0;
+	md_new_event();
 out:
 	return err;
 }
@@ -2235,6 +2280,7 @@ static int hot_remove_disk(mddev_t * mdd
 
 	kick_rdev_from_array(rdev);
 	md_update_sb(mddev);
+	md_new_event();
 
 	return 0;
 busy:
@@ -2325,7 +2371,7 @@ static int hot_add_disk(mddev_t * mddev,
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-
+	md_new_event();
 	return 0;
 
 abort_unbind_export:
@@ -2941,6 +2987,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	md_new_event();
 }
 
 /* seq_file implementation /proc/mdstat */
@@ -3087,6 +3134,7 @@ static int md_seq_show(struct seq_file *
 	sector_t size;
 	struct list_head *tmp2;
 	mdk_rdev_t *rdev;
+	struct mdstat_info *mi = seq->private;
 	int i;
 
 	if (v == (void*)1) {
@@ -3097,11 +3145,13 @@ static int md_seq_show(struct seq_file *
 				seq_printf(seq, "[%s] ", pers[i]->name);
 
 		spin_unlock(&pers_lock);
-		seq_printf(seq, "\n");
+		mi->reading = atomic_read(&md_event_count);
+		seq_printf(seq, "\nEvent: %-20ld\n", mi->reading);
 		return 0;
 	}
 	if (v == (void*)2) {
 		status_unused(seq);
+		mi->seen = mi->reading;
 		return 0;
 	}
 
@@ -3160,19 +3210,74 @@ static struct seq_operations md_seq_ops 
 	.show   = md_seq_show,
 };
 
+
 static int md_seq_open(struct inode *inode, struct file *file)
 {
 	int error;
+	struct mdstat_info *mi = kmalloc(sizeof(*mi), GFP_KERNEL);
+	if (mi == NULL)
+		return -ENOMEM;
 
 	error = seq_open(file, &md_seq_ops);
+	if (error)
+		kfree(mi);
+	else {
+		struct seq_file *p = file->private_data;
+		p->private = mi;
+		mi->acknowledged = mi->seen = mi->reading = 0;
+		if (file->f_mode & FMODE_WRITE) {
+			spin_lock(&readers_lock);
+			list_add(&mi->list, &readers);
+			spin_unlock(&readers_lock);
+		} else
+			INIT_LIST_HEAD(&mi->list);
+	}
 	return error;
 }
 
+static int md_seq_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = (struct seq_file*)file->private_data;
+	struct mdstat_info *mi = m->private;
+
+	m->private = NULL;
+	if (!list_empty(&mi->list)) {
+		spin_lock(&readers_lock);
+		list_del(&mi->list);
+		spin_unlock(&readers_lock);
+	}
+	kfree(mi);
+	wake_up(&md_event_waiters);
+	return seq_release(inode, file);
+}
+	
+static unsigned int
+mdstat_poll(struct file *filp, poll_table *wait)
+{
+	struct seq_file *m = (struct seq_file*)filp->private_data;
+	struct mdstat_info*mi = m->private;
+	int mask;
+
+	if (mi->acknowledged != mi->seen) {
+		mi->acknowledged = mi->seen;
+		wake_up(&md_event_waiters);
+	}
+	poll_wait(filp, &md_event_waiters, wait);
+
+	/* always allow read */
+	mask = POLLIN | POLLRDNORM;
+
+	if (mi->seen < atomic_read(&md_event_count))
+		mask |= POLLPRI;
+	return mask;
+}
+
 static struct file_operations md_seq_fops = {
 	.open           = md_seq_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
-	.release	= seq_release,
+	.release	= md_seq_release,
+	.poll		= mdstat_poll,
 };
 
 int register_md_personality(int pnum, mdk_personality_t *p)
@@ -3418,6 +3523,11 @@ static void md_do_sync(mddev_t *mddev)
 		atomic_add(sectors, &mddev->recovery_active);
 		j += sectors;
 		if (j>1) mddev->curr_resync = j;
+		if (last_check==0)
+			/* This is the earliest that rebuild will be visible
+			 * in /proc/mdstat
+			 */
+			md_new_event();
 
 		if (last_check + window > j || j == max_sectors)
 			continue;
@@ -3569,6 +3679,7 @@ void md_check_recovery(mddev_t *mddev)
 			/* flag recovery needed just to double check */
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			wake_up(&resync_wait);
+			md_new_event();
 			goto unlock;
 		}
 		if (mddev->recovery) {
@@ -3595,9 +3706,10 @@ void md_check_recovery(mddev_t *mddev)
 			ITERATE_RDEV(mddev,rdev,rtmp)
 				if (rdev->raid_disk < 0
 				    && !rdev->faulty) {
-					if (mddev->pers->hot_add_disk(mddev,rdev))
+					if (mddev->pers->hot_add_disk(mddev,rdev)) {
 						spares++;
-					else
+						md_new_event();
+					} else
 						break;
 				}
 		}
@@ -3622,6 +3734,7 @@ void md_check_recovery(mddev_t *mddev)
 			} else {
 				md_wakeup_thread(mddev->sync_thread);
 			}
+			md_new_event();
 		}
 	unlock:
 		mddev_unlock(mddev);
@@ -3664,7 +3777,7 @@ static void md_geninit(void)
 
 	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
-	p = create_proc_entry("mdstat", S_IRUGO, NULL);
+	p = create_proc_entry("mdstat", S_IRUGO|S_IWUSR, NULL);
 	if (p)
 		p->proc_fops = &md_seq_fops;
 }

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-09-03 11:34:26.000000000 +1000
+++ ./drivers/md/multipath.c	2004-09-03 11:34:38.000000000 +1000
@@ -54,15 +54,20 @@ static void mp_pool_free(void *mpb, void
 	kfree(mpb);
 }
 
-static int multipath_map (multipath_conf_t *conf)
+static int multipath_map (multipath_conf_t *conf, int retry)
 {
 	int i, disks = conf->raid_disks;
+	int failed = -1;
 
 	/*
-	 * Later we do read balancing on the read side 
-	 * now we use the first available disk.
+	 * We cannot tell the difference between a bad device and a bad block.
+	 * So, while we always prefer a path that hasn't seen a failure,
+	 * if there is no other option we accept a device which has seen
+	 * a failure, but only on the first attempt, never on a retry.
+	 * Normally, devices which have failed are removed from the array,
+	 * but this does not happen for the last device.
 	 */
-
+ retry:
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
 		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
@@ -71,9 +76,23 @@ static int multipath_map (multipath_conf
 			spin_unlock_irq(&conf->device_lock);
 			return i;
 		}
+		if (rdev) failed = i;
+	}
+	if (!retry && failed >= 0) {
+		mdk_rdev_t *rdev = conf->multipaths[failed].rdev;
+		atomic_inc(&rdev->nr_pending);
+		spin_unlock_irq(&conf->device_lock);
+		return failed;
 	}
 	spin_unlock_irq(&conf->device_lock);
 
+	/* sync with any monitoring daemon */
+	wait_event(md_event_waiters,
+		   md_event_reached(conf->last_fail_event) ||
+		   conf->working_disks >= 1);
+	if (conf->working_disks)
+		goto retry;
+
 	printk(KERN_ERR "multipath_map(): no more operational IO paths?\n");
 	return (-1);
 }
@@ -186,7 +205,7 @@ static int multipath_make_request (reque
 		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bio));
 	}
 
-	mp_bh->path = multipath_map(conf);
+	mp_bh->path = multipath_map(conf, 0);
 	if (mp_bh->path < 0) {
 		bio_endio(bio, bio->bi_size, -EIO);
 		mempool_free(mp_bh, conf->pool);
@@ -250,32 +269,23 @@ static void multipath_error (mddev_t *md
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 
-	if (conf->working_disks <= 1) {
-		/*
-		 * Uh oh, we can do nothing if this is our last path, but
-		 * first check if this is a queued request for a device
-		 * which has just failed.
-		 */
-		printk(KERN_ALERT 
-			"multipath: only one IO path left and IO error.\n");
-		/* leave it active... it's all we have */
-	} else {
-		/*
-		 * Mark disk as unusable
-		 */
-		if (!rdev->faulty) {
-			char b[BDEVNAME_SIZE];
-			rdev->in_sync = 0;
-			rdev->faulty = 1;
-			mddev->sb_dirty = 1;
-			conf->working_disks--;
-			printk(KERN_ALERT "multipath: IO failure on %s,"
-				" disabling IO path. \n	Operation continuing"
-				" on %d IO paths.\n",
-				bdevname (rdev->bdev,b),
-				conf->working_disks);
-		}
+	conf->last_fail_event = md_new_event();
+	/*
+	 * Mark disk as unusable
+	 */
+	if (!rdev->faulty) {
+		char b[BDEVNAME_SIZE];
+		rdev->in_sync = 0;
+		rdev->faulty = 1;
+		mddev->sb_dirty = 1;
+		conf->working_disks--;
+		printk(KERN_ALERT "multipath: IO failure on %s,"
+		       " disabling IO path. \n	Operation continuing"
+		       " on %d IO paths.\n",
+		       bdevname (rdev->bdev,b),
+		       conf->working_disks);
 	}
+
 }
 
 static void print_multipath_conf (multipath_conf_t *conf)
@@ -347,10 +357,17 @@ static int multipath_remove_disk(mddev_t
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 
+	if (conf->working_disks == 0)
+		/* don't remove devices when none seem to be working.
+		 * We want to have somewhere to keep trying incase it
+		 * is really a device error
+		 */
+		goto abort;
 	if (p->rdev) {
 		if (p->rdev->in_sync ||
 		    atomic_read(&p->rdev->nr_pending)) {
-			printk(KERN_ERR "hot-remove-disk, slot %d is identified"				" but is still operational!\n", number);
+			printk(KERN_ERR "hot-remove-disk, slot %d is identified"
+			       " but is still operational!\n", number);
 			err = -EBUSY;
 			goto abort;
 		}
@@ -397,7 +414,7 @@ static void multipathd (mddev_t *mddev)
 		bio = &mp_bh->bio;
 		bio->bi_sector = mp_bh->master_bio->bi_sector;
 		
-		if ((mp_bh->path = multipath_map (conf))<0) {
+		if ((mp_bh->path = multipath_map(conf, 1))<0) {
 			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
 				" error for block %llu\n",
 				bdevname(bio->bi_bdev,b),

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-09-03 11:34:26.000000000 +1000
+++ ./include/linux/raid/md_k.h	2004-09-03 11:34:38.000000000 +1000
@@ -360,5 +360,9 @@ do {									\
 	__wait_event_lock_irq(wq, condition, lock, cmd);		\
 } while (0)
 
+extern int md_new_event(void);
+extern wait_queue_head_t md_event_waiters;
+extern int md_event_reached(unsigned long ev);
+
 #endif
 

diff ./include/linux/raid/multipath.h~current~ ./include/linux/raid/multipath.h
--- ./include/linux/raid/multipath.h~current~	2004-09-03 11:34:26.000000000 +1000
+++ ./include/linux/raid/multipath.h	2004-09-03 11:34:38.000000000 +1000
@@ -13,6 +13,7 @@ struct multipath_private_data {
 	int			raid_disks;
 	int			working_disks;
 	spinlock_t		device_lock;
+	unsigned long		last_fail_event;
 
 	mempool_t		*pool;
 };
