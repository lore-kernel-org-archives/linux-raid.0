From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - raid in 2.5.15 - 2 of 3 - Tidy up raid5 code
Date: Wed, 15 May 2002 15:23:53 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15585.61673.887561.865806@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



- remove md_ prefix from some calls that used to be
  defined in md_compatability.h

- remove "raid5_" prefix from some static functions,
  in line with recent changes to raid1.c

?? should cpu_has_mmx be moved to in processor.h ?

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c         |   76 +++++++++++++++++++++----------------------
 ./drivers/md/xor.c           |    5 +-
 ./include/asm-i386/xor.h     |    4 +-
 ./include/linux/raid/raid5.h |    4 +-
 4 files changed, 45 insertions(+), 44 deletions(-)

--- ./include/linux/raid/raid5.h	2002/05/14 05:38:33	1.1
+++ ./include/linux/raid/raid5.h	2002/05/15 04:23:59	1.2
@@ -215,11 +215,11 @@
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
-	md_wait_queue_head_t	wait_for_stripe;
+	wait_queue_head_t	wait_for_stripe;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
 							 * waiting for 25% to be free
 							 */        
-	md_spinlock_t		device_lock;
+	spinlock_t		device_lock;
 
 	int			plugged;
 	struct tq_struct	plug_tq;
--- ./include/asm-i386/xor.h	2002/05/14 23:20:01	1.1
+++ ./include/asm-i386/xor.h	2002/05/15 04:23:59	1.2
@@ -839,6 +839,8 @@
 /* Also try the generic routines.  */
 #include <asm-generic/xor.h>
 
+#define cpu_has_mmx	(test_bit(X86_FEATURE_MMX,  boot_cpu_data.x86_capability))
+
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES				\
 	do {						\
@@ -846,7 +848,7 @@
 		xor_speed(&xor_block_32regs);		\
 	        if (cpu_has_xmm)			\
 			xor_speed(&xor_block_pIII_sse);	\
-	        if (md_cpu_has_mmx()) {			\
+	        if (cpu_has_mmx) {			\
 	                xor_speed(&xor_block_pII_mmx);	\
 	                xor_speed(&xor_block_p5_mmx);	\
 	        }					\
--- ./drivers/md/raid5.c	2002/05/14 05:38:33	1.1
+++ ./drivers/md/raid5.c	2002/05/15 04:23:59	1.2
@@ -251,7 +251,7 @@
 
 	PRINTK("get_stripe, sector %lu\n", sector);
 
-	md_spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->device_lock);
 
 	do {
 		if (conf->buffer_size == 0 ||
@@ -325,7 +325,7 @@
 	if (sh)
 		atomic_inc(&sh->count);
 
-	md_spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->device_lock);
 	return sh;
 }
 
@@ -449,13 +449,13 @@
 		return;
 	}
 
-	md_spin_lock_irqsave(&conf->device_lock, flags);
+	spin_lock_irqsave(&conf->device_lock, flags);
 	if (!uptodate)
 		md_error(conf->mddev, bh->b_bdev);
 	clear_buffer_locked(bh);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	__release_stripe(conf, sh);
-	md_spin_unlock_irqrestore(&conf->device_lock, flags);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
 }
 	
 
@@ -476,14 +476,14 @@
 	return bh;
 }
 
-static int raid5_error (mddev_t *mddev, kdev_t dev)
+static int error (mddev_t *mddev, kdev_t dev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	mdp_super_t *sb = mddev->sb;
 	struct disk_info *disk;
 	int i;
 
-	PRINTK("raid5_error called\n");
+	PRINTK("raid5: error called\n");
 
 	for (i = 0, disk = conf->disks; i < conf->raid_disks; i++, disk++) {
 		if (kdev_same(disk->dev, dev)) {
@@ -1192,7 +1192,7 @@
 	spin_unlock_irq(&conf->device_lock);
 }
 
-static int raid5_make_request (mddev_t *mddev, int rw, struct buffer_head * bh)
+static int make_request (mddev_t *mddev, int rw, struct buffer_head * bh)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	const unsigned int raid_disks = conf->raid_disks;
@@ -1211,7 +1211,7 @@
 	new_sector = raid5_compute_sector(bh->b_rsector,
 			raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 
-	PRINTK("raid5_make_request, sector %lu\n", new_sector);
+	PRINTK("raid5: make_request, sector %lu\n", new_sector);
 	sh = get_active_stripe(conf, new_sector, bh->b_size, read_ahead);
 	if (sh) {
 		sh->pd_idx = pd_idx;
@@ -1226,7 +1226,7 @@
 	return 0;
 }
 
-static int raid5_sync_request (mddev_t *mddev, unsigned long sector_nr)
+static int sync_request (mddev_t *mddev, unsigned long sector_nr)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
@@ -1280,7 +1280,7 @@
 		mddev->sb_dirty = 0;
 		md_update_sb(mddev);
 	}
-	md_spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct list_head *first;
 
@@ -1300,17 +1300,17 @@
 		atomic_inc(&sh->count);
 		if (atomic_read(&sh->count)!= 1)
 			BUG();
-		md_spin_unlock_irq(&conf->device_lock);
+		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
 		handle_stripe(sh);
 		release_stripe(sh);
 
-		md_spin_lock_irq(&conf->device_lock);
+		spin_lock_irq(&conf->device_lock);
 	}
 	PRINTK("%d stripes handled\n", handled);
 
-	md_spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->device_lock);
 
 	PRINTK("--- raid5d inactive\n");
 }
@@ -1340,7 +1340,7 @@
 	printk("raid5: resync finished.\n");
 }
 
-static int raid5_run (mddev_t *mddev)
+static int run (mddev_t *mddev)
 {
 	raid5_conf_t *conf;
 	int i, j, raid_disk, memory;
@@ -1348,7 +1348,7 @@
 	mdp_disk_t *desc;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
-	struct md_list_head *tmp;
+	struct list_head *tmp;
 	int start_recovery = 0;
 
 	MOD_INC_USE_COUNT;
@@ -1365,12 +1365,12 @@
 	memset (conf, 0, sizeof (*conf));
 	conf->mddev = mddev;
 
-	if ((conf->stripe_hashtbl = (struct stripe_head **) md__get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL)
+	if ((conf->stripe_hashtbl = (struct stripe_head **) __get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL)
 		goto abort;
 	memset(conf->stripe_hashtbl, 0, HASH_PAGES * PAGE_SIZE);
 
-	conf->device_lock = MD_SPIN_LOCK_UNLOCKED;
-	md_init_waitqueue_head(&conf->wait_for_stripe);
+	conf->device_lock = SPIN_LOCK_UNLOCKED;
+	init_waitqueue_head(&conf->wait_for_stripe);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
@@ -1383,7 +1383,7 @@
 	conf->plug_tq.routine = &raid5_unplug_device;
 	conf->plug_tq.data = conf;
 
-	PRINTK("raid5_run(md%d) called.\n", mdidx(mddev));
+	PRINTK("raid5: run(md%d) called.\n", mdidx(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		/*
@@ -1580,7 +1580,7 @@
 	return -EIO;
 }
 
-static int raid5_stop_resync (mddev_t *mddev)
+static int stop_resync (mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	mdk_thread_t *thread = conf->resync_thread;
@@ -1597,7 +1597,7 @@
 	return 0;
 }
 
-static int raid5_restart_resync (mddev_t *mddev)
+static int restart_resync (mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
@@ -1616,7 +1616,7 @@
 }
 
 
-static int raid5_stop (mddev_t *mddev)
+static int stop (mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 
@@ -1651,7 +1651,7 @@
 	struct stripe_head *sh;
 	int i;
 
-	md_spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < NR_HASH; i++) {
 		sh = conf->stripe_hashtbl[i];
 		for (; sh; sh = sh->hash_next) {
@@ -1660,13 +1660,13 @@
 			print_sh(sh);
 		}
 	}
-	md_spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->device_lock);
 
 	PRINTK("--- raid5d inactive\n");
 }
 #endif
 
-static int raid5_status (char *page, mddev_t *mddev)
+static int status (char *page, mddev_t *mddev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	mdp_super_t *sb = mddev->sb;
@@ -1711,7 +1711,7 @@
 	}
 }
 
-static int raid5_diskop(mddev_t *mddev, mdp_disk_t **d, int state)
+static int diskop(mddev_t *mddev, mdp_disk_t **d, int state)
 {
 	int err = 0;
 	int i, failed_disk=-1, spare_disk=-1, removed_disk=-1, added_disk=-1;
@@ -1722,7 +1722,7 @@
 	mdk_rdev_t *spare_rdev, *failed_rdev;
 
 	print_raid5_conf(conf);
-	md_spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(&conf->device_lock);
 	/*
 	 * find the disk ...
 	 */
@@ -1980,7 +1980,7 @@
 		goto abort;
 	}
 abort:
-	md_spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(&conf->device_lock);
 	print_raid5_conf(conf);
 	return err;
 }
@@ -1988,18 +1988,18 @@
 static mdk_personality_t raid5_personality=
 {
 	name:		"raid5",
-	make_request:	raid5_make_request,
-	run:		raid5_run,
-	stop:		raid5_stop,
-	status:		raid5_status,
-	error_handler:	raid5_error,
-	diskop:		raid5_diskop,
-	stop_resync:	raid5_stop_resync,
-	restart_resync:	raid5_restart_resync,
-	sync_request:	raid5_sync_request
+	make_request:	make_request,
+	run:		run,
+	stop:		stop,
+	status:		status,
+	error_handler:	error,
+	diskop:		diskop,
+	stop_resync:	stop_resync,
+	restart_resync:	restart_resync,
+	sync_request:	sync_request
 };
 
-static int md__init raid5_init (void)
+static int __init raid5_init (void)
 {
 	return register_md_personality (RAID5, &raid5_personality);
 }
--- ./drivers/md/xor.c	2002/05/14 23:02:19	1.1
+++ ./drivers/md/xor.c	2002/05/15 04:23:59	1.2
@@ -19,7 +19,6 @@
 #define BH_TRACE 0
 #include <linux/module.h>
 #include <linux/raid/md.h>
-#include <linux/raid/md_compatible.h>
 #include <linux/raid/xor.h>
 #include <asm/xor.h>
 
@@ -103,7 +102,7 @@
 	void *b1, *b2;
 	struct xor_block_template *f, *fastest;
 
-	b1 = (void *) md__get_free_pages(GFP_KERNEL, 2);
+	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
 	if (! b1) {
 		printk("raid5: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -137,7 +136,7 @@
 	return 0;
 }
 
-MD_EXPORT_SYMBOL(xor_block);
+EXPORT_SYMBOL(xor_block);
 MODULE_LICENSE("GPL");
 
 module_init(calibrate_xor_block);
