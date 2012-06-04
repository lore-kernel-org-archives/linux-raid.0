From: Shaohua Li <shli@kernel.org>
Subject: [patch 8/8] raid5: create multiple threads to handle stripes
Date: Mon, 04 Jun 2012 16:02:00 +0800
Message-ID: <20120604080354.686050081@kernel.org>
References: <20120604080152.098975870@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-multiple-threads.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Like raid 1/10, raid5 uses one thread to handle stripe. In a fast storage, the
thread becomes a bottleneck. raid5 can offload calculation like checksum to
async threads. And if storge is fast, scheduling async work and running async
work will introduce heavy lock contention of workqueue, which makes such
optimization useless. And calculation isn't the only bottleneck. For example,
in my test raid5 thread must handle > 450k requests per second. Just doing
dispatch and completion will make raid5 thread incapable. The only chance to
scale is using several threads to handle stripe.

With this patch, user can create several extra threads to handle stripe. How
many threads are better depending on disk number, so the thread number can be
changed in userspace. By default, the thread number is 0, which means no extra
thread.

In a 3-disk raid5 setup, 2 extra threads can provide 130% throughput
improvement (double stripe_cache_size) and the throughput is pretty close to
theory value. With >=4 disks, the improvement is even bigger, for example, can
improve 200% for 4-disk setup, but the throughput is far less than theory
value, which is caused by several factors like request queue lock contention,
cache issue, latency introduced by how a stripe is handled in different disks.
Those factors need further investigations.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.h |    2 
 2 files changed, 120 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-01 15:23:56.001992200 +0800
+++ linux/drivers/md/raid5.c	2012-06-04 11:54:25.775331361 +0800
@@ -4602,6 +4602,41 @@ static int __get_stripe_batch(struct r5c
 	return batch->count;
 }
 
+static void raid5auxd(struct mddev *mddev)
+{
+	struct r5conf *conf = mddev->private;
+	struct blk_plug plug;
+	struct stripe_head_batch batch;
+	int handled, i;
+
+	pr_debug("+++ raid5auxd active\n");
+
+	blk_start_plug(&plug);
+	handled = 0;
+	spin_lock_irq(&conf->device_lock);
+	while (1) {
+		if (!__get_stripe_batch(conf, &batch))
+			break;
+		spin_unlock_irq(&conf->device_lock);
+
+		for (i = 0; i < batch.count; i++) {
+			handled++;
+			handle_stripe(batch.stripes[i]);
+		}
+
+		release_stripe_flush_batch(&batch);
+		cond_resched();
+
+		spin_lock_irq(&conf->device_lock);
+	}
+	pr_debug("%d stripes handled\n", handled);
+
+	spin_unlock_irq(&conf->device_lock);
+	blk_finish_plug(&plug);
+
+	pr_debug("--- raid5auxd inactive\n");
+}
+
 /*
  * This is our raid5 kernel thread.
  *
@@ -4651,6 +4686,8 @@ static void raid5d(struct mddev *mddev)
 
 		if (!__get_stripe_batch(conf, &batch))
 			break;
+		for (i = 0; i < conf->aux_thread_num; i++)
+			md_wakeup_thread(conf->aux_threads[i]);
 		spin_unlock_irq(&conf->device_lock);
 
 		for (i = 0; i < batch.count; i++) {
@@ -4784,10 +4821,86 @@ stripe_cache_active_show(struct mddev *m
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static ssize_t
+raid5_show_auxthread_number(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf)
+		return sprintf(page, "%d\n", conf->aux_thread_num);
+	else
+		return 0;
+}
+
+static ssize_t
+raid5_store_auxthread_number(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new;
+	int i;
+	struct md_thread **threads;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	if (strict_strtoul(page, 10, &new))
+		return -EINVAL;
+
+	if (new == conf->aux_thread_num)
+		return len;
+
+	if (new > conf->aux_thread_num) {
+
+		threads = kmalloc(sizeof(struct md_thread *) * new, GFP_KERNEL);
+		if (!threads)
+			return -EFAULT;
+
+		i = conf->aux_thread_num;
+		while (i < new) {
+			char name[10];
+
+			sprintf(name, "aux%d", i);
+			threads[i] = md_register_thread(raid5auxd, mddev, name);
+			if (!threads[i])
+				goto error;
+			i++;
+		}
+		memcpy(threads, conf->aux_threads,
+			sizeof(struct md_thread *) * conf->aux_thread_num);
+		spin_lock_irq(&conf->device_lock);
+		kfree(conf->aux_threads);
+		conf->aux_threads = threads;
+		conf->aux_thread_num = new;
+		spin_unlock_irq(&conf->device_lock);
+	} else {
+		int old = conf->aux_thread_num;
+
+		spin_lock_irq(&conf->device_lock);
+		conf->aux_thread_num = new;
+		spin_unlock_irq(&conf->device_lock);
+		for (i = new; i < old; i++)
+			md_unregister_thread(&conf->aux_threads[i]);
+	}
+
+	return len;
+error:
+	while (--i >= conf->aux_thread_num)
+		md_unregister_thread(&threads[i]);
+	kfree(threads);
+	return -EFAULT;
+}
+
+static struct md_sysfs_entry
+raid5_auxthread_number = __ATTR(auxthread_number, S_IRUGO|S_IWUSR,
+				raid5_show_auxthread_number,
+				raid5_store_auxthread_number);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
+	&raid5_auxthread_number.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -4835,6 +4948,7 @@ static void raid5_free_percpu(struct r5c
 
 static void free_conf(struct r5conf *conf)
 {
+	kfree(conf->aux_threads);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
 	kfree(conf->disks);
@@ -5391,6 +5505,10 @@ abort:
 static int stop(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
+	int i;
+
+	for (i = 0; i < conf->aux_thread_num; i++)
+		md_unregister_thread(&conf->aux_threads[i]);
 
 	md_unregister_thread(&mddev->thread);
 	if (mddev->queue)
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-06-01 15:23:56.017991998 +0800
+++ linux/drivers/md/raid5.h	2012-06-01 15:27:12.515521685 +0800
@@ -463,6 +463,8 @@ struct r5conf {
 	 * the new thread here until we fully activate the array.
 	 */
 	struct md_thread	*thread;
+	int			aux_thread_num;
+	struct md_thread	**aux_threads;
 };
 
 /*

