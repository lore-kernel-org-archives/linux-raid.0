From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 4] Assorted fixes/improvemnet to generic md resync code.
Date: Mon, 23 Aug 2004 13:10:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Bz5E3-0005Bt-4d@notabene.cse.unsw.edu.au>
References: <20040823130657.19914.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


1/ Introduce "mddev->resync_max_sectors" so that an md personality
can ask for resync to cover a different address range than that of a
single drive.  raid10 will use this.

2/ fix is_mddev_idle so that if there seem to be a negative number
 of events, it doesn't immediately assume activity.

3/ make "sync_io" (the count of IO sectors used for array resync)
 an atomic_t to avoid SMP races.  

4/ Pass md_sync_acct a "block_device" rather than the containing "rdev",
  as the whole rdev isn't needed. Also make this an inline function.

5/ Make sure recovery gets interrupted on any error.

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   32 ++++++++++++++++++++++----------
 ./drivers/md/raid1.c        |    4 ++--
 ./drivers/md/raid5.c        |    5 +++--
 ./drivers/md/raid6main.c    |    5 +++--
 ./include/linux/genhd.h     |    2 +-
 ./include/linux/raid/md.h   |    1 -
 ./include/linux/raid/md_k.h |    6 ++++++
 7 files changed, 37 insertions(+), 18 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-08-23 12:07:44.000000000 +1000
+++ ./drivers/md/md.c	2004-08-23 12:23:14.000000000 +1000
@@ -1684,6 +1684,8 @@ static int do_md_run(mddev_t * mddev)
 	mddev->pers = pers[pnum];
 	spin_unlock(&pers_lock);
 
+	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */
+
 	err = mddev->pers->run(mddev);
 	if (err) {
 		printk(KERN_ERR "md: pers->run() failed ...\n");
@@ -2989,6 +2991,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	if (!mddev->pers->error_handler)
 		return;
 	mddev->pers->error_handler(mddev,rdev);
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 }
@@ -3021,7 +3024,11 @@ static void status_resync(struct seq_fil
 	unsigned long max_blocks, resync, res, dt, db, rt;
 
 	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active))/2;
-	max_blocks = mddev->size;
+
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+		max_blocks = mddev->resync_max_sectors >> 1;
+	else
+		max_blocks = mddev->size;
 
 	/*
 	 * Should not happen.
@@ -3257,11 +3264,6 @@ int unregister_md_personality(int pnum)
 	return 0;
 }
 
-void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors)
-{
-	rdev->bdev->bd_contains->bd_disk->sync_io += nr_sectors;
-}
-
 static int is_mddev_idle(mddev_t *mddev)
 {
 	mdk_rdev_t * rdev;
@@ -3274,8 +3276,12 @@ static int is_mddev_idle(mddev_t *mddev)
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = disk_stat_read(disk, read_sectors) + 
 				disk_stat_read(disk, write_sectors) - 
-				disk->sync_io;
-		if ((curr_events - rdev->last_events) > 32) {
+				atomic_read(&disk->sync_io);
+		/* Allow some slack between valud of curr_events and last_events,
+		 * as there are some uninteresting races.
+		 * Note: the following is an unsigned comparison.
+		 */
+		if ((curr_events - rdev->last_events + 32) > 64) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}
@@ -3409,7 +3415,14 @@ static void md_do_sync(mddev_t *mddev)
 		}
 	} while (mddev->curr_resync < 2);
 
-	max_sectors = mddev->size << 1;
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+		/* resync follows the size requested by the personality,
+		 * which default to physical size, but can be virtual size
+		 */
+		max_sectors = mddev->resync_max_sectors;
+	else
+		/* recovery follows the physical size of devices */
+		max_sectors = mddev->size << 1;
 
 	printk(KERN_INFO "md: syncing RAID array %s\n", mdname(mddev));
 	printk(KERN_INFO "md: minimum _guaranteed_ reconstruction speed:"
@@ -3832,7 +3845,6 @@ module_exit(md_exit)
 EXPORT_SYMBOL(register_md_personality);
 EXPORT_SYMBOL(unregister_md_personality);
 EXPORT_SYMBOL(md_error);
-EXPORT_SYMBOL(md_sync_acct);
 EXPORT_SYMBOL(md_done_sync);
 EXPORT_SYMBOL(md_write_start);
 EXPORT_SYMBOL(md_write_end);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-08-23 12:07:44.000000000 +1000
+++ ./drivers/md/raid1.c	2004-08-23 12:20:59.000000000 +1000
@@ -903,7 +903,7 @@ static void sync_request_write(mddev_t *
 
 		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
 		atomic_inc(&r1_bio->remaining);
-		md_sync_acct(conf->mirrors[i].rdev, wbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);
 		generic_make_request(wbio);
 	}
 
@@ -1143,7 +1143,7 @@ static int sync_request(mddev_t *mddev, 
 	bio = r1_bio->bios[disk];
 	r1_bio->sectors = nr_sectors;
 
-	md_sync_acct(mirror->rdev, nr_sectors);
+	md_sync_acct(mirror->rdev->bdev, nr_sectors);
 
 	generic_make_request(bio);
 

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-08-23 12:07:44.000000000 +1000
+++ ./drivers/md/raid5.c	2004-08-23 12:20:59.000000000 +1000
@@ -1071,7 +1071,8 @@ static void handle_stripe(struct stripe_
 					PRINTK("Reading block %d (sync=%d)\n", 
 						i, syncing);
 					if (syncing)
-						md_sync_acct(conf->disks[i].rdev, STRIPE_SECTORS);
+						md_sync_acct(conf->disks[i].rdev->bdev,
+							     STRIPE_SECTORS);
 				}
 			}
 		}
@@ -1256,7 +1257,7 @@ static void handle_stripe(struct stripe_
  
 		if (rdev) {
 			if (test_bit(R5_Syncio, &sh->dev[i].flags))
-				md_sync_acct(rdev, STRIPE_SECTORS);
+				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
 			PRINTK("for %llu schedule op %ld on disc %d\n",

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-08-23 12:07:44.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-08-23 12:20:59.000000000 +1000
@@ -1208,7 +1208,8 @@ static void handle_stripe(struct stripe_
 					PRINTK("Reading block %d (sync=%d)\n",
 						i, syncing);
 					if (syncing)
-						md_sync_acct(conf->disks[i].rdev, STRIPE_SECTORS);
+						md_sync_acct(conf->disks[i].rdev->bdev,
+							     STRIPE_SECTORS);
 				}
 			}
 		}
@@ -1418,7 +1419,7 @@ static void handle_stripe(struct stripe_
 
 		if (rdev) {
 			if (test_bit(R5_Syncio, &sh->dev[i].flags))
-				md_sync_acct(rdev, STRIPE_SECTORS);
+				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
 			PRINTK("for %llu schedule op %ld on disc %d\n",

diff ./include/linux/genhd.h~current~ ./include/linux/genhd.h
--- ./include/linux/genhd.h~current~	2004-08-23 12:07:44.000000000 +1000
+++ ./include/linux/genhd.h	2004-08-23 12:20:59.000000000 +1000
@@ -100,7 +100,7 @@ struct gendisk {
 	struct timer_rand_state *random;
 	int policy;
 
-	unsigned sync_io;		/* RAID */
+	atomic_t sync_io;		/* RAID */
 	unsigned long stamp, stamp_idle;
 	int in_flight;
 #ifdef	CONFIG_SMP

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2004-08-23 12:07:44.000000000 +1000
+++ ./include/linux/raid/md.h	2004-08-23 12:20:59.000000000 +1000
@@ -74,7 +74,6 @@ extern void md_write_start(mddev_t *mdde
 extern void md_write_end(mddev_t *mddev);
 extern void md_handle_safemode(mddev_t *mddev);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
-extern void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors);
 extern void md_error (mddev_t *mddev, mdk_rdev_t *rdev);
 extern void md_unplug_mddev(mddev_t *mddev);
 

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-08-23 12:07:44.000000000 +1000
+++ ./include/linux/raid/md_k.h	2004-08-23 12:20:59.000000000 +1000
@@ -216,6 +216,7 @@ struct mddev_s
 	unsigned long			resync_mark;	/* a recent timestamp */
 	sector_t			resync_mark_cnt;/* blocks written at resync_mark */
 
+	sector_t			resync_max_sectors; /* may be set by personality */
 	/* recovery/resync flags 
 	 * NEEDED:   we might need to start a resync/recover
 	 * RUNNING:  a thread is running, or about to be started
@@ -263,6 +264,11 @@ static inline void rdev_dec_pending(mdk_
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 }
 
+static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
+{
+        atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
+}
+
 struct mdk_personality_s
 {
 	char *name;
