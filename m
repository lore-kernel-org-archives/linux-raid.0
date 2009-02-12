From: NeilBrown <neilb@suse.de>
Subject: [PATCH 15/18] md: hopefully enable suspend/resume of md devices.
Date: Thu, 12 Feb 2009 14:10:11 +1100
Message-ID: <20090212031011.23983.37119.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


---

 drivers/md/md.c           |   79 ++++++++++++++++++++++++++++++++++++---------
 include/linux/raid/md_k.h |    2 +
 2 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cbe0f20..0e0e1ff 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -202,12 +202,68 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
 		)
 
 
-static int md_fail_request(struct request_queue *q, struct bio *bio)
+/* Rather than calling directly into the personality make_request function,
+ * IO requests come here first so that we can check if the device is
+ * being suspended pending a reconfiguration.
+ * We hold a refcount over the call to ->make_request.  By the time that
+ * call has finished, the bio has been linked into some internal structure
+ * and so is visible to ->quiesce(), so we don't need the refcount any more.
+ */
+static int md_make_request(struct request_queue *q, struct bio *bio)
 {
-	bio_io_error(bio);
-	return 0;
+	mddev_t *mddev = q->queuedata;
+	int rv;
+	if (mddev == NULL || mddev->pers == NULL) {
+		bio_io_error(bio);
+		return 0;
+	}
+	rcu_read_lock();
+	if (mddev->suspended) {
+		DEFINE_WAIT(__wait);
+		for(;;) {
+			prepare_to_wait(&mddev->sb_wait, &__wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!mddev->suspended)
+				break;
+			rcu_read_unlock();
+			schedule();
+			rcu_read_lock();
+		}
+		finish_wait(&mddev->sb_wait, &__wait);
+	}
+	atomic_inc(&mddev->active_io);
+	rcu_read_unlock();
+	rv = mddev->pers->make_request(q, bio);
+	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
+		wake_up(&mddev->sb_wait);
+	
+	return rv;
 }
 
+static void mddev_suspend(mddev_t *mddev)
+{
+	BUG_ON(mddev->suspended);
+	mddev->suspended = 1;
+	synchronize_rcu();
+	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
+	mddev->pers->quiesce(mddev, 1);
+	md_unregister_thread(mddev->thread);
+	mddev->thread = NULL;
+	/* we now know that no code is executing in the personality module,
+	 * except possibly the tail end of a ->bi_end_io function, but that
+	 * is certain to complete before the module has a chance to get
+	 * unloaded
+	 */
+}
+
+static void mddev_resume(mddev_t *mddev)
+{
+	mddev->suspended = 0;
+	wake_up(&mddev->sb_wait);
+	mddev->pers->quiesce(mddev, 0);
+}
+
+
 static inline mddev_t *mddev_get(mddev_t *mddev)
 {
 	atomic_inc(&mddev->active);
@@ -315,6 +371,7 @@ static mddev_t * mddev_find(dev_t unit)
 	init_timer(&new->safemode_timer);
 	atomic_set(&new->active, 1);
 	atomic_set(&new->openers, 0);
+	atomic_set(&new->active_io, 0);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
 	init_waitqueue_head(&new->recovery_wait);
@@ -3597,10 +3654,12 @@ static int md_alloc(dev_t dev, char *name)
 		mddev_put(mddev);
 		return -ENOMEM;
 	}
+	mddev->queue->queuedata = mddev;
+
 	/* Can be unlocked because the queue is new: no concurrency */
 	queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, mddev->queue);
 
-	blk_queue_make_request(mddev->queue, md_fail_request);
+	blk_queue_make_request(mddev->queue, md_make_request);
 
 	disk = alloc_disk(1 << shift);
 	if (!disk) {
@@ -3896,16 +3955,6 @@ static int do_md_run(mddev_t * mddev)
 
 	set_capacity(disk, mddev->array_sectors);
 
-	/* If we call blk_queue_make_request here, it will
-	 * re-initialise max_sectors etc which may have been
-	 * refined inside -> run.  So just set the bits we need to set.
-	 * Most initialisation happended when we called
-	 * blk_queue_make_request(..., md_fail_request)
-	 * earlier.
-	 */
-	mddev->queue->queuedata = mddev;
-	mddev->queue->make_request_fn = mddev->pers->make_request;
-
 	/* If there is a partially-recovered drive we need to
 	 * start recovery here.  If we leave it to md_check_recovery,
 	 * it will remove the drives and not do the right thing
@@ -4035,7 +4084,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 			md_super_wait(mddev);
 			if (mddev->ro)
 				set_disk_ro(disk, 0);
-			blk_queue_make_request(mddev->queue, md_fail_request);
+
 			mddev->pers->stop(mddev);
 			mddev->queue->merge_bvec_fn = NULL;
 			mddev->queue->unplug_fn = NULL;
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 9598155..a815bab 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -132,6 +132,8 @@ struct mddev_s
 #define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
 #define MD_CHANGE_PENDING 2	/* superblock update in progress */
 
+	int				suspended;
+	atomic_t			active_io;
 	int				ro;
 
 	struct gendisk			*gendisk;


