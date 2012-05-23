From: Shaohua Li <shli@kernel.org>
Subject: [patch 4/4] raid10: percpu dispatch for write request if bitmap supported
Date: Wed, 23 May 2012 15:26:23 +0800
Message-ID: <20120523072857.298217738@kernel.org>
References: <20120523072619.670179001@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid10-write-percpulist.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

In raid10, all write requests are dispatched in raid10d thread. In fast
storage, the raid10d thread is a bottleneck, because it dispatches request too
slow. Also raid10d thread migrates freely, which makes request completion cpu
not match with submission cpu even driver/block layer has such capability. This
will cause bad cache issue.

If bitmap support is enabled, write requests can only be dispatched after dirty
bitmap is flushed out. After bitmap is flushed, how write requests are
dispatched doesn't impact correctness. A natural idea is to distribute request
dispatch to several threads. With this patch, requests are added to a percpu
list first. After bitmap is flushed, then the percpu list requests will
dispatched in a workqueue. In this way, above bottleneck is removed.

In a 4k randwrite test with a 4 disks setup, below patch can provide about 95%
performance improvements depending on numa binding.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid10.c |   97 ++++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid10.h |   10 ++++-
 2 files changed, 88 insertions(+), 19 deletions(-)

Index: linux/drivers/md/raid10.h
===================================================================
--- linux.orig/drivers/md/raid10.h	2012-05-22 19:19:42.945454678 +0800
+++ linux/drivers/md/raid10.h	2012-05-22 19:21:18.100256510 +0800
@@ -11,6 +11,14 @@ struct mirror_info {
 						 */
 };
 
+struct write_list {
+	struct bio_list	pending_bio_list;
+	struct bio_list	running_bio_list;
+	struct bio_list	tmp_bio_list;
+	struct work_struct work;
+	struct r10conf *conf;
+};
+
 struct r10conf {
 	struct mddev		*mddev;
 	struct mirror_info	*mirrors;
@@ -43,7 +51,7 @@ struct r10conf {
 
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
-	struct bio_list		pending_bio_list;
+	struct write_list __percpu *write_list;
 	int			pending_count;
 
 	spinlock_t		resync_lock;
Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2012-05-22 19:21:17.216269521 +0800
+++ linux/drivers/md/raid10.c	2012-05-22 19:21:46.867897039 +0800
@@ -824,22 +824,21 @@ static int raid10_congested(void *data,
 	return ret;
 }
 
-static void flush_pending_writes(struct r10conf *conf)
+static void raid10_write_work(struct work_struct *work)
 {
-	/* Any writes that have been queued but are awaiting
-	 * bitmap updates get flushed here.
-	 */
-	spin_lock_irq(&conf->device_lock);
+	struct write_list *list = container_of(work, struct write_list, work);
+	struct bio *bio;
+	struct blk_plug plug;
+	bool try_again = true;
 
-	if (conf->pending_bio_list.head) {
-		struct bio *bio;
-		bio = bio_list_get(&conf->pending_bio_list);
-		conf->pending_count = 0;
-		spin_unlock_irq(&conf->device_lock);
-		/* flush any pending bitmap writes to disk
-		 * before proceeding w/ I/O */
-		bitmap_unplug(conf->mddev->bitmap);
-		wake_up(&conf->wait_barrier);
+	blk_start_plug(&plug);
+
+	while (try_again) {
+		spin_lock_irq(&list->conf->device_lock);
+		bio = bio_list_get(&list->running_bio_list);
+		spin_unlock_irq(&list->conf->device_lock);
+
+		try_again = (bio != NULL);
 
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
@@ -847,8 +846,52 @@ static void flush_pending_writes(struct
 			generic_make_request(bio);
 			bio = next;
 		}
-	} else
-		spin_unlock_irq(&conf->device_lock);
+	}
+	blk_finish_plug(&plug);
+}
+
+static void flush_pending_writes(struct r10conf *conf)
+{
+	int c;
+	struct write_list *list;
+
+	/* Any writes that have been queued but are awaiting
+	 * bitmap updates get flushed here.
+	 */
+	spin_lock_irq(&conf->device_lock);
+
+	for_each_present_cpu(c) {
+		list = per_cpu_ptr(conf->write_list, c);
+		if (!bio_list_empty(&list->pending_bio_list)) {
+			bio_list_merge(&list->tmp_bio_list,
+				      &list->pending_bio_list);
+			bio_list_init(&list->pending_bio_list);
+		}
+	}
+
+	conf->pending_count = 0;
+	spin_unlock_irq(&conf->device_lock);
+
+	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
+	bitmap_unplug(conf->mddev->bitmap);
+	wake_up(&conf->wait_barrier);
+
+	spin_lock_irq(&conf->device_lock);
+	for_each_present_cpu(c) {
+		list = per_cpu_ptr(conf->write_list, c);
+		if (!bio_list_empty(&list->tmp_bio_list)) {
+			bio_list_merge(&list->running_bio_list,
+				       &list->tmp_bio_list);
+			bio_list_init(&list->tmp_bio_list);
+			if (likely(cpu_online(c)))
+				schedule_work_on(c, &list->work);
+			else
+				schedule_work_on(cpumask_any(cpu_online_mask),
+						 &list->work);
+		}
+	}
+
+	spin_unlock_irq(&conf->device_lock);
 }
 
 /* Barriers....
@@ -1305,8 +1348,10 @@ retry_write:
 
 		atomic_inc(&r10_bio->remaining);
 		if (mddev->bitmap) {
+			struct write_list *list;
 			spin_lock_irqsave(&conf->device_lock, flags);
-			bio_list_add(&conf->pending_bio_list, mbio);
+			list = this_cpu_ptr(conf->write_list);
+			bio_list_add(&list->pending_bio_list, mbio);
 			conf->pending_count++;
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 		} else
@@ -1333,8 +1378,10 @@ retry_write:
 
 		atomic_inc(&r10_bio->remaining);
 		if (mddev->bitmap) {
+			struct write_list *list;
 			spin_lock_irqsave(&conf->device_lock, flags);
-			bio_list_add(&conf->pending_bio_list, mbio);
+			list = this_cpu_ptr(conf->write_list);
+			bio_list_add(&list->pending_bio_list, mbio);
 			conf->pending_count++;
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 		} else
@@ -3261,6 +3308,18 @@ static struct r10conf *setup_conf(struct
 	spin_lock_init(&conf->resync_lock);
 	init_waitqueue_head(&conf->wait_barrier);
 
+	conf->write_list = alloc_percpu(struct write_list);
+	if (!conf->write_list)
+		goto out;
+	for_each_present_cpu(nc) {
+		struct write_list *list = per_cpu_ptr(conf->write_list, nc);
+		bio_list_init(&list->pending_bio_list);
+		bio_list_init(&list->running_bio_list);
+		bio_list_init(&list->tmp_bio_list);
+		INIT_WORK(&list->work, raid10_write_work);
+		list->conf = conf;
+	}
+
 	conf->thread = md_register_thread(raid10d, mddev, NULL);
 	if (!conf->thread)
 		goto out;
@@ -3272,6 +3331,7 @@ static struct r10conf *setup_conf(struct
 	printk(KERN_ERR "md/raid10:%s: couldn't allocate memory.\n",
 	       mdname(mddev));
 	if (conf) {
+		free_percpu(conf->write_list);
 		if (conf->r10bio_pool)
 			mempool_destroy(conf->r10bio_pool);
 		kfree(conf->mirrors);
@@ -3427,6 +3487,7 @@ static int stop(struct mddev *mddev)
 
 	md_unregister_thread(&mddev->thread);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
+	free_percpu(conf->write_list);
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	kfree(conf->mirrors);

