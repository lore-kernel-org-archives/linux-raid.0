From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v3 3/5] raid5: offload stripe handle to workqueue
Date: Wed, 28 Aug 2013 16:56:14 +1000
Message-ID: <20130828165614.011b4331@notabene.brown>
References: <20130827095038.303090029@kernel.org>
	<20130827095452.202091257@kernel.org>
	<20130828135305.3f328d92@notabene.brown>
	<20130828063016.GB17163@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xvmCxCJcax=ShULM_zSDKm="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130828063016.GB17163@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/xvmCxCJcax=ShULM_zSDKm=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Aug 2013 14:30:16 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, Aug 28, 2013 at 01:53:05PM +1000, NeilBrown wrote:
> > On Tue, 27 Aug 2013 17:50:41 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > -static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
> > > +static struct stripe_head *__get_priority_stripe(struct r5conf *conf=
, int group)
> > >  {
> > > -	struct stripe_head *sh;
> > > +	struct stripe_head *sh =3D NULL, *tmp;
> > > +	struct list_head *handle_list =3D NULL;
> > > +
> > > +	if (conf->worker_cnt_per_group =3D=3D 0) {
> > > +		handle_list =3D &conf->handle_list;
> > > +		if (list_empty(handle_list))
> > > +			handle_list =3D NULL;
> > > +	} else if (group !=3D ANY_GROUP) {
> > > +		handle_list =3D &conf->worker_groups[group].handle_list;
> > > +		if (list_empty(handle_list))
> > > +			handle_list =3D NULL;
> > > +	} else {
> > > +		int i;
> > > +		for (i =3D 0; i < conf->group_cnt; i++) {
> > > +			handle_list =3D &conf->worker_groups[i].handle_list;
> > > +			if (!list_empty(handle_list))
> > > +				break;
> > > +		}
> > > +		if (i =3D=3D conf->group_cnt)
> > > +			handle_list =3D NULL;
> > > +	}
> >=20
> > Sorry, I meant to mention this last time...
> >=20
> > The setting of handle_list to NULL seems unnecessary.  It is sufficient=
 to
> > test if it is empty.
> > The only interesting case is the last 'else' above.  That is only reach=
ed if
> > worker_cnt_per_group !=3D 0 so handle_list will get set to some list_he=
ad.
> > If all list_heads are empty, handle_list will be set to the last list_h=
ead
> > so a list_empty(handle_list) test is perfectly safe.
> >=20
> > Also with the current code:
> > > =20
> > >  	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\=
n",
> > >  		  __func__,
> > > -		  list_empty(&conf->handle_list) ? "empty" : "busy",
> > > +		  list_empty(handle_list) ? "empty" : "busy",
> >                   ^^^^^^^^^^^^^^^^^^^^^^^
> > This will crash.
>=20
> Fixed. Other patches can still apply with hunks.
>=20
>=20
> Subject: raid5: offload stripe handle to workqueue
>=20
> This is another attempt to create multiple threads to handle raid5 stripe=
s.
> This time I use workqueue.
>=20
> raid5 handles request (especially write) in stripe unit. A stripe is page=
 size
> aligned/long and acrosses all disks. Writing to any disk sector, raid5 ru=
ns a
> state machine for the corresponding stripe, which includes reading some d=
isks
> of the stripe, calculating parity, and writing some disks of the stripe. =
The
> state machine is running in raid5d thread currently. Since there is only =
one
> thread, it doesn't scale well for high speed storage. An obvious solution=
 is
> multi-threading.
>=20
> To get better performance, we have some requirements:
> a. locality. stripe corresponding to request submitted from one cpu is be=
tter
> handled in thread in local cpu or local node. local cpu is preferred but =
some
> times could be a bottleneck, for example, parity calculation is too heavy.
> local node running has wide adaptability.
> b. configurablity. Different setup of raid5 array might need diffent
> configuration. Especially the thread number. More threads don't always me=
an
> better performance because of lock contentions.
>=20
> My original implementation is creating some kernel threads. There are
> interfaces to control which cpu's stripe each thread should handle. And
> userspace can set affinity of the threads. This provides biggest flexibil=
ity
> and configurability. But it's hard to use and apparently a new thread pool
> implementation is disfavor.
>=20
> Recent workqueue improvement is quite promising. unbound workqueue will be
> bound to numa node. If WQ_SYSFS is set in workqueue, there are sysfs opti=
on to
> do affinity setting. For example, we can only include one HT sibling in
> affinity. Since work is non-reentrant by default, and we can control runn=
ing
> thread number by limiting dispatched work_struct number.
>=20
> In this patch, I created several stripe worker group. A group is a numa n=
ode.
> stripes from cpus of one node will be added to a group list. Workqueue th=
read
> of one node will only handle stripes of worker group of the node. In this=
 way,
> stripe handling has numa node locality. And as I said, we can control thr=
ead
> number by limiting dispatched work_struct number.
>=20
> The work_struct callback function handles several stripes in one run. A t=
ypical
> work queue usage is to run one unit in each work_struct. In raid5 case, t=
he
> unit is a stripe. But we can't do that:
> a. Though handling a stripe doesn't need lock because of reference accoun=
ting
> and stripe isn't in any list, queuing a work_struct for each stripe will =
make
> workqueue lock contended very heavily.
> b. blk_start_plug()/blk_finish_plug() should surround stripe handle, as we
> might dispatch request. If each work_struct only handles one stripe, such=
 block
> plug is meaningless.
>=20
> This implementation can't do very fine grained configuration. But the numa
> binding is most popular usage model, should be enough for most workloads.=
=20
>=20
> Note: since we have only one stripe queue, switching to multi-thread might
> decrease request size dispatching down to low level layer. The impact dep=
ends
> on thread number, raid configuration and workload. So multi-thread raid5 =
might
> not be proper for all setups.
>=20
> Changes V1 -> V2:
> 1. remove WQ_NON_REENTRANT
> 2. disabling multi-threading by default
> 3. Add more descriptions in changelog
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |  186 ++++++++++++++++++++++++++++++++++++++++++++++=
++-----
>  drivers/md/raid5.h |   15 ++++
>  2 files changed, 186 insertions(+), 15 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2013-08-28 13:54:17.260930690 +0800
> +++ linux/drivers/md/raid5.c	2013-08-28 13:59:13.225210586 +0800
> @@ -53,6 +53,7 @@
>  #include <linux/cpu.h>
>  #include <linux/slab.h>
>  #include <linux/ratelimit.h>
> +#include <linux/nodemask.h>
>  #include <trace/events/block.h>
> =20
>  #include "md.h"
> @@ -60,6 +61,10 @@
>  #include "raid0.h"
>  #include "bitmap.h"
> =20
> +#define cpu_to_group(cpu) cpu_to_node(cpu)
> +#define ANY_GROUP NUMA_NO_NODE
> +
> +static struct workqueue_struct *raid5_wq;
>  /*
>   * Stripe cache
>   */
> @@ -200,6 +205,34 @@ static int stripe_operations_active(stru
>  	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
>  }
> =20
> +static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
> +{
> +	struct r5conf *conf =3D sh->raid_conf;
> +	struct r5worker_group *group;
> +	int i, cpu =3D sh->cpu;
> +
> +	if (!cpu_online(cpu)) {
> +		cpu =3D cpumask_any(cpu_online_mask);
> +		sh->cpu =3D cpu;
> +	}
> +
> +	if (list_empty(&sh->lru)) {
> +		struct r5worker_group *group;
> +		group =3D conf->worker_groups + cpu_to_group(cpu);
> +		list_add_tail(&sh->lru, &group->handle_list);
> +	}
> +
> +	if (conf->worker_cnt_per_group =3D=3D 0) {
> +		md_wakeup_thread(conf->mddev->thread);
> +		return;
> +	}
> +
> +	group =3D conf->worker_groups + cpu_to_group(sh->cpu);
> +
> +	for (i =3D 0; i < conf->worker_cnt_per_group; i++)
> +		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
> +}
> +
>  static void do_release_stripe(struct r5conf *conf, struct stripe_head *s=
h)
>  {
>  	BUG_ON(!list_empty(&sh->lru));
> @@ -214,7 +247,12 @@ static void do_release_stripe(struct r5c
>  		else {
>  			clear_bit(STRIPE_DELAYED, &sh->state);
>  			clear_bit(STRIPE_BIT_DELAY, &sh->state);
> -			list_add_tail(&sh->lru, &conf->handle_list);
> +			if (conf->worker_cnt_per_group =3D=3D 0) {
> +				list_add_tail(&sh->lru, &conf->handle_list);
> +			} else {
> +				raid5_wakeup_stripe_thread(sh);
> +				return;
> +			}
>  		}
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
> @@ -409,6 +447,7 @@ static void init_stripe(struct stripe_he
>  		raid5_build_block(sh, i, previous);
>  	}
>  	insert_hash(conf, sh);
> +	sh->cpu =3D smp_processor_id();
>  }
> =20
>  static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t s=
ector,
> @@ -3830,6 +3869,7 @@ static void raid5_activate_delayed(struc
>  			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
>  			list_add_tail(&sh->lru, &conf->hold_list);
> +			raid5_wakeup_stripe_thread(sh);
>  		}
>  	}
>  }
> @@ -4109,18 +4149,32 @@ static int chunk_aligned_read(struct mdd
>   * head of the hold_list has changed, i.e. the head was promoted to the
>   * handle_list.
>   */
> -static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
> +static struct stripe_head *__get_priority_stripe(struct r5conf *conf, in=
t group)
>  {
> -	struct stripe_head *sh;
> +	struct stripe_head *sh =3D NULL, *tmp;
> +	struct list_head *handle_list =3D NULL;
> +
> +	if (conf->worker_cnt_per_group =3D=3D 0) {
> +		handle_list =3D &conf->handle_list;
> +	} else if (group !=3D ANY_GROUP) {
> +		handle_list =3D &conf->worker_groups[group].handle_list;
> +	} else {
> +		int i;
> +		for (i =3D 0; i < conf->group_cnt; i++) {
> +			handle_list =3D &conf->worker_groups[i].handle_list;
> +			if (!list_empty(handle_list))
> +				break;
> +		}
> +	}
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
> @@ -4138,12 +4192,25 @@ static struct stripe_head *__get_priorit
>  		   ((conf->bypass_threshold &&
>  		     conf->bypass_count > conf->bypass_threshold) ||
>  		    atomic_read(&conf->pending_full_writes) =3D=3D 0)) {
> -		sh =3D list_entry(conf->hold_list.next,
> -				typeof(*sh), lru);
> -		conf->bypass_count -=3D conf->bypass_threshold;
> -		if (conf->bypass_count < 0)
> -			conf->bypass_count =3D 0;
> -	} else
> +
> +		list_for_each_entry(tmp, &conf->hold_list,  lru) {
> +			if (conf->worker_cnt_per_group =3D=3D 0 ||
> +			    group =3D=3D ANY_GROUP ||
> +			    !cpu_online(tmp->cpu) ||
> +			    cpu_to_group(tmp->cpu) =3D=3D group) {
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
> +
> +	if (!sh)
>  		return NULL;
> =20
>  	list_del_init(&sh->lru);
> @@ -4853,13 +4920,13 @@ static int  retry_aligned_read(struct r5
>  }
> =20
>  #define MAX_STRIPE_BATCH 8
> -static int handle_active_stripes(struct r5conf *conf)
> +static int handle_active_stripes(struct r5conf *conf, int group)
>  {
>  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
>  	int i, batch_size =3D 0;
> =20
>  	while (batch_size < MAX_STRIPE_BATCH &&
> -			(sh =3D __get_priority_stripe(conf)) !=3D NULL)
> +			(sh =3D __get_priority_stripe(conf, group)) !=3D NULL)
>  		batch[batch_size++] =3D sh;
> =20
>  	if (batch_size =3D=3D 0)
> @@ -4877,6 +4944,38 @@ static int handle_active_stripes(struct
>  	return batch_size;
>  }
> =20
> +static void raid5_do_work(struct work_struct *work)
> +{
> +	struct r5worker *worker =3D container_of(work, struct r5worker, work);
> +	struct r5worker_group *group =3D worker->group;
> +	struct r5conf *conf =3D group->conf;
> +	int group_id =3D group - conf->worker_groups;
> +	int handled;
> +	struct blk_plug plug;
> +
> +	pr_debug("+++ raid5worker active\n");
> +
> +	blk_start_plug(&plug);
> +	handled =3D 0;
> +	spin_lock_irq(&conf->device_lock);
> +	while (1) {
> +		int batch_size, released;
> +
> +		released =3D release_stripe_list(conf);
> +
> +		batch_size =3D handle_active_stripes(conf, group_id);
> +		if (!batch_size && !released)
> +			break;
> +		handled +=3D batch_size;
> +	}
> +	pr_debug("%d stripes handled\n", handled);
> +
> +	spin_unlock_irq(&conf->device_lock);
> +	blk_finish_plug(&plug);
> +
> +	pr_debug("--- raid5worker inactive\n");
> +}
> +
>  /*
>   * This is our raid5 kernel thread.
>   *
> @@ -4926,7 +5025,7 @@ static void raid5d(struct md_thread *thr
>  			handled++;
>  		}
> =20
> -		batch_size =3D handle_active_stripes(conf);
> +		batch_size =3D handle_active_stripes(conf, ANY_GROUP);
>  		if (!batch_size && !released)
>  			break;
>  		handled +=3D batch_size;
> @@ -5066,6 +5165,54 @@ static struct attribute_group raid5_attr
>  	.attrs =3D raid5_attrs,
>  };
> =20
> +static int alloc_thread_groups(struct r5conf *conf, int cnt)
> +{
> +	int i, j;
> +	ssize_t size;
> +	struct r5worker *workers;
> +
> +	conf->worker_cnt_per_group =3D cnt;
> +	if (cnt =3D=3D 0) {
> +		conf->worker_groups =3D NULL;
> +		return 0;
> +	}
> +	conf->group_cnt =3D num_possible_nodes();
> +	size =3D sizeof(struct r5worker) * cnt;
> +	workers =3D kzalloc(size * conf->group_cnt, GFP_NOIO);
> +	conf->worker_groups =3D kzalloc(sizeof(struct r5worker_group) *
> +				conf->group_cnt, GFP_NOIO);
> +	if (!conf->worker_groups || !workers) {
> +		kfree(workers);
> +		kfree(conf->worker_groups);
> +		conf->worker_groups =3D NULL;
> +		return -ENOMEM;
> +	}
> +
> +	for (i =3D 0; i < conf->group_cnt; i++) {
> +		struct r5worker_group *group;
> +
> +		group =3D &conf->worker_groups[i];
> +		INIT_LIST_HEAD(&group->handle_list);
> +		group->conf =3D conf;
> +		group->workers =3D workers + i * cnt;
> +
> +		for (j =3D 0; j < cnt; j++) {
> +			group->workers[j].group =3D group;
> +			INIT_WORK(&group->workers[j].work, raid5_do_work);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void free_thread_groups(struct r5conf *conf)
> +{
> +	if (conf->worker_groups)
> +		kfree(conf->worker_groups[0].workers);
> +	kfree(conf->worker_groups);
> +	conf->worker_groups =3D NULL;
> +}
> +
>  static sector_t
>  raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks)
>  {
> @@ -5106,6 +5253,7 @@ static void raid5_free_percpu(struct r5c
> =20
>  static void free_conf(struct r5conf *conf)
>  {
> +	free_thread_groups(conf);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
>  	kfree(conf->disks);
> @@ -5234,6 +5382,9 @@ static struct r5conf *setup_conf(struct
>  	conf =3D kzalloc(sizeof(struct r5conf), GFP_KERNEL);
>  	if (conf =3D=3D NULL)
>  		goto abort;
> +	/* Don't enable multi-threading by default*/
> +	if (alloc_thread_groups(conf, 0))
> +		goto abort;
>  	spin_lock_init(&conf->device_lock);
>  	seqcount_init(&conf->gen_lock);
>  	init_waitqueue_head(&conf->wait_for_stripe);
> @@ -6549,6 +6700,10 @@ static struct md_personality raid4_perso
> =20
>  static int __init raid5_init(void)
>  {
> +	raid5_wq =3D alloc_workqueue("raid5wq",
> +		WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE|WQ_SYSFS, 0);
> +	if (!raid5_wq)
> +		return -ENOMEM;
>  	register_md_personality(&raid6_personality);
>  	register_md_personality(&raid5_personality);
>  	register_md_personality(&raid4_personality);
> @@ -6560,6 +6715,7 @@ static void raid5_exit(void)
>  	unregister_md_personality(&raid6_personality);
>  	unregister_md_personality(&raid5_personality);
>  	unregister_md_personality(&raid4_personality);
> +	destroy_workqueue(raid5_wq);
>  }
> =20
>  module_init(raid5_init);
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2013-08-28 13:54:17.260930690 +0800
> +++ linux/drivers/md/raid5.h	2013-08-28 13:54:17.260930690 +0800
> @@ -212,6 +212,7 @@ struct stripe_head {
>  	enum check_states	check_state;
>  	enum reconstruct_states reconstruct_state;
>  	spinlock_t		stripe_lock;
> +	int			cpu;
>  	/**
>  	 * struct stripe_operations
>  	 * @target - STRIPE_OP_COMPUTE_BLK target
> @@ -365,6 +366,17 @@ struct disk_info {
>  	struct md_rdev	*rdev, *replacement;
>  };
> =20
> +struct r5worker {
> +	struct work_struct work;
> +	struct r5worker_group *group;
> +};
> +
> +struct r5worker_group {
> +	struct list_head handle_list;
> +	struct r5conf *conf;
> +	struct r5worker *workers;
> +};
> +
>  struct r5conf {
>  	struct hlist_head	*stripe_hashtbl;
>  	struct mddev		*mddev;
> @@ -462,6 +474,9 @@ struct r5conf {
>  	 * the new thread here until we fully activate the array.
>  	 */
>  	struct md_thread	*thread;
> +	struct r5worker_group	*worker_groups;
> +	int			group_cnt;
> +	int			worker_cnt_per_group;
>  };
> =20
>  /*


Applied, thanks.

NeilBrown

--Sig_/xvmCxCJcax=ShULM_zSDKm=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh2fDjnsnt1WYoG5AQJTSA//Z78d34s5QWSOsn79G1eQZBEMwrYbv1ki
t2OyiNJOGsxALa2fJvbVz5hv4uvK9MaveMEIjbJJUH8QHz2y+abGrYB4dR4mxAYr
YJXuR/xjiwmY7Y3+7z1iCKu55EQlz1VuRD5O5+yyv78mKY6dgrr8qSRjB8ybRdDj
C6YYNER8Oj5Tjov3sVzO5ggDBUBZoMR61VOXLQUK3gm/k1vzmDfBFGOGGPAObAUT
URfqXLHxW2A4ZDDxkNwc+It2NvVCoNYujresEJS1nlJmAQj3i4MYU/ETm1n57WJf
vgjLCAauz3ruDh6JlsjouWi2iwpyU6dFz4g14OxwbvUvieV0081W5iBQ0+XJ0JJZ
VkZWHwkY/ys1Aehbww3WOcBjSfy0wWJCpyYrzm56zjfX7pCtTrNiDl6SIBfi87jl
ErgYsAXiunHGH5naby/HAD6ZklZTZkAu8Mo3JAem2fowBUI98ZAADIl9TQSDTtQC
zsJov10vENRUfw9zQWyI1VqkwTWXVrT8Rvqg1hL2Iei7bjOo3ZVtghEF1LsS4+WU
qkQWEy35+n0l8SnbjCBpSq0k6CvIt83LNWKvnj77Olqhni7xlmJwmXSjQhYoTvg9
IWbMfrvEa8JbsrzrHBCdlt0zv0/GHghlvEfDxBTKnP7I8MYGl9yODRjlFl0GbrbN
bx314nGJN+k=
=pg23
-----END PGP SIGNATURE-----

--Sig_/xvmCxCJcax=ShULM_zSDKm=--
