From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/3 v2] raid1: percpu dispatch for write request if bitmap supported
Date: Mon, 28 May 2012 09:13:24 +0800
Message-ID: <20120528011551.258017754@kernel.org>
References: <20120528011322.058698078@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid1-write-percpulist.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

In raid1, all write requests are dispatched in raid1d thread. In fast storage,
the raid1d thread is a bottleneck, because it dispatches request too slow. Also
raid1d thread migrates freely, which makes request completion cpu not match
with submission cpu even driver/block layer has such capability. This will
cause bad cache issue.

If bitmap support is enabled, write requests can only be dispatched after dirty
bitmap is flushed out. After bitmap is flushed, how write requests are
dispatched doesn't impact correctness. A natural idea is to distribute request
dispatch to several threads. With this patch, requests are added to a percpu
list first. After bitmap is flushed, then the percpu list requests will
dispatched in a workqueue. In this way, above bottleneck is removed.

In a 4k randwrite test with a 2 disks setup, below patch can provide 10% ~ 50%
performance improvements depending on numa binding.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   97 +++++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid1.h |   10 ++++-
 2 files changed, 88 insertions(+), 19 deletions(-)

Index: linux/drivers/md/raid1.h
===================================================================
--- linux.orig/drivers/md/raid1.h	2012-05-24 15:41:58.940980194 +0800
+++ linux/drivers/md/raid1.h	2012-05-24 15:45:03.074656334 +0800
@@ -22,6 +22,14 @@ struct pool_info {
 	int	raid_disks;
 };
 
+struct write_list {
+	struct bio_list	pending_bio_list;
+	struct bio_list	running_bio_list;
+	struct bio_list	tmp_bio_list;
+	struct work_struct work;
+	struct r1conf *conf;
+};
+
 struct r1conf {
 	struct mddev		*mddev;
 	struct mirror_info	*mirrors;	/* twice 'raid_disks' to
@@ -50,7 +58,7 @@ struct r1conf {
 	struct list_head	retry_list;
 
 	/* queue pending writes to be submitted on unplug */
-	struct bio_list		pending_bio_list;
+	struct write_list __percpu *write_list;
 	int			pending_count;
 
 	/* for use when syncing mirrors:
Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-05-24 15:42:56.896251635 +0800
+++ linux/drivers/md/raid1.c	2012-05-24 15:45:03.074656334 +0800
@@ -687,22 +687,21 @@ static int raid1_congested(void *data, i
 		md_raid1_congested(mddev, bits);
 }
 
-static void flush_pending_writes(struct r1conf *conf)
+static void raid1_write_work(struct work_struct *work)
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
-		/* flush any pending bitmap writes to
-		 * disk before proceeding w/ I/O */
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
@@ -710,8 +709,53 @@ static void flush_pending_writes(struct
 			generic_make_request(bio);
 			bio = next;
 		}
-	} else
-		spin_unlock_irq(&conf->device_lock);
+	}
+	blk_finish_plug(&plug);
+}
+
+static void flush_pending_writes(struct r1conf *conf)
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
+				md_schedule_work_on(c, &list->work);
+			else {
+				int cpu = cpumask_any(cpu_online_mask);
+				md_schedule_work_on(cpu, &list->work);
+			}
+		}
+	}
+
+	spin_unlock_irq(&conf->device_lock);
 }
 
 /* Barriers....
@@ -1137,6 +1181,7 @@ read_again:
 	first_clone = 1;
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
+		struct write_list *list;
 		if (!r1_bio->bios[i])
 			continue;
 
@@ -1188,7 +1233,8 @@ read_again:
 
 		atomic_inc(&r1_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
+		list = this_cpu_ptr(conf->write_list);
+		bio_list_add(&list->pending_bio_list, mbio);
 		conf->pending_count++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
@@ -2572,7 +2618,6 @@ static struct r1conf *setup_conf(struct
 	spin_lock_init(&conf->resync_lock);
 	init_waitqueue_head(&conf->wait_barrier);
 
-	bio_list_init(&conf->pending_bio_list);
 	conf->pending_count = 0;
 	conf->recovery_disabled = mddev->recovery_disabled - 1;
 
@@ -2617,6 +2662,19 @@ static struct r1conf *setup_conf(struct
 		goto abort;
 	}
 	err = -ENOMEM;
+
+	conf->write_list = alloc_percpu(struct write_list);
+	if (!conf->write_list)
+		goto abort;
+	for_each_present_cpu(i) {
+		struct write_list *list = per_cpu_ptr(conf->write_list, i);
+		bio_list_init(&list->pending_bio_list);
+		bio_list_init(&list->running_bio_list);
+		bio_list_init(&list->tmp_bio_list);
+		INIT_WORK(&list->work, raid1_write_work);
+		list->conf = conf;
+	}
+
 	conf->thread = md_register_thread(raid1d, mddev, NULL);
 	if (!conf->thread) {
 		printk(KERN_ERR
@@ -2629,6 +2687,7 @@ static struct r1conf *setup_conf(struct
 
  abort:
 	if (conf) {
+		free_percpu(conf->write_list);
 		if (conf->r1bio_pool)
 			mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
@@ -2735,6 +2794,8 @@ static int stop(struct mddev *mddev)
 	lower_barrier(conf);
 
 	md_unregister_thread(&mddev->thread);
+	free_percpu(conf->write_list);
+
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);

