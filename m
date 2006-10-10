From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Tue, 10 Oct 2006 10:08:48 +1000
Message-ID: <17706.58512.374925.103556@cse.unsw.edu.au>
References: <17532.59212.364233.765155@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>
	<17532.62343.933852.982391@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>
	<17534.22056.981033.686846@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>
	<17535.59496.431182.785563@cse.unsw.edu.au>
	<448F0994.6050704@tmr.com>
	<17551.18061.160356.35034@cse.unsw.!edu.au>
	<4528377A.2010001@cjx.com>
	<20061009110344.GA7104@cjx.com>
	<17706.54775.830279.53938@cse.unsw.edu.au>
	<452AD986.1010304@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Allen on Tuesday October 10
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 10, chris@cjx.com wrote:
> 
> Very happy to. Let me know what you'd like me to do.

Cool thanks.

At the end is a patch against 2.6.17.11, though it should apply against
any later 2.6.17 kernel.
Apply this and reboot.

Then run

       while true
       do cat /sys/block/mdX/md/stripe_cache_active
          sleep 10
       done > /dev/null

(maybe write a little script or whatever).  Leave this running. It
effects the check for "has raid5 hung".  Make sure to change "mdX" to
whatever is appropriate.

Occasionally look in the kernel logs for
   plug problem:

if you find that, send me the surrounding text - there should be about
a dozen lines following this one.

Hopefully this will let me know which is last thing to happen: a plug
or an unplug.
If the last is a "plug", then the timer really should still be
pending, but isn't (this is impossible).  So I'll look more closely at
that option.
If the last is an "unplug", then the 'Plugged' flag should really be
clear but it isn't (this is impossible).  So I'll look more closely at
that option.

Dean is running this, but he only gets the hang every couple of
weeks.  If you get it more often, that would help me a lot.

Thanks,
NeilBrown


diff ./.patches/orig/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- ./.patches/orig/block/ll_rw_blk.c	2006-08-21 09:52:46.000000000 +1000
+++ ./block/ll_rw_blk.c	2006-10-05 11:33:32.000000000 +1000
@@ -1546,6 +1546,7 @@ static int ll_merge_requests_fn(request_
  * This is called with interrupts off and no requests on the queue and
  * with the queue lock held.
  */
+static atomic_t seq = ATOMIC_INIT(0);
 void blk_plug_device(request_queue_t *q)
 {
 	WARN_ON(!irqs_disabled());
@@ -1558,9 +1559,16 @@ void blk_plug_device(request_queue_t *q)
 		return;
 
 	if (!test_and_set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
+		q->last_plug = jiffies;
+		q->plug_seq = atomic_read(&seq);
+		atomic_inc(&seq);
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
 		blk_add_trace_generic(q, NULL, 0, BLK_TA_PLUG);
-	}
+	} else
+		q->last_plug_skip = jiffies;
+	if (!timer_pending(&q->unplug_timer) &&
+	    !q->unplug_work.pending)
+		printk("Neither Timer or work are pending\n");
 }
 
 EXPORT_SYMBOL(blk_plug_device);
@@ -1573,10 +1581,17 @@ int blk_remove_plug(request_queue_t *q)
 {
 	WARN_ON(!irqs_disabled());
 
-	if (!test_and_clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
+	if (!test_and_clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags)) {
+		q->last_unplug_skip = jiffies;
 		return 0;
+	}
 
 	del_timer(&q->unplug_timer);
+	q->last_unplug = jiffies;
+	q->unplug_seq = atomic_read(&seq);
+	atomic_inc(&seq);
+	if (test_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags))
+		printk("queue still (or again) plugged\n");
 	return 1;
 }
 
@@ -1635,7 +1650,7 @@ static void blk_backing_dev_unplug(struc
 static void blk_unplug_work(void *data)
 {
 	request_queue_t *q = data;
-
+	q->last_unplug_work = jiffies;
 	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
@@ -1649,6 +1664,7 @@ static void blk_unplug_timeout(unsigned 
 	blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_TIMER, NULL,
 				q->rq.count[READ] + q->rq.count[WRITE]);
 
+	q->last_unplug_timeout = jiffies;
 	kblockd_schedule_work(&q->unplug_work);
 }
 

diff ./.patches/orig/drivers/md/raid1.c ./drivers/md/raid1.c
--- ./.patches/orig/drivers/md/raid1.c	2006-08-10 17:28:01.000000000 +1000
+++ ./drivers/md/raid1.c	2006-09-04 21:58:31.000000000 +1000
@@ -1486,7 +1486,6 @@ static void raid1d(mddev_t *mddev)
 							d = conf->raid_disks;
 						d--;
 						rdev = conf->mirrors[d].rdev;
-						atomic_add(s, &rdev->corrected_errors);
 						if (rdev &&
 						    test_bit(In_sync, &rdev->flags)) {
 							if (sync_page_io(rdev->bdev,
@@ -1509,6 +1508,9 @@ static void raid1d(mddev_t *mddev)
 									 s<<9, conf->tmppage, READ) == 0)
 								/* Well, this device is dead */
 								md_error(mddev, rdev);
+							else
+								atomic_add(s, &rdev->corrected_errors);
+
 						}
 					}
 				} else {

diff ./.patches/orig/drivers/md/raid5.c ./drivers/md/raid5.c
--- ./.patches/orig/drivers/md/raid5.c	2006-08-10 17:28:01.000000000 +1000
+++ ./drivers/md/raid5.c	2006-09-25 11:11:59.000000000 +1000
@@ -93,6 +93,8 @@ static void __release_stripe(raid5_conf_
 					md_wakeup_thread(conf->mddev->thread);
 			}
 			atomic_dec(&conf->active_stripes);
+			if (atomic_read(&conf->active_stripes) < conf->low_size)
+				conf->low_size = atomic_read(&conf->active_stripes);
 			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->inactive_list);
 				wake_up(&conf->wait_for_stripe);
@@ -1677,7 +1679,12 @@ static void raid5_unplug_device(request_
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
+	if (conf->dotrace)
+		printk(" trace unplug_device\n");
+
 	if (blk_remove_plug(q)) {
+		if (conf->dotrace)
+			printk(" trace remove plug\n");
 		conf->seq_flush++;
 		raid5_activate_delayed(conf);
 	}
@@ -1721,6 +1728,8 @@ static int raid5_issue_flush(request_que
 static inline void raid5_plug_device(raid5_conf_t *conf)
 {
 	spin_lock_irq(&conf->device_lock);
+	if (conf->dotrace)
+		printk(" trace plug device\n");
 	blk_plug_device(conf->mddev->queue);
 	spin_unlock_irq(&conf->device_lock);
 }
@@ -2154,6 +2163,42 @@ static ssize_t
 stripe_cache_active_show(mddev_t *mddev, char *page)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
+
+	/* tracing */
+	if (conf->dotrace) {
+		conf->dotrace = 0;
+		printk("end trace, force unplug\n");
+		raid5_unplug_device(mddev->queue);
+		raid5_unplug_device(mddev->queue);
+	} else {
+		if (conf->last_size > conf->max_nr_stripes/2 &&
+		    conf->last_size <= conf->low_size) {
+			conf->dotrace = 1;
+			printk("plug problem: low_size=%d\n", conf->low_size);
+			printk(" blk_queue_plugged = %d\n", blk_queue_plugged(mddev->queue));
+			printk(" flags = %lx\n", mddev->queue->queue_flags);
+			printk(" unplug_delay = %lu (HZ=%d)\n", mddev->queue->unplug_delay, HZ);
+			printk(" timer->expires %lu (jiffies %lu)\n",
+			       mddev->queue->unplug_timer.expires, jiffies);
+			printk(" pending = %d\n", timer_pending(&mddev->queue->unplug_timer));
+			printk(" wq_pending = %lx\n", mddev->queue->unplug_work.pending);
+			printk(" wq_entry empty? %d\n", list_empty(&mddev->queue->unplug_work.entry));
+			printk(" unplug=%lu unplug_skip=%lu\n",
+			       mddev->queue->last_unplug,
+			       mddev->queue->last_unplug_skip);
+			printk(" plug=%lu plug_skip=%lu\n",
+			       mddev->queue->last_plug,
+			       mddev->queue->last_plug_skip);
+			printk(" unplug_work=%lu unplug_timeout=%lu\n",
+			       mddev->queue->last_unplug_work,
+			       mddev->queue->last_unplug_timeout);
+			printk(" unplug_seq=%lu plug_seq=%lu\n",
+			       mddev->queue->unplug_seq,
+			       mddev->queue->plug_seq);
+		}
+		conf->last_size = atomic_read(&conf->active_stripes);
+		conf->low_size = conf->last_size;
+	}
 	if (conf)
 		return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
 	else

diff ./.patches/orig/include/linux/blkdev.h ./include/linux/blkdev.h
--- ./.patches/orig/include/linux/blkdev.h	2006-08-10 17:28:48.000000000 +1000
+++ ./include/linux/blkdev.h	2006-09-25 11:08:27.000000000 +1000
@@ -380,6 +380,9 @@ struct request_queue
 	 */
 	unsigned long		queue_flags;
 
+	unsigned long last_unplug, last_unplug_skip, last_plug, last_plug_skip;
+	unsigned long last_unplug_work, last_unplug_timeout;
+	unsigned long unplug_seq, plug_seq;
 	/*
 	 * protects queue structures from reentrancy. ->__queue_lock should
 	 * _never_ be used directly, it is queue private. always use

diff ./.patches/orig/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- ./.patches/orig/include/linux/raid/raid5.h	2006-08-10 17:28:53.000000000 +1000
+++ ./include/linux/raid/raid5.h	2006-08-28 14:09:32.000000000 +1000
@@ -245,6 +245,10 @@ struct raid5_private_data {
 
 	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
 
+	int dotrace;
+	int last_size;
+	int low_size;
+
 	/*
 	 * Free stripes pool
 	 */
