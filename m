From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - Fix compile errors when tracing enabled in MD
Date: Wed, 11 Sep 2002 11:02:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020911010209.4481@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

both md.c and raid5.c can be compiled with debugging and compile
errors in this code aren't normally noticed as they aren't even 
compiled.
Now the debugging messages are compiled but optimised out so we will
always see the errors.

Current errors are fixed.




 ----------- Diffstat output ------------
 ./drivers/md/md.c        |    9 +++------
 ./drivers/md/multipath.c |   14 --------------
 ./drivers/md/raid5.c     |   12 +++++-------
 3 files changed, 8 insertions(+), 27 deletions(-)

--- ./drivers/md/md.c	2002/09/11 00:37:33	1.2
+++ ./drivers/md/md.c	2002/09/11 00:59:18	1.3
@@ -56,11 +56,8 @@
 #include <linux/blk.h>
 
 #define DEBUG 0
-#if DEBUG
-# define dprintk(x...) printk(x)
-#else
-# define dprintk(x...) do { } while(0)
-#endif
+#define dprintk(x...) ((void)(DEBUG && printk(x)))
+
 
 #ifndef MODULE
 static void autostart_arrays (void);
@@ -2593,7 +2590,7 @@ static void md_recover_arrays(void)
 void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		MD_MAJOR,mdidx(mddev),MAJOR(bdev->bd_dev),MINOR(bdev->bd_dev),
+		MD_MAJOR,mdidx(mddev),MAJOR(rdev->bdev->bd_dev),MINOR(rdev->bdev->bd_dev),
 		__builtin_return_address(0),__builtin_return_address(1),
 		__builtin_return_address(2),__builtin_return_address(3));
 
--- ./drivers/md/raid5.c	2002/09/11 00:38:33	1.2
+++ ./drivers/md/raid5.c	2002/09/11 00:59:18	1.3
@@ -49,12 +49,10 @@
 # define CHECK_DEVLOCK()
 #endif
 
+#define PRINTK(x...) ((void)(RAID5_DEBUG && printk(x)))
 #if RAID5_DEBUG
-#define PRINTK(x...) printk(x)
 #define inline
 #define __inline__
-#else
-#define PRINTK(x...) do { } while (0)
 #endif
 
 static void print_raid5_conf (raid5_conf_t *conf);
@@ -1167,7 +1165,7 @@ static void handle_stripe(struct stripe_
 					md_sync_acct(rdev, STRIPE_SECTORS);
 
 				bi->bi_bdev = rdev->bdev;
-				PRINTK("for %ld schedule op %d on disc %d\n", sh->sector, bi->bi_rw, i);
+				PRINTK("for %ld schedule op %ld on disc %d\n", sh->sector, bi->bi_rw, i);
 				atomic_inc(&sh->count);
 				bi->bi_sector = sh->sector;
 				bi->bi_flags = 0;
@@ -1178,7 +1176,7 @@ static void handle_stripe(struct stripe_
 				bi->bi_next = NULL;
 				generic_make_request(bi);
 			} else {
-				PRINTK("skip op %d on disc %d for sector %ld\n", bi->bi_rw, i, sh->sector);
+				PRINTK("skip op %ld on disc %d for sector %ld\n", bi->bi_rw, i, sh->sector);
 				clear_bit(R5_LOCKED, &dev->flags);
 				set_bit(STRIPE_HANDLE, &sh->state);
 			}
@@ -1245,8 +1243,8 @@ static int make_request (request_queue_t
 		new_sector = raid5_compute_sector(logical_sector,
 						  raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 
-		PRINTK("raid5: make_request, sector %ul logical %ul\n", 
-		       new_sector, logical_sector);
+		PRINTK("raid5: make_request, sector %Lu logical %Lu\n", 
+		       (unsigned long long)new_sector, (unsigned long long)logical_sector);
 
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
--- ./drivers/md/multipath.c	2002/09/11 00:38:59	1.1
+++ ./drivers/md/multipath.c	2002/09/11 00:59:18	1.2
@@ -37,20 +37,6 @@
 #define	NR_RESERVED_BUFS	32
 
 
-/*
- * The following can be used to debug the driver
- */
-#define MULTIPATH_DEBUG	0
-
-#if MULTIPATH_DEBUG
-#define PRINTK(x...)   printk(x)
-#define inline
-#define __inline__
-#else
-#define PRINTK(x...)  do { } while (0)
-#endif
-
-
 static mdk_personality_t multipath_personality;
 static spinlock_t retry_list_lock = SPIN_LOCK_UNLOCKED;
 struct multipath_bh *multipath_retry_list = NULL, **multipath_retry_tail;
