From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 2 of 22 - Make device plugging work for md/raid5
Date: Wed, 19 Jun 2002 10:45:36 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54320.248237.433265@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




We embed a request_queue_t in the mddev structure and so
have a separate one for each mddev.
This is used for plugging (in raid5).

Given this embeded request_queue_t, md_make_request no-longer
needs to make from device number to mddev, but can map from
the queue to the mddev instead.


 ----------- Diffstat output ------------
 ./drivers/md/md.c            |   25 ++++++++++++++++++++++---
 ./drivers/md/raid5.c         |   24 +++++++++---------------
 ./include/linux/raid/md_k.h  |    2 ++
 ./include/linux/raid/raid5.h |    5 +----
 4 files changed, 34 insertions(+), 22 deletions(-)

--- ./drivers/md/md.c	2002/06/17 23:28:59	1.2
+++ ./drivers/md/md.c	2002/06/18 03:26:36	1.3
@@ -172,7 +172,7 @@
 
 static int md_make_request (request_queue_t *q, struct bio *bio)
 {
-	mddev_t *mddev = kdev_to_mddev(to_kdev_t(bio->bi_bdev->bd_dev));
+	mddev_t *mddev = q->queuedata;
 
 	if (mddev && mddev->pers)
 		return mddev->pers->make_request(mddev, bio_rw(bio), bio);
@@ -182,6 +182,12 @@
 	}
 }
 
+static int md_fail_request (request_queue_t *q, struct bio *bio)
+{
+	bio_io_error(bio);
+	return 0;
+}
+
 static mddev_t * alloc_mddev(kdev_t dev)
 {
 	mddev_t *mddev;
@@ -1711,6 +1717,9 @@
 	}
 	mddev->pers = pers[pnum];
 
+	blk_queue_make_request(&mddev->queue, md_make_request);
+	mddev->queue.queuedata = mddev;
+
 	err = mddev->pers->run(mddev);
 	if (err) {
 		printk(KERN_ERR "md: pers->run() failed ...\n");
@@ -3616,6 +3625,15 @@
 #endif
 }
 
+request_queue_t * md_queue_proc(kdev_t dev)
+{
+	mddev_t *mddev = kdev_to_mddev(dev);
+	if (mddev == NULL)
+		return BLK_DEFAULT_QUEUE(MAJOR_NR);
+	else
+		return &mddev->queue;
+}
+
 int __init md_init(void)
 {
 	static char * name = "mdrecoveryd";
@@ -3640,8 +3658,9 @@
 			S_IFBLK | S_IRUSR | S_IWUSR, &md_fops, NULL);
 	}
 
-	/* forward all md request to md_make_request */
-	blk_queue_make_request(BLK_DEFAULT_QUEUE(MAJOR_NR), md_make_request);
+	/* all requests on an uninitialised device get failed... */
+	blk_queue_make_request(BLK_DEFAULT_QUEUE(MAJOR_NR), md_fail_request);
+	blk_dev[MAJOR_NR].queue = md_queue_proc;
 
 	add_gendisk(&md_gendisk);
 
--- ./drivers/md/raid5.c	2002/06/17 23:38:44	1.3
+++ ./drivers/md/raid5.c	2002/06/18 03:26:36	1.4
@@ -1225,14 +1225,15 @@
 }
 static void raid5_unplug_device(void *data)
 {
-	raid5_conf_t *conf = (raid5_conf_t *)data;
+	request_queue_t *q = data;
+	mddev_t *mddev = q->queuedata;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
-	raid5_activate_delayed(conf);
-	
-	conf->plugged = 0;
+	if (blk_remove_plug(q))
+		raid5_activate_delayed(conf);
 	md_wakeup_thread(conf->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -1241,17 +1242,13 @@
 static inline void raid5_plug_device(raid5_conf_t *conf)
 {
 	spin_lock_irq(&conf->device_lock);
-	if (list_empty(&conf->delayed_list))
-		if (!conf->plugged) {
-			conf->plugged = 1;
-			queue_task(&conf->plug_tq, &tq_disk);
-		}
+	blk_plug_device(&conf->mddev->queue);
 	spin_unlock_irq(&conf->device_lock);
 }
 
 static int make_request (mddev_t *mddev, int rw, struct bio * bi)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
 	const unsigned int raid_disks = conf->raid_disks;
 	const unsigned int data_disks = raid_disks - 1;
 	unsigned int dd_idx, pd_idx;
@@ -1352,7 +1349,7 @@
 
 		if (list_empty(&conf->handle_list) &&
 		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !conf->plugged &&
+		    !blk_queue_plugged(&mddev->queue) &&
 		    !list_empty(&conf->delayed_list))
 			raid5_activate_delayed(conf);
 
@@ -1443,10 +1440,7 @@
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 
-	conf->plugged = 0;
-	conf->plug_tq.sync = 0;
-	conf->plug_tq.routine = &raid5_unplug_device;
-	conf->plug_tq.data = conf;
+	mddev->queue.unplug_fn = raid5_unplug_device;
 
 	PRINTK("raid5: run(md%d) called.\n", mdidx(mddev));
 
--- ./include/linux/raid/md_k.h	2002/06/17 23:33:53	1.1
+++ ./include/linux/raid/md_k.h	2002/06/18 03:26:36	1.2
@@ -214,6 +214,8 @@
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 
+	request_queue_t			queue;	/* for plugging ... */
+
 	struct list_head		all_mddevs;
 };
 
--- ./include/linux/raid/raid5.h	2002/06/17 23:33:53	1.1
+++ ./include/linux/raid/raid5.h	2002/06/18 03:26:36	1.2
@@ -176,7 +176,7 @@
  * is put on a "delayed" queue until there are no stripes currently
  * in a pre-read phase.  Further, if the "delayed" queue is empty when
  * a stripe is put on it then we "plug" the queue and do not process it
- * until an unplg call is made. (the tq_disk list is run).
+ * until an unplug call is made. (blk_run_queues is run).
  *
  * When preread is initiated on a stripe, we set PREREAD_ACTIVE and add
  * it to the count of prereading stripes.
@@ -228,9 +228,6 @@
 							 * waiting for 25% to be free
 							 */        
 	spinlock_t		device_lock;
-
-	int			plugged;
-	struct tq_struct	plug_tq;
 };
 
 typedef struct raid5_private_data raid5_conf_t;
