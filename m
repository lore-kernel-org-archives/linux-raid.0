From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md
 array.
Date: Wed, 3 Nov 2004 15:03:15 -0800
Message-ID: <20041103150315.47a7982e.akpm@osdl.org>
References: <20041102143440.12019.patches@notabene>
	<E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> As the unplug timer can potentially fire at any time, and
> and it access data that is released by the md ->stop function,
> we need to del_timer_sync before releasing that data.

I don't think I saw an update to this patch so I just knocked up the below
simple conversion.  If anyone can think up a nice description of what
blk_sync_queue() should do, it would be appreciated ;)



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/block/ll_rw_blk.c |   12 ++++++++++--
 25-akpm/drivers/md/linear.c       |    2 +-
 25-akpm/drivers/md/multipath.c    |    2 +-
 25-akpm/drivers/md/raid0.c        |    2 +-
 25-akpm/drivers/md/raid1.c        |    2 +-
 25-akpm/drivers/md/raid10.c       |    2 +-
 25-akpm/drivers/md/raid5.c        |    2 +-
 25-akpm/drivers/md/raid6main.c    |    2 +-
 25-akpm/include/linux/blkdev.h    |    1 +
 9 files changed, 18 insertions(+), 9 deletions(-)

diff -puN drivers/block/ll_rw_blk.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/block/ll_rw_blk.c
--- 25/drivers/block/ll_rw_blk.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/block/ll_rw_blk.c	Wed Nov  3 15:01:14 2004
@@ -1358,10 +1358,19 @@ void blk_stop_queue(request_queue_t *q)
 	blk_remove_plug(q);
 	set_bit(QUEUE_FLAG_STOPPED, &q->queue_flags);
 }
-
 EXPORT_SYMBOL(blk_stop_queue);
 
 /**
+ * blk_sync_queue - prepare to destroy a queue
+ * @q: the queue
+ */
+void blk_sync_queue(struct request_queue *q)
+{
+	del_timer_sync(&q->unplug_timer);
+}
+EXPORT_SYMBOL(blk_sync_queue);
+
+/**
  * blk_run_queue - run a single device queue
  * @q:	The queue to run
  */
@@ -1374,7 +1383,6 @@ void blk_run_queue(struct request_queue 
 	q->request_fn(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
-
 EXPORT_SYMBOL(blk_run_queue);
 
 /**
diff -puN drivers/md/linear.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/md/linear.c
--- 25/drivers/md/linear.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/md/linear.c	Wed Nov  3 15:01:14 2004
@@ -231,7 +231,7 @@ static int linear_stop (mddev_t *mddev)
 {
 	linear_conf_t *conf = mddev_to_conf(mddev);
   
-	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
+	blk_sync_queue(&mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf->hash_table);
 	kfree(conf);
 
diff -puN drivers/md/multipath.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/md/multipath.c
--- 25/drivers/md/multipath.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/md/multipath.c	Wed Nov  3 15:01:14 2004
@@ -566,7 +566,7 @@ static int multipath_stop (mddev_t *mdde
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
-	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
+	blk_sync_queue(&mddev->queue); /* the unplug fn references 'conf'*/
 	mempool_destroy(conf->pool);
 	kfree(conf->multipaths);
 	kfree(conf);
diff -puN drivers/md/raid0.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/md/raid0.c
--- 25/drivers/md/raid0.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/md/raid0.c	Wed Nov  3 15:01:14 2004
@@ -385,7 +385,7 @@ static int raid0_stop (mddev_t *mddev)
 {
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 
-	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
+	blk_sync_queue(&mddev->queue); /* the unplug fn references 'conf'*/
 	kfree (conf->hash_table);
 	conf->hash_table = NULL;
 	kfree (conf->strip_zone);
diff -puN drivers/md/raid10.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/md/raid10.c
--- 25/drivers/md/raid10.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/md/raid10.c	Wed Nov  3 15:01:14 2004
@@ -1744,7 +1744,7 @@ static int stop(mddev_t *mddev)
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
-	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
+	blk_sync_queue(&mddev->queue); /* the unplug fn references 'conf'*/
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	if (conf->mirrors)
diff -puN drivers/md/raid1.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/md/raid1.c
--- 25/drivers/md/raid1.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/md/raid1.c	Wed Nov  3 15:01:14 2004
@@ -1293,7 +1293,7 @@ static int stop(mddev_t *mddev)
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
-	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
+	blk_sync_queue(&mddev->queue); /* the unplug fn references 'conf'*/
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	if (conf->mirrors)
diff -puN drivers/md/raid5.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/md/raid5.c
--- 25/drivers/md/raid5.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/md/raid5.c	Wed Nov  3 15:01:14 2004
@@ -1707,7 +1707,7 @@ static int stop (mddev_t *mddev)
 	mddev->thread = NULL;
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
-	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
+	blk_sync_queue(&mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;
diff -puN drivers/md/raid6main.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup drivers/md/raid6main.c
--- 25/drivers/md/raid6main.c~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:14 2004
+++ 25-akpm/drivers/md/raid6main.c	Wed Nov  3 15:01:14 2004
@@ -1878,7 +1878,7 @@ static int stop (mddev_t *mddev)
 	mddev->thread = NULL;
 	shrink_stripes(conf);
 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
-	del_timer_sync(&mddev->queue->unplug_timer); /* the unplug fn references 'conf'*/
+	blk_sync_queue(&mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;
diff -puN include/linux/blkdev.h~md-delete-unplug-timer-before-shutting-down-md-array-cleanup include/linux/blkdev.h
--- 25/include/linux/blkdev.h~md-delete-unplug-timer-before-shutting-down-md-array-cleanup	Wed Nov  3 15:01:34 2004
+++ 25-akpm/include/linux/blkdev.h	Wed Nov  3 15:01:55 2004
@@ -522,6 +522,7 @@ extern int blk_hw_contig_segment(request
 extern int scsi_cmd_ioctl(struct file *, struct gendisk *, unsigned int, void __user *);
 extern void blk_start_queue(request_queue_t *q);
 extern void blk_stop_queue(request_queue_t *q);
+extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
_

