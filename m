From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 007 of 18] Improve raid10 "IO Barrier" concept.
Date: Mon, 28 Nov 2005 10:40:12 +1100
Message-ID: <1051127234012.14817@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


raid10 needs to put up a barrier to new requests while it 
does resync or other background recovery.
The code for this is currently open-coded, slighty obscure
by its use of two waitqueues, and not documented.

This patch gathers all the related code into 4 functions,
and includes a comment which (hopefully) explains what is happening. 

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c         |  135 ++++++++++++++++++++++++------------------
 ./include/linux/raid/raid10.h |    4 -
 2 files changed, 81 insertions(+), 58 deletions(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-11-28 10:08:26.000000000 +1100
+++ ./drivers/md/raid10.c	2005-11-28 10:12:24.000000000 +1100
@@ -47,6 +47,9 @@
 
 static void unplug_slaves(mddev_t *mddev);
 
+static void allow_barrier(conf_t *conf);
+static void lower_barrier(conf_t *conf);
+
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	conf_t *conf = data;
@@ -175,20 +178,13 @@ static void put_all_bios(conf_t *conf, r
 
 static inline void free_r10bio(r10bio_t *r10_bio)
 {
-	unsigned long flags;
-
 	conf_t *conf = mddev_to_conf(r10_bio->mddev);
 
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
 
 	put_all_bios(conf, r10_bio);
 	mempool_free(r10_bio, conf->r10bio_pool);
@@ -197,22 +193,10 @@ static inline void free_r10bio(r10bio_t 
 static inline void put_buf(r10bio_t *r10_bio)
 {
 	conf_t *conf = mddev_to_conf(r10_bio->mddev);
-	unsigned long flags;
 
 	mempool_free(r10_bio, conf->r10buf_pool);
 
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
 
 static void reschedule_retry(r10bio_t *r10_bio)
@@ -640,30 +624,82 @@ static int raid10_issue_flush(request_qu
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
-			    conf->resync_lock, unplug_slaves(conf->mddev));
 
-	if (!conf->barrier++) {
-		wait_event_lock_irq(conf->wait_idle, !conf->nr_pending,
-				    conf->resync_lock, unplug_slaves(conf->mddev));
-		if (conf->nr_pending)
-			BUG();
-	}
-	wait_event_lock_irq(conf->wait_resume, conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock, unplug_slaves(conf->mddev));
-	conf->next_resync = sect;
+	/* Wait until no block IO is waiting */
+	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
+			    conf->resync_lock,
+			    raid10_unplug(conf->mddev->queue));
+
+	/* block any new IO from starting */
+	conf->barrier++;
+
+	/* No wait for all pending IO to complete */
+	wait_event_lock_irq(conf->wait_barrier,
+			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
+			    conf->resync_lock,
+			    raid10_unplug(conf->mddev->queue));
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
+				    raid10_unplug(conf->mddev->queue));
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
 static int make_request(request_queue_t *q, struct bio * bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -719,10 +755,7 @@ static int make_request(request_queue_t 
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
-	spin_lock_irq(&conf->resync_lock);
-	wait_event_lock_irq(conf->wait_resume, !conf->barrier, conf->resync_lock, );
-	conf->nr_pending++;
-	spin_unlock_irq(&conf->resync_lock);
+	wait_barrier(conf);
 
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
@@ -897,13 +930,8 @@ static void print_conf(conf_t *conf)
 
 static void close_sync(conf_t *conf)
 {
-	spin_lock_irq(&conf->resync_lock);
-	wait_event_lock_irq(conf->wait_resume, !conf->barrier,
-			    conf->resync_lock, 	unplug_slaves(conf->mddev));
-	spin_unlock_irq(&conf->resync_lock);
-
-	if (conf->barrier) BUG();
-	if (waitqueue_active(&conf->wait_idle)) BUG();
+	wait_barrier(conf);
+	allow_barrier(conf);
 
 	mempool_destroy(conf->r10buf_pool);
 	conf->r10buf_pool = NULL;
@@ -1395,9 +1423,10 @@ static sector_t sync_request(mddev_t *md
 	 * If there is non-resync activity waiting for us then
 	 * put in a delay to throttle resync.
 	 */
-	if (!go_faster && waitqueue_active(&conf->wait_resume))
+	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
-	device_barrier(conf, sector_nr + RESYNC_SECTORS);
+	raise_barrier(conf);
+	conf->next_resync = sector_nr;
 
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
@@ -1427,7 +1456,6 @@ static sector_t sync_request(mddev_t *md
 
 				r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
 				spin_lock_irq(&conf->resync_lock);
-				conf->nr_pending++;
 				if (rb2) conf->barrier++;
 				spin_unlock_irq(&conf->resync_lock);
 				atomic_set(&r10_bio->remaining, 0);
@@ -1500,10 +1528,6 @@ static sector_t sync_request(mddev_t *md
 		int count = 0;
 		r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
 
-		spin_lock_irq(&conf->resync_lock);
-		conf->nr_pending++;
-		spin_unlock_irq(&conf->resync_lock);
-
 		r10_bio->mddev = mddev;
 		atomic_set(&r10_bio->remaining, 0);
 
@@ -1713,8 +1737,7 @@ static int run(mddev_t *mddev)
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
-	init_waitqueue_head(&conf->wait_idle);
-	init_waitqueue_head(&conf->wait_resume);
+	init_waitqueue_head(&conf->wait_barrier);
 
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf)) {

diff ./include/linux/raid/raid10.h~current~ ./include/linux/raid/raid10.h
--- ./include/linux/raid/raid10.h~current~	2005-11-28 10:08:19.000000000 +1100
+++ ./include/linux/raid/raid10.h	2005-11-28 10:12:24.000000000 +1100
@@ -39,11 +39,11 @@ struct r10_private_data_s {
 
 	spinlock_t		resync_lock;
 	int nr_pending;
+	int nr_waiting;
 	int barrier;
 	sector_t		next_resync;
 
-	wait_queue_head_t	wait_idle;
-	wait_queue_head_t	wait_resume;
+	wait_queue_head_t	wait_barrier;
 
 	mempool_t *r10bio_pool;
 	mempool_t *r10buf_pool;
