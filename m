From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC, PATCH] raid456: replace the handle_list with a
	multi-threaded workqueue
Date: Tue, 27 Feb 2007 19:10:57 -0700
Message-ID: <1172628657.19493.44.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently raid456 queues up work to a single raid5d thread per array.
Since there are no dependencies between operations on different stripes
I believed a speed up could be obtained by spreading the handle_stripe
load across all available CPU's.  However I am not seeing a speed up, as
measured by tiobench.  I think the reason is that multi-processor
effects will only show up when data is already in the cache.  In this
case the work is already spread out per client thread.  Also work
submitted to workqueues is sticky to the CPU where queue_work() was
called, not load balanced amongst the available CPUs.  I'm posting it
anyway to see if I am overlooking a case where it would be helpful, and
from a cosmetic standpoint it separates raid5d housekeeping work from
handle_stripe work.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |  108 ++++++++++++++++++++++++++------------------
 include/linux/raid/raid5.h |    6 ++
 2 files changed, 68 insertions(+), 46 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 11c3d7b..e54310c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -121,7 +121,10 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 				blk_plug_device(conf->mddev->queue);
 			} else {
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
-				list_add_tail(&sh->lru, &conf->handle_list);
+				conf->workqueue_stripes++;
+				atomic_inc(&sh->count);
+				BUG_ON(queue_work(conf->workqueue,
+					&sh->work) == 0);
 			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
@@ -310,6 +313,7 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
 				if (list_empty(&sh->lru) &&
+				    !work_pending(&sh->work) &&
 				    !test_bit(STRIPE_EXPANDING, &sh->state))
 					BUG();
 				list_del_init(&sh->lru);
@@ -324,6 +328,7 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 	return sh;
 }
 
+static void raid456_workqueue(struct work_struct *work);
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
@@ -343,6 +348,7 @@ static int grow_one_stripe(raid5_conf_t *conf)
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
+	INIT_WORK(&sh->work, raid456_workqueue);
 	INIT_LIST_HEAD(&sh->lru);
 	release_stripe(sh);
 	return 1;
@@ -2448,7 +2454,9 @@ static void raid5_activate_delayed(raid5_conf_t *conf)
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
-			list_add_tail(&sh->lru, &conf->handle_list);
+			conf->workqueue_stripes++;
+			atomic_inc(&sh->count);
+			BUG_ON(queue_work(conf->workqueue, &sh->work) == 0);
 		}
 	}
 }
@@ -3181,7 +3189,6 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 }
 
 
-
 /*
  * This is our raid5 kernel thread.
  *
@@ -3191,9 +3198,9 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
  */
 static void raid5d (mddev_t *mddev)
 {
-	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int handled;
+	struct bio *bio;
 
 	PRINTK("+++ raid5d active\n");
 
@@ -3201,51 +3208,30 @@ static void raid5d (mddev_t *mddev)
 
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
-	while (1) {
-		struct list_head *first;
-		struct bio *bio;
-
-		if (conf->seq_flush != conf->seq_write) {
-			int seq = conf->seq_flush;
-			spin_unlock_irq(&conf->device_lock);
-			bitmap_unplug(mddev->bitmap);
-			spin_lock_irq(&conf->device_lock);
-			conf->seq_write = seq;
-			activate_bit_delay(conf);
-		}
-
-		if (list_empty(&conf->handle_list) &&
-		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !blk_queue_plugged(mddev->queue) &&
-		    !list_empty(&conf->delayed_list))
-			raid5_activate_delayed(conf);
-
-		while ((bio = remove_bio_from_retry(conf))) {
-			int ok;
-			spin_unlock_irq(&conf->device_lock);
-			ok = retry_aligned_read(conf, bio);
-			spin_lock_irq(&conf->device_lock);
-			if (!ok)
-				break;
-			handled++;
-		}
 
-		if (list_empty(&conf->handle_list))
-			break;
+	if (conf->seq_flush != conf->seq_write) {
+		int seq = conf->seq_flush;
+		spin_unlock_irq(&conf->device_lock);
+		bitmap_unplug(mddev->bitmap);
+		spin_lock_irq(&conf->device_lock);
+		conf->seq_write = seq;
+		activate_bit_delay(conf);
+	}
 
-		first = conf->handle_list.next;
-		sh = list_entry(first, struct stripe_head, lru);
+	if (conf->workqueue_stripes == 0 &&
+	    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
+	    !blk_queue_plugged(conf->mddev->queue) &&
+	    !list_empty(&conf->delayed_list))
+		raid5_activate_delayed(conf);
 
-		list_del_init(first);
-		atomic_inc(&sh->count);
-		BUG_ON(atomic_read(&sh->count)!= 1);
+	while ((bio = remove_bio_from_retry(conf))) {
+		int ok;
 		spin_unlock_irq(&conf->device_lock);
-		
-		handled++;
-		handle_stripe(sh, conf->spare_page);
-		release_stripe(sh);
-
+		ok = retry_aligned_read(conf, bio);
 		spin_lock_irq(&conf->device_lock);
+		if (!ok)
+			break;
+		handled++;
 	}
 	PRINTK("%d stripes handled\n", handled);
 
@@ -3256,6 +3242,29 @@ static void raid5d (mddev_t *mddev)
 	PRINTK("--- raid5d inactive\n");
 }
 
+static void raid456_workqueue(struct work_struct *work)
+{
+	struct stripe_head *sh = container_of(work, struct stripe_head, work);
+	raid5_conf_t *conf = sh->raid_conf;
+	unsigned long flags;
+	int workqueue_stripes;
+
+	PRINTK("%s called for stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	handle_stripe(sh, conf->spare_page);
+
+	spin_lock_irqsave(&conf->device_lock, flags);
+	__release_stripe(conf, sh);
+	workqueue_stripes = --conf->workqueue_stripes;
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+
+	if (workqueue_stripes == 0)
+		raid5d(conf->mddev);
+	else if (unlikely(workqueue_stripes < 0))
+		BUG();
+}
+
 static ssize_t
 raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 {
@@ -3409,16 +3418,22 @@ static int run(mddev_t *mddev)
 		if (!conf->spare_page)
 			goto abort;
 	}
+
+	sprintf(conf->workqueue_name, "%s_work", mddev->gendisk->disk_name);
+	
+	if ((conf->workqueue = create_workqueue(conf->workqueue_name)) == NULL)
+		goto abort;
+
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
-	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
+	conf->workqueue_stripes = 0;
 
 	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
 
@@ -3574,6 +3589,8 @@ abort:
 		safe_put_page(conf->spare_page);
 		kfree(conf->disks);
 		kfree(conf->stripe_hashtbl);
+		if (conf->workqueue)
+			destroy_workqueue(conf->workqueue);
 		kfree(conf);
 	}
 	mddev->private = NULL;
@@ -3593,6 +3610,7 @@ static int stop(mddev_t *mddev)
 	kfree(conf->stripe_hashtbl);
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
+	destroy_workqueue(conf->workqueue);
 	kfree(conf->disks);
 	kfree(conf);
 	mddev->private = NULL;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index d8286db..3dc410e 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -136,6 +136,7 @@ struct stripe_head {
 	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
+	struct work_struct	work;			/* handle_stripe workqueue */
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
@@ -224,15 +225,18 @@ struct raid5_private_data {
 					    */
 	int			previous_raid_disks;
 
-	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
+	int			workqueue_stripes; /* stripes currently being handled */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
+
+	struct workqueue_struct	*workqueue;
+	char			workqueue_name[20];	
 	/* unfortunately we need two cache names as we temporarily have
 	 * two caches.
 	 */
