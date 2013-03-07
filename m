From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 2/2 v3]raid5: create multiple threads to handle stripes
Date: Thu, 7 Mar 2013 15:31:23 +0800
Message-ID: <20130307073123.GA5819@kernel.org>
References: <20120809085808.GB30111@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120809085808.GB30111@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@gmail.com
List-Id: linux-raid.ids

Hi Neil,

I just noticed this one is missed. It used to be in your branch, but get
dropped some time. Is anything I missed? I can resend it if you like.

Thanks,
Shaohua

On Thu, Aug 09, 2012 at 04:58:08PM +0800, Shaohua Li wrote:
> This is a new tempt to make raid5 handle stripes in multiple threads, as
> suggested by Neil to have maxium flexibility and better numa binding. It
> basically is a combination of my first and second generation patches. By
> default, no multiple thread is enabled (all stripes are handled by raid5d).
> 
> An example to enable multiple threads:
> #echo 3 > /sys/block/md0/md/auxthread_number
> This will create 3 auxiliary threads to handle stripes. The threads can run
> on any cpus and handle stripes produced by any cpus.
> 
> #echo 1-3 > /sys/block/md0/md/auxth0/cpulist
> This will bind auxiliary thread 0 to cpu 1-3, and this thread will only handle
> stripes produced by cpu 1-3. User tool can further change the thread's
> affinity, but the thread can only handle stripes produced by cpu 1-3 till the
> sysfs entry is changed again.
> 
> If stripes produced by a CPU aren't handled by any auxiliary thread, such
> stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
> stripes.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/md.c    |    8 -
>  drivers/md/md.h    |    8 +
>  drivers/md/raid5.c |  406 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/md/raid5.h |   19 ++
>  4 files changed, 418 insertions(+), 23 deletions(-)
> 
> Index: linux/drivers/md/raid5.c
> ===================================================================
> --- linux.orig/drivers/md/raid5.c	2012-08-09 10:43:04.800022626 +0800
> +++ linux/drivers/md/raid5.c	2012-08-09 16:44:39.663278511 +0800
> @@ -196,6 +196,21 @@ static int stripe_operations_active(stru
>  	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
>  }
>  
> +static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
> +{
> +	struct r5conf *conf = sh->raid_conf;
> +	struct raid5_percpu *percpu;
> +	int i, orphaned = 1;
> +
> +	percpu = per_cpu_ptr(conf->percpu, sh->cpu);
> +	for_each_cpu(i, &percpu->handle_threads) {
> +		md_wakeup_thread(conf->aux_threads[i]->thread);
> +		orphaned = 0;
> +	}
> +	if (orphaned)
> +		md_wakeup_thread(conf->mddev->thread);
> +}
> +
>  static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
>  {
>  	BUG_ON(!list_empty(&sh->lru));
> @@ -208,9 +223,19 @@ static void do_release_stripe(struct r5c
>  			   sh->bm_seq - conf->seq_write > 0)
>  			list_add_tail(&sh->lru, &conf->bitmap_list);
>  		else {
> +			int cpu = sh->cpu;
> +			struct raid5_percpu *percpu;
> +			if (!cpu_online(cpu)) {
> +				cpu = cpumask_any(cpu_online_mask);
> +				sh->cpu = cpu;
> +			}
> +			percpu = per_cpu_ptr(conf->percpu, cpu);
> +
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			clear_bit(STRIPE_BIT_DELAY, &sh->state);
> -			list_add_tail(&sh->lru, &conf->handle_list);
> +			list_add_tail(&sh->lru, &percpu->handle_list);
> +			raid5_wakeup_stripe_thread(sh);
> +			return;
>  		}
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
> @@ -355,6 +380,7 @@ static void init_stripe(struct stripe_he
>  		raid5_build_block(sh, i, previous);
>  	}
>  	insert_hash(conf, sh);
> +	sh->cpu = smp_processor_id();
>  }
>  
>  static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
> @@ -3689,12 +3715,19 @@ static void raid5_activate_delayed(struc
>  		while (!list_empty(&conf->delayed_list)) {
>  			struct list_head *l = conf->delayed_list.next;
>  			struct stripe_head *sh;
> +			int cpu;
>  			sh = list_entry(l, struct stripe_head, lru);
>  			list_del_init(l);
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			list_add_tail(&sh->lru, &conf->hold_list);
> +			cpu = sh->cpu;
> +			if (!cpu_online(cpu)) {
> +				cpu = cpumask_any(cpu_online_mask);
> +				sh->cpu = cpu;
> +			}
> +			raid5_wakeup_stripe_thread(sh);
>  		}
>  	}
>  }
> @@ -3968,18 +4001,29 @@ static int chunk_aligned_read(struct mdd
>   * head of the hold_list has changed, i.e. the head was promoted to the
>   * handle_list.
>   */
> -static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
> +static struct stripe_head *__get_priority_stripe(struct r5conf *conf,
> +	cpumask_t *mask)
>  {
> -	struct stripe_head *sh;
> -
> +	struct stripe_head *sh = NULL, *tmp;
> +	struct list_head *handle_list = NULL;
> +	int cpu;
> +
> +	/* Should we take action to avoid starvation of latter CPUs ? */
> +	for_each_cpu(cpu, mask) {
> +		struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
> +		if (!list_empty(&percpu->handle_list)) {
> +			handle_list = &percpu->handle_list;
> +			break;
> +		}
> +	}
>  	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\n",
>  		  __func__,
> -		  list_empty(&conf->handle_list) ? "empty" : "busy",
> +		  !handle_list ? "empty" : "busy",
>  		  list_empty(&conf->hold_list) ? "empty" : "busy",
>  		  atomic_read(&conf->pending_full_writes), conf->bypass_count);
>  
> -	if (!list_empty(&conf->handle_list)) {
> -		sh = list_entry(conf->handle_list.next, typeof(*sh), lru);
> +	if (handle_list) {
> +		sh = list_entry(handle_list->next, typeof(*sh), lru);
>  
>  		if (list_empty(&conf->hold_list))
>  			conf->bypass_count = 0;
> @@ -3997,12 +4041,23 @@ static struct stripe_head *__get_priorit
>  		   ((conf->bypass_threshold &&
>  		     conf->bypass_count > conf->bypass_threshold) ||
>  		    atomic_read(&conf->pending_full_writes) == 0)) {
> -		sh = list_entry(conf->hold_list.next,
> -				typeof(*sh), lru);
> -		conf->bypass_count -= conf->bypass_threshold;
> -		if (conf->bypass_count < 0)
> -			conf->bypass_count = 0;
> -	} else
> +
> +		list_for_each_entry(tmp, &conf->hold_list,  lru) {
> +			if (cpumask_test_cpu(tmp->cpu, mask) ||
> +			    !cpu_online(tmp->cpu)) {
> +				sh = tmp;
> +				break;
> +			}
> +		}
> +
> +		if (sh) {
> +			conf->bypass_count -= conf->bypass_threshold;
> +			if (conf->bypass_count < 0)
> +				conf->bypass_count = 0;
> +		}
> +	}
> +
> +	if (!sh)
>  		return NULL;
>  
>  	list_del_init(&sh->lru);
> @@ -4594,13 +4649,13 @@ static int  retry_aligned_read(struct r5
>  }
>  
>  #define MAX_STRIPE_BATCH 8
> -static int handle_active_stripes(struct r5conf *conf)
> +static int handle_active_stripes(struct r5conf *conf, cpumask_t *mask)
>  {
>  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
>  	int i, batch_size = 0;
>  
>  	while (batch_size < MAX_STRIPE_BATCH &&
> -			(sh = __get_priority_stripe(conf)) != NULL)
> +			(sh = __get_priority_stripe(conf, mask)) != NULL)
>  		batch[batch_size++] = sh;
>  
>  	if (batch_size == 0)
> @@ -4618,6 +4673,35 @@ static int handle_active_stripes(struct
>  	return batch_size;
>  }
>  
> +static void raid5auxd(struct md_thread *thread)
> +{
> +	struct mddev *mddev = thread->mddev;
> +	struct r5conf *conf = mddev->private;
> +	struct blk_plug plug;
> +	int handled;
> +	struct raid5_auxth *auxth = thread->private;
> +
> +	pr_debug("+++ raid5auxd active\n");
> +
> +	blk_start_plug(&plug);
> +	handled = 0;
> +	spin_lock_irq(&conf->device_lock);
> +	while (1) {
> +		int batch_size;
> +
> +		batch_size = handle_active_stripes(conf, &auxth->work_mask);
> +		if (!batch_size)
> +			break;
> +		handled += batch_size;
> +	}
> +	pr_debug("%d stripes handled\n", handled);
> +
> +	spin_unlock_irq(&conf->device_lock);
> +	blk_finish_plug(&plug);
> +
> +	pr_debug("--- raid5auxd inactive\n");
> +}
> +
>  /*
>   * This is our raid5 kernel thread.
>   *
> @@ -4665,7 +4749,7 @@ static void raid5d(struct md_thread *thr
>  			handled++;
>  		}
>  
> -		batch_size = handle_active_stripes(conf);
> +		batch_size = handle_active_stripes(conf, &conf->work_mask);
>  		if (!batch_size)
>  			break;
>  		handled += batch_size;
> @@ -4794,10 +4878,270 @@ stripe_cache_active_show(struct mddev *m
>  static struct md_sysfs_entry
>  raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
>  
> +static void raid5_update_threads_handle_mask(struct mddev *mddev)
> +{
> +	int cpu, i;
> +	struct raid5_percpu *percpu;
> +	struct r5conf *conf = mddev->private;
> +
> +	for_each_online_cpu(cpu) {
> +		percpu = per_cpu_ptr(conf->percpu, cpu);
> +		cpumask_clear(&percpu->handle_threads);
> +	}
> +	cpumask_copy(&conf->work_mask, cpu_online_mask);
> +
> +	for (i = 0; i < conf->aux_thread_num; i++) {
> +		cpumask_t *work_mask = &conf->aux_threads[i]->work_mask;
> +		for_each_cpu(cpu, work_mask) {
> +			percpu = per_cpu_ptr(conf->percpu, cpu);
> +			cpumask_set_cpu(i, &percpu->handle_threads);
> +		}
> +		cpumask_andnot(&conf->work_mask, &conf->work_mask,
> +				work_mask);
> +	}
> +}
> +
> +struct raid5_auxth_sysfs {
> +	struct attribute attr;
> +	ssize_t (*show)(struct mddev *, struct raid5_auxth *, char *);
> +	ssize_t (*store)(struct mddev *, struct raid5_auxth *,
> +		const char *, size_t);
> +};
> +
> +static ssize_t raid5_show_thread_cpulist(struct mddev *mddev,
> +	struct raid5_auxth *thread, char *page)
> +{
> +	if (!mddev->private)
> +		return 0;
> +	return cpulist_scnprintf(page, PAGE_SIZE, &thread->work_mask);
> +}
> +
> +static ssize_t
> +raid5_store_thread_cpulist(struct mddev *mddev, struct raid5_auxth *thread,
> +	const char *page, size_t len)
> +{
> +	struct r5conf *conf = mddev->private;
> +	cpumask_var_t mask;
> +
> +	if (!conf)
> +		return -ENODEV;
> +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	if (cpulist_parse(page, mask)) {
> +		free_cpumask_var(mask);
> +		return -EINVAL;
> +	}
> +
> +	get_online_cpus();
> +	spin_lock_irq(&conf->device_lock);
> +	cpumask_copy(&thread->work_mask, mask);
> +	raid5_update_threads_handle_mask(mddev);
> +	spin_unlock_irq(&conf->device_lock);
> +	put_online_cpus();
> +	set_cpus_allowed_ptr(thread->thread->tsk, mask);
> +
> +	free_cpumask_var(mask);
> +	return len;
> +}
> +
> +static struct raid5_auxth_sysfs thread_cpulist =
> +__ATTR(cpulist, S_IRUGO|S_IWUSR, raid5_show_thread_cpulist,
> +	raid5_store_thread_cpulist);
> +
> +static struct attribute *auxth_attrs[] = {
> +	&thread_cpulist.attr,
> +	NULL,
> +};
> +
> +static ssize_t
> +raid5_auxth_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
> +{
> +	struct raid5_auxth_sysfs *entry = container_of(attr,
> +		struct raid5_auxth_sysfs, attr);
> +	struct raid5_auxth *thread = container_of(kobj,
> +		struct raid5_auxth, kobj);
> +	struct mddev *mddev = thread->thread->mddev;
> +	ssize_t ret;
> +
> +	if (!entry->show)
> +		return -EIO;
> +	mddev_lock(mddev);
> +	ret = entry->show(mddev, thread, page);
> +	mddev_unlock(mddev);
> +	return ret;
> +}
> +
> +static ssize_t
> +raid5_auxth_attr_store(struct kobject *kobj, struct attribute *attr,
> +	      const char *page, size_t length)
> +{
> +	struct raid5_auxth_sysfs *entry = container_of(attr,
> +		struct raid5_auxth_sysfs, attr);
> +	struct raid5_auxth *thread = container_of(kobj,
> +		struct raid5_auxth, kobj);
> +	struct mddev *mddev = thread->thread->mddev;
> +	ssize_t ret;
> +
> +	if (!entry->store)
> +		return -EIO;
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +	mddev_lock(mddev);
> +	ret = entry->store(mddev, thread, page, length);
> +	mddev_unlock(mddev);
> +	return ret;
> +}
> +
> +static void raid5_auxth_release(struct kobject *kobj)
> +{
> +	struct raid5_auxth *thread = container_of(kobj,
> +		struct raid5_auxth, kobj);
> +	kfree(thread);
> +}
> +
> +static const struct sysfs_ops raid5_auxth_sysfsops = {
> +	.show = raid5_auxth_attr_show,
> +	.store = raid5_auxth_attr_store,
> +};
> +static struct kobj_type raid5_auxth_ktype = {
> +	.release = raid5_auxth_release,
> +	.sysfs_ops = &raid5_auxth_sysfsops,
> +	.default_attrs = auxth_attrs,
> +};
> +
> +static ssize_t
> +raid5_show_auxthread_number(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf = mddev->private;
> +	if (conf)
> +		return sprintf(page, "%d\n", conf->aux_thread_num);
> +	else
> +		return 0;
> +}
> +
> +static void raid5_auxth_delete(struct work_struct *ws)
> +{
> +	struct raid5_auxth *thread = container_of(ws, struct raid5_auxth,
> +		del_work);
> +
> +	kobject_del(&thread->kobj);
> +	kobject_put(&thread->kobj);
> +}
> +
> +static void __free_aux_thread(struct mddev *mddev, struct raid5_auxth *thread)
> +{
> +	md_unregister_thread(&thread->thread);
> +	INIT_WORK(&thread->del_work, raid5_auxth_delete);
> +	kobject_get(&thread->kobj);
> +	md_queue_misc_work(&thread->del_work);
> +}
> +
> +static struct raid5_auxth *__create_aux_thread(struct mddev *mddev, int i)
> +{
> +	struct raid5_auxth *thread;
> +	char name[10];
> +
> +	thread = kzalloc(sizeof(*thread), GFP_KERNEL);
> +	if (!thread)
> +		return NULL;
> +	snprintf(name, 10, "aux%d", i);
> +	thread->thread = md_register_thread(raid5auxd, mddev, name);
> +	if (!thread->thread) {
> +		kfree(thread);
> +		return NULL;
> +	}
> +	thread->thread->private = thread;
> +
> +	cpumask_copy(&thread->work_mask, cpu_online_mask);
> +
> +	if (kobject_init_and_add(&thread->kobj, &raid5_auxth_ktype,
> +	    &mddev->kobj, "auxth%d", i)) {
> +		md_unregister_thread(&thread->thread);
> +		kfree(thread);
> +		return NULL;
> +	}
> +	return thread;
> +}
> +
> +static ssize_t
> +raid5_store_auxthread_number(struct mddev *mddev, const char *page, size_t len)
> +{
> +	struct r5conf *conf = mddev->private;
> +	unsigned long new;
> +	int i;
> +	struct raid5_auxth **threads;
> +
> +	if (len >= PAGE_SIZE)
> +		return -EINVAL;
> +	if (!conf)
> +		return -ENODEV;
> +
> +	if (kstrtoul(page, 10, &new))
> +		return -EINVAL;
> +
> +	if (new == conf->aux_thread_num)
> +		return len;
> +
> +	/* There is no point creating more threads than cpu number */
> +	if (new > num_online_cpus())
> +		return -EINVAL;
> +
> +	if (new > conf->aux_thread_num) {
> +		threads = kzalloc(sizeof(struct raid5_auxth *) * new,
> +				GFP_KERNEL);
> +		if (!threads)
> +			return -ENOMEM;
> +
> +		i = conf->aux_thread_num;
> +		while (i < new) {
> +			threads[i] = __create_aux_thread(mddev, i);
> +			if (!threads[i])
> +				goto error;
> +
> +			i++;
> +		}
> +		memcpy(threads, conf->aux_threads,
> +			sizeof(struct raid5_auxth *) * conf->aux_thread_num);
> +		get_online_cpus();
> +		spin_lock_irq(&conf->device_lock);
> +		kfree(conf->aux_threads);
> +		conf->aux_threads = threads;
> +		conf->aux_thread_num = new;
> +		raid5_update_threads_handle_mask(mddev);
> +		spin_unlock_irq(&conf->device_lock);
> +		put_online_cpus();
> +	} else {
> +		int old = conf->aux_thread_num;
> +
> +		get_online_cpus();
> +		spin_lock_irq(&conf->device_lock);
> +		conf->aux_thread_num = new;
> +		raid5_update_threads_handle_mask(mddev);
> +		spin_unlock_irq(&conf->device_lock);
> +		put_online_cpus();
> +		for (i = new; i < old; i++)
> +			__free_aux_thread(mddev, conf->aux_threads[i]);
> +	}
> +
> +	return len;
> +error:
> +	while (--i >= conf->aux_thread_num)
> +		__free_aux_thread(mddev, threads[i]);
> +	kfree(threads);
> +	return -ENOMEM;
> +}
> +
> +static struct md_sysfs_entry
> +raid5_auxthread_number = __ATTR(auxthread_number, S_IRUGO|S_IWUSR,
> +				raid5_show_auxthread_number,
> +				raid5_store_auxthread_number);
> +
>  static struct attribute *raid5_attrs[] =  {
>  	&raid5_stripecache_size.attr,
>  	&raid5_stripecache_active.attr,
>  	&raid5_preread_bypass_threshold.attr,
> +	&raid5_auxthread_number.attr,
>  	NULL,
>  };
>  static struct attribute_group raid5_attrs_group = {
> @@ -4845,6 +5189,7 @@ static void raid5_free_percpu(struct r5c
>  
>  static void free_conf(struct r5conf *conf)
>  {
> +	kfree(conf->aux_threads);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
>  	kfree(conf->disks);
> @@ -4857,7 +5202,7 @@ static int raid456_cpu_notify(struct not
>  			      void *hcpu)
>  {
>  	struct r5conf *conf = container_of(nfb, struct r5conf, cpu_notify);
> -	long cpu = (long)hcpu;
> +	long cpu = (long)hcpu, anycpu;
>  	struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
>  
>  	switch (action) {
> @@ -4876,9 +5221,17 @@ static int raid456_cpu_notify(struct not
>  			       __func__, cpu);
>  			return notifier_from_errno(-ENOMEM);
>  		}
> +		INIT_LIST_HEAD(&(percpu->handle_list));
> +		cpumask_clear(&percpu->handle_threads);
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> +		spin_lock_irq(&conf->device_lock);
> +		anycpu = cpumask_any(cpu_online_mask);
> +		list_splice_tail_init(&percpu->handle_list,
> +			&per_cpu_ptr(conf->percpu, anycpu)->handle_list);
> +		spin_unlock_irq(&conf->device_lock);
> +
>  		safe_put_page(percpu->spare_page);
>  		kfree(percpu->scribble);
>  		percpu->spare_page = NULL;
> @@ -4887,6 +5240,10 @@ static int raid456_cpu_notify(struct not
>  	default:
>  		break;
>  	}
> +
> +	spin_lock_irq(&conf->device_lock);
> +	raid5_update_threads_handle_mask(conf->mddev);
> +	spin_unlock_irq(&conf->device_lock);
>  	return NOTIFY_OK;
>  }
>  #endif
> @@ -4907,20 +5264,24 @@ static int raid5_alloc_percpu(struct r5c
>  	get_online_cpus();
>  	err = 0;
>  	for_each_present_cpu(cpu) {
> +		struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
> +
>  		if (conf->level == 6) {
>  			spare_page = alloc_page(GFP_KERNEL);
>  			if (!spare_page) {
>  				err = -ENOMEM;
>  				break;
>  			}
> -			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
> +			percpu->spare_page = spare_page;
>  		}
>  		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
>  		if (!scribble) {
>  			err = -ENOMEM;
>  			break;
>  		}
> -		per_cpu_ptr(conf->percpu, cpu)->scribble = scribble;
> +		percpu->scribble = scribble;
> +		INIT_LIST_HEAD(&percpu->handle_list);
> +		cpumask_clear(&percpu->handle_threads);
>  	}
>  #ifdef CONFIG_HOTPLUG_CPU
>  	conf->cpu_notify.notifier_call = raid456_cpu_notify;
> @@ -4976,7 +5337,6 @@ static struct r5conf *setup_conf(struct
>  	spin_lock_init(&conf->device_lock);
>  	init_waitqueue_head(&conf->wait_for_stripe);
>  	init_waitqueue_head(&conf->wait_for_overlap);
> -	INIT_LIST_HEAD(&conf->handle_list);
>  	INIT_LIST_HEAD(&conf->hold_list);
>  	INIT_LIST_HEAD(&conf->delayed_list);
>  	INIT_LIST_HEAD(&conf->bitmap_list);
> @@ -4987,6 +5347,8 @@ static struct r5conf *setup_conf(struct
>  	conf->bypass_threshold = BYPASS_THRESHOLD;
>  	conf->recovery_disabled = mddev->recovery_disabled - 1;
>  
> +	cpumask_copy(&conf->work_mask, cpu_online_mask);
> +
>  	conf->raid_disks = mddev->raid_disks;
>  	if (mddev->reshape_position == MaxSector)
>  		conf->previous_raid_disks = mddev->raid_disks;
> @@ -5403,6 +5765,10 @@ abort:
>  static int stop(struct mddev *mddev)
>  {
>  	struct r5conf *conf = mddev->private;
> +	int i;
> +
> +	for (i = 0; i < conf->aux_thread_num; i++)
> +		__free_aux_thread(mddev, conf->aux_threads[i]);
>  
>  	md_unregister_thread(&mddev->thread);
>  	if (mddev->queue)
> Index: linux/drivers/md/raid5.h
> ===================================================================
> --- linux.orig/drivers/md/raid5.h	2012-08-09 09:57:23.826481331 +0800
> +++ linux/drivers/md/raid5.h	2012-08-09 16:17:51.279501447 +0800
> @@ -211,6 +211,7 @@ struct stripe_head {
>  	enum check_states	check_state;
>  	enum reconstruct_states reconstruct_state;
>  	spinlock_t		stripe_lock;
> +	int			cpu;
>  	/**
>  	 * struct stripe_operations
>  	 * @target - STRIPE_OP_COMPUTE_BLK target
> @@ -364,6 +365,14 @@ struct disk_info {
>  	struct md_rdev	*rdev, *replacement;
>  };
>  
> +struct raid5_auxth {
> +	struct md_thread	*thread;
> +	/* which CPUs should the auxiliary thread handle stripes from */
> +	cpumask_t		work_mask;
> +	struct kobject		kobj;
> +	struct work_struct	del_work;
> +};
> +
>  struct r5conf {
>  	struct hlist_head	*stripe_hashtbl;
>  	struct mddev		*mddev;
> @@ -432,6 +441,12 @@ struct r5conf {
>  					      * lists and performing address
>  					      * conversions
>  					      */
> +		struct list_head handle_list;
> +		cpumask_t	handle_threads; /* Which threads can the CPU's
> +						 * stripes be handled. It really
> +						 * is a bitmap to aux_threads[],
> +						 * but has max bits NR_CPUS
> +						 */
>  	} __percpu *percpu;
>  	size_t			scribble_len; /* size of scribble region must be
>  					       * associated with conf to handle
> @@ -459,6 +474,10 @@ struct r5conf {
>  	 * the new thread here until we fully activate the array.
>  	 */
>  	struct md_thread	*thread;
> +	int			aux_thread_num;
> +	struct raid5_auxth	**aux_threads;
> +	/* which CPUs should raid5d thread handle stripes from */
> +	cpumask_t		work_mask;
>  };
>  
>  /*
> Index: linux/drivers/md/md.c
> ===================================================================
> --- linux.orig/drivers/md/md.c	2012-08-09 10:43:04.796022675 +0800
> +++ linux/drivers/md/md.c	2012-08-09 16:17:19.367902517 +0800
> @@ -640,9 +640,9 @@ static struct mddev * mddev_find(dev_t u
>  	goto retry;
>  }
>  
> -static inline int mddev_lock(struct mddev * mddev)
> +int md_queue_misc_work(struct work_struct *work)
>  {
> -	return mutex_lock_interruptible(&mddev->reconfig_mutex);
> +	return queue_work(md_misc_wq, work);
>  }
>  
>  static inline int mddev_is_locked(struct mddev *mddev)
> @@ -657,7 +657,7 @@ static inline int mddev_trylock(struct m
>  
>  static struct attribute_group md_redundancy_group;
>  
> -static void mddev_unlock(struct mddev * mddev)
> +void mddev_unlock(struct mddev * mddev)
>  {
>  	if (mddev->to_remove) {
>  		/* These cannot be removed under reconfig_mutex as
> @@ -8569,6 +8569,8 @@ EXPORT_SYMBOL(md_register_thread);
>  EXPORT_SYMBOL(md_unregister_thread);
>  EXPORT_SYMBOL(md_wakeup_thread);
>  EXPORT_SYMBOL(md_check_recovery);
> +EXPORT_SYMBOL(mddev_unlock);
> +EXPORT_SYMBOL(md_queue_misc_work);
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("MD RAID framework");
>  MODULE_ALIAS("md");
> Index: linux/drivers/md/md.h
> ===================================================================
> --- linux.orig/drivers/md/md.h	2012-08-09 10:43:04.800022626 +0800
> +++ linux/drivers/md/md.h	2012-08-09 16:14:26.318078815 +0800
> @@ -636,4 +636,12 @@ static inline int mddev_check_plugged(st
>  	return !!blk_check_plugged(md_unplug, mddev,
>  				   sizeof(struct blk_plug_cb));
>  }
> +
> +static inline int mddev_lock(struct mddev * mddev)
> +{
> +	return mutex_lock_interruptible(&mddev->reconfig_mutex);
> +}
> +extern void mddev_unlock(struct mddev *mddev);
> +extern int md_queue_misc_work(struct work_struct *work);
> +
>  #endif /* _MD_MD_H */
