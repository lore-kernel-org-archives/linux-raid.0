From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Thu, 5 Sep 2013 16:29:10 +1000
Message-ID: <20130905162910.179ea808@notabene.brown>
References: <20130812022434.507702228@kernel.org>
	<20130812022549.013010221@kernel.org>
	<20130827131752.4d5ba375@notabene.brown>
	<20130827085330.GA30133@kernel.org>
	<20130828143252.1d48b04b@notabene.brown>
	<20130828063953.GD17163@kernel.org>
	<20130903160858.2175a41b@notabene.brown>
	<20130903070228.GA25041@kernel.org>
	<20130904164132.177701e0@notabene.brown>
	<20130905054035.GA30216@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L5NJ3y4gJxVv3JeFzaEL0sp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130905054035.GA30216@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

--Sig_/L5NJ3y4gJxVv3JeFzaEL0sp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Sep 2013 13:40:35 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, Sep 04, 2013 at 04:41:32PM +1000, NeilBrown wrote:
> > On Tue, 3 Sep 2013 15:02:28 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Tue, Sep 03, 2013 at 04:08:58PM +1000, NeilBrown wrote:
> > > > On Wed, 28 Aug 2013 14:39:53 +0800 Shaohua Li <shli@kernel.org> wro=
te:
> > > >=20
> > > > > On Wed, Aug 28, 2013 at 02:32:52PM +1000, NeilBrown wrote:
> > > > > > On Tue, 27 Aug 2013 16:53:30 +0800 Shaohua Li <shli@kernel.org>=
 wrote:
> > > > > >=20
> > > > > > > On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:
> > > > > >=20
> > > > > > >=20
> > > > > > > > Then get_active_stripe wouldn't need to worry about device_=
lock at all and
> > > > > > > > would only need to get the hash lock for the particular sec=
tor.  That should
> > > > > > > > make it a lot simpler.
> > > > > > >=20
> > > > > > > did you mean get_active_stripe() doesn't need device_lock for=
 any code path?
> > > > > > > How could it be safe? device_lock still protects something li=
ke handle_list,
> > > > > > > delayed_list, which release_stripe() will use while a get_act=
ive_stripe can run
> > > > > > > concurrently.
> > > > > >=20
> > > > > > Yes you will still need device_lock to protect list_del_init(&s=
h->lru),
> > > > > > as well as the hash lock.
> > > > > > Do you need device_lock anywhere else in there?
> > > > >=20
> > > > > That's what I mean. So I need get both device_lock and hash_lock.=
 To not
> > > > > deadlock, I need release hash_lock and relock device_lock/hash_lo=
ck. Since I
> > > > > release lock, I need recheck if I can find the stripe in hash aga=
in. So the
> > > > > seqcount locking doesn't simplify things here. I thought the seql=
ock only fixes
> > > > > one race. Did I miss anything?
> > > >=20
> > > > Can you order the locks so that you take the hash_lock first, then =
the
> > > > device_lock?  That would be a lot simpler.
> > >=20
> > > Looks impossible. For example, in handle_active_stripes() we release =
several
> > > stripes, we can't take hash_lock first.
> >=20
> > "impossible" just takes a little longer :-)
> >=20
> > do_release_stripe gets called with only device_lock held.  It gets pass=
ed an
> > (initially) empty list_head too.
> > If it wants to add the stripe to an inactive list it puts it on the giv=
en
> > list_head instead.
> >=20
> > release_stripe(), after calling do_release_stripe() calls some function=
 to
> > grab the appropriate hash_lock for each stripe in the list_head and add=
 it
> > to that inactive list.
> >=20
> > release_stripe_list() might collect some stripes from from __release_st=
ripe
> > that need to go on an inactive list.  It arranges for them to be put on=
 the
> > right list, with the right lock, next time device_lock is dropped.  That
> > might be in handle_active_stripes()
> >=20
> > activate_bit_delay might similarly collect stripes, which are handled t=
he
> > same way as those collected by release_stripe_list.
> > etc.
> >=20
> > i.e. the hash_locks protect the various inactive lists.  device_lock pr=
otects
> > all the others.  If we need to add something to an inactive list while
> > holding device_lock we delay until device_lock can be dropped.
>=20
> Alright, this option works, but we need allocate some spaces, which isn't=
 very
> good for unplug cb. Below is the patch I tested.
>=20
> Thanks,
> Shaohua
>=20
> Subject: raid5: relieve lock contention in get_active_stripe()
>=20
> get_active_stripe() is the last place we have lock contention. It has two
> paths. One is stripe isn't found and new stripe is allocated, the other is
> stripe is found.
>=20
> The first path basically calls __find_stripe and init_stripe. It accesses
> conf->generation, conf->previous_raid_disks, conf->raid_disks,
> conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
> conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. E=
xcept
> stripe_hashtbl and inactive_list, other fields are changed very rarely.
>=20
> With this patch, we split inactive_list and add new hash locks. Each free
> stripe belongs to a specific inactive list. Which inactive list is determ=
ined
> by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, it h=
as a
> lock_hash assigned. Stripe's inactive list is protected by a hash lock, w=
hich
> is determined by it's lock_hash too. The lock_hash is derivied from curre=
nt
> stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be ass=
igned
> to a specific lock_hash, so we can use new hash lock to protect stripe_ha=
shtbl
> list too. The goal of the new hash locks introduced is we can only use th=
e new
> locks in the first path of get_active_stripe(). Since we have several hash
> locks, lock contention is relieved significantly.
>=20
> The first path of get_active_stripe() accesses other fields, since they a=
re
> changed rarely, changing them now need take conf->device_lock and all hash
> locks. For a slow path, this isn't a problem.
>=20
> If we need lock device_lock and hash lock, we always lock hash lock first=
. The
> tricky part is release_stripe and friends. We need take device_lock first.
> Neil's suggestion is we put inactive stripes to a temporary list and read=
d it
> to inactive_list after device_lock is released. In this way, we add strip=
es to
> temporary list with device_lock hold and remove stripes from the list wit=
h hash
> lock hold. So we don't allow concurrent access to the temporary list, whi=
ch
> means we need allocate temporary list for all participants of release_str=
ipe.
>=20
> One downside is free stripes are maintained in their inactive list, they =
can't
> across between the lists. By default, we have total 256 stripes and 8 lis=
ts, so
> each list will have 32 stripes. It's possible one list has free stripe but
> other list hasn't. The chance should be rare because stripes allocation a=
re
> even distributed. And we can always allocate more stripes for cache, seve=
ral
> mega bytes memory isn't a big deal.
>=20
> This completely removes the lock contention of the first path of
> get_active_stripe(). It slows down the second code path a little bit thou=
gh
> because we now need takes two locks, but since the hash lock isn't conten=
ded,
> the overhead should be quite small (several atomic instructions). The sec=
ond
> path of get_active_stripe() (basically sequential write or big request si=
ze
> randwrite) still has lock contentions.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |  346 ++++++++++++++++++++++++++++++++++++++++------=
-------
>  drivers/md/raid5.h |   11 +
>  2 files changed, 276 insertions(+), 81 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2013-09-05 08:23:42.187851834 +0800
> +++ linux/drivers/md/raid5.c	2013-09-05 12:52:47.581235145 +0800
> @@ -86,6 +86,67 @@ static inline struct hlist_head *stripe_
>  	return &conf->stripe_hashtbl[hash];
>  }
> =20
> +static inline int stripe_hash_locks_hash(sector_t sect)
> +{
> +	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
> +}
> +
> +static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
> +{
> +	spin_lock_irq(conf->hash_locks + hash);
> +	spin_lock(&conf->device_lock);
> +}
> +
> +static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
> +{
> +	spin_unlock(&conf->device_lock);
> +	spin_unlock_irq(conf->hash_locks + hash);
> +}
> +
> +static void __lock_all_hash_locks(struct r5conf *conf)
> +{
> +	int i;
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		spin_lock(conf->hash_locks + i);
> +}
> +
> +static void __unlock_all_hash_locks(struct r5conf *conf)
> +{
> +	int i;
> +	for (i =3D NR_STRIPE_HASH_LOCKS; i; i--)
> +		spin_unlock(conf->hash_locks + i - 1);
> +}
> +
> +static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
> +{
> +	local_irq_disable();
> +	__lock_all_hash_locks(conf);
> +	spin_lock(&conf->device_lock);
> +}
> +
> +static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
> +{
> +	spin_unlock(&conf->device_lock);
> +	__unlock_all_hash_locks(conf);
> +	local_irq_enable();
> +}
> +
> +static inline void lock_all_device_hash_locks_irqsave(struct r5conf *con=
f,
> +	unsigned long *flags)
> +{
> +	local_irq_save(*flags);
> +	__lock_all_hash_locks(conf);
> +	spin_lock(&conf->device_lock);
> +}
> +
> +static inline void unlock_all_device_hash_locks_irqrestore(struct r5conf=
 *conf,
> +	unsigned long *flags)
> +{
> +	spin_unlock(&conf->device_lock);
> +	__unlock_all_hash_locks(conf);
> +	local_irq_restore(*flags);
> +}
> +
>  /* bio's attached to a stripe+device for I/O are linked together in bi_s=
ector
>   * order without overlap.  There may be several bio's per stripe+device,=
 and
>   * a bio could span several devices.
> @@ -250,7 +311,8 @@ static void raid5_wakeup_stripe_thread(s
>  	}
>  }
> =20
> -static void do_release_stripe(struct r5conf *conf, struct stripe_head *s=
h)
> +static void do_release_stripe(struct r5conf *conf, struct stripe_head *s=
h,
> +	struct list_head *temp_inactive_list)
>  {
>  	BUG_ON(!list_empty(&sh->lru));
>  	BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
> @@ -279,19 +341,59 @@ static void do_release_stripe(struct r5c
>  			    < IO_THRESHOLD)
>  				md_wakeup_thread(conf->mddev->thread);
>  		atomic_dec(&conf->active_stripes);
> -		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> -			list_add_tail(&sh->lru, &conf->inactive_list);
> -			wake_up(&conf->wait_for_stripe);
> -			if (conf->retry_read_aligned)
> -				md_wakeup_thread(conf->mddev->thread);
> -		}
> +		if (!test_bit(STRIPE_EXPANDING, &sh->state))
> +			list_add_tail(&sh->lru, temp_inactive_list);
>  	}
>  }
> =20
> -static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
> +static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
> +	struct list_head *temp_inactive_list)
>  {
>  	if (atomic_dec_and_test(&sh->count))
> -		do_release_stripe(conf, sh);
> +		do_release_stripe(conf, sh, temp_inactive_list);
> +}
> +
> +/*
> + * @hash could be NR_STRIPE_HASH_LOCKS, then we have a list of inactive_=
list
> + *
> + * Be careful: Only one task can add/delete stripes from temp_inactive_l=
ist at
> + * given time. Adding stripes only takes device lock, while deleting str=
ipes
> + * only takes hash lock.
> + */
> +static void release_inactive_stripe_list(struct r5conf *conf,
> +	struct list_head *temp_inactive_list, int hash)
> +{
> +	int size;
> +	bool do_wakeup =3D false;
> +	unsigned long flags;
> +
> +	if (hash =3D=3D NR_STRIPE_HASH_LOCKS) {
> +		size =3D NR_STRIPE_HASH_LOCKS;
> +		hash =3D NR_STRIPE_HASH_LOCKS - 1;
> +	} else
> +		size =3D 1;
> +	while (size) {
> +		struct list_head *list =3D &temp_inactive_list[size - 1];
> +
> +		/*
> +		 * We don't hold any lock here yet, get_active_stripe() might
> +		 * remove stripes from the list
> +		 */
> +		if (!list_empty_careful(list)) {
> +			spin_lock_irqsave(conf->hash_locks + hash, flags);
> +			list_splice_tail_init(list, conf->inactive_list + hash);
> +			do_wakeup =3D true;
> +			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
> +		}
> +		size--;
> +		hash--;
> +	}
> +
> +	if (do_wakeup) {
> +		wake_up(&conf->wait_for_stripe);
> +		if (conf->retry_read_aligned)
> +			md_wakeup_thread(conf->mddev->thread);
> +	}
>  }
> =20
>  static struct llist_node *llist_reverse_order(struct llist_node *head)
> @@ -309,7 +411,8 @@ static struct llist_node *llist_reverse_
>  }
> =20
>  /* should hold conf->device_lock already */
> -static int release_stripe_list(struct r5conf *conf)
> +static int release_stripe_list(struct r5conf *conf,
> +	struct list_head *temp_inactive_list)
>  {
>  	struct stripe_head *sh;
>  	int count =3D 0;
> @@ -318,6 +421,8 @@ static int release_stripe_list(struct r5
>  	head =3D llist_del_all(&conf->released_stripes);
>  	head =3D llist_reverse_order(head);
>  	while (head) {
> +		int hash;
> +
>  		sh =3D llist_entry(head, struct stripe_head, release_list);
>  		head =3D llist_next(head);
>  		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
> @@ -328,7 +433,8 @@ static int release_stripe_list(struct r5
>  		 * again, the count is always > 1. This is true for
>  		 * STRIPE_ON_UNPLUG_LIST bit too.
>  		 */
> -		__release_stripe(conf, sh);
> +		hash =3D sh->hash_lock_index;
> +		__release_stripe(conf, sh, &temp_inactive_list[hash]);
>  		count++;
>  	}
> =20
> @@ -339,6 +445,8 @@ static void release_stripe(struct stripe
>  {
>  	struct r5conf *conf =3D sh->raid_conf;
>  	unsigned long flags;
> +	struct list_head list;
> +	int hash;
>  	bool wakeup;
> =20
>  	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
> @@ -351,8 +459,11 @@ slow_path:
>  	local_irq_save(flags);
>  	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
>  	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
> -		do_release_stripe(conf, sh);
> +		INIT_LIST_HEAD(&list);
> +		hash =3D sh->hash_lock_index;
> +		do_release_stripe(conf, sh, &list);
>  		spin_unlock(&conf->device_lock);
> +		release_inactive_stripe_list(conf, &list, hash);
>  	}
>  	local_irq_restore(flags);
>  }
> @@ -377,18 +488,19 @@ static inline void insert_hash(struct r5
> =20
> =20
>  /* find an idle stripe, make sure it is unhashed, and return it. */
> -static struct stripe_head *get_free_stripe(struct r5conf *conf)
> +static struct stripe_head *get_free_stripe(struct r5conf *conf, int hash)
>  {
>  	struct stripe_head *sh =3D NULL;
>  	struct list_head *first;
> =20
> -	if (list_empty(&conf->inactive_list))
> +	if (list_empty(conf->inactive_list + hash))
>  		goto out;
> -	first =3D conf->inactive_list.next;
> +	first =3D (conf->inactive_list + hash)->next;
>  	sh =3D list_entry(first, struct stripe_head, lru);
>  	list_del_init(first);
>  	remove_hash(sh);
>  	atomic_inc(&conf->active_stripes);
> +	BUG_ON(hash !=3D sh->hash_lock_index);
>  out:
>  	return sh;
>  }
> @@ -567,33 +679,35 @@ get_active_stripe(struct r5conf *conf, s
>  		  int previous, int noblock, int noquiesce)
>  {
>  	struct stripe_head *sh;
> +	int hash =3D stripe_hash_locks_hash(sector);
> =20
>  	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
> =20
> -	spin_lock_irq(&conf->device_lock);
> +	spin_lock_irq(conf->hash_locks + hash);
> =20
>  	do {
>  		wait_event_lock_irq(conf->wait_for_stripe,
>  				    conf->quiesce =3D=3D 0 || noquiesce,
> -				    conf->device_lock);
> +				    *(conf->hash_locks + hash));
>  		sh =3D __find_stripe(conf, sector, conf->generation - previous);
>  		if (!sh) {
> -			if (!conf->inactive_blocked)
> -				sh =3D get_free_stripe(conf);
> +			sh =3D get_free_stripe(conf, hash);
>  			if (noblock && sh =3D=3D NULL)
>  				break;
>  			if (!sh) {
>  				conf->inactive_blocked =3D 1;
>  				wait_event_lock_irq(conf->wait_for_stripe,
> -						    !list_empty(&conf->inactive_list) &&
> -						    (atomic_read(&conf->active_stripes)
> -						     < (conf->max_nr_stripes *3/4)
> -						     || !conf->inactive_blocked),
> -						    conf->device_lock);
> +					!list_empty(conf->inactive_list + hash) &&
> +					(atomic_read(&conf->active_stripes)
> +					  < (conf->max_nr_stripes * 3 / 4)
> +					|| !conf->inactive_blocked),
> +					*(conf->hash_locks + hash));
>  				conf->inactive_blocked =3D 0;
>  			} else
>  				init_stripe(sh, sector, previous);
>  		} else {
> +			spin_lock(&conf->device_lock);
> +
>  			if (atomic_read(&sh->count)) {
>  				BUG_ON(!list_empty(&sh->lru)
>  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
>  					sh->group =3D NULL;
>  				}
>  			}
> +			spin_unlock(&conf->device_lock);
>  		}
>  	} while (sh =3D=3D NULL);
> =20
>  	if (sh)
>  		atomic_inc(&sh->count);
> =20
> -	spin_unlock_irq(&conf->device_lock);
> +	spin_unlock_irq(conf->hash_locks + hash);
>  	return sh;
>  }
> =20
> @@ -1585,7 +1700,7 @@ static void raid_run_ops(struct stripe_h
>  	put_cpu();
>  }
> =20
> -static int grow_one_stripe(struct r5conf *conf)
> +static int grow_one_stripe(struct r5conf *conf, int hash)
>  {
>  	struct stripe_head *sh;
>  	sh =3D kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
> @@ -1601,11 +1716,13 @@ static int grow_one_stripe(struct r5conf
>  		kmem_cache_free(conf->slab_cache, sh);
>  		return 0;
>  	}
> +	sh->hash_lock_index =3D hash;
>  	/* we just created an active stripe so... */
>  	atomic_set(&sh->count, 1);
>  	atomic_inc(&conf->active_stripes);
>  	INIT_LIST_HEAD(&sh->lru);
>  	release_stripe(sh);
> +	conf->max_hash_nr_stripes[hash]++;
>  	return 1;
>  }
> =20
> @@ -1613,6 +1730,7 @@ static int grow_stripes(struct r5conf *c
>  {
>  	struct kmem_cache *sc;
>  	int devs =3D max(conf->raid_disks, conf->previous_raid_disks);
> +	int hash;
> =20
>  	if (conf->mddev->gendisk)
>  		sprintf(conf->cache_name[0],
> @@ -1630,9 +1748,12 @@ static int grow_stripes(struct r5conf *c
>  		return 1;
>  	conf->slab_cache =3D sc;
>  	conf->pool_size =3D devs;
> -	while (num--)
> -		if (!grow_one_stripe(conf))
> +	hash =3D 0;
> +	while (num--) {
> +		if (!grow_one_stripe(conf, hash))
>  			return 1;
> +		hash =3D (hash + 1) % NR_STRIPE_HASH_LOCKS;
> +	}
>  	return 0;
>  }
> =20
> @@ -1690,6 +1811,7 @@ static int resize_stripes(struct r5conf
>  	int err;
>  	struct kmem_cache *sc;
>  	int i;
> +	int hash, cnt;
> =20
>  	if (newsize <=3D conf->pool_size)
>  		return 0; /* never bother to shrink */
> @@ -1729,19 +1851,28 @@ static int resize_stripes(struct r5conf
>  	 * OK, we have enough stripes, start collecting inactive
>  	 * stripes and copying them over
>  	 */
> +	hash =3D 0;
> +	cnt =3D 0;
>  	list_for_each_entry(nsh, &newstripes, lru) {
> -		spin_lock_irq(&conf->device_lock);
> -		wait_event_lock_irq(conf->wait_for_stripe,
> -				    !list_empty(&conf->inactive_list),
> -				    conf->device_lock);
> -		osh =3D get_free_stripe(conf);
> -		spin_unlock_irq(&conf->device_lock);
> +		lock_device_hash_lock(conf, hash);
> +		wait_event_cmd(conf->wait_for_stripe,
> +				    !list_empty(conf->inactive_list + hash),
> +				    unlock_device_hash_lock(conf, hash),
> +				    lock_device_hash_lock(conf, hash));
> +		osh =3D get_free_stripe(conf, hash);
> +		unlock_device_hash_lock(conf, hash);
>  		atomic_set(&nsh->count, 1);
>  		for(i=3D0; i<conf->pool_size; i++)
>  			nsh->dev[i].page =3D osh->dev[i].page;
>  		for( ; i<newsize; i++)
>  			nsh->dev[i].page =3D NULL;
> +		nsh->hash_lock_index =3D hash;
>  		kmem_cache_free(conf->slab_cache, osh);
> +		cnt++;
> +		if (cnt >=3D conf->max_hash_nr_stripes[hash]) {
> +			hash++;
> +			cnt =3D 0;
> +		}
>  	}
>  	kmem_cache_destroy(conf->slab_cache);
> =20
> @@ -1800,13 +1931,14 @@ static int resize_stripes(struct r5conf
>  	return err;
>  }
> =20
> -static int drop_one_stripe(struct r5conf *conf)
> +static int drop_one_stripe(struct r5conf *conf, int hash)
>  {
>  	struct stripe_head *sh;
> =20
> -	spin_lock_irq(&conf->device_lock);
> -	sh =3D get_free_stripe(conf);
> -	spin_unlock_irq(&conf->device_lock);
> +	spin_lock_irq(conf->hash_locks + hash);
> +	sh =3D get_free_stripe(conf, hash);
> +	conf->max_hash_nr_stripes[hash]--;
> +	spin_unlock_irq(conf->hash_locks + hash);
>  	if (!sh)
>  		return 0;
>  	BUG_ON(atomic_read(&sh->count));
> @@ -1818,8 +1950,10 @@ static int drop_one_stripe(struct r5conf
> =20
>  static void shrink_stripes(struct r5conf *conf)
>  {
> -	while (drop_one_stripe(conf))
> -		;
> +	int hash;
> +	for (hash =3D 0; hash < NR_STRIPE_HASH_LOCKS; hash++)
> +		while (drop_one_stripe(conf, hash))
> +			;
> =20
>  	if (conf->slab_cache)
>  		kmem_cache_destroy(conf->slab_cache);
> @@ -2048,10 +2182,10 @@ static void error(struct mddev *mddev, s
>  	unsigned long flags;
>  	pr_debug("raid456: error called\n");
> =20
> -	spin_lock_irqsave(&conf->device_lock, flags);
> +	lock_all_device_hash_locks_irqsave(conf, &flags);
>  	clear_bit(In_sync, &rdev->flags);
>  	mddev->degraded =3D calc_degraded(conf);
> -	spin_unlock_irqrestore(&conf->device_lock, flags);
> +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
>  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> =20
>  	set_bit(Blocked, &rdev->flags);
> @@ -3895,7 +4029,8 @@ static void raid5_activate_delayed(struc
>  	}
>  }
> =20
> -static void activate_bit_delay(struct r5conf *conf)
> +static void activate_bit_delay(struct r5conf *conf,
> +	struct list_head *temp_inactive_list)
>  {
>  	/* device_lock is held */
>  	struct list_head head;
> @@ -3903,9 +4038,11 @@ static void activate_bit_delay(struct r5
>  	list_del_init(&conf->bitmap_list);
>  	while (!list_empty(&head)) {
>  		struct stripe_head *sh =3D list_entry(head.next, struct stripe_head, l=
ru);
> +		int hash;
>  		list_del_init(&sh->lru);
>  		atomic_inc(&sh->count);
> -		__release_stripe(conf, sh);
> +		hash =3D sh->hash_lock_index;
> +		__release_stripe(conf, sh, &temp_inactive_list[hash]);
>  	}
>  }
> =20
> @@ -3921,7 +4058,7 @@ int md_raid5_congested(struct mddev *mdd
>  		return 1;
>  	if (conf->quiesce)
>  		return 1;
> -	if (list_empty_careful(&conf->inactive_list))
> +	if (atomic_read(&conf->active_stripes) =3D=3D conf->max_nr_stripes)
>  		return 1;
> =20
>  	return 0;
> @@ -4251,6 +4388,7 @@ static struct stripe_head *__get_priorit
>  struct raid5_plug_cb {
>  	struct blk_plug_cb	cb;
>  	struct list_head	list;
> +	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
>  };
> =20
>  static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
> @@ -4261,6 +4399,7 @@ static void raid5_unplug(struct blk_plug
>  	struct mddev *mddev =3D cb->cb.data;
>  	struct r5conf *conf =3D mddev->private;
>  	int cnt =3D 0;
> +	int hash;
> =20
>  	if (cb->list.next && !list_empty(&cb->list)) {
>  		spin_lock_irq(&conf->device_lock);
> @@ -4278,11 +4417,14 @@ static void raid5_unplug(struct blk_plug
>  			 * STRIPE_ON_RELEASE_LIST could be set here. In that
>  			 * case, the count is always > 1 here
>  			 */
> -			__release_stripe(conf, sh);
> +			hash =3D sh->hash_lock_index;
> +			__release_stripe(conf, sh, &cb->temp_inactive_list[hash]);
>  			cnt++;
>  		}
>  		spin_unlock_irq(&conf->device_lock);
>  	}
> +	release_inactive_stripe_list(conf, cb->temp_inactive_list,
> +		NR_STRIPE_HASH_LOCKS);
>  	if (mddev->queue)
>  		trace_block_unplug(mddev->queue, cnt, !from_schedule);
>  	kfree(cb);
> @@ -4303,8 +4445,12 @@ static void release_stripe_plug(struct m
> =20
>  	cb =3D container_of(blk_cb, struct raid5_plug_cb, cb);
> =20
> -	if (cb->list.next =3D=3D NULL)
> +	if (cb->list.next =3D=3D NULL) {
> +		int i;
>  		INIT_LIST_HEAD(&cb->list);
> +		for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +			INIT_LIST_HEAD(cb->temp_inactive_list + i);
> +	}
> =20
>  	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
>  		list_add_tail(&sh->lru, &cb->list);
> @@ -4949,27 +5095,45 @@ static int  retry_aligned_read(struct r5
>  }
> =20
>  static int handle_active_stripes(struct r5conf *conf, int group,
> -				 struct r5worker *worker)
> +				 struct r5worker *worker,
> +				 struct list_head *temp_inactive_list)
>  {
>  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> -	int i, batch_size =3D 0;
> +	int i, batch_size =3D 0, hash;
> +	bool release_inactive =3D false;
> =20
>  	while (batch_size < MAX_STRIPE_BATCH &&
>  			(sh =3D __get_priority_stripe(conf, group)) !=3D NULL)
>  		batch[batch_size++] =3D sh;
> =20
> -	if (batch_size =3D=3D 0)
> -		return batch_size;
> +	if (batch_size =3D=3D 0) {
> +		for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +			if (!list_empty(temp_inactive_list + i))
> +				break;
> +		if (i =3D=3D NR_STRIPE_HASH_LOCKS)
> +			return batch_size;
> +		release_inactive =3D true;
> +	}
>  	spin_unlock_irq(&conf->device_lock);
> =20
> +	release_inactive_stripe_list(conf, temp_inactive_list,
> +		NR_STRIPE_HASH_LOCKS);
> +
> +	if (release_inactive) {
> +		spin_lock_irq(&conf->device_lock);
> +		return 0;
> +	}
> +
>  	for (i =3D 0; i < batch_size; i++)
>  		handle_stripe(batch[i]);
> =20
>  	cond_resched();
> =20
>  	spin_lock_irq(&conf->device_lock);
> -	for (i =3D 0; i < batch_size; i++)
> -		__release_stripe(conf, batch[i]);
> +	for (i =3D 0; i < batch_size; i++) {
> +		hash =3D batch[i]->hash_lock_index;
> +		__release_stripe(conf, batch[i], &temp_inactive_list[hash]);
> +	}
>  	return batch_size;
>  }
> =20
> @@ -4990,9 +5154,10 @@ static void raid5_do_work(struct work_st
>  	while (1) {
>  		int batch_size, released;
> =20
> -		released =3D release_stripe_list(conf);
> +		released =3D release_stripe_list(conf, worker->temp_inactive_list);
> =20
> -		batch_size =3D handle_active_stripes(conf, group_id, worker);
> +		batch_size =3D handle_active_stripes(conf, group_id, worker,
> +				worker->temp_inactive_list);
>  		worker->working =3D false;
>  		if (!batch_size && !released)
>  			break;
> @@ -5031,7 +5196,7 @@ static void raid5d(struct md_thread *thr
>  		struct bio *bio;
>  		int batch_size, released;
> =20
> -		released =3D release_stripe_list(conf);
> +		released =3D release_stripe_list(conf, conf->temp_inactive_list);
> =20
>  		if (
>  		    !list_empty(&conf->bitmap_list)) {
> @@ -5041,7 +5206,7 @@ static void raid5d(struct md_thread *thr
>  			bitmap_unplug(mddev->bitmap);
>  			spin_lock_irq(&conf->device_lock);
>  			conf->seq_write =3D conf->seq_flush;
> -			activate_bit_delay(conf);
> +			activate_bit_delay(conf, conf->temp_inactive_list);
>  		}
>  		raid5_activate_delayed(conf);
> =20
> @@ -5055,7 +5220,8 @@ static void raid5d(struct md_thread *thr
>  			handled++;
>  		}
> =20
> -		batch_size =3D handle_active_stripes(conf, ANY_GROUP, NULL);
> +		batch_size =3D handle_active_stripes(conf, ANY_GROUP, NULL,
> +				conf->temp_inactive_list);
>  		if (!batch_size && !released)
>  			break;
>  		handled +=3D batch_size;
> @@ -5091,22 +5257,28 @@ raid5_set_cache_size(struct mddev *mddev
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	int err;
> +	int hash;
> =20
>  	if (size <=3D 16 || size > 32768)
>  		return -EINVAL;
> +	size =3D round_up(size, NR_STRIPE_HASH_LOCKS);
> +	hash =3D 0;
>  	while (size < conf->max_nr_stripes) {
> -		if (drop_one_stripe(conf))
> +		if (drop_one_stripe(conf, hash))
>  			conf->max_nr_stripes--;
>  		else
>  			break;
> +		hash =3D (hash + 1) % NR_STRIPE_HASH_LOCKS;
>  	}
>  	err =3D md_allow_write(mddev);
>  	if (err)
>  		return err;
> +	hash =3D 0;
>  	while (size > conf->max_nr_stripes) {
> -		if (grow_one_stripe(conf))
> +		if (grow_one_stripe(conf, hash))
>  			conf->max_nr_stripes++;
>  		else break;
> +		hash =3D (hash + 1) % NR_STRIPE_HASH_LOCKS;
>  	}
>  	return 0;
>  }
> @@ -5257,7 +5429,7 @@ static struct attribute_group raid5_attr
> =20
>  static int alloc_thread_groups(struct r5conf *conf, int cnt)
>  {
> -	int i, j;
> +	int i, j, k;
>  	ssize_t size;
>  	struct r5worker *workers;
> =20
> @@ -5287,8 +5459,12 @@ static int alloc_thread_groups(struct r5
>  		group->workers =3D workers + i * cnt;
> =20
>  		for (j =3D 0; j < cnt; j++) {
> -			group->workers[j].group =3D group;
> -			INIT_WORK(&group->workers[j].work, raid5_do_work);
> +			struct r5worker *worker =3D group->workers + j;
> +			worker->group =3D group;
> +			INIT_WORK(&worker->work, raid5_do_work);
> +
> +			for (k =3D 0; k < NR_STRIPE_HASH_LOCKS; k++)
> +				INIT_LIST_HEAD(worker->temp_inactive_list + k);
>  		}
>  	}
> =20
> @@ -5439,6 +5615,7 @@ static struct r5conf *setup_conf(struct
>  	struct md_rdev *rdev;
>  	struct disk_info *disk;
>  	char pers_name[6];
> +	int i;
> =20
>  	if (mddev->new_level !=3D 5
>  	    && mddev->new_level !=3D 4
> @@ -5483,7 +5660,6 @@ static struct r5conf *setup_conf(struct
>  	INIT_LIST_HEAD(&conf->hold_list);
>  	INIT_LIST_HEAD(&conf->delayed_list);
>  	INIT_LIST_HEAD(&conf->bitmap_list);
> -	INIT_LIST_HEAD(&conf->inactive_list);
>  	init_llist_head(&conf->released_stripes);
>  	atomic_set(&conf->active_stripes, 0);
>  	atomic_set(&conf->preread_active_stripes, 0);
> @@ -5509,6 +5685,15 @@ static struct r5conf *setup_conf(struct
>  	if ((conf->stripe_hashtbl =3D kzalloc(PAGE_SIZE, GFP_KERNEL)) =3D=3D NU=
LL)
>  		goto abort;
> =20
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		spin_lock_init(conf->hash_locks + i);
> +
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		INIT_LIST_HEAD(conf->inactive_list + i);
> +
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +		INIT_LIST_HEAD(conf->temp_inactive_list + i);
> +
>  	conf->level =3D mddev->new_level;
>  	if (raid5_alloc_percpu(conf) !=3D 0)
>  		goto abort;
> @@ -6034,9 +6219,9 @@ static int raid5_spare_active(struct mdd
>  			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
>  		}
>  	}
> -	spin_lock_irqsave(&conf->device_lock, flags);
> +	lock_all_device_hash_locks_irqsave(conf, &flags);
>  	mddev->degraded =3D calc_degraded(conf);
> -	spin_unlock_irqrestore(&conf->device_lock, flags);
> +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
>  	print_raid5_conf(conf);
>  	return count;
>  }
> @@ -6347,9 +6532,9 @@ static int raid5_start_reshape(struct md
>  		 * ->degraded is measured against the larger of the
>  		 * pre and post number of devices.
>  		 */
> -		spin_lock_irqsave(&conf->device_lock, flags);
> +		lock_all_device_hash_locks_irqsave(conf, &flags);
>  		mddev->degraded =3D calc_degraded(conf);
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> +		unlock_all_device_hash_locks_irqrestore(conf, &flags);
>  	}
>  	mddev->raid_disks =3D conf->raid_disks;
>  	mddev->reshape_position =3D conf->reshape_progress;
> @@ -6363,14 +6548,14 @@ static int raid5_start_reshape(struct md
>  						"reshape");
>  	if (!mddev->sync_thread) {
>  		mddev->recovery =3D 0;
> -		spin_lock_irq(&conf->device_lock);
> +		lock_all_device_hash_locks_irq(conf);
>  		mddev->raid_disks =3D conf->raid_disks =3D conf->previous_raid_disks;
>  		rdev_for_each(rdev, mddev)
>  			rdev->new_data_offset =3D rdev->data_offset;
>  		smp_wmb();
>  		conf->reshape_progress =3D MaxSector;
>  		mddev->reshape_position =3D MaxSector;
> -		spin_unlock_irq(&conf->device_lock);
> +		unlock_all_device_hash_locks_irq(conf);
>  		return -EAGAIN;
>  	}
>  	conf->reshape_checkpoint =3D jiffies;
> @@ -6388,13 +6573,13 @@ static void end_reshape(struct r5conf *c
>  	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
>  		struct md_rdev *rdev;
> =20
> -		spin_lock_irq(&conf->device_lock);
> +		lock_all_device_hash_locks_irq(conf);
>  		conf->previous_raid_disks =3D conf->raid_disks;
>  		rdev_for_each(rdev, conf->mddev)
>  			rdev->data_offset =3D rdev->new_data_offset;
>  		smp_wmb();
>  		conf->reshape_progress =3D MaxSector;
> -		spin_unlock_irq(&conf->device_lock);
> +		unlock_all_device_hash_locks_irq(conf);
>  		wake_up(&conf->wait_for_overlap);
> =20
>  		/* read-ahead size must cover two whole stripes, which is
> @@ -6425,9 +6610,9 @@ static void raid5_finish_reshape(struct
>  			revalidate_disk(mddev->gendisk);
>  		} else {
>  			int d;
> -			spin_lock_irq(&conf->device_lock);
> +			lock_all_device_hash_locks_irq(conf);
>  			mddev->degraded =3D calc_degraded(conf);
> -			spin_unlock_irq(&conf->device_lock);
> +			unlock_all_device_hash_locks_irq(conf);
>  			for (d =3D conf->raid_disks ;
>  			     d < conf->raid_disks - mddev->delta_disks;
>  			     d++) {
> @@ -6457,27 +6642,28 @@ static void raid5_quiesce(struct mddev *
>  		break;
> =20
>  	case 1: /* stop all writes */
> -		spin_lock_irq(&conf->device_lock);
> +		lock_all_device_hash_locks_irq(conf);
>  		/* '2' tells resync/reshape to pause so that all
>  		 * active stripes can drain
>  		 */
>  		conf->quiesce =3D 2;
> -		wait_event_lock_irq(conf->wait_for_stripe,
> +		wait_event_cmd(conf->wait_for_stripe,
>  				    atomic_read(&conf->active_stripes) =3D=3D 0 &&
>  				    atomic_read(&conf->active_aligned_reads) =3D=3D 0,
> -				    conf->device_lock);
> +				    unlock_all_device_hash_locks_irq(conf),
> +				    lock_all_device_hash_locks_irq(conf));
>  		conf->quiesce =3D 1;
> -		spin_unlock_irq(&conf->device_lock);
> +		unlock_all_device_hash_locks_irq(conf);
>  		/* allow reshape to continue */
>  		wake_up(&conf->wait_for_overlap);
>  		break;
> =20
>  	case 0: /* re-enable writes */
> -		spin_lock_irq(&conf->device_lock);
> +		lock_all_device_hash_locks_irq(conf);
>  		conf->quiesce =3D 0;
>  		wake_up(&conf->wait_for_stripe);
>  		wake_up(&conf->wait_for_overlap);
> -		spin_unlock_irq(&conf->device_lock);
> +		unlock_all_device_hash_locks_irq(conf);
>  		break;
>  	}
>  }
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2013-09-05 08:23:42.187851834 +0800
> +++ linux/drivers/md/raid5.h	2013-09-05 08:30:49.090484930 +0800
> @@ -205,6 +205,7 @@ struct stripe_head {
>  	short			pd_idx;		/* parity disk index */
>  	short			qd_idx;		/* 'Q' disk index for raid6 */
>  	short			ddf_layout;/* use DDF ordering to calculate Q */
> +	short			hash_lock_index;
>  	unsigned long		state;		/* state flags */
>  	atomic_t		count;	      /* nr of active thread/requests */
>  	int			bm_seq;	/* sequence number for bitmap flushes */
> @@ -367,9 +368,13 @@ struct disk_info {
>  	struct md_rdev	*rdev, *replacement;
>  };
> =20
> +#define NR_STRIPE_HASH_LOCKS 8
> +#define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
> +
>  struct r5worker {
>  	struct work_struct work;
>  	struct r5worker_group *group;
> +	struct list_head temp_inactive_list[NR_STRIPE_HASH_LOCKS];
>  	bool working;
>  };
> =20
> @@ -382,6 +387,8 @@ struct r5worker_group {
> =20
>  struct r5conf {
>  	struct hlist_head	*stripe_hashtbl;
> +	/* only protect corresponding hash list and inactive_list */
> +	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
>  	struct mddev		*mddev;
>  	int			chunk_sectors;
>  	int			level, algorithm;
> @@ -462,7 +469,8 @@ struct r5conf {
>  	 * Free stripes pool
>  	 */
>  	atomic_t		active_stripes;
> -	struct list_head	inactive_list;
> +	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
> +	int			max_hash_nr_stripes[NR_STRIPE_HASH_LOCKS];
>  	struct llist_head	released_stripes;
>  	wait_queue_head_t	wait_for_stripe;
>  	wait_queue_head_t	wait_for_overlap;
> @@ -477,6 +485,7 @@ struct r5conf {
>  	 * the new thread here until we fully activate the array.
>  	 */
>  	struct md_thread	*thread;
> +	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
>  	struct r5worker_group	*worker_groups;
>  	int			group_cnt;
>  	int			worker_cnt_per_group;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hi,
 thanks for this.  It is looking quite good.

 I don't really like max_hash_nr_stripes though.
 I note that you round up the cache_size to a multiple of
 NR_STRIPE_HASH_LOCKS.
 I think that is a good idea and should allow us to ensure that every hash
 value always has the same number of stripe_heads.
 If we get a failure when allocating, we would need to free some to bring it
 back to a uniform number.

 I'm in two minds about the temp_inactive_list.
 An alternative would be to have a single list and use list_sort() to sort =
it
 by hash_lock_index before moving the stripe_heads to the relevant lists,
 taking one lock at a time.
 This save some memory and costs some cpu time.  On the whole I think it
 gains in elegance but I'm not sure.  What do you think?

Thanks,
NeilBrown

--Sig_/L5NJ3y4gJxVv3JeFzaEL0sp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUigktjnsnt1WYoG5AQIBiA/+KPuP9qmzTNQ53B0+Boea7z3JBY7pmlfc
YF+fh2IIrneZJyCvBaQrh/Bf0St4taLtxgeR5Hs6JVUrqT6NDhBK2eAhnG7Aahfg
0tiw9d0UEMdigObO5CDZ5U9aZKxNLQ7/MHUlINZlPOU9tM3Uxv8w69gKPRrgrssO
AigShjRICfllUdxezmPHQeAMH+r0g6osgaRlN8x9LgOm1X+jU6YLzTrf8z3oYvtp
mzyi29KhCQQLQ/aoDInqYBrhLl26fkn13AmvlYOgFgXJV03E1Pv2xgIfDbCjPerQ
BEDoNjLV1akFY2wac3vZKvEuHVLlO1AzBkYBkFcXzyR/zJpYhZxTscfkSRRQNw+W
pAKXfw1QIdsVsxClm4FPcRkttkKmg+0NUipk1zpxZFDRB0EXxVrFpVrdui4F6j3z
1c5kp6PQYK7MxdYBi5Bee0/Awpzb7GFdspOgoGs+wRQY/YkDxIqeUr3sX7/PhoRb
Zj9d9NHphmMejizJPu1a8T3TvBomiSGjRF2bEMtOuKs8fibQJQoAmWg68sc5dzdw
eBE/VqngR6fox+ZKkTSdDM7FQqb3k6AJdRIGmFRdkowdjwt4RIDR0xSkGE9KxF5G
nFhTPHBngX71v4K72cFmpPM6qZg+nrrQqVyrX5/kUwFiq5fkpv1vZx6sjf03dOpL
DDzJ6EWIFxg=
=FWYr
-----END PGP SIGNATURE-----

--Sig_/L5NJ3y4gJxVv3JeFzaEL0sp--
