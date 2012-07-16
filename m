From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: multiple thread handle stripe
Date: Mon, 16 Jul 2012 14:47:46 +1000
Message-ID: <20120716144746.08d26926@notabene.brown>
References: <20120709080024.GA801@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OLDbP9l6KH54as4eg=wzSS4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709080024.GA801@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/OLDbP9l6KH54as4eg=wzSS4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 16:00:24 +0800 Shaohua Li <shli@kernel.org> wrote:

> I had another implementation of raid5 mult-thread. The basic idea is to r=
ecord
> stripe submitted CPU. Each cpu has a thread, which only handles stripes
> submitted from this cpu.
>=20
> Dan mentioned similar idea several day ago. I used to think we need make
> conf->device_lock per-cpu to make this work, but turn out that isn't requ=
ired.
> Simply using percpu list and still using global device_lock works here.
> Performance is good too.
>=20
> This is a RFC patch, I'll resubmit in a better reviewable way if you like=
 the idea.

I mostly like this, thanks.  It seems to take a fairly simple approach -
having a single list of pending stripes and each thread just takes the ones
that are relevant for it.

I'm not convinced of the idea of having one thread for every CPU though. I
wonder if we should be more NUMA-aware.
E.g. on an Intel core with SMT we want at most one thread per core, not one
thread per control thread.
Similarly in a larger NUMA machine we might want one or 2 threads per node
even if they have multiple CPUs.  Does that seem reasonable?

So I imagine having each aux thread be tied to some collection of CPUs.
We keep a mask of all CPUs that any thread is tied to.  If a stripe_head is
marked for a CPU not in that mask (or that is not available) the main thread
handles that stripe, otherwise it is left for the thread (or threads) which
request that CPU.
Then we have a simple program that, based on some policy configuration,
creates multiple threads, sets the allows_cpu mask for each, and then calls
some new "MD_RUN_AUX_THREAD" ioctl passing a mask of cpus to service
(presumably similar to the mask of CPUs that it can run on).

This gives up  the flexiblity to experiment with different NUMA and SMT
policies without putting too much knowledge into the kernel.

What do you think of that?

NeilBrown


>=20
>=20
> ---
>  drivers/md/md.c        |    7 +
>  drivers/md/md.h        |    7 +
>  drivers/md/multipath.c |    3=20
>  drivers/md/raid1.c     |    3=20
>  drivers/md/raid10.c    |    3=20
>  drivers/md/raid5.c     |  182 +++++++++++++++++++++++++++++++++++-------=
-------
>  drivers/md/raid5.h     |    4 -
>  7 files changed, 148 insertions(+), 61 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-07-09 01:25:37.522848182 -0600
> +++ linux/drivers/md/raid5.c	2012-07-09 01:27:43.202847084 -0600
> @@ -208,8 +208,17 @@ static void handle_release_stripe(struct
>  			   sh->bm_seq - conf->seq_write > 0)
>  			list_add_tail(&sh->lru, &conf->bitmap_list);
>  		else {
> +			int cpu =3D sh->cpu;
> +			struct raid5_percpu *percpu;
> +			if (!cpu_online(cpu)) {
> +				cpu =3D cpumask_any(cpu_online_mask);
> +				sh->cpu =3D cpu;
> +			}
> +			percpu =3D per_cpu_ptr(conf->percpu, cpu);
>  			clear_bit(STRIPE_BIT_DELAY, &sh->state);
> -			list_add_tail(&sh->lru, &conf->handle_list);
> +			list_add_tail(&sh->lru, &percpu->handle_list);
> +			md_wakeup_thread(percpu->aux_thread);
> +			return;
>  		}
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
> @@ -354,6 +363,7 @@ static void init_stripe(struct stripe_he
>  		raid5_build_block(sh, i, previous);
>  	}
>  	insert_hash(conf, sh);
> +	sh->cpu =3D smp_processor_id();
>  }
> =20
>  static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t s=
ector,
> @@ -3646,12 +3656,19 @@ static void raid5_activate_delayed(struc
>  		while (!list_empty(&conf->delayed_list)) {
>  			struct list_head *l =3D conf->delayed_list.next;
>  			struct stripe_head *sh;
> +			int cpu;
>  			sh =3D list_entry(l, struct stripe_head, lru);
>  			list_del_init(l);
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			list_add_tail(&sh->lru, &conf->hold_list);
> +			cpu =3D sh->cpu;
> +			if (!cpu_online(cpu)) {
> +				cpu =3D cpumask_any(cpu_online_mask);
> +				sh->cpu =3D cpu;
> +			}
> +			md_wakeup_thread(per_cpu_ptr(conf->percpu, cpu)->aux_thread);
>  		}
>  	}
>  }
> @@ -3924,18 +3941,20 @@ static int chunk_aligned_read(struct mdd
>   * head of the hold_list has changed, i.e. the head was promoted to the
>   * handle_list.
>   */
> -static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
> +static struct stripe_head *__get_priority_stripe(struct r5conf *conf, in=
t cpu)
>  {
> -	struct stripe_head *sh;
> +	struct stripe_head *sh =3D NULL, *tmp;
> +	struct list_head *handle_list =3D
> +			&per_cpu_ptr(conf->percpu, cpu)->handle_list;
> =20
>  	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\n",
>  		  __func__,
> -		  list_empty(&conf->handle_list) ? "empty" : "busy",
> +		  list_empty(handle_list) ? "empty" : "busy",
>  		  list_empty(&conf->hold_list) ? "empty" : "busy",
>  		  atomic_read(&conf->pending_full_writes), conf->bypass_count);
> =20
> -	if (!list_empty(&conf->handle_list)) {
> -		sh =3D list_entry(conf->handle_list.next, typeof(*sh), lru);
> +	if (!list_empty(handle_list)) {
> +		sh =3D list_entry(handle_list->next, typeof(*sh), lru);
> =20
>  		if (list_empty(&conf->hold_list))
>  			conf->bypass_count =3D 0;
> @@ -3953,12 +3972,20 @@ static struct stripe_head *__get_priorit
>  		   ((conf->bypass_threshold &&
>  		     conf->bypass_count > conf->bypass_threshold) ||
>  		    atomic_read(&conf->pending_full_writes) =3D=3D 0)) {
> -		sh =3D list_entry(conf->hold_list.next,
> -				typeof(*sh), lru);
> -		conf->bypass_count -=3D conf->bypass_threshold;
> -		if (conf->bypass_count < 0)
> -			conf->bypass_count =3D 0;
> -	} else
> +		list_for_each_entry(tmp, &conf->hold_list,  lru) {
> +			if (tmp->cpu =3D=3D cpu || !cpu_online(tmp->cpu)) {
> +				sh =3D tmp;
> +				break;
> +			}
> +		}
> +
> +		if (sh) {
> +			conf->bypass_count -=3D conf->bypass_threshold;
> +			if (conf->bypass_count < 0)
> +				conf->bypass_count =3D 0;
> +		}
> +	}
> +	if (!sh)
>  		return NULL;
> =20
>  	list_del_init(&sh->lru);
> @@ -4551,13 +4578,13 @@ static int  retry_aligned_read(struct r5
>  }
> =20
>  #define MAX_STRIPE_BATCH 8
> -static int handle_active_stripes(struct r5conf *conf)
> +static int handle_active_stripes(struct r5conf *conf, int cpu)
>  {
>  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
>  	int i, batch_size =3D 0;
> =20
>  	while (batch_size < MAX_STRIPE_BATCH &&
> -			(sh =3D __get_priority_stripe(conf)) !=3D NULL)
> +			(sh =3D __get_priority_stripe(conf, cpu)) !=3D NULL)
>  		batch[batch_size++] =3D sh;
> =20
>  	if (batch_size =3D=3D 0)
> @@ -4575,6 +4602,35 @@ static int handle_active_stripes(struct
>  	return batch_size;
>  }
> =20
> +static void raid5auxd(struct md_thread *thread)
> +{
> +	struct mddev *mddev =3D thread->mddev;
> +	struct r5conf *conf =3D mddev->private;
> +	struct blk_plug plug;
> +	int handled;
> +	int cpu =3D (long)thread->thread_data;
> +
> +	set_cpus_allowed(current, cpumask_of_cpu(cpu));
> +	pr_debug("+++ raid5auxd active\n");
> +
> +	blk_start_plug(&plug);
> +	handled =3D 0;
> +	spin_lock_irq(&conf->device_lock);
> +	while (1) {
> +		int batch_size;
> +
> +		batch_size =3D handle_active_stripes(conf, cpu);
> +		if (!batch_size)
> +			break;
> +		handled +=3D batch_size;
> +	}
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
> @@ -4582,11 +4638,13 @@ static int handle_active_stripes(struct
>   * During the scan, completed stripes are saved for us by the interrupt
>   * handler, so that they will not have to wait for our next wakeup.
>   */
> -static void raid5d(struct mddev *mddev)
> +static void raid5d(struct md_thread *thread)
>  {
> +	struct mddev *mddev =3D thread->mddev;
>  	struct r5conf *conf =3D mddev->private;
>  	int handled;
>  	struct blk_plug plug;
> +	struct bio *bio;
> =20
>  	pr_debug("+++ raid5d active\n");
> =20
> @@ -4595,43 +4653,34 @@ static void raid5d(struct mddev *mddev)
>  	blk_start_plug(&plug);
>  	handled =3D 0;
>  	spin_lock_irq(&conf->device_lock);
> -	while (1) {
> -		struct bio *bio;
> -		int batch_size;
> =20
> -		if (atomic_read(&mddev->plug_cnt) =3D=3D 0 &&
> +	if (atomic_read(&mddev->plug_cnt) =3D=3D 0 &&
>  		    !list_empty(&conf->bitmap_list)) {
> -			/* Now is a good time to flush some bitmap updates */
> -			conf->seq_flush++;
> -			spin_unlock_irq(&conf->device_lock);
> -			bitmap_unplug(mddev->bitmap);
> -			spin_lock_irq(&conf->device_lock);
> -			conf->seq_write =3D conf->seq_flush;
> -			activate_bit_delay(conf);
> -		}
> -		if (atomic_read(&mddev->plug_cnt) =3D=3D 0)
> -			raid5_activate_delayed(conf);
> -
> -		while ((bio =3D remove_bio_from_retry(conf))) {
> -			int ok;
> -			spin_unlock_irq(&conf->device_lock);
> -			ok =3D retry_aligned_read(conf, bio);
> -			spin_lock_irq(&conf->device_lock);
> -			if (!ok)
> -				break;
> -			handled++;
> -		}
> +		/* Now is a good time to flush some bitmap updates */
> +		conf->seq_flush++;
> +		spin_unlock_irq(&conf->device_lock);
> +		bitmap_unplug(mddev->bitmap);
> +		spin_lock_irq(&conf->device_lock);
> +		conf->seq_write =3D conf->seq_flush;
> +		activate_bit_delay(conf);
> +	}
> +	if (atomic_read(&mddev->plug_cnt) =3D=3D 0)
> +		raid5_activate_delayed(conf);
> =20
> -		batch_size =3D handle_active_stripes(conf);
> -		if (!batch_size)
> +	while ((bio =3D remove_bio_from_retry(conf))) {
> +		int ok;
> +		spin_unlock_irq(&conf->device_lock);
> +		ok =3D retry_aligned_read(conf, bio);
> +		spin_lock_irq(&conf->device_lock);
> +		if (!ok)
>  			break;
> -		handled +=3D batch_size;
> +		handled++;
> +	}
> =20
> -		if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
> -			spin_unlock_irq(&conf->device_lock);
> -			md_check_recovery(mddev);
> -			spin_lock_irq(&conf->device_lock);
> -		}
> +	if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
> +		spin_unlock_irq(&conf->device_lock);
> +		md_check_recovery(mddev);
> +		spin_lock_irq(&conf->device_lock);
>  	}
>  	pr_debug("%d stripes handled\n", handled);
> =20
> @@ -4791,6 +4840,7 @@ static void raid5_free_percpu(struct r5c
>  		percpu =3D per_cpu_ptr(conf->percpu, cpu);
>  		safe_put_page(percpu->spare_page);
>  		kfree(percpu->scribble);
> +		md_unregister_thread(&percpu->aux_thread);
>  	}
>  #ifdef CONFIG_HOTPLUG_CPU
>  	unregister_cpu_notifier(&conf->cpu_notify);
> @@ -4815,6 +4865,7 @@ static int raid456_cpu_notify(struct not
>  {
>  	struct r5conf *conf =3D container_of(nfb, struct r5conf, cpu_notify);
>  	long cpu =3D (long)hcpu;
> +	long anycpu;
>  	struct raid5_percpu *percpu =3D per_cpu_ptr(conf->percpu, cpu);
> =20
>  	switch (action) {
> @@ -4824,8 +4875,18 @@ static int raid456_cpu_notify(struct not
>  			percpu->spare_page =3D alloc_page(GFP_KERNEL);
>  		if (!percpu->scribble)
>  			percpu->scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
> +		if (!percpu->aux_thread) {
> +			char name[10];
> +
> +			snprintf(name, 10, "aux%ld", cpu);
> +			percpu->aux_thread =3D md_register_thread(raid5auxd,
> +							conf->mddev, name);
> +			if (percpu->aux_thread)
> +				percpu->aux_thread->thread_data =3D (void *)cpu;
> +			INIT_LIST_HEAD(&(percpu->handle_list));
> +		}
> =20
> -		if (!percpu->scribble ||
> +		if (!percpu->scribble || !percpu->aux_thread ||
>  		    (conf->level =3D=3D 6 && !percpu->spare_page)) {
>  			safe_put_page(percpu->spare_page);
>  			kfree(percpu->scribble);
> @@ -4836,6 +4897,14 @@ static int raid456_cpu_notify(struct not
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> +		md_unregister_thread(&percpu->aux_thread);
> +
> +		spin_lock_irq(&conf->device_lock);
> +		anycpu =3D cpumask_any(cpu_online_mask);
> +		list_splice_tail_init(&percpu->handle_list,
> +			&per_cpu_ptr(conf->percpu, anycpu)->handle_list);
> +		spin_unlock_irq(&conf->device_lock);
> +
>  		safe_put_page(percpu->spare_page);
>  		kfree(percpu->scribble);
>  		percpu->spare_page =3D NULL;
> @@ -4864,20 +4933,32 @@ static int raid5_alloc_percpu(struct r5c
>  	get_online_cpus();
>  	err =3D 0;
>  	for_each_present_cpu(cpu) {
> +		struct raid5_percpu *percpu =3D per_cpu_ptr(conf->percpu, cpu);
> +		char name[10];
> +
>  		if (conf->level =3D=3D 6) {
>  			spare_page =3D alloc_page(GFP_KERNEL);
>  			if (!spare_page) {
>  				err =3D -ENOMEM;
>  				break;
>  			}
> -			per_cpu_ptr(conf->percpu, cpu)->spare_page =3D spare_page;
> +			percpu->spare_page =3D spare_page;
>  		}
>  		scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
>  		if (!scribble) {
>  			err =3D -ENOMEM;
>  			break;
>  		}
> -		per_cpu_ptr(conf->percpu, cpu)->scribble =3D scribble;
> +		percpu->scribble =3D scribble;
> +		snprintf(name, 10, "aux%ld", cpu);
> +		percpu->aux_thread =3D md_register_thread(raid5auxd, conf->mddev,
> +							name);
> +		if (!percpu->aux_thread) {
> +			err =3D -ENOMEM;
> +			break;
> +		}
> +		percpu->aux_thread->thread_data =3D (void *)cpu;
> +		INIT_LIST_HEAD(&(percpu->handle_list));
>  	}
>  #ifdef CONFIG_HOTPLUG_CPU
>  	conf->cpu_notify.notifier_call =3D raid456_cpu_notify;
> @@ -4932,7 +5013,6 @@ static struct r5conf *setup_conf(struct
>  	spin_lock_init(&conf->device_lock);
>  	init_waitqueue_head(&conf->wait_for_stripe);
>  	init_waitqueue_head(&conf->wait_for_overlap);
> -	INIT_LIST_HEAD(&conf->handle_list);
>  	INIT_LIST_HEAD(&conf->hold_list);
>  	INIT_LIST_HEAD(&conf->delayed_list);
>  	INIT_LIST_HEAD(&conf->bitmap_list);
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2012-07-09 01:25:37.492848182 -0600
> +++ linux/drivers/md/raid5.h	2012-07-09 01:27:43.202847084 -0600
> @@ -211,6 +211,7 @@ struct stripe_head {
>  	enum check_states	check_state;
>  	enum reconstruct_states reconstruct_state;
>  	spinlock_t		stripe_lock;
> +	int cpu;
>  	/**
>  	 * struct stripe_operations
>  	 * @target - STRIPE_OP_COMPUTE_BLK target
> @@ -395,7 +396,6 @@ struct r5conf {
>  						  * but is closest to zero.
>  						  */
> =20
> -	struct list_head	handle_list; /* stripes needing handling */
>  	struct list_head	hold_list; /* preread ready stripes */
>  	struct list_head	delayed_list; /* stripes that have plugged requests */
>  	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap updat=
e */
> @@ -431,6 +431,8 @@ struct r5conf {
>  					      * lists and performing address
>  					      * conversions
>  					      */
> +		struct list_head handle_list; /*stripes needing handling */
> +		struct md_thread *aux_thread;
>  	} __percpu *percpu;
>  	size_t			scribble_len; /* size of scribble region must be
>  					       * associated with conf to handle
> Index: linux/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/md.c	2012-07-09 01:25:37.502848182 -0600
> +++ linux/drivers/md/md.c	2012-07-09 01:27:43.202847084 -0600
> @@ -6715,7 +6715,7 @@ static int md_thread(void * arg)
> =20
>  		clear_bit(THREAD_WAKEUP, &thread->flags);
>  		if (!kthread_should_stop())
> -			thread->run(thread->mddev);
> +			thread->run(thread);
>  	}
> =20
>  	return 0;
> @@ -6730,7 +6730,7 @@ void md_wakeup_thread(struct md_thread *
>  	}
>  }
> =20
> -struct md_thread *md_register_thread(void (*run) (struct mddev *), struc=
t mddev *mddev,
> +struct md_thread *md_register_thread(void (*run) (struct md_thread *), s=
truct mddev *mddev,
>  				 const char *name)
>  {
>  	struct md_thread *thread;
> @@ -7280,8 +7280,9 @@ EXPORT_SYMBOL_GPL(md_allow_write);
> =20
>  #define SYNC_MARKS	10
>  #define	SYNC_MARK_STEP	(3*HZ)
> -void md_do_sync(struct mddev *mddev)
> +void md_do_sync(struct md_thread *thread)
>  {
> +	struct mddev *mddev =3D thread->mddev;
>  	struct mddev *mddev2;
>  	unsigned int currspeed =3D 0,
>  		 window;
> Index: linux/drivers/md/md.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/md.h	2012-07-09 01:25:37.482848182 -0600
> +++ linux/drivers/md/md.h	2012-07-09 01:27:43.202847084 -0600
> @@ -543,12 +543,13 @@ static inline void sysfs_unlink_rdev(str
>  	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
> =20
>  struct md_thread {
> -	void			(*run) (struct mddev *mddev);
> +	void			(*run) (struct md_thread *thread);
>  	struct mddev		*mddev;
>  	wait_queue_head_t	wqueue;
>  	unsigned long           flags;
>  	struct task_struct	*tsk;
>  	unsigned long		timeout;
> +	void			*thread_data;
>  };
> =20
>  #define THREAD_WAKEUP  0
> @@ -587,7 +588,7 @@ static inline void safe_put_page(struct
>  extern int register_md_personality(struct md_personality *p);
>  extern int unregister_md_personality(struct md_personality *p);
>  extern struct md_thread *md_register_thread(
> -	void (*run)(struct mddev *mddev),
> +	void (*run)(struct md_thread *thread),
>  	struct mddev *mddev,
>  	const char *name);
>  extern void md_unregister_thread(struct md_thread **threadp);
> @@ -606,7 +607,7 @@ extern void md_super_write(struct mddev
>  extern void md_super_wait(struct mddev *mddev);
>  extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,=
=20
>  			struct page *page, int rw, bool metadata_op);
> -extern void md_do_sync(struct mddev *mddev);
> +extern void md_do_sync(struct md_thread *thread);
>  extern void md_new_event(struct mddev *mddev);
>  extern int md_allow_write(struct mddev *mddev);
>  extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev =
*mddev);
> Index: linux/drivers/md/multipath.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/multipath.c	2012-07-09 01:25:37.532848182 -0600
> +++ linux/drivers/md/multipath.c	2012-07-09 01:27:43.202847084 -0600
> @@ -335,8 +335,9 @@ abort:
>   *	3.	Performs writes following reads for array syncronising.
>   */
> =20
> -static void multipathd (struct mddev *mddev)
> +static void multipathd (struct md_thread *thread)
>  {
> +	struct mddev *mddev =3D thread->mddev;
>  	struct multipath_bh *mp_bh;
>  	struct bio *bio;
>  	unsigned long flags;
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c	2012-07-09 01:25:37.512848182 -0600
> +++ linux/drivers/md/raid1.c	2012-07-09 01:27:43.202847084 -0600
> @@ -2157,8 +2157,9 @@ read_more:
>  	}
>  }
> =20
> -static void raid1d(struct mddev *mddev)
> +static void raid1d(struct md_thread *thread)
>  {
> +	struct mddev *mddev =3D thread->mddev;
>  	struct r1bio *r1_bio;
>  	unsigned long flags;
>  	struct r1conf *conf =3D mddev->private;
> Index: linux/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid10.c	2012-07-09 01:25:37.502848182 -0600
> +++ linux/drivers/md/raid10.c	2012-07-09 01:27:43.202847084 -0600
> @@ -2648,8 +2648,9 @@ static void handle_write_completed(struc
>  	}
>  }
> =20
> -static void raid10d(struct mddev *mddev)
> +static void raid10d(struct md_thread *thread)
>  {
> +	struct mddev *mddev =3D thread->mddev;
>  	struct r10bio *r10_bio;
>  	unsigned long flags;
>  	struct r10conf *conf =3D mddev->private;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/OLDbP9l6KH54as4eg=wzSS4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOc8jnsnt1WYoG5AQJfiw/+OOM5yVzhVLOKZmjZsYAWsJzJmnwhvn7d
+1zzKbxoi9/WQfF2q/VXSvzExCKvdx3lYgFnUnDA/5Es30qsLseB1TMwmcZTep7S
ziJlAwg3eyA34ZzjRx+3h1Bz+V0EM/71x4S1aL3e1BahC7dhDQGKZh2VP/1vacgg
nmKRqn9pLwss/0qlMR+rZJdm0CpvQqpNIn9cpkl23I9Dv3SQtoeMSvfluJQznTCG
/7FjGQRy7IeQDSuz13HHucNn8obAZm1ZTuK2ytMubSN6Y1xXFjOj348un/14TWzL
JvQya6qi/SpVbKcZstdukzeBIPe4drDYKITc1Fyh4Hg+edap4UH7zaYyySQqbip8
W1mhHHMINJShjoWjjo0xRtauJW4LcZXcX9L55DS7tEwuoMRhFQyu4LzS6J4df8a3
GvSBotGJFY8BXDx2as2CA7Q0ZA996AjXKPu3Aej01G8M2y9vYCAOQi2Xv0IXIGBM
6xgRBXXusqocO13ou+YyvhpKeJ8zZc1XM8EIB3LfJ+EQeoI/E1cVRDog7MOzZJTS
YoajnxM1C9smX02H3e0yaqQudguPFP27z+xpPrIQ+NQKWwfJsFMfebLVZ7rwWFUG
f9rgzvkRUv3Gx8pJerpwtMotz3wmBbJUh4Jl50fgSgucTpEBEa3hHtTDVqkliopN
m34uisyQmrE=
=xjbh
-----END PGP SIGNATURE-----

--Sig_/OLDbP9l6KH54as4eg=wzSS4--
