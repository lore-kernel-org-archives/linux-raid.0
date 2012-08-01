From: Shaohua Li <shli@kernel.org>
Subject: [RFC v2]raid5: create multiple threads to handle stripes
Date: Wed, 1 Aug 2012 11:40:00 +0800
Message-ID: <20120801034000.GA25799@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@intel.com
List-Id: linux-raid.ids

This is a new tempt to make raid5 handle stripes in multiple threads, as
suggested by Neil to have maxium flexibility and better numa binding. It
basically is a combination of my first and second generation patches. By
default, no multiple thread is enabled (all stripes are handled by raid5d).

An example to enable multiple threads:
#echo 3 > /sys/block/md0/md/auxthread_number
This will create 3 auxiliary threads to handle stripes. The threads can run
on any cpus and handle stripes produced by any cpus.

#echo 1-3 > /sys/block/md0/md/aux0_cpulist
This will bind auxiliary thread 0 to cpu 1-3, and this thread will only handle
stripes produced by cpu 1-3. User tool can further change the thread's
affinity, but the thread can only handle stripes produced by cpu 1-3 till the
sysfs entry is changed again.

If stripes produced by a CPU aren't handled by any auxiliary thread, such
stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
stripes.

Please let me know how do you think about it. I'll split the patch to a more
reviewable form if no one objects the idea.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/bitmap.c    |   48 ++++--
 drivers/md/md.c        |  158 ++++++++++++++-------
 drivers/md/md.h        |   12 -
 drivers/md/multipath.c |    3 
 drivers/md/raid1.c     |    3 
 drivers/md/raid10.c    |    3 
 drivers/md/raid5.c     |  354 +++++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/raid5.h     |   18 ++
 8 files changed, 494 insertions(+), 105 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-07-30 10:11:26.910008493 +0800
+++ linux/drivers/md/raid5.c	2012-08-01 10:27:23.862704311 +0800
@@ -196,6 +196,21 @@ static int stripe_operations_active(stru
 	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
 }
 
+static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct raid5_percpu *percpu;
+	int i, orphaned = 1;
+
+	percpu = per_cpu_ptr(conf->percpu, sh->cpu);
+	for_each_cpu(i, &percpu->handle_threads) {
+		md_wakeup_thread(conf->aux_threads[i]->thread);
+		orphaned = 0;
+	}
+	if (orphaned)
+		md_wakeup_thread(conf->mddev->thread);
+}
+
 static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
 {
 	BUG_ON(!list_empty(&sh->lru));
@@ -208,9 +223,19 @@ static void do_release_stripe(struct r5c
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
+
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			clear_bit(STRIPE_BIT_DELAY, &sh->state);
-			list_add_tail(&sh->lru, &conf->handle_list);
+			list_add_tail(&sh->lru, &percpu->handle_list);
+			raid5_wakeup_stripe_thread(sh);
+			return;
 		}
 		md_wakeup_thread(conf->mddev->thread);
 	} else {
@@ -355,6 +380,7 @@ static void init_stripe(struct stripe_he
 		raid5_build_block(sh, i, previous);
 	}
 	insert_hash(conf, sh);
+	sh->cpu = smp_processor_id();
 }
 
 static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
@@ -3689,12 +3715,19 @@ static void raid5_activate_delayed(struc
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
+			raid5_wakeup_stripe_thread(sh);
 		}
 	}
 }
@@ -3968,18 +4001,29 @@ static int chunk_aligned_read(struct mdd
  * head of the hold_list has changed, i.e. the head was promoted to the
  * handle_list.
  */
-static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
+static struct stripe_head *__get_priority_stripe(struct r5conf *conf,
+	cpumask_t *mask)
 {
-	struct stripe_head *sh;
-
+	struct stripe_head *sh = NULL, *tmp;
+	struct list_head *handle_list = NULL;
+	int cpu;
+
+	/* Should we take action to avoid starvation of latter CPUs ? */
+	for_each_cpu(cpu, mask) {
+		struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
+		if (!list_empty(&percpu->handle_list)) {
+			handle_list = &percpu->handle_list;
+			break;
+		}
+	}
 	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\n",
 		  __func__,
-		  list_empty(&conf->handle_list) ? "empty" : "busy",
+		  !handle_list ? "empty" : "busy",
 		  list_empty(&conf->hold_list) ? "empty" : "busy",
 		  atomic_read(&conf->pending_full_writes), conf->bypass_count);
 
-	if (!list_empty(&conf->handle_list)) {
-		sh = list_entry(conf->handle_list.next, typeof(*sh), lru);
+	if (handle_list) {
+		sh = list_entry(handle_list->next, typeof(*sh), lru);
 
 		if (list_empty(&conf->hold_list))
 			conf->bypass_count = 0;
@@ -3997,12 +4041,23 @@ static struct stripe_head *__get_priorit
 		   ((conf->bypass_threshold &&
 		     conf->bypass_count > conf->bypass_threshold) ||
 		    atomic_read(&conf->pending_full_writes) == 0)) {
-		sh = list_entry(conf->hold_list.next,
-				typeof(*sh), lru);
-		conf->bypass_count -= conf->bypass_threshold;
-		if (conf->bypass_count < 0)
-			conf->bypass_count = 0;
-	} else
+
+		list_for_each_entry(tmp, &conf->hold_list,  lru) {
+			if (cpumask_test_cpu(tmp->cpu, mask) ||
+			    !cpu_online(tmp->cpu)) {
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
+
+	if (!sh)
 		return NULL;
 
 	list_del_init(&sh->lru);
@@ -4594,13 +4649,13 @@ static int  retry_aligned_read(struct r5
 }
 
 #define MAX_STRIPE_BATCH 8
-static int handle_active_stripes(struct r5conf *conf)
+static int handle_active_stripes(struct r5conf *conf, cpumask_t *mask)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
 	int i, batch_size = 0;
 
 	while (batch_size < MAX_STRIPE_BATCH &&
-			(sh = __get_priority_stripe(conf)) != NULL)
+			(sh = __get_priority_stripe(conf, mask)) != NULL)
 		batch[batch_size++] = sh;
 
 	if (batch_size == 0)
@@ -4618,6 +4673,37 @@ static int handle_active_stripes(struct
 	return batch_size;
 }
 
+static void raid5auxd(struct md_thread *thread)
+{
+	struct mddev *mddev = thread->mddev;
+	struct r5conf *conf = mddev->private;
+	struct blk_plug plug;
+	int handled;
+	cpumask_t *mask;
+	struct raid5_auxth *auxth = thread->thread_data;
+
+	pr_debug("+++ raid5auxd active\n");
+
+	blk_start_plug(&plug);
+	handled = 0;
+	spin_lock_irq(&conf->device_lock);
+	while (1) {
+		int batch_size;
+		mask = &auxth->worker_mask;
+
+		batch_size = handle_active_stripes(conf, mask);
+		if (!batch_size)
+			break;
+		handled += batch_size;
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
@@ -4625,8 +4711,9 @@ static int handle_active_stripes(struct
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
@@ -4664,7 +4751,7 @@ static void raid5d(struct mddev *mddev)
 			handled++;
 		}
 
-		batch_size = handle_active_stripes(conf);
+		batch_size = handle_active_stripes(conf, &conf->global_mask);
 		if (!batch_size)
 			break;
 		handled += batch_size;
@@ -4686,7 +4773,8 @@ static void raid5d(struct mddev *mddev)
 }
 
 static ssize_t
-raid5_show_stripe_cache_size(struct mddev *mddev, char *page)
+raid5_show_stripe_cache_size(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	struct r5conf *conf = mddev->private;
 	if (conf)
@@ -4722,7 +4810,8 @@ raid5_set_cache_size(struct mddev *mddev
 EXPORT_SYMBOL(raid5_set_cache_size);
 
 static ssize_t
-raid5_store_stripe_cache_size(struct mddev *mddev, const char *page, size_t len)
+raid5_store_stripe_cache_size(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *page, size_t len)
 {
 	struct r5conf *conf = mddev->private;
 	unsigned long new;
@@ -4747,7 +4836,8 @@ raid5_stripecache_size = __ATTR(stripe_c
 				raid5_store_stripe_cache_size);
 
 static ssize_t
-raid5_show_preread_threshold(struct mddev *mddev, char *page)
+raid5_show_preread_threshold(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	struct r5conf *conf = mddev->private;
 	if (conf)
@@ -4757,7 +4847,8 @@ raid5_show_preread_threshold(struct mdde
 }
 
 static ssize_t
-raid5_store_preread_threshold(struct mddev *mddev, const char *page, size_t len)
+raid5_store_preread_threshold(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *page, size_t len)
 {
 	struct r5conf *conf = mddev->private;
 	unsigned long new;
@@ -4781,7 +4872,8 @@ raid5_preread_bypass_threshold = __ATTR(
 					raid5_store_preread_threshold);
 
 static ssize_t
-stripe_cache_active_show(struct mddev *mddev, char *page)
+stripe_cache_active_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	struct r5conf *conf = mddev->private;
 	if (conf)
@@ -4793,10 +4885,198 @@ stripe_cache_active_show(struct mddev *m
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static void raid5_update_threads_handle_mask(struct mddev *mddev)
+{
+	int cpu, i;
+	struct raid5_percpu *percpu;
+	struct r5conf *conf = mddev->private;
+
+	for_each_online_cpu(cpu) {
+		percpu = per_cpu_ptr(conf->percpu, cpu);
+		cpumask_clear(&percpu->handle_threads);
+	}
+	cpumask_copy(&conf->global_mask, cpu_online_mask);
+
+	for (i = 0; i < conf->aux_thread_num; i++) {
+		cpumask_t *worker_mask = &conf->aux_threads[i]->worker_mask;
+		for_each_cpu(cpu, worker_mask) {
+			percpu = per_cpu_ptr(conf->percpu, cpu);
+			cpumask_set_cpu(i, &percpu->handle_threads);
+		}
+		cpumask_andnot(&conf->global_mask, &conf->global_mask,
+				worker_mask);
+	}
+}
+
+static ssize_t raid5_show_thread_cpulist(struct mddev *mddev,
+	struct md_sysfs_entry *entry, char *page)
+{
+	struct raid5_auxth *thread = container_of(entry,
+			struct raid5_auxth, sysfs_entry);
+
+	return cpulist_scnprintf(page, PAGE_SIZE, &thread->worker_mask);
+}
+
+static ssize_t
+raid5_store_thread_cpulist(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *page, size_t len)
+{
+	struct raid5_auxth *thread = container_of(entry,
+			struct raid5_auxth, sysfs_entry);
+	struct r5conf *conf = mddev->private;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	if (cpulist_parse(page, mask)) {
+		free_cpumask_var(mask);
+		return -EINVAL;
+	}
+
+	get_online_cpus();
+	spin_lock_irq(&conf->device_lock);
+	cpumask_copy(&thread->worker_mask, mask);
+	raid5_update_threads_handle_mask(mddev);
+	spin_unlock_irq(&conf->device_lock);
+	put_online_cpus();
+	set_cpus_allowed_ptr(thread->thread->tsk, mask);
+
+	free_cpumask_var(mask);
+	return len;
+}
+
+static ssize_t
+raid5_show_auxthread_number(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf)
+		return sprintf(page, "%d\n", conf->aux_thread_num);
+	else
+		return 0;
+}
+
+static void __free_aux_thread(struct mddev *mddev, struct raid5_auxth *thread)
+{
+	sysfs_remove_file(&mddev->kobj, &thread->sysfs_entry.attr);
+	md_unregister_thread(&thread->thread);
+	kfree(thread);
+}
+
+static struct raid5_auxth *__create_aux_thread(struct mddev *mddev, int i)
+{
+	struct raid5_auxth *thread;
+	char name[10];
+
+	thread = kzalloc(sizeof(*thread), GFP_KERNEL);
+	if (!thread)
+		return NULL;
+	sprintf(name, "aux%d", i);
+	thread->thread = md_register_thread(raid5auxd, mddev, name);
+	if (!thread->thread) {
+		kfree(thread);
+		return NULL;
+	}
+	cpumask_copy(&thread->worker_mask, cpu_online_mask);
+	thread->thread->thread_data = thread;
+
+	snprintf(thread->sysfs_name, sizeof(thread->sysfs_name) - 1,
+		"aux%d_cpulist", i);
+	thread->sysfs_entry.attr.name = thread->sysfs_name;
+	thread->sysfs_entry.attr.mode = S_IRUGO|S_IWUSR;
+	sysfs_attr_init(&thread->sysfs_entry.attr);
+	thread->sysfs_entry.show = raid5_show_thread_cpulist;
+	thread->sysfs_entry.store = raid5_store_thread_cpulist;
+
+	if (sysfs_create_file(&mddev->kobj, &thread->sysfs_entry.attr)) {
+		md_unregister_thread(&thread->thread);
+		kfree(thread);
+		return NULL;
+	}
+
+	return thread;
+}
+
+static ssize_t
+raid5_store_auxthread_number(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new;
+	int i;
+	struct raid5_auxth **threads;
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
+	/* There is no point creating more threads than cpu number */
+	if (new > num_online_cpus())
+		return -EINVAL;
+
+	if (new > conf->aux_thread_num) {
+		threads = kzalloc(sizeof(struct raid5_auxth *) * new,
+				GFP_KERNEL);
+		if (!threads)
+			return -ENOMEM;
+
+		i = conf->aux_thread_num;
+		while (i < new) {
+			threads[i] = __create_aux_thread(mddev, i);
+			if (!threads[i])
+				goto error;
+
+			i++;
+		}
+		memcpy(threads, conf->aux_threads,
+			sizeof(struct raid5_auxth *) * conf->aux_thread_num);
+		get_online_cpus();
+		spin_lock_irq(&conf->device_lock);
+		kfree(conf->aux_threads);
+		conf->aux_threads = threads;
+		conf->aux_thread_num = new;
+		raid5_update_threads_handle_mask(mddev);
+		spin_unlock_irq(&conf->device_lock);
+		put_online_cpus();
+	} else {
+		int old = conf->aux_thread_num;
+
+		get_online_cpus();
+		spin_lock_irq(&conf->device_lock);
+		conf->aux_thread_num = new;
+		raid5_update_threads_handle_mask(mddev);
+		spin_unlock_irq(&conf->device_lock);
+		put_online_cpus();
+		for (i = new; i < old; i++)
+			__free_aux_thread(mddev, conf->aux_threads[i]);
+	}
+
+	return len;
+error:
+	while (--i >= conf->aux_thread_num)
+		__free_aux_thread(mddev, threads[i]);
+	kfree(threads);
+	return -ENOMEM;
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
@@ -4844,6 +5124,7 @@ static void raid5_free_percpu(struct r5c
 
 static void free_conf(struct r5conf *conf)
 {
+	kfree(conf->aux_threads);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
 	kfree(conf->disks);
@@ -4856,7 +5137,7 @@ static int raid456_cpu_notify(struct not
 			      void *hcpu)
 {
 	struct r5conf *conf = container_of(nfb, struct r5conf, cpu_notify);
-	long cpu = (long)hcpu;
+	long cpu = (long)hcpu, anycpu;
 	struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
 
 	switch (action) {
@@ -4875,9 +5156,17 @@ static int raid456_cpu_notify(struct not
 			       __func__, cpu);
 			return notifier_from_errno(-ENOMEM);
 		}
+		INIT_LIST_HEAD(&(percpu->handle_list));
+		cpumask_clear(&percpu->handle_threads);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		spin_lock_irq(&conf->device_lock);
+		anycpu = cpumask_any(cpu_online_mask);
+		list_splice_tail_init(&percpu->handle_list,
+			&per_cpu_ptr(conf->percpu, anycpu)->handle_list);
+		spin_unlock_irq(&conf->device_lock);
+
 		safe_put_page(percpu->spare_page);
 		kfree(percpu->scribble);
 		percpu->spare_page = NULL;
@@ -4886,6 +5175,10 @@ static int raid456_cpu_notify(struct not
 	default:
 		break;
 	}
+
+	spin_lock_irq(&conf->device_lock);
+	raid5_update_threads_handle_mask(conf->mddev);
+	spin_unlock_irq(&conf->device_lock);
 	return NOTIFY_OK;
 }
 #endif
@@ -4906,20 +5199,24 @@ static int raid5_alloc_percpu(struct r5c
 	get_online_cpus();
 	err = 0;
 	for_each_present_cpu(cpu) {
+		struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
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
+		INIT_LIST_HEAD(&percpu->handle_list);
+		cpumask_clear(&percpu->handle_threads);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
 	conf->cpu_notify.notifier_call = raid456_cpu_notify;
@@ -4975,7 +5272,6 @@ static struct r5conf *setup_conf(struct
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
-	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
@@ -4986,6 +5282,8 @@ static struct r5conf *setup_conf(struct
 	conf->bypass_threshold = BYPASS_THRESHOLD;
 	conf->recovery_disabled = mddev->recovery_disabled - 1;
 
+	cpumask_copy(&conf->global_mask, cpu_online_mask);
+
 	conf->raid_disks = mddev->raid_disks;
 	if (mddev->reshape_position == MaxSector)
 		conf->previous_raid_disks = mddev->raid_disks;
@@ -5402,6 +5700,10 @@ abort:
 static int stop(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
+	int i;
+
+	for (i = 0; i < conf->aux_thread_num; i++)
+		__free_aux_thread(mddev, conf->aux_threads[i]);
 
 	md_unregister_thread(&mddev->thread);
 	if (mddev->queue)
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-07-30 10:11:26.926007992 +0800
+++ linux/drivers/md/raid5.h	2012-08-01 10:30:45.908164594 +0800
@@ -211,6 +211,7 @@ struct stripe_head {
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
 	spinlock_t		stripe_lock;
+	int			cpu;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -364,6 +365,14 @@ struct disk_info {
 	struct md_rdev	*rdev, *replacement;
 };
 
+struct raid5_auxth {
+	struct md_thread	*thread;
+	/* which CPUs should the auxiliary thread handle stripes from */
+	cpumask_t		worker_mask;
+	struct md_sysfs_entry	sysfs_entry;
+	char			sysfs_name[20];
+};
+
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	struct mddev		*mddev;
@@ -432,6 +441,11 @@ struct r5conf {
 					      * lists and performing address
 					      * conversions
 					      */
+		struct list_head handle_list;
+		cpumask_t	handle_threads; /* Which threads can the CPU's
+						 * stripes be handled. It really
+						 * is a bitmap to aux_threads
+						 */
 	} __percpu *percpu;
 	size_t			scribble_len; /* size of scribble region must be
 					       * associated with conf to handle
@@ -459,6 +473,10 @@ struct r5conf {
 	 * the new thread here until we fully activate the array.
 	 */
 	struct md_thread	*thread;
+	int			aux_thread_num;
+	struct raid5_auxth	**aux_threads;
+	/* which CPUs should raid5d thread handle stripes from */
+	cpumask_t		global_mask;
 };
 
 /*
Index: linux/drivers/md/md.c
===================================================================
--- linux.orig/drivers/md/md.c	2012-07-30 10:01:10.093762606 +0800
+++ linux/drivers/md/md.c	2012-08-01 10:25:02.512481681 +0800
@@ -3437,13 +3437,15 @@ int strict_strtoul_scaled(const char *cp
 static void md_safemode_timeout(unsigned long data);
 
 static ssize_t
-safe_delay_show(struct mddev *mddev, char *page)
+safe_delay_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	int msec = (mddev->safemode_delay*1000)/HZ;
 	return sprintf(page, "%d.%03d\n", msec/1000, msec%1000);
 }
 static ssize_t
-safe_delay_store(struct mddev *mddev, const char *cbuf, size_t len)
+safe_delay_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *cbuf, size_t len)
 {
 	unsigned long msec;
 
@@ -3465,7 +3467,8 @@ static struct md_sysfs_entry md_safe_del
 __ATTR(safe_mode_delay, S_IRUGO|S_IWUSR,safe_delay_show, safe_delay_store);
 
 static ssize_t
-level_show(struct mddev *mddev, char *page)
+level_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	struct md_personality *p = mddev->pers;
 	if (p)
@@ -3479,7 +3482,8 @@ level_show(struct mddev *mddev, char *pa
 }
 
 static ssize_t
-level_store(struct mddev *mddev, const char *buf, size_t len)
+level_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char clevel[16];
 	ssize_t rv = len;
@@ -3660,7 +3664,8 @@ __ATTR(level, S_IRUGO|S_IWUSR, level_sho
 
 
 static ssize_t
-layout_show(struct mddev *mddev, char *page)
+layout_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	/* just a number, not meaningful for all levels */
 	if (mddev->reshape_position != MaxSector &&
@@ -3671,7 +3676,8 @@ layout_show(struct mddev *mddev, char *p
 }
 
 static ssize_t
-layout_store(struct mddev *mddev, const char *buf, size_t len)
+layout_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
@@ -3701,7 +3707,8 @@ __ATTR(layout, S_IRUGO|S_IWUSR, layout_s
 
 
 static ssize_t
-raid_disks_show(struct mddev *mddev, char *page)
+raid_disks_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	if (mddev->raid_disks == 0)
 		return 0;
@@ -3715,7 +3722,8 @@ raid_disks_show(struct mddev *mddev, cha
 static int update_raid_disks(struct mddev *mddev, int raid_disks);
 
 static ssize_t
-raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
+raid_disks_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char *e;
 	int rv = 0;
@@ -3749,7 +3757,8 @@ static struct md_sysfs_entry md_raid_dis
 __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
 
 static ssize_t
-chunk_size_show(struct mddev *mddev, char *page)
+chunk_size_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	if (mddev->reshape_position != MaxSector &&
 	    mddev->chunk_sectors != mddev->new_chunk_sectors)
@@ -3760,7 +3769,8 @@ chunk_size_show(struct mddev *mddev, cha
 }
 
 static ssize_t
-chunk_size_store(struct mddev *mddev, const char *buf, size_t len)
+chunk_size_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
@@ -3789,7 +3799,8 @@ static struct md_sysfs_entry md_chunk_si
 __ATTR(chunk_size, S_IRUGO|S_IWUSR, chunk_size_show, chunk_size_store);
 
 static ssize_t
-resync_start_show(struct mddev *mddev, char *page)
+resync_start_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	if (mddev->recovery_cp == MaxSector)
 		return sprintf(page, "none\n");
@@ -3797,7 +3808,8 @@ resync_start_show(struct mddev *mddev, c
 }
 
 static ssize_t
-resync_start_store(struct mddev *mddev, const char *buf, size_t len)
+resync_start_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long n = simple_strtoull(buf, &e, 10);
@@ -3867,7 +3879,8 @@ static int match_word(const char *word,
 }
 
 static ssize_t
-array_state_show(struct mddev *mddev, char *page)
+array_state_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	enum array_state st = inactive;
 
@@ -3906,7 +3919,8 @@ static int do_md_run(struct mddev * mdde
 static int restart_array(struct mddev *mddev);
 
 static ssize_t
-array_state_store(struct mddev *mddev, const char *buf, size_t len)
+array_state_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	int err = -EINVAL;
 	enum array_state st = match_word(buf, array_states);
@@ -3998,13 +4012,16 @@ static struct md_sysfs_entry md_array_st
 __ATTR(array_state, S_IRUGO|S_IWUSR, array_state_show, array_state_store);
 
 static ssize_t
-max_corrected_read_errors_show(struct mddev *mddev, char *page) {
+max_corrected_read_errors_show(struct mddev *mddev,
+	struct md_sysfs_entry *entry, char *page)
+{
 	return sprintf(page, "%d\n",
 		       atomic_read(&mddev->max_corr_read_errors));
 }
 
 static ssize_t
-max_corrected_read_errors_store(struct mddev *mddev, const char *buf, size_t len)
+max_corrected_read_errors_store(struct mddev *mddev,
+	struct md_sysfs_entry *entry, const char *buf, size_t len)
 {
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
@@ -4021,13 +4038,14 @@ __ATTR(max_read_errors, S_IRUGO|S_IWUSR,
 	max_corrected_read_errors_store);
 
 static ssize_t
-null_show(struct mddev *mddev, char *page)
+null_show(struct mddev *mddev, struct md_sysfs_entry *entry, char *page)
 {
 	return -EINVAL;
 }
 
 static ssize_t
-new_dev_store(struct mddev *mddev, const char *buf, size_t len)
+new_dev_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	/* buf must be %d:%d\n? giving major and minor numbers */
 	/* The new device is added to the array.
@@ -4084,7 +4102,8 @@ static struct md_sysfs_entry md_new_devi
 __ATTR(new_dev, S_IWUSR, null_show, new_dev_store);
 
 static ssize_t
-bitmap_store(struct mddev *mddev, const char *buf, size_t len)
+bitmap_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char *end;
 	unsigned long chunk, end_chunk;
@@ -4113,7 +4132,8 @@ static struct md_sysfs_entry md_bitmap =
 __ATTR(bitmap_set_bits, S_IWUSR, null_show, bitmap_store);
 
 static ssize_t
-size_show(struct mddev *mddev, char *page)
+size_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%llu\n",
 		(unsigned long long)mddev->dev_sectors / 2);
@@ -4122,7 +4142,8 @@ size_show(struct mddev *mddev, char *pag
 static int update_size(struct mddev *mddev, sector_t num_sectors);
 
 static ssize_t
-size_store(struct mddev *mddev, const char *buf, size_t len)
+size_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	/* If array is inactive, we can reduce the component size, but
 	 * not increase it (except from 0).
@@ -4157,7 +4178,8 @@ __ATTR(component_size, S_IRUGO|S_IWUSR,
  * or N.M for internally known formats
  */
 static ssize_t
-metadata_show(struct mddev *mddev, char *page)
+metadata_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	if (mddev->persistent)
 		return sprintf(page, "%d.%d\n",
@@ -4169,7 +4191,8 @@ metadata_show(struct mddev *mddev, char
 }
 
 static ssize_t
-metadata_store(struct mddev *mddev, const char *buf, size_t len)
+metadata_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	int major, minor;
 	char *e;
@@ -4223,7 +4246,8 @@ static struct md_sysfs_entry md_metadata
 __ATTR(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
 static ssize_t
-action_show(struct mddev *mddev, char *page)
+action_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	char *type = "idle";
 	if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
@@ -4248,7 +4272,8 @@ action_show(struct mddev *mddev, char *p
 static void reap_sync_thread(struct mddev *mddev);
 
 static ssize_t
-action_store(struct mddev *mddev, const char *page, size_t len)
+action_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *page, size_t len)
 {
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
@@ -4294,7 +4319,8 @@ action_store(struct mddev *mddev, const
 }
 
 static ssize_t
-mismatch_cnt_show(struct mddev *mddev, char *page)
+mismatch_cnt_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%llu\n",
 		       (unsigned long long) mddev->resync_mismatches);
@@ -4307,14 +4333,16 @@ __ATTR(sync_action, S_IRUGO|S_IWUSR, act
 static struct md_sysfs_entry md_mismatches = __ATTR_RO(mismatch_cnt);
 
 static ssize_t
-sync_min_show(struct mddev *mddev, char *page)
+sync_min_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_min(mddev),
 		       mddev->sync_speed_min ? "local": "system");
 }
 
 static ssize_t
-sync_min_store(struct mddev *mddev, const char *buf, size_t len)
+sync_min_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	int min;
 	char *e;
@@ -4333,14 +4361,16 @@ static struct md_sysfs_entry md_sync_min
 __ATTR(sync_speed_min, S_IRUGO|S_IWUSR, sync_min_show, sync_min_store);
 
 static ssize_t
-sync_max_show(struct mddev *mddev, char *page)
+sync_max_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%d (%s)\n", speed_max(mddev),
 		       mddev->sync_speed_max ? "local": "system");
 }
 
 static ssize_t
-sync_max_store(struct mddev *mddev, const char *buf, size_t len)
+sync_max_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	int max;
 	char *e;
@@ -4359,20 +4389,23 @@ static struct md_sysfs_entry md_sync_max
 __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
 
 static ssize_t
-degraded_show(struct mddev *mddev, char *page)
+degraded_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%d\n", mddev->degraded);
 }
 static struct md_sysfs_entry md_degraded = __ATTR_RO(degraded);
 
 static ssize_t
-sync_force_parallel_show(struct mddev *mddev, char *page)
+sync_force_parallel_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%d\n", mddev->parallel_resync);
 }
 
 static ssize_t
-sync_force_parallel_store(struct mddev *mddev, const char *buf, size_t len)
+sync_force_parallel_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	long n;
 
@@ -4396,7 +4429,8 @@ __ATTR(sync_force_parallel, S_IRUGO|S_IW
        sync_force_parallel_show, sync_force_parallel_store);
 
 static ssize_t
-sync_speed_show(struct mddev *mddev, char *page)
+sync_speed_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	unsigned long resync, dt, db;
 	if (mddev->curr_resync == 0)
@@ -4411,7 +4445,8 @@ sync_speed_show(struct mddev *mddev, cha
 static struct md_sysfs_entry md_sync_speed = __ATTR_RO(sync_speed);
 
 static ssize_t
-sync_completed_show(struct mddev *mddev, char *page)
+sync_completed_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	unsigned long long max_sectors, resync;
 
@@ -4431,13 +4466,15 @@ sync_completed_show(struct mddev *mddev,
 static struct md_sysfs_entry md_sync_completed = __ATTR_RO(sync_completed);
 
 static ssize_t
-min_sync_show(struct mddev *mddev, char *page)
+min_sync_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%llu\n",
 		       (unsigned long long)mddev->resync_min);
 }
 static ssize_t
-min_sync_store(struct mddev *mddev, const char *buf, size_t len)
+min_sync_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	unsigned long long min;
 	if (strict_strtoull(buf, 10, &min))
@@ -4462,7 +4499,8 @@ static struct md_sysfs_entry md_min_sync
 __ATTR(sync_min, S_IRUGO|S_IWUSR, min_sync_show, min_sync_store);
 
 static ssize_t
-max_sync_show(struct mddev *mddev, char *page)
+max_sync_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	if (mddev->resync_max == MaxSector)
 		return sprintf(page, "max\n");
@@ -4471,7 +4509,8 @@ max_sync_show(struct mddev *mddev, char
 			       (unsigned long long)mddev->resync_max);
 }
 static ssize_t
-max_sync_store(struct mddev *mddev, const char *buf, size_t len)
+max_sync_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	if (strncmp(buf, "max", 3) == 0)
 		mddev->resync_max = MaxSector;
@@ -4502,13 +4541,15 @@ static struct md_sysfs_entry md_max_sync
 __ATTR(sync_max, S_IRUGO|S_IWUSR, max_sync_show, max_sync_store);
 
 static ssize_t
-suspend_lo_show(struct mddev *mddev, char *page)
+suspend_lo_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_lo);
 }
 
 static ssize_t
-suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
+suspend_lo_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
@@ -4536,13 +4577,14 @@ __ATTR(suspend_lo, S_IRUGO|S_IWUSR, susp
 
 
 static ssize_t
-suspend_hi_show(struct mddev *mddev, char *page)
+suspend_hi_show(struct mddev *mddev, struct md_sysfs_entry *entry, char *page)
 {
 	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_hi);
 }
 
 static ssize_t
-suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
+suspend_hi_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
@@ -4569,7 +4611,8 @@ static struct md_sysfs_entry md_suspend_
 __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
 
 static ssize_t
-reshape_position_show(struct mddev *mddev, char *page)
+reshape_position_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	if (mddev->reshape_position != MaxSector)
 		return sprintf(page, "%llu\n",
@@ -4579,7 +4622,8 @@ reshape_position_show(struct mddev *mdde
 }
 
 static ssize_t
-reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
+reshape_position_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	struct md_rdev *rdev;
 	char *e;
@@ -4604,14 +4648,16 @@ __ATTR(reshape_position, S_IRUGO|S_IWUSR
        reshape_position_store);
 
 static ssize_t
-reshape_direction_show(struct mddev *mddev, char *page)
+reshape_direction_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%s\n",
 		       mddev->reshape_backwards ? "backwards" : "forwards");
 }
 
 static ssize_t
-reshape_direction_store(struct mddev *mddev, const char *buf, size_t len)
+reshape_direction_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	int backwards = 0;
 	if (cmd_match(buf, "forwards"))
@@ -4640,7 +4686,7 @@ __ATTR(reshape_direction, S_IRUGO|S_IWUS
        reshape_direction_store);
 
 static ssize_t
-array_size_show(struct mddev *mddev, char *page)
+array_size_show(struct mddev *mddev, struct md_sysfs_entry *entry, char *page)
 {
 	if (mddev->external_size)
 		return sprintf(page, "%llu\n",
@@ -4650,7 +4696,8 @@ array_size_show(struct mddev *mddev, cha
 }
 
 static ssize_t
-array_size_store(struct mddev *mddev, const char *buf, size_t len)
+array_size_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	sector_t sectors;
 
@@ -4741,7 +4788,7 @@ md_attr_show(struct kobject *kobj, struc
 
 	rv = mddev_lock(mddev);
 	if (!rv) {
-		rv = entry->show(mddev, page);
+		rv = entry->show(mddev, entry, page);
 		mddev_unlock(mddev);
 	}
 	mddev_put(mddev);
@@ -4769,7 +4816,7 @@ md_attr_store(struct kobject *kobj, stru
 	spin_unlock(&all_mddevs_lock);
 	rv = mddev_lock(mddev);
 	if (!rv) {
-		rv = entry->store(mddev, page, length);
+		rv = entry->store(mddev, entry, page, length);
 		mddev_unlock(mddev);
 	}
 	mddev_put(mddev);
@@ -6709,7 +6756,7 @@ static int md_thread(void * arg)
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 		if (!kthread_should_stop())
-			thread->run(thread->mddev);
+			thread->run(thread);
 	}
 
 	return 0;
@@ -6724,8 +6771,8 @@ void md_wakeup_thread(struct md_thread *
 	}
 }
 
-struct md_thread *md_register_thread(void (*run) (struct mddev *), struct mddev *mddev,
-				 const char *name)
+struct md_thread *md_register_thread(void (*run) (struct md_thread *),
+		struct mddev *mddev, const char *name)
 {
 	struct md_thread *thread;
 
@@ -7274,8 +7321,9 @@ EXPORT_SYMBOL_GPL(md_allow_write);
 
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
--- linux.orig/drivers/md/md.h	2012-07-30 10:01:10.093762606 +0800
+++ linux/drivers/md/md.h	2012-08-01 10:24:32.828855197 +0800
@@ -479,8 +479,9 @@ struct md_personality
 
 struct md_sysfs_entry {
 	struct attribute attr;
-	ssize_t (*show)(struct mddev *, char *);
-	ssize_t (*store)(struct mddev *, const char *, size_t);
+	ssize_t (*show)(struct mddev *, struct md_sysfs_entry *, char *);
+	ssize_t (*store)(struct mddev *, struct md_sysfs_entry *,
+		const char *, size_t);
 };
 extern struct attribute_group md_bitmap_group;
 
@@ -540,12 +541,13 @@ static inline void sysfs_unlink_rdev(str
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
@@ -584,7 +586,7 @@ static inline void safe_put_page(struct
 extern int register_md_personality(struct md_personality *p);
 extern int unregister_md_personality(struct md_personality *p);
 extern struct md_thread *md_register_thread(
-	void (*run)(struct mddev *mddev),
+	void (*run)(struct md_thread *thread),
 	struct mddev *mddev,
 	const char *name);
 extern void md_unregister_thread(struct md_thread **threadp);
@@ -603,7 +605,7 @@ extern void md_super_write(struct mddev
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
--- linux.orig/drivers/md/multipath.c	2012-07-04 11:53:32.321865791 +0800
+++ linux/drivers/md/multipath.c	2012-07-30 13:46:56.143468404 +0800
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
--- linux.orig/drivers/md/raid1.c	2012-07-30 10:01:10.093762606 +0800
+++ linux/drivers/md/raid1.c	2012-07-30 13:47:44.502832526 +0800
@@ -2285,8 +2285,9 @@ read_more:
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
--- linux.orig/drivers/md/raid10.c	2012-07-30 10:01:10.093762606 +0800
+++ linux/drivers/md/raid10.c	2012-07-30 13:48:33.882237240 +0800
@@ -2667,8 +2667,9 @@ static void handle_write_completed(struc
 	}
 }
 
-static void raid10d(struct mddev *mddev)
+static void raid10d(struct md_thread *thread)
 {
+	struct mddev *mddev = thread->mddev;
 	struct r10bio *r10_bio;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
Index: linux/drivers/md/bitmap.c
===================================================================
--- linux.orig/drivers/md/bitmap.c	2012-07-30 10:01:10.089762657 +0800
+++ linux/drivers/md/bitmap.c	2012-08-01 10:31:25.183669193 +0800
@@ -1957,7 +1957,8 @@ err:
 EXPORT_SYMBOL_GPL(bitmap_resize);
 
 static ssize_t
-location_show(struct mddev *mddev, char *page)
+location_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	ssize_t len;
 	if (mddev->bitmap_info.file)
@@ -1971,7 +1972,8 @@ location_show(struct mddev *mddev, char
 }
 
 static ssize_t
-location_store(struct mddev *mddev, const char *buf, size_t len)
+location_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 
 	if (mddev->pers) {
@@ -2054,13 +2056,15 @@ __ATTR(location, S_IRUGO|S_IWUSR, locati
  * resize the bitmap to match a resized array.
  */
 static ssize_t
-space_show(struct mddev *mddev, char *page)
+space_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%lu\n", mddev->bitmap_info.space);
 }
 
 static ssize_t
-space_store(struct mddev *mddev, const char *buf, size_t len)
+space_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	unsigned long sectors;
 	int rv;
@@ -2087,7 +2091,8 @@ static struct md_sysfs_entry bitmap_spac
 __ATTR(space, S_IRUGO|S_IWUSR, space_show, space_store);
 
 static ssize_t
-timeout_show(struct mddev *mddev, char *page)
+timeout_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	ssize_t len;
 	unsigned long secs = mddev->bitmap_info.daemon_sleep / HZ;
@@ -2101,7 +2106,8 @@ timeout_show(struct mddev *mddev, char *
 }
 
 static ssize_t
-timeout_store(struct mddev *mddev, const char *buf, size_t len)
+timeout_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	/* timeout can be set at any time */
 	unsigned long timeout;
@@ -2137,13 +2143,15 @@ static struct md_sysfs_entry bitmap_time
 __ATTR(time_base, S_IRUGO|S_IWUSR, timeout_show, timeout_store);
 
 static ssize_t
-backlog_show(struct mddev *mddev, char *page)
+backlog_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%lu\n", mddev->bitmap_info.max_write_behind);
 }
 
 static ssize_t
-backlog_store(struct mddev *mddev, const char *buf, size_t len)
+backlog_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	unsigned long backlog;
 	int rv = strict_strtoul(buf, 10, &backlog);
@@ -2159,13 +2167,15 @@ static struct md_sysfs_entry bitmap_back
 __ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
 
 static ssize_t
-chunksize_show(struct mddev *mddev, char *page)
+chunksize_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%lu\n", mddev->bitmap_info.chunksize);
 }
 
 static ssize_t
-chunksize_store(struct mddev *mddev, const char *buf, size_t len)
+chunksize_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	/* Can only be changed when no bitmap is active */
 	int rv;
@@ -2185,13 +2195,15 @@ chunksize_store(struct mddev *mddev, con
 static struct md_sysfs_entry bitmap_chunksize =
 __ATTR(chunksize, S_IRUGO|S_IWUSR, chunksize_show, chunksize_store);
 
-static ssize_t metadata_show(struct mddev *mddev, char *page)
+static ssize_t metadata_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	return sprintf(page, "%s\n", (mddev->bitmap_info.external
 				      ? "external" : "internal"));
 }
 
-static ssize_t metadata_store(struct mddev *mddev, const char *buf, size_t len)
+static ssize_t metadata_store(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	if (mddev->bitmap ||
 	    mddev->bitmap_info.file ||
@@ -2209,7 +2221,8 @@ static ssize_t metadata_store(struct mdd
 static struct md_sysfs_entry bitmap_metadata =
 __ATTR(metadata, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
-static ssize_t can_clear_show(struct mddev *mddev, char *page)
+static ssize_t can_clear_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	int len;
 	if (mddev->bitmap)
@@ -2220,7 +2233,8 @@ static ssize_t can_clear_show(struct mdd
 	return len;
 }
 
-static ssize_t can_clear_store(struct mddev *mddev, const char *buf, size_t len)
+static ssize_t can_clear_store(struct mddev *mddev,
+	struct md_sysfs_entry *entry, const char *buf, size_t len)
 {
 	if (mddev->bitmap == NULL)
 		return -ENOENT;
@@ -2239,7 +2253,8 @@ static struct md_sysfs_entry bitmap_can_
 __ATTR(can_clear, S_IRUGO|S_IWUSR, can_clear_show, can_clear_store);
 
 static ssize_t
-behind_writes_used_show(struct mddev *mddev, char *page)
+behind_writes_used_show(struct mddev *mddev, struct md_sysfs_entry *entry,
+	char *page)
 {
 	if (mddev->bitmap == NULL)
 		return sprintf(page, "0\n");
@@ -2248,7 +2263,8 @@ behind_writes_used_show(struct mddev *md
 }
 
 static ssize_t
-behind_writes_used_reset(struct mddev *mddev, const char *buf, size_t len)
+behind_writes_used_reset(struct mddev *mddev, struct md_sysfs_entry *entry,
+	const char *buf, size_t len)
 {
 	if (mddev->bitmap)
 		mddev->bitmap->behind_writes_used = 0;
