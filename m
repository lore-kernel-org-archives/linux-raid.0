From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 5 of 27 - Embed bio in mp_bh rather than separate allocation.
Date: Thu, 18 Jul 2002 23:32:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133246.4809@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Embed bio in mp_bh rather than separate allocation.

multipath currently allocates an mp_bh and a bio for each
request.  With this patch, the bio is made to be part of the
mp_bh so there is only one allocation, and it from a private 
pool (the bio was allocated from a shared pool).

Also remove "remaining" and "cmd" from mp_bh which aren't used.
And remove spare (unused) from multipath_private_data.






 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |   18 +++++++-----------
 ./include/linux/raid/multipath.h |   10 +++-------
 2 files changed, 10 insertions(+), 18 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 12:00:17	1.5
+++ ./drivers/md/multipath.c	2002/07/18 12:00:24	1.6
@@ -121,7 +121,6 @@ static void multipath_end_bh_io (struct 
 	multipath_conf_t *conf = mddev_to_conf(mp_bh->mddev);
 
 	bio_endio(bio, uptodate);
-	bio_put(mp_bh->bio);
 	mempool_free(mp_bh, conf->pool);
 }
 
@@ -164,7 +163,6 @@ static int multipath_make_request (reque
 {
 	mddev_t *mddev = q->queuedata;
 	multipath_conf_t *conf = mddev_to_conf(mddev);
-	struct bio *real_bio;
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 
@@ -172,20 +170,17 @@ static int multipath_make_request (reque
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
-	mp_bh->cmd = bio_data_dir(bio);
 
 	/*
 	 * read balancing logic:
 	 */
 	multipath = conf->multipaths + multipath_read_balance(conf);
 
-	real_bio = bio_clone(bio, GFP_NOIO);
-	real_bio->bi_bdev = multipath->bdev;
-	real_bio->bi_rw = bio_data_dir(bio);
-	real_bio->bi_end_io = multipath_end_request;
-	real_bio->bi_private = mp_bh;
-	mp_bh->bio = real_bio;
-	generic_make_request(real_bio);
+	mp_bh->bio = *bio;
+	mp_bh->bio.bi_bdev = multipath->bdev;
+	mp_bh->bio.bi_end_io = multipath_end_request;
+	mp_bh->bio.bi_private = mp_bh;
+	generic_make_request(&mp_bh->bio);
 	return 0;
 }
 
@@ -598,7 +593,8 @@ static void multipathd (void *data)
 			printk(KERN_INFO "dirty sb detected, updating.\n");
 			md_update_sb(mddev);
 		}
-		bio = mp_bh->bio;
+		bio = &mp_bh->bio;
+		bio->bi_sector = mp_bh->master_bio->bi_sector;
 		bdev = bio->bi_bdev;
 		
 		multipath_map (mddev, &bio->bi_bdev);
--- ./include/linux/raid/multipath.h	2002/07/18 12:00:17	1.3
+++ ./include/linux/raid/multipath.h	2002/07/18 12:00:24	1.4
@@ -2,6 +2,7 @@
 #define _MULTIPATH_H
 
 #include <linux/raid/md.h>
+#include <linux/bio.h>
 
 struct multipath_info {
 	int		number;
@@ -24,7 +25,6 @@ struct multipath_private_data {
 	int			raid_disks;
 	int			working_disks;
 	mdk_thread_t		*thread;
-	struct multipath_info	*spare;
 	spinlock_t		device_lock;
 
 	mempool_t		*pool;
@@ -45,13 +45,9 @@ typedef struct multipath_private_data mu
  */
 
 struct multipath_bh {
-	atomic_t		remaining; /* 'have we finished' count,
-					    * used from IRQ handlers
-					    */
-	int			cmd;
 	mddev_t			*mddev;
 	struct bio		*master_bio;
-	struct bio		*bio;
-	struct multipath_bh	*next_mp; /* next for retry or in free list */
+	struct bio		bio;
+	struct multipath_bh	*next_mp; /* next for retry */
 };
 #endif
