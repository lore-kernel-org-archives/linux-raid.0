From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 006 of 18] Improve raid1 "IO Barrier" concept.
Date: Mon, 28 Nov 2005 10:40:07 +1100
Message-ID: <1051127234007.14805@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


raid1 needs to put up a barrier to new requests while it 
does resync or other background recovery.
The code for this is currently open-coded, slighty obscure
by its use of two waitqueues, and not documented.

This patch gathers all the related code into 4 functions,
and includes a comment which (hopefully) explains what is happening. 


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c         |  169 ++++++++++++++++++++++---------------------
 ./include/linux/raid/raid1.h |    4 -
 2 files changed, 92 insertions(+), 81 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 10:11:52.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 10:12:17.000000000 +1100
@@ -51,6 +51,8 @@ static mdk_personality_t raid1_personali
 
 static void unplug_slaves(mddev_t *mddev);
 
+static void allow_barrier(conf_t *conf);
+static void lower_barrier(conf_t *conf);
 
 static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
@@ -160,20 +162,13 @@ static void put_all_bios(conf_t *conf, r
 
 static inline void free_r1bio(r1bio_t *r1_bio)
 {
-	unsigned long flags;
-
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
 	/*
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.
 	 */
-	spin_lock_irqsave(&conf->resync_lock, flags);
-	if (!--conf->nr_pending) {
-		wake_up(&conf->wait_idle);
-		wake_up(&conf->wait_resume);
-	}
-	spin_unlock_irqrestore(&conf->resync_lock, flags);
+	allow_barrier(conf);
 
 	put_all_bios(conf, r1_bio);
 	mempool_free(r1_bio, conf->r1bio_pool);
@@ -182,22 +177,10 @@ static inline void free_r1bio(r1bio_t *r
 static inline void put_buf(r1bio_t *r1_bio)
 {
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
-	unsigned long flags;
 
 	mempool_free(r1_bio, conf->r1buf_pool);
 
-	spin_lock_irqsave(&conf->resync_lock, flags);
-	if (!conf->barrier)
-		BUG();
-	--conf->barrier;
-	wake_up(&conf->wait_resume);
-	wake_up(&conf->wait_idle);
-
-	if (!--conf->nr_pending) {
-		wake_up(&conf->wait_idle);
-		wake_up(&conf->wait_resume);
-	}
-	spin_unlock_irqrestore(&conf->resync_lock, flags);
+	lower_barrier(conf);
 }
 
 static void reschedule_retry(r1bio_t *r1_bio)
@@ -210,6 +193,7 @@ static void reschedule_retry(r1bio_t *r1
 	list_add(&r1_bio->retry_list, &conf->retry_list);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
+	wake_up(&conf->wait_barrier);
 	md_wakeup_thread(mddev->thread);
 }
 
@@ -592,30 +576,83 @@ static int raid1_issue_flush(request_que
 	return ret;
 }
 
-/*
- * Throttle resync depth, so that we can both get proper overlapping of
- * requests, but are still able to handle normal requests quickly.
+/* Barriers....
+ * Sometimes we need to suspend IO while we do something else,
+ * either some resync/recovery, or reconfigure the array.
+ * To do this we raise a 'barrier'.
+ * The 'barrier' is a counter that can be raised multiple times
+ * to count how many activities are happening which preclude
+ * normal IO.
+ * We can only raise the barrier if there is no pending IO.
+ * i.e. if nr_pending == 0.
+ * We choose only to raise the barrier if no-one is waiting for the
+ * barrier to go down.  This means that as soon as an IO request
+ * is ready, no other operations which require a barrier will start
+ * until the IO request has had a chance.
+ *
+ * So: regular IO calls 'wait_barrier'.  When that returns there
+ *    is no backgroup IO happening,  It must arrange to call
+ *    allow_barrier when it has finished its IO.
+ * backgroup IO calls must call raise_barrier.  Once that returns
+ *    there is no normal IO happeing.  It must arrange to call
+ *    lower_barrier when the particular background IO completes.
  */
 #define RESYNC_DEPTH 32
 
-static void device_barrier(conf_t *conf, sector_t sect)
+static void raise_barrier(conf_t *conf)
 {
 	spin_lock_irq(&conf->resync_lock);
-	wait_event_lock_irq(conf->wait_idle, !waitqueue_active(&conf->wait_resume),
-			    conf->resync_lock, raid1_unplug(conf->mddev->queue));
-	
-	if (!conf->barrier++) {
-		wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
-				    conf->resync_lock, raid1_unplug(conf->mddev->queue));
-		if (conf->nr_pending)
-			BUG();
-	}
-	wait_event_lock_irq(conf->wait_resume, conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock, raid1_unplug(conf->mddev->queue));
-	conf->next_resync = sect;
+
+	/* Wait until no block IO is waiting */
+	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
+			    conf->resync_lock,
+			    raid1_unplug(conf->mddev->queue));
+
+	/* block any new IO from starting */
+	conf->barrier++;
+
+	/* No wait for all pending IO to complete */
+	wait_event_lock_irq(conf->wait_barrier,
+			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
+			    conf->resync_lock,
+			    raid1_unplug(conf->mddev->queue));
+
+	spin_unlock_irq(&conf->resync_lock);
+}
+
+static void lower_barrier(conf_t *conf)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&conf->resync_lock, flags);
+	conf->barrier--;
+	spin_unlock_irqrestore(&conf->resync_lock, flags);
+	wake_up(&conf->wait_barrier);
+}
+
+static void wait_barrier(conf_t *conf)
+{
+	spin_lock_irq(&conf->resync_lock);
+	if (conf->barrier) {
+		conf->nr_waiting++;
+		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
+				    conf->resync_lock,
+				    raid1_unplug(conf->mddev->queue));
+		conf->nr_waiting--;
+	}
+	conf->nr_pending++;
 	spin_unlock_irq(&conf->resync_lock);
 }
 
+static void allow_barrier(conf_t *conf)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&conf->resync_lock, flags);
+	conf->nr_pending--;
+	spin_unlock_irqrestore(&conf->resync_lock, flags);
+	wake_up(&conf->wait_barrier);
+}
+
+
 /* duplicate the data pages for behind I/O */
 static struct page **alloc_behind_pages(struct bio *bio)
 {
@@ -677,10 +714,7 @@ static int make_request(request_queue_t 
 	 */
 	md_write_start(mddev, bio); /* wait on superblock update early */
 
-	spin_lock_irq(&conf->resync_lock);
-	wait_event_lock_irq(conf->wait_resume, !conf->barrier, conf->resync_lock, );
-	conf->nr_pending++;
-	spin_unlock_irq(&conf->resync_lock);
+	wait_barrier(conf);
 
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
@@ -908,13 +942,8 @@ static void print_conf(conf_t *conf)
 
 static void close_sync(conf_t *conf)
 {
-	spin_lock_irq(&conf->resync_lock);
-	wait_event_lock_irq(conf->wait_resume, !conf->barrier,
-			    conf->resync_lock, 	raid1_unplug(conf->mddev->queue));
-	spin_unlock_irq(&conf->resync_lock);
-
-	if (conf->barrier) BUG();
-	if (waitqueue_active(&conf->wait_idle)) BUG();
+	wait_barrier(conf);
+	allow_barrier(conf);
 
 	mempool_destroy(conf->r1buf_pool);
 	conf->r1buf_pool = NULL;
@@ -1316,12 +1345,16 @@ static sector_t sync_request(mddev_t *md
 		return sync_blocks;
 	}
 	/*
-	 * If there is non-resync activity waiting for us then
-	 * put in a delay to throttle resync.
+	 * If there is non-resync activity waiting for a turn,
+	 * and resync is going fast enough,
+	 * then let it though before starting on this new sync request.
 	 */
-	if (!go_faster && waitqueue_active(&conf->wait_resume))
+	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
-	device_barrier(conf, sector_nr + RESYNC_SECTORS);
+
+	raise_barrier(conf);
+
+	conf->next_resync = sector_nr;
 
 	/*
 	 * If reconstructing, and >1 working disc,
@@ -1354,10 +1387,6 @@ static sector_t sync_request(mddev_t *md
 
 	r1_bio = mempool_alloc(conf->r1buf_pool, GFP_NOIO);
 
-	spin_lock_irq(&conf->resync_lock);
-	conf->nr_pending++;
-	spin_unlock_irq(&conf->resync_lock);
-
 	r1_bio->mddev = mddev;
 	r1_bio->sector = sector_nr;
 	r1_bio->state = 0;
@@ -1541,8 +1570,7 @@ static int run(mddev_t *mddev)
 		mddev->recovery_cp = MaxSector;
 
 	spin_lock_init(&conf->resync_lock);
-	init_waitqueue_head(&conf->wait_idle);
-	init_waitqueue_head(&conf->wait_resume);
+	init_waitqueue_head(&conf->wait_barrier);
 
 	bio_list_init(&conf->pending_bio_list);
 	bio_list_init(&conf->flushing_bio_list);
@@ -1713,11 +1741,7 @@ static int raid1_reshape(mddev_t *mddev,
 	}
 	memset(newmirrors, 0, sizeof(struct mirror_info)*raid_disks);
 
-	spin_lock_irq(&conf->resync_lock);
-	conf->barrier++;
-	wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
-			    conf->resync_lock, raid1_unplug(mddev->queue));
-	spin_unlock_irq(&conf->resync_lock);
+	raise_barrier(conf);
 
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
@@ -1737,12 +1761,7 @@ static int raid1_reshape(mddev_t *mddev,
 	conf->raid_disks = mddev->raid_disks = raid_disks;
 
 	conf->last_used = 0; /* just make sure it is in-range */
-	spin_lock_irq(&conf->resync_lock);
-	conf->barrier--;
-	spin_unlock_irq(&conf->resync_lock);
-	wake_up(&conf->wait_resume);
-	wake_up(&conf->wait_idle);
-
+	lower_barrier(conf);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -1757,18 +1776,10 @@ static void raid1_quiesce(mddev_t *mddev
 
 	switch(state) {
 	case 1:
-		spin_lock_irq(&conf->resync_lock);
-		conf->barrier++;
-		wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
-				    conf->resync_lock, raid1_unplug(mddev->queue));
-		spin_unlock_irq(&conf->resync_lock);
+		raise_barrier(conf);
 		break;
 	case 0:
-		spin_lock_irq(&conf->resync_lock);
-		conf->barrier--;
-		spin_unlock_irq(&conf->resync_lock);
-		wake_up(&conf->wait_resume);
-		wake_up(&conf->wait_idle);
+		lower_barrier(conf);
 		break;
 	}
 	if (mddev->thread) {

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./include/linux/raid/raid1.h	2005-11-28 10:12:17.000000000 +1100
@@ -45,6 +45,7 @@ struct r1_private_data_s {
 
 	spinlock_t		resync_lock;
 	int			nr_pending;
+	int			nr_waiting;
 	int			barrier;
 	sector_t		next_resync;
 	int			fullsync;  /* set to 1 if a full sync is needed,
@@ -52,8 +53,7 @@ struct r1_private_data_s {
 					    * Cleared when a sync completes.
 					    */
 
-	wait_queue_head_t	wait_idle;
-	wait_queue_head_t	wait_resume;
+	wait_queue_head_t	wait_barrier;
 
 	struct pool_info	*poolinfo;
 
