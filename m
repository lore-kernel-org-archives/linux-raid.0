From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 5 of 9] Improve locking on 'safemode' and move superblock writes
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <E1D1wCK-0000XN-Cl@notabene.cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When md marks the superblock dirty before a write, it calls
generic_make_request (to write the superblock) from within
generic_make_request (to write the first dirty block), which
could cause problems later.
With this patch, the superblock write is always done by the
helper thread, and write request are delayed until that
write completes.

Also, the locking around marking the array dirty and writing
the superblock is improved to avoid possible races.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   73 +++++++++++++++++++++++++++++++++++---------
 ./drivers/md/raid1.c        |    4 +-
 ./drivers/md/raid10.c       |    5 ++-
 ./drivers/md/raid5.c        |    6 ++-
 ./drivers/md/raid6main.c    |    6 ++-
 ./include/linux/raid/md.h   |    2 -
 ./include/linux/raid/md_k.h |    7 ++++
 7 files changed, 82 insertions(+), 21 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/md.c	2005-02-18 11:11:25.000000000 +1100
@@ -261,6 +261,8 @@ static mddev_t * mddev_find(dev_t unit)
 	INIT_LIST_HEAD(&new->all_mddevs);
 	init_timer(&new->safemode_timer);
 	atomic_set(&new->active, 1);
+	bio_list_init(&new->write_list);
+	spin_lock_init(&new->write_lock);
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -1294,9 +1296,11 @@ static void md_update_sb(mddev_t * mddev
 	int err, count = 100;
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
+	int sync_req;
 
-	mddev->sb_dirty = 0;
 repeat:
+	spin_lock(&mddev->write_lock);
+	sync_req = mddev->in_sync;
 	mddev->utime = get_seconds();
 	mddev->events ++;
 
@@ -1315,8 +1319,12 @@ repeat:
 	 * do not write anything to disk if using
 	 * nonpersistent superblocks
 	 */
-	if (!mddev->persistent)
+	if (!mddev->persistent) {
+		mddev->sb_dirty = 0;
+		spin_unlock(&mddev->write_lock);
 		return;
+	}
+	spin_unlock(&mddev->write_lock);
 
 	dprintk(KERN_INFO 
 		"md: updating %s RAID superblock on device (in sync %d)\n",
@@ -1347,6 +1355,15 @@ repeat:
 		printk(KERN_ERR \
 			"md: excessive errors occurred during superblock update, exiting\n");
 	}
+	spin_lock(&mddev->write_lock);
+	if (mddev->in_sync != sync_req) {
+		/* have to write it out again */
+		spin_unlock(&mddev->write_lock);
+		goto repeat;
+	}
+	mddev->sb_dirty = 0;
+	spin_unlock(&mddev->write_lock);
+
 }
 
 /*
@@ -3298,19 +3315,31 @@ void md_done_sync(mddev_t *mddev, int bl
 }
 
 
-void md_write_start(mddev_t *mddev)
+/* md_write_start(mddev, bi)
+ * If we need to update some array metadata (e.g. 'active' flag
+ * in superblock) before writing, queue bi for later writing
+ * and return 0, else return 1 and it will be written now
+ */
+int md_write_start(mddev_t *mddev, struct bio *bi)
 {
-	if (!atomic_read(&mddev->writes_pending)) {
-		mddev_lock_uninterruptible(mddev);
-		if (mddev->in_sync) {
-			mddev->in_sync = 0;
- 			del_timer(&mddev->safemode_timer);
-			md_update_sb(mddev);
-		}
-		atomic_inc(&mddev->writes_pending);
-		mddev_unlock(mddev);
-	} else
-		atomic_inc(&mddev->writes_pending);
+	if (bio_data_dir(bi) != WRITE)
+		return 1;
+
+	atomic_inc(&mddev->writes_pending);
+	spin_lock(&mddev->write_lock);
+	if (mddev->in_sync == 0 && mddev->sb_dirty == 0) {
+		spin_unlock(&mddev->write_lock);
+		return 1;
+	}
+	bio_list_add(&mddev->write_list, bi);
+
+	if (mddev->in_sync) {
+		mddev->in_sync = 0;
+		mddev->sb_dirty = 1;
+	}
+	spin_unlock(&mddev->write_lock);
+	md_wakeup_thread(mddev->thread);
+	return 0;
 }
 
 void md_write_end(mddev_t *mddev)
@@ -3597,6 +3626,7 @@ void md_check_recovery(mddev_t *mddev)
 		mddev->sb_dirty ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
+		mddev->write_list.head ||
 		(mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
@@ -3605,7 +3635,9 @@ void md_check_recovery(mddev_t *mddev)
 
 	if (mddev_trylock(mddev)==0) {
 		int spares =0;
+		struct bio *blist;
 
+		spin_lock(&mddev->write_lock);
 		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
 		    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
 			mddev->in_sync = 1;
@@ -3613,9 +3645,22 @@ void md_check_recovery(mddev_t *mddev)
 		}
 		if (mddev->safemode == 1)
 			mddev->safemode = 0;
+		blist = bio_list_get(&mddev->write_list);
+		spin_unlock(&mddev->write_lock);
 
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);
+
+		while (blist) {
+			struct bio *b = blist;
+			blist = blist->bi_next;
+			b->bi_next = NULL;
+			generic_make_request(b);
+			/* we already counted this, so need to un-count */
+			md_write_end(mddev);
+		}
+
+
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
 			/* resync/recovery still happening */

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/raid1.c	2005-02-18 11:11:25.000000000 +1100
@@ -530,6 +530,8 @@ static int make_request(request_queue_t 
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
+	if (md_write_start(mddev, bio)==0)
+		return 0;
 	spin_lock_irq(&conf->resync_lock);
 	wait_event_lock_irq(conf->wait_resume, !conf->barrier, conf->resync_lock, );
 	conf->nr_pending++;
@@ -611,7 +613,7 @@ static int make_request(request_queue_t 
 	rcu_read_unlock();
 
 	atomic_set(&r1_bio->remaining, 1);
-	md_write_start(mddev);
+
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
 		if (!r1_bio->bios[i])

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/raid10.c	2005-02-18 11:11:25.000000000 +1100
@@ -700,6 +700,9 @@ static int make_request(request_queue_t 
 		return 0;
 	}
 
+	if (md_write_start(mddev, bio) == 0)
+		return 0;
+
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
@@ -774,7 +777,7 @@ static int make_request(request_queue_t 
 	rcu_read_unlock();
 
 	atomic_set(&r10_bio->remaining, 1);
-	md_write_start(mddev);
+
 	for (i = 0; i < conf->copies; i++) {
 		struct bio *mbio;
 		int d = r10_bio->devs[i].devnum;

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/raid5.c	2005-02-18 11:11:26.000000000 +1100
@@ -1409,6 +1409,9 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
+	if (md_write_start(mddev, bi)==0)
+		return 0;
+
 	if (bio_data_dir(bi)==WRITE) {
 		disk_stat_inc(mddev->gendisk, writes);
 		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bi));
@@ -1421,8 +1424,7 @@ static int make_request (request_queue_t
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
-	if ( bio_data_dir(bi) == WRITE )
-		md_write_start(mddev);
+
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-02-18 11:11:26.000000000 +1100
@@ -1568,6 +1568,9 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
+	if (md_write_start(mddev, bi)==0)
+		return 0;
+
 	if (bio_data_dir(bi)==WRITE) {
 		disk_stat_inc(mddev->gendisk, writes);
 		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bi));
@@ -1581,8 +1584,7 @@ static int make_request (request_queue_t
 
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
-	if ( bio_data_dir(bi) == WRITE )
-		md_write_start(mddev);
+
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2005-02-18 11:08:39.000000000 +1100
+++ ./include/linux/raid/md.h	2005-02-18 11:11:26.000000000 +1100
@@ -69,7 +69,7 @@ extern mdk_thread_t * md_register_thread
 extern void md_unregister_thread (mdk_thread_t *thread);
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_check_recovery(mddev_t *mddev);
-extern void md_write_start(mddev_t *mddev);
+extern int md_write_start(mddev_t *mddev, struct bio *bi);
 extern void md_write_end(mddev_t *mddev);
 extern void md_handle_safemode(mddev_t *mddev);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-02-18 11:08:39.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-02-18 11:11:26.000000000 +1100
@@ -15,6 +15,9 @@
 #ifndef _MD_K_H
 #define _MD_K_H
 
+/* and dm-bio-list.h is not under include/linux because.... ??? */
+#include "../../../drivers/md/dm-bio-list.h"
+
 #define MD_RESERVED       0UL
 #define LINEAR            1UL
 #define RAID0             2UL
@@ -252,6 +255,10 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
+
+	spinlock_t			write_lock;
+	struct bio_list			write_list;
+
 	unsigned int			safemode;	/* if set, update "clean" superblock
 							 * when no writes pending.
 							 */ 
