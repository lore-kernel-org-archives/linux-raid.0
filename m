From: Shaohua Li <shli@kernel.org>
Subject: [RFC]raid5: multiple thread handle stripe
Date: Mon, 9 Jul 2012 16:00:24 +0800
Message-ID: <20120709080024.GA801@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@intel.com
List-Id: linux-raid.ids

I had another implementation of raid5 mult-thread. The basic idea is to record
stripe submitted CPU. Each cpu has a thread, which only handles stripes
submitted from this cpu.

Dan mentioned similar idea several day ago. I used to think we need make
conf->device_lock per-cpu to make this work, but turn out that isn't required.
Simply using percpu list and still using global device_lock works here.
Performance is good too.

This is a RFC patch, I'll resubmit in a better reviewable way if you like the idea.


---
 drivers/md/md.c        |    7 +
 drivers/md/md.h        |    7 +
 drivers/md/multipath.c |    3 
 drivers/md/raid1.c     |    3 
 drivers/md/raid10.c    |    3 
 drivers/md/raid5.c     |  182 +++++++++++++++++++++++++++++++++++--------------
 drivers/md/raid5.h     |    4 -
 7 files changed, 148 insertions(+), 61 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-07-09 01:25:37.522848182 -0600
+++ linux/drivers/md/raid5.c	2012-07-09 01:27:43.202847084 -0600
@@ -208,8 +208,17 @@ static void handle_release_stripe(struct
 			   sh->bm_seq - conf->seq_write > 0)
 			list_add_tail(&sh->lru, &conf->bitmap_list);
 		else {
+			int cpu = sh->cpu;
+			struct raid5_percpu *percpu;
+			if (!cpu_online(cpu)) {
+				cpu = cpumask_any(cpu_online_mask);
+				sh->cpu = cpu;
+			}
+			percpu = per_cpu_ptr(conf->percpu, cpu);
 			clear_bit(STRIPE_BIT_DELAY, &sh->state);
-			list_add_tail(&sh->lru, &conf->handle_list);
+			list_add_tail(&sh->lru, &percpu->handle_list);
+			md_wakeup_thread(percpu->aux_thread);
+			return;
 		}
 		md_wakeup_thread(conf->mddev->thread);
 	} else {
@@ -354,6 +363,7 @@ static void init_stripe(struct stripe_he
 		raid5_build_block(sh, i, previous);
 	}
 	insert_hash(conf, sh);
+	sh->cpu = smp_processor_id();
 }
 
 static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
@@ -3646,12 +3656,19 @@ static void raid5_activate_delayed(struc
 		while (!list_empty(&conf->delayed_list)) {
 			struct list_head *l = conf->delayed_list.next;
 			struct stripe_head *sh;
+			int cpu;
 			sh = list_entry(l, struct stripe_head, lru);
 			list_del_init(l);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			list_add_tail(&sh->lru, &conf->hold_list);
+			cpu = sh->cpu;
+			if (!cpu_online(cpu)) {
+				cpu = cpumask_any(cpu_online_mask);
+				sh->cpu = cpu;
+			}
+			md_wakeup_thread(per_cpu_ptr(conf->percpu, cpu)->aux_thread);
 		}
 	}
 }
@@ -3924,18 +3941,20 @@ static int chunk_aligned_read(struct mdd
  * head of the hold_list has changed, i.e. the head was promoted to the
  * handle_list.
  */
-static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
+static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int cpu)
 {
-	struct stripe_head *sh;
+	struct stripe_head *sh = NULL, *tmp;
+	struct list_head *handle_list =
+			&per_cpu_ptr(conf->percpu, cpu)->handle_list;
 
 	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\n",
 		  __func__,
-		  list_empty(&conf->handle_list) ? "empty" : "busy",
+		  list_empty(handle_list) ? "empty" : "busy",
 		  list_empty(&conf->hold_list) ? "empty" : "busy",
 		  atomic_read(&conf->pending_full_writes), conf->bypass_count);
 
-	if (!list_empty(&conf->handle_list)) {
-		sh = list_entry(conf->handle_list.next, typeof(*sh), lru);
+	if (!list_empty(handle_list)) {
+		sh = list_entry(handle_list->next, typeof(*sh), lru);
 
 		if (list_empty(&conf->hold_list))
 			conf->bypass_count = 0;
@@ -3953,12 +3972,20 @@ static struct stripe_head *__get_priorit
 		   ((conf->bypass_threshold &&
 		     conf->bypass_count > conf->bypass_threshold) ||
 		    atomic_read(&conf->pending_full_writes) == 0)) {
-		sh = list_entry(conf->hold_list.next,
-				typeof(*sh), lru);
-		conf->bypass_count -= conf->bypass_threshold;
-		if (conf->bypass_count < 0)
-			conf->bypass_count = 0;
-	} else
+		list_for_each_entry(tmp, &conf->hold_list,  lru) {
+			if (tmp->cpu == cpu || !cpu_online(tmp->cpu)) {
+				sh = tmp;
+				break;
+			}
+		}
+
+		if (sh) {
+			conf->bypass_count -= conf->bypass_threshold;
+			if (conf->bypass_count < 0)
+				conf->bypass_count = 0;
+		}
+	}
+	if (!sh)
 		return NULL;
 
 	list_del_init(&sh->lru);
@@ -4551,13 +4578,13 @@ static int  retry_aligned_read(struct r5
 }
 
 #define MAX_STRIPE_BATCH 8
-static int handle_active_stripes(struct r5conf *conf)
+static int handle_active_stripes(struct r5conf *conf, int cpu)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
 	int i, batch_size = 0;
 
 	while (batch_size < MAX_STRIPE_BATCH &&
-			(sh = __get_priority_stripe(conf)) != NULL)
+			(sh = __get_priority_stripe(conf, cpu)) != NULL)
 		batch[batch_size++] = sh;
 
 	if (batch_size == 0)
@@ -4575,6 +4602,35 @@ static int handle_active_stripes(struct
 	return batch_size;
 }
 
+static void raid5auxd(struct md_thread *thread)
+{
+	struct mddev *mddev = thread->mddev;
+	struct r5conf *conf = mddev->private;
+	struct blk_plug plug;
+	int handled;
+	int cpu = (long)thread->thread_data;
+
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	pr_debug("+++ raid5auxd active\n");
+
+	blk_start_plug(&plug);
+	handled = 0;
+	spin_lock_irq(&conf->device_lock);
+	while (1) {
+		int batch_size;
+
+		batch_size = handle_active_stripes(conf, cpu);
+		if (!batch_size)
+			break;
+		handled += batch_size;
+	}
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
@@ -4582,11 +4638,13 @@ static int handle_active_stripes(struct
  * During the scan, completed stripes are saved for us by the interrupt
  * handler, so that they will not have to wait for our next wakeup.
  */
-static void raid5d(struct mddev *mddev)
+static void raid5d(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct r5conf *conf = mddev->private;
 	int handled;
 	struct blk_plug plug;
+	struct bio *bio;
 
 	pr_debug("+++ raid5d active\n");
 
@@ -4595,43 +4653,34 @@ static void raid5d(struct mddev *mddev)
 	blk_start_plug(&plug);
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
-	while (1) {
-		struct bio *bio;
-		int batch_size;
 
-		if (atomic_read(&mddev->plug_cnt) == 0 &&
+	if (atomic_read(&mddev->plug_cnt) == 0 &&
 		    !list_empty(&conf->bitmap_list)) {
-			/* Now is a good time to flush some bitmap updates */
-			conf->seq_flush++;
-			spin_unlock_irq(&conf->device_lock);
-			bitmap_unplug(mddev->bitmap);
-			spin_lock_irq(&conf->device_lock);
-			conf->seq_write = conf->seq_flush;
-			activate_bit_delay(conf);
-		}
-		if (atomic_read(&mddev->plug_cnt) == 0)
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
+		/* Now is a good time to flush some bitmap updates */
+		conf->seq_flush++;
+		spin_unlock_irq(&conf->device_lock);
+		bitmap_unplug(mddev->bitmap);
+		spin_lock_irq(&conf->device_lock);
+		conf->seq_write = conf->seq_flush;
+		activate_bit_delay(conf);
+	}
+	if (atomic_read(&mddev->plug_cnt) == 0)
+		raid5_activate_delayed(conf);
 
-		batch_size = handle_active_stripes(conf);
-		if (!batch_size)
+	while ((bio = remove_bio_from_retry(conf))) {
+		int ok;
+		spin_unlock_irq(&conf->device_lock);
+		ok = retry_aligned_read(conf, bio);
+		spin_lock_irq(&conf->device_lock);
+		if (!ok)
 			break;
-		handled += batch_size;
+		handled++;
+	}
 
-		if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
-			spin_unlock_irq(&conf->device_lock);
-			md_check_recovery(mddev);
-			spin_lock_irq(&conf->device_lock);
-		}
+	if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
+		spin_unlock_irq(&conf->device_lock);
+		md_check_recovery(mddev);
+		spin_lock_irq(&conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
@@ -4791,6 +4840,7 @@ static void raid5_free_percpu(struct r5c
 		percpu = per_cpu_ptr(conf->percpu, cpu);
 		safe_put_page(percpu->spare_page);
 		kfree(percpu->scribble);
+		md_unregister_thread(&percpu->aux_thread);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
 	unregister_cpu_notifier(&conf->cpu_notify);
@@ -4815,6 +4865,7 @@ static int raid456_cpu_notify(struct not
 {
 	struct r5conf *conf = container_of(nfb, struct r5conf, cpu_notify);
 	long cpu = (long)hcpu;
+	long anycpu;
 	struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
 
 	switch (action) {
@@ -4824,8 +4875,18 @@ static int raid456_cpu_notify(struct not
 			percpu->spare_page = alloc_page(GFP_KERNEL);
 		if (!percpu->scribble)
 			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
+		if (!percpu->aux_thread) {
+			char name[10];
+
+			snprintf(name, 10, "aux%ld", cpu);
+			percpu->aux_thread = md_register_thread(raid5auxd,
+							conf->mddev, name);
+			if (percpu->aux_thread)
+				percpu->aux_thread->thread_data = (void *)cpu;
+			INIT_LIST_HEAD(&(percpu->handle_list));
+		}
 
-		if (!percpu->scribble ||
+		if (!percpu->scribble || !percpu->aux_thread ||
 		    (conf->level == 6 && !percpu->spare_page)) {
 			safe_put_page(percpu->spare_page);
 			kfree(percpu->scribble);
@@ -4836,6 +4897,14 @@ static int raid456_cpu_notify(struct not
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		md_unregister_thread(&percpu->aux_thread);
+
+		spin_lock_irq(&conf->device_lock);
+		anycpu = cpumask_any(cpu_online_mask);
+		list_splice_tail_init(&percpu->handle_list,
+			&per_cpu_ptr(conf->percpu, anycpu)->handle_list);
+		spin_unlock_irq(&conf->device_lock);
+
 		safe_put_page(percpu->spare_page);
 		kfree(percpu->scribble);
 		percpu->spare_page = NULL;
@@ -4864,20 +4933,32 @@ static int raid5_alloc_percpu(struct r5c
 	get_online_cpus();
 	err = 0;
 	for_each_present_cpu(cpu) {
+		struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
+		char name[10];
+
 		if (conf->level == 6) {
 			spare_page = alloc_page(GFP_KERNEL);
 			if (!spare_page) {
 				err = -ENOMEM;
 				break;
 			}
-			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
+			percpu->spare_page = spare_page;
 		}
 		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
 		if (!scribble) {
 			err = -ENOMEM;
 			break;
 		}
-		per_cpu_ptr(conf->percpu, cpu)->scribble = scribble;
+		percpu->scribble = scribble;
+		snprintf(name, 10, "aux%ld", cpu);
+		percpu->aux_thread = md_register_thread(raid5auxd, conf->mddev,
+							name);
+		if (!percpu->aux_thread) {
+			err = -ENOMEM;
+			break;
+		}
+		percpu->aux_thread->thread_data = (void *)cpu;
+		INIT_LIST_HEAD(&(percpu->handle_list));
 	}
 #ifdef CONFIG_HOTPLUG_CPU
 	conf->cpu_notify.notifier_call = raid456_cpu_notify;
@@ -4932,7 +5013,6 @@ static struct r5conf *setup_conf(struct
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
-	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-07-09 01:25:37.492848182 -0600
+++ linux/drivers/md/raid5.h	2012-07-09 01:27:43.202847084 -0600
@@ -211,6 +211,7 @@ struct stripe_head {
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
 	spinlock_t		stripe_lock;
+	int cpu;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -395,7 +396,6 @@ struct r5conf {
 						  * but is closest to zero.
 						  */
 
-	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	hold_list; /* preread ready stripes */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
@@ -431,6 +431,8 @@ struct r5conf {
 					      * lists and performing address
 					      * conversions
 					      */
+		struct list_head handle_list; /*stripes needing handling */
+		struct md_thread *aux_thread;
 	} __percpu *percpu;
 	size_t			scribble_len; /* size of scribble region must be
 					       * associated with conf to handle
Index: linux/drivers/md/md.c
===================================================================
--- linux.orig/drivers/md/md.c	2012-07-09 01:25:37.502848182 -0600
+++ linux/drivers/md/md.c	2012-07-09 01:27:43.202847084 -0600
@@ -6715,7 +6715,7 @@ static int md_thread(void * arg)
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 		if (!kthread_should_stop())
-			thread->run(thread->mddev);
+			thread->run(thread);
 	}
 
 	return 0;
@@ -6730,7 +6730,7 @@ void md_wakeup_thread(struct md_thread *
 	}
 }
 
-struct md_thread *md_register_thread(void (*run) (struct mddev *), struct mddev *mddev,
+struct md_thread *md_register_thread(void (*run) (struct md_thread *), struct mddev *mddev,
 				 const char *name)
 {
 	struct md_thread *thread;
@@ -7280,8 +7280,9 @@ EXPORT_SYMBOL_GPL(md_allow_write);
 
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
-void md_do_sync(struct mddev *mddev)
+void md_do_sync(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct mddev *mddev2;
 	unsigned int currspeed = 0,
 		 window;
Index: linux/drivers/md/md.h
===================================================================
--- linux.orig/drivers/md/md.h	2012-07-09 01:25:37.482848182 -0600
+++ linux/drivers/md/md.h	2012-07-09 01:27:43.202847084 -0600
@@ -543,12 +543,13 @@ static inline void sysfs_unlink_rdev(str
 	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
 
 struct md_thread {
-	void			(*run) (struct mddev *mddev);
+	void			(*run) (struct md_thread *thread);
 	struct mddev		*mddev;
 	wait_queue_head_t	wqueue;
 	unsigned long           flags;
 	struct task_struct	*tsk;
 	unsigned long		timeout;
+	void			*thread_data;
 };
 
 #define THREAD_WAKEUP  0
@@ -587,7 +588,7 @@ static inline void safe_put_page(struct
 extern int register_md_personality(struct md_personality *p);
 extern int unregister_md_personality(struct md_personality *p);
 extern struct md_thread *md_register_thread(
-	void (*run)(struct mddev *mddev),
+	void (*run)(struct md_thread *thread),
 	struct mddev *mddev,
 	const char *name);
 extern void md_unregister_thread(struct md_thread **threadp);
@@ -606,7 +607,7 @@ extern void md_super_write(struct mddev
 extern void md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size, 
 			struct page *page, int rw, bool metadata_op);
-extern void md_do_sync(struct mddev *mddev);
+extern void md_do_sync(struct md_thread *thread);
 extern void md_new_event(struct mddev *mddev);
 extern int md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
Index: linux/drivers/md/multipath.c
===================================================================
--- linux.orig/drivers/md/multipath.c	2012-07-09 01:25:37.532848182 -0600
+++ linux/drivers/md/multipath.c	2012-07-09 01:27:43.202847084 -0600
@@ -335,8 +335,9 @@ abort:
  *	3.	Performs writes following reads for array syncronising.
  */
 
-static void multipathd (struct mddev *mddev)
+static void multipathd (struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct multipath_bh *mp_bh;
 	struct bio *bio;
 	unsigned long flags;
Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-07-09 01:25:37.512848182 -0600
+++ linux/drivers/md/raid1.c	2012-07-09 01:27:43.202847084 -0600
@@ -2157,8 +2157,9 @@ read_more:
 	}
 }
 
-static void raid1d(struct mddev *mddev)
+static void raid1d(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct r1bio *r1_bio;
 	unsigned long flags;
 	struct r1conf *conf = mddev->private;
Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2012-07-09 01:25:37.502848182 -0600
+++ linux/drivers/md/raid10.c	2012-07-09 01:27:43.202847084 -0600
@@ -2648,8 +2648,9 @@ static void handle_write_completed(struc
 	}
 }
 
-static void raid10d(struct mddev *mddev)
+static void raid10d(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct r10bio *r10_bio;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
