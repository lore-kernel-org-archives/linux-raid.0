From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 4 of 4] Fix md deadlock due to md thread processing delayed requests.
Date: Tue, 08 Mar 2005 16:50:59 +1100
Message-ID: <E1D8XcR-0000zK-Qh@notabene.cse.unsw.edu.au>
References: <20050308165021.3745.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Before completing a 'write' the md superblock might need to be updated.
This is best done by the md_thread. 
The current code schedules this up and queues the write request for later
handling by the md_thread.
However some personalities (Raid5/raid6) will deadlock if the
md_thread tries to submit requests to its own array.
So this patch changes things so the processes submitting the
request waits for the superblock to be written and then submits
the request itself.

This fixes a recently-created deadlock in raid5/raid6


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   45 +++++++++++++++-----------------------------
 ./drivers/md/raid1.c        |    4 +--
 ./drivers/md/raid10.c       |    3 --
 ./drivers/md/raid5.c        |    3 --
 ./drivers/md/raid6main.c    |    3 --
 ./include/linux/raid/md.h   |    2 -
 ./include/linux/raid/md_k.h |    2 -
 7 files changed, 23 insertions(+), 39 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-03-08 16:08:10.000000000 +1100
+++ ./drivers/md/md.c	2005-03-08 16:11:44.000000000 +1100
@@ -267,8 +267,8 @@ static mddev_t * mddev_find(dev_t unit)
 	INIT_LIST_HEAD(&new->all_mddevs);
 	init_timer(&new->safemode_timer);
 	atomic_set(&new->active, 1);
-	bio_list_init(&new->write_list);
 	spin_lock_init(&new->write_lock);
+	init_waitqueue_head(&new->sb_wait);
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -1350,6 +1350,7 @@ repeat:
 	if (!mddev->persistent) {
 		mddev->sb_dirty = 0;
 		spin_unlock(&mddev->write_lock);
+		wake_up(&mddev->sb_wait);
 		return;
 	}
 	spin_unlock(&mddev->write_lock);
@@ -1391,6 +1392,7 @@ repeat:
 	}
 	mddev->sb_dirty = 0;
 	spin_unlock(&mddev->write_lock);
+	wake_up(&mddev->sb_wait);
 
 }
 
@@ -3489,29 +3491,26 @@ void md_done_sync(mddev_t *mddev, int bl
 
 /* md_write_start(mddev, bi)
  * If we need to update some array metadata (e.g. 'active' flag
- * in superblock) before writing, queue bi for later writing
- * and return 0, else return 1 and it will be written now
+ * in superblock) before writing, schedule a superblock update
+ * and wait for it to complete.
  */
-int md_write_start(mddev_t *mddev, struct bio *bi)
+void md_write_start(mddev_t *mddev, struct bio *bi)
 {
+	DEFINE_WAIT(w);
 	if (bio_data_dir(bi) != WRITE)
-		return 1;
+		return;
 
 	atomic_inc(&mddev->writes_pending);
-	spin_lock(&mddev->write_lock);
-	if (mddev->in_sync == 0 && mddev->sb_dirty == 0) {
-		spin_unlock(&mddev->write_lock);
-		return 1;
-	}
-	bio_list_add(&mddev->write_list, bi);
-
 	if (mddev->in_sync) {
-		mddev->in_sync = 0;
-		mddev->sb_dirty = 1;
+		spin_lock(&mddev->write_lock);
+		if (mddev->in_sync) {
+			mddev->in_sync = 0;
+			mddev->sb_dirty = 1;
+			md_wakeup_thread(mddev->thread);
+		}
+		spin_unlock(&mddev->write_lock);
 	}
-	spin_unlock(&mddev->write_lock);
-	md_wakeup_thread(mddev->thread);
-	return 0;
+	wait_event(mddev->sb_wait, mddev->sb_dirty==0);
 }
 
 void md_write_end(mddev_t *mddev)
@@ -3808,7 +3807,6 @@ void md_check_recovery(mddev_t *mddev)
 		mddev->sb_dirty ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-		mddev->write_list.head ||
 		(mddev->safemode == 1) ||
 		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
@@ -3817,7 +3815,6 @@ void md_check_recovery(mddev_t *mddev)
 
 	if (mddev_trylock(mddev)==0) {
 		int spares =0;
-		struct bio *blist;
 
 		spin_lock(&mddev->write_lock);
 		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
@@ -3827,21 +3824,11 @@ void md_check_recovery(mddev_t *mddev)
 		}
 		if (mddev->safemode == 1)
 			mddev->safemode = 0;
-		blist = bio_list_get(&mddev->write_list);
 		spin_unlock(&mddev->write_lock);
 
 		if (mddev->sb_dirty)
 			md_update_sb(mddev);
 
-		while (blist) {
-			struct bio *b = blist;
-			blist = blist->bi_next;
-			b->bi_next = NULL;
-			generic_make_request(b);
-			/* we already counted this, so need to un-count */
-			md_write_end(mddev);
-		}
-
 
 		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-03-08 16:08:10.000000000 +1100
+++ ./drivers/md/raid1.c	2005-03-07 16:33:42.000000000 +1100
@@ -561,8 +561,8 @@ static int make_request(request_queue_t 
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
-	if (md_write_start(mddev, bio)==0)
-		return 0;
+	md_write_start(mddev, bio); /* wait on superblock update early */
+
 	spin_lock_irq(&conf->resync_lock);
 	wait_event_lock_irq(conf->wait_resume, !conf->barrier, conf->resync_lock, );
 	conf->nr_pending++;

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-03-08 16:08:10.000000000 +1100
+++ ./drivers/md/raid10.c	2005-03-07 16:33:59.000000000 +1100
@@ -700,8 +700,7 @@ static int make_request(request_queue_t 
 		return 0;
 	}
 
-	if (md_write_start(mddev, bio) == 0)
-		return 0;
+	md_write_start(mddev, bio);
 
 	/*
 	 * Register the new request and wait if the reconstruction

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-03-08 16:08:10.000000000 +1100
+++ ./drivers/md/raid5.c	2005-03-07 16:34:09.000000000 +1100
@@ -1411,8 +1411,7 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
-	if (md_write_start(mddev, bi)==0)
-		return 0;
+	md_write_start(mddev, bi);
 
 	if (bio_data_dir(bi)==WRITE) {
 		disk_stat_inc(mddev->gendisk, writes);

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-03-08 16:08:10.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-03-07 16:34:29.000000000 +1100
@@ -1570,8 +1570,7 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
-	if (md_write_start(mddev, bi)==0)
-		return 0;
+	md_write_start(mddev, bi);
 
 	if (bio_data_dir(bi)==WRITE) {
 		disk_stat_inc(mddev->gendisk, writes);

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2005-03-08 16:08:10.000000000 +1100
+++ ./include/linux/raid/md.h	2005-03-07 16:32:55.000000000 +1100
@@ -69,7 +69,7 @@ extern mdk_thread_t * md_register_thread
 extern void md_unregister_thread (mdk_thread_t *thread);
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_check_recovery(mddev_t *mddev);
-extern int md_write_start(mddev_t *mddev, struct bio *bi);
+extern void md_write_start(mddev_t *mddev, struct bio *bi);
 extern void md_write_end(mddev_t *mddev);
 extern void md_handle_safemode(mddev_t *mddev);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-03-08 16:08:10.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-03-07 16:31:44.000000000 +1100
@@ -261,7 +261,7 @@ struct mddev_s
 	sector_t			recovery_cp;
 
 	spinlock_t			write_lock;
-	struct bio_list			write_list;
+	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */
 
 	unsigned int			safemode;	/* if set, update "clean" superblock
 							 * when no writes pending.
