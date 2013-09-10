From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Tue, 10 Sep 2013 10:35:55 +0800
Message-ID: <20130910023555.GA17907@kernel.org>
References: <20130828143252.1d48b04b@notabene.brown>
 <20130828063953.GD17163@kernel.org>
 <20130903160858.2175a41b@notabene.brown>
 <20130903070228.GA25041@kernel.org>
 <20130904164132.177701e0@notabene.brown>
 <20130905054035.GA30216@kernel.org>
 <20130905162910.179ea808@notabene.brown>
 <20130905091822.GA8401@kernel.org>
 <20130909043318.GA27517@kernel.org>
 <20130910111318.1d19e8d3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130910111318.1d19e8d3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, Sep 10, 2013 at 11:13:18AM +1000, NeilBrown wrote:
> On Mon, 9 Sep 2013 12:33:18 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Thu, Sep 05, 2013 at 05:18:22PM +0800, Shaohua Li wrote:
> > > On Thu, Sep 05, 2013 at 04:29:10PM +1000, NeilBrown wrote:
> 
> > > >  I'm in two minds about the temp_inactive_list.
> > > >  An alternative would be to have a single list and use list_sort() to sort it
> > > >  by hash_lock_index before moving the stripe_heads to the relevant lists,
> > > >  taking one lock at a time.
> > > >  This save some memory and costs some cpu time.  On the whole I think it
> > > >  gains in elegance but I'm not sure.  What do you think?
> > > 
> > > I thought it doesn't work. For example, we lock hash 0 lock.
> > > get_active_stripe() finds a stripe of hash 1, and delete it from lru, while the
> > > stripe is in temp_inactive_list. We are locking different hash locks, so the
> > > list could corrupt. Alternative is we hold device_lock again and move one
> > > hash's temp_active_list to another list, then unlock device_lock. then do
> > > releae for the new temporary list. But in this way, we need take device_lock
> > > several times, which isn't good too.
> 
> Yes, I agree.
> 
> > 
> > Here is the latest patch which fixes the max_hash_nr_stripes issue.
> 
> Thanks.  Looks good but still a few little comments (4 of them).
> 
> 
> 
> > 
> > 
> > Subject: raid5: relieve lock contention in get_active_stripe()
> > 
> > get_active_stripe() is the last place we have lock contention. It has two
> > paths. One is stripe isn't found and new stripe is allocated, the other is
> > stripe is found.
> > 
> > The first path basically calls __find_stripe and init_stripe. It accesses
> > conf->generation, conf->previous_raid_disks, conf->raid_disks,
> > conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
> > conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. Except
> > stripe_hashtbl and inactive_list, other fields are changed very rarely.
> > 
> > With this patch, we split inactive_list and add new hash locks. Each free
> > stripe belongs to a specific inactive list. Which inactive list is determined
> > by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, it has a
> > lock_hash assigned. Stripe's inactive list is protected by a hash lock, which
> > is determined by it's lock_hash too. The lock_hash is derivied from current
> > stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be assigned
> > to a specific lock_hash, so we can use new hash lock to protect stripe_hashtbl
> > list too. The goal of the new hash locks introduced is we can only use the new
> > locks in the first path of get_active_stripe(). Since we have several hash
> > locks, lock contention is relieved significantly.
> > 
> > The first path of get_active_stripe() accesses other fields, since they are
> > changed rarely, changing them now need take conf->device_lock and all hash
> > locks. For a slow path, this isn't a problem.
> > 
> > If we need lock device_lock and hash lock, we always lock hash lock first. The
> > tricky part is release_stripe and friends. We need take device_lock first.
> > Neil's suggestion is we put inactive stripes to a temporary list and readd it
> > to inactive_list after device_lock is released. In this way, we add stripes to
> > temporary list with device_lock hold and remove stripes from the list with hash
> > lock hold. So we don't allow concurrent access to the temporary list, which
> > means we need allocate temporary list for all participants of release_stripe.
> > 
> > One downside is free stripes are maintained in their inactive list, they can't
> > across between the lists. By default, we have total 256 stripes and 8 lists, so
> > each list will have 32 stripes. It's possible one list has free stripe but
> > other list hasn't. The chance should be rare because stripes allocation are
> > even distributed. And we can always allocate more stripes for cache, several
> > mega bytes memory isn't a big deal.
> > 
> > This completely removes the lock contention of the first path of
> > get_active_stripe(). It slows down the second code path a little bit though
> > because we now need takes two locks, but since the hash lock isn't contended,
> > the overhead should be quite small (several atomic instructions). The second
> > path of get_active_stripe() (basically sequential write or big request size
> > randwrite) still has lock contentions.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > ---
> >  drivers/md/raid5.c |  370 ++++++++++++++++++++++++++++++++++++++++-------------
> >  drivers/md/raid5.h |   10 +
> >  2 files changed, 294 insertions(+), 86 deletions(-)
> > 
> > Index: linux/drivers/md/raid5.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid5.c	2013-09-05 22:10:18.426462400 +0800
> > +++ linux/drivers/md/raid5.c	2013-09-05 22:34:05.828512112 +0800
> > @@ -86,6 +86,67 @@ static inline struct hlist_head *stripe_
> >  	return &conf->stripe_hashtbl[hash];
> >  }
> >  
> > +static inline int stripe_hash_locks_hash(sector_t sect)
> > +{
> > +	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
> > +}
> > +
> > +static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
> > +{
> > +	spin_lock_irq(conf->hash_locks + hash);
> > +	spin_lock(&conf->device_lock);
> > +}
> > +
> > +static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
> > +{
> > +	spin_unlock(&conf->device_lock);
> > +	spin_unlock_irq(conf->hash_locks + hash);
> > +}
> > +
> > +static void __lock_all_hash_locks(struct r5conf *conf)
> > +{
> > +	int i;
> > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > +		spin_lock(conf->hash_locks + i);
> > +}
> > +
> > +static void __unlock_all_hash_locks(struct r5conf *conf)
> > +{
> > +	int i;
> > +	for (i = NR_STRIPE_HASH_LOCKS; i; i--)
> > +		spin_unlock(conf->hash_locks + i - 1);
> > +}
> > +
> > +static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
> > +{
> > +	local_irq_disable();
> > +	__lock_all_hash_locks(conf);
> > +	spin_lock(&conf->device_lock);
> > +}
> > +
> > +static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
> > +{
> > +	spin_unlock(&conf->device_lock);
> > +	__unlock_all_hash_locks(conf);
> > +	local_irq_enable();
> > +}
> > +
> > +static inline void lock_all_device_hash_locks_irqsave(struct r5conf *conf,
> > +	unsigned long *flags)
> > +{
> > +	local_irq_save(*flags);
> > +	__lock_all_hash_locks(conf);
> > +	spin_lock(&conf->device_lock);
> > +}
> > +
> > +static inline void unlock_all_device_hash_locks_irqrestore(struct r5conf *conf,
> > +	unsigned long *flags)
> > +{
> > +	spin_unlock(&conf->device_lock);
> > +	__unlock_all_hash_locks(conf);
> > +	local_irq_restore(*flags);
> > +}
> > +
> >  /* bio's attached to a stripe+device for I/O are linked together in bi_sector
> >   * order without overlap.  There may be several bio's per stripe+device, and
> >   * a bio could span several devices.
> > @@ -250,7 +311,8 @@ static void raid5_wakeup_stripe_thread(s
> >  	}
> >  }
> >  
> > -static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
> > +static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
> > +	struct list_head *temp_inactive_list)
> >  {
> >  	BUG_ON(!list_empty(&sh->lru));
> >  	BUG_ON(atomic_read(&conf->active_stripes)==0);
> > @@ -279,19 +341,59 @@ static void do_release_stripe(struct r5c
> >  			    < IO_THRESHOLD)
> >  				md_wakeup_thread(conf->mddev->thread);
> >  		atomic_dec(&conf->active_stripes);
> > -		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> > -			list_add_tail(&sh->lru, &conf->inactive_list);
> > -			wake_up(&conf->wait_for_stripe);
> > -			if (conf->retry_read_aligned)
> > -				md_wakeup_thread(conf->mddev->thread);
> > -		}
> > +		if (!test_bit(STRIPE_EXPANDING, &sh->state))
> > +			list_add_tail(&sh->lru, temp_inactive_list);
> >  	}
> >  }
> >  
> > -static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
> > +static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
> > +	struct list_head *temp_inactive_list)
> >  {
> >  	if (atomic_dec_and_test(&sh->count))
> > -		do_release_stripe(conf, sh);
> > +		do_release_stripe(conf, sh, temp_inactive_list);
> > +}
> > +
> > +/*
> > + * @hash could be NR_STRIPE_HASH_LOCKS, then we have a list of inactive_list
> > + *
> > + * Be careful: Only one task can add/delete stripes from temp_inactive_list at
> > + * given time. Adding stripes only takes device lock, while deleting stripes
> > + * only takes hash lock.
> > + */
> > +static void release_inactive_stripe_list(struct r5conf *conf,
> > +	struct list_head *temp_inactive_list, int hash)
> > +{
> > +	int size;
> > +	bool do_wakeup = false;
> > +	unsigned long flags;
> > +
> > +	if (hash == NR_STRIPE_HASH_LOCKS) {
> > +		size = NR_STRIPE_HASH_LOCKS;
> > +		hash = NR_STRIPE_HASH_LOCKS - 1;
> > +	} else
> > +		size = 1;
> > +	while (size) {
> > +		struct list_head *list = &temp_inactive_list[size - 1];
> > +
> > +		/*
> > +		 * We don't hold any lock here yet, get_active_stripe() might
> > +		 * remove stripes from the list
> > +		 */
> > +		if (!list_empty_careful(list)) {
> > +			spin_lock_irqsave(conf->hash_locks + hash, flags);
> > +			list_splice_tail_init(list, conf->inactive_list + hash);
> > +			do_wakeup = true;
> > +			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
> > +		}
> > +		size--;
> > +		hash--;
> > +	}
> > +
> > +	if (do_wakeup) {
> > +		wake_up(&conf->wait_for_stripe);
> > +		if (conf->retry_read_aligned)
> > +			md_wakeup_thread(conf->mddev->thread);
> > +	}
> >  }
> >  
> >  static struct llist_node *llist_reverse_order(struct llist_node *head)
> > @@ -309,7 +411,8 @@ static struct llist_node *llist_reverse_
> >  }
> >  
> >  /* should hold conf->device_lock already */
> > -static int release_stripe_list(struct r5conf *conf)
> > +static int release_stripe_list(struct r5conf *conf,
> > +	struct list_head *temp_inactive_list)
> >  {
> >  	struct stripe_head *sh;
> >  	int count = 0;
> > @@ -318,6 +421,8 @@ static int release_stripe_list(struct r5
> >  	head = llist_del_all(&conf->released_stripes);
> >  	head = llist_reverse_order(head);
> >  	while (head) {
> > +		int hash;
> > +
> >  		sh = llist_entry(head, struct stripe_head, release_list);
> >  		head = llist_next(head);
> >  		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
> > @@ -328,7 +433,8 @@ static int release_stripe_list(struct r5
> >  		 * again, the count is always > 1. This is true for
> >  		 * STRIPE_ON_UNPLUG_LIST bit too.
> >  		 */
> > -		__release_stripe(conf, sh);
> > +		hash = sh->hash_lock_index;
> > +		__release_stripe(conf, sh, &temp_inactive_list[hash]);
> >  		count++;
> >  	}
> >  
> > @@ -339,6 +445,8 @@ static void release_stripe(struct stripe
> >  {
> >  	struct r5conf *conf = sh->raid_conf;
> >  	unsigned long flags;
> > +	struct list_head list;
> > +	int hash;
> >  	bool wakeup;
> >  
> >  	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
> > @@ -351,8 +459,11 @@ slow_path:
> >  	local_irq_save(flags);
> >  	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
> >  	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
> > -		do_release_stripe(conf, sh);
> > +		INIT_LIST_HEAD(&list);
> > +		hash = sh->hash_lock_index;
> > +		do_release_stripe(conf, sh, &list);
> >  		spin_unlock(&conf->device_lock);
> > +		release_inactive_stripe_list(conf, &list, hash);
> >  	}
> >  	local_irq_restore(flags);
> >  }
> > @@ -377,18 +488,19 @@ static inline void insert_hash(struct r5
> >  
> >  
> >  /* find an idle stripe, make sure it is unhashed, and return it. */
> > -static struct stripe_head *get_free_stripe(struct r5conf *conf)
> > +static struct stripe_head *get_free_stripe(struct r5conf *conf, int hash)
> >  {
> >  	struct stripe_head *sh = NULL;
> >  	struct list_head *first;
> >  
> > -	if (list_empty(&conf->inactive_list))
> > +	if (list_empty(conf->inactive_list + hash))
> >  		goto out;
> > -	first = conf->inactive_list.next;
> > +	first = (conf->inactive_list + hash)->next;
> >  	sh = list_entry(first, struct stripe_head, lru);
> >  	list_del_init(first);
> >  	remove_hash(sh);
> >  	atomic_inc(&conf->active_stripes);
> > +	BUG_ON(hash != sh->hash_lock_index);
> >  out:
> >  	return sh;
> >  }
> > @@ -567,33 +679,35 @@ get_active_stripe(struct r5conf *conf, s
> >  		  int previous, int noblock, int noquiesce)
> >  {
> >  	struct stripe_head *sh;
> > +	int hash = stripe_hash_locks_hash(sector);
> >  
> >  	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
> >  
> > -	spin_lock_irq(&conf->device_lock);
> > +	spin_lock_irq(conf->hash_locks + hash);
> >  
> >  	do {
> >  		wait_event_lock_irq(conf->wait_for_stripe,
> >  				    conf->quiesce == 0 || noquiesce,
> > -				    conf->device_lock);
> > +				    *(conf->hash_locks + hash));
> >  		sh = __find_stripe(conf, sector, conf->generation - previous);
> >  		if (!sh) {
> > -			if (!conf->inactive_blocked)
> > -				sh = get_free_stripe(conf);
> > +			sh = get_free_stripe(conf, hash);
> 
> Why did you removed the test on "inactive_blocked"??  It is important to have
> this test and it encourages batching of requests.
Ok.
 
> >  			if (noblock && sh == NULL)
> >  				break;
> >  			if (!sh) {
> >  				conf->inactive_blocked = 1;
> >  				wait_event_lock_irq(conf->wait_for_stripe,
> > -						    !list_empty(&conf->inactive_list) &&
> > -						    (atomic_read(&conf->active_stripes)
> > -						     < (conf->max_nr_stripes *3/4)
> > -						     || !conf->inactive_blocked),
> > -						    conf->device_lock);
> > +					!list_empty(conf->inactive_list + hash) &&
> > +					(atomic_read(&conf->active_stripes)
> > +					  < (conf->max_nr_stripes * 3 / 4)
> > +					|| !conf->inactive_blocked),
> > +					*(conf->hash_locks + hash));
> >  				conf->inactive_blocked = 0;
> >  			} else
> >  				init_stripe(sh, sector, previous);
> >  		} else {
> > +			spin_lock(&conf->device_lock);
> > +
> >  			if (atomic_read(&sh->count)) {
> >  				BUG_ON(!list_empty(&sh->lru)
> >  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> > @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
> >  					sh->group = NULL;
> >  				}
> >  			}
> > +			spin_unlock(&conf->device_lock);
> 
> The device_lock is only really needed in the 'else' branch of the if
> statement.  So can we have it only there.  i.e. don't take the lock if
> sh->count is non-zero.

This is correct, I assume this isn't worthy optimizing before. Will fix soon.

> >  		}
> >  	} while (sh == NULL);
> >  
> >  	if (sh)
> >  		atomic_inc(&sh->count);
> >  
> > -	spin_unlock_irq(&conf->device_lock);
> > +	spin_unlock_irq(conf->hash_locks + hash);
> >  	return sh;
> >  }
> >  
> > @@ -1585,7 +1700,7 @@ static void raid_run_ops(struct stripe_h
> >  	put_cpu();
> >  }
> >  
> > -static int grow_one_stripe(struct r5conf *conf)
> > +static int grow_one_stripe(struct r5conf *conf, int hash)
> >  {
> >  	struct stripe_head *sh;
> >  	sh = kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
> > @@ -1601,6 +1716,7 @@ static int grow_one_stripe(struct r5conf
> >  		kmem_cache_free(conf->slab_cache, sh);
> >  		return 0;
> >  	}
> > +	sh->hash_lock_index = hash;
> >  	/* we just created an active stripe so... */
> >  	atomic_set(&sh->count, 1);
> >  	atomic_inc(&conf->active_stripes);
> > @@ -1609,10 +1725,12 @@ static int grow_one_stripe(struct r5conf
> >  	return 1;
> >  }
> >  
> > +static int drop_one_stripe(struct r5conf *conf, int hash);
> >  static int grow_stripes(struct r5conf *conf, int num)
> >  {
> >  	struct kmem_cache *sc;
> >  	int devs = max(conf->raid_disks, conf->previous_raid_disks);
> > +	int hash;
> >  
> >  	if (conf->mddev->gendisk)
> >  		sprintf(conf->cache_name[0],
> > @@ -1630,10 +1748,21 @@ static int grow_stripes(struct r5conf *c
> >  		return 1;
> >  	conf->slab_cache = sc;
> >  	conf->pool_size = devs;
> > -	while (num--)
> > -		if (!grow_one_stripe(conf))
> > -			return 1;
> > +	hash = 0;
> > +	while (num--) {
> > +		if (!grow_one_stripe(conf, hash))
> > +			goto error;
> > +		conf->max_nr_stripes++;
> > +		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
> > +	}
> >  	return 0;
> > +error:
> > +	while (hash > 0) {
> > +		drop_one_stripe(conf, hash - 1);
> > +		conf->max_nr_stripes--;
> > +		hash--;
> > +	}
> > +	return 1;
> >  }
> >  
> >  /**
> > @@ -1690,6 +1819,7 @@ static int resize_stripes(struct r5conf
> >  	int err;
> >  	struct kmem_cache *sc;
> >  	int i;
> > +	int hash, cnt;
> >  
> >  	if (newsize <= conf->pool_size)
> >  		return 0; /* never bother to shrink */
> > @@ -1729,19 +1859,28 @@ static int resize_stripes(struct r5conf
> >  	 * OK, we have enough stripes, start collecting inactive
> >  	 * stripes and copying them over
> >  	 */
> > +	hash = 0;
> > +	cnt = 0;
> >  	list_for_each_entry(nsh, &newstripes, lru) {
> > -		spin_lock_irq(&conf->device_lock);
> > -		wait_event_lock_irq(conf->wait_for_stripe,
> > -				    !list_empty(&conf->inactive_list),
> > -				    conf->device_lock);
> > -		osh = get_free_stripe(conf);
> > -		spin_unlock_irq(&conf->device_lock);
> > +		lock_device_hash_lock(conf, hash);
> > +		wait_event_cmd(conf->wait_for_stripe,
> > +				    !list_empty(conf->inactive_list + hash),
> > +				    unlock_device_hash_lock(conf, hash),
> > +				    lock_device_hash_lock(conf, hash));
> > +		osh = get_free_stripe(conf, hash);
> > +		unlock_device_hash_lock(conf, hash);
> >  		atomic_set(&nsh->count, 1);
> >  		for(i=0; i<conf->pool_size; i++)
> >  			nsh->dev[i].page = osh->dev[i].page;
> >  		for( ; i<newsize; i++)
> >  			nsh->dev[i].page = NULL;
> > +		nsh->hash_lock_index = hash;
> >  		kmem_cache_free(conf->slab_cache, osh);
> > +		cnt++;
> > +		if (cnt >= conf->max_nr_stripes / NR_STRIPE_HASH_LOCKS) {
> > +			hash++;
> > +			cnt = 0;
> > +		}
> >  	}
> >  	kmem_cache_destroy(conf->slab_cache);
> >  
> > @@ -1800,13 +1939,13 @@ static int resize_stripes(struct r5conf
> >  	return err;
> >  }
> >  
> > -static int drop_one_stripe(struct r5conf *conf)
> > +static int drop_one_stripe(struct r5conf *conf, int hash)
> >  {
> >  	struct stripe_head *sh;
> >  
> > -	spin_lock_irq(&conf->device_lock);
> > -	sh = get_free_stripe(conf);
> > -	spin_unlock_irq(&conf->device_lock);
> > +	spin_lock_irq(conf->hash_locks + hash);
> > +	sh = get_free_stripe(conf, hash);
> > +	spin_unlock_irq(conf->hash_locks + hash);
> >  	if (!sh)
> >  		return 0;
> >  	BUG_ON(atomic_read(&sh->count));
> > @@ -1818,8 +1957,10 @@ static int drop_one_stripe(struct r5conf
> >  
> >  static void shrink_stripes(struct r5conf *conf)
> >  {
> > -	while (drop_one_stripe(conf))
> > -		;
> > +	int hash;
> > +	for (hash = 0; hash < NR_STRIPE_HASH_LOCKS; hash++)
> > +		while (drop_one_stripe(conf, hash))
> > +			;
> >  
> >  	if (conf->slab_cache)
> >  		kmem_cache_destroy(conf->slab_cache);
> > @@ -2048,10 +2189,10 @@ static void error(struct mddev *mddev, s
> >  	unsigned long flags;
> >  	pr_debug("raid456: error called\n");
> >  
> > -	spin_lock_irqsave(&conf->device_lock, flags);
> > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> >  	clear_bit(In_sync, &rdev->flags);
> >  	mddev->degraded = calc_degraded(conf);
> > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> >  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> 
> Why do you think you need to take all the hash locks here and elsewhere when
> ->degraded is set?
> The lock is only need to ensure that the 'In_sync' flags are consistent with
> the 'degraded' count.
> ->degraded isn't used in get_active_stripe so I cannot see how it is relevant
> to the hash locks.
> 
> We need to lock everything in raid5_quiesce().  I don't think we need to
> anywhere else.

init_stripe() accesses some filelds, don't need to protect?

> >  
> >  	set_bit(Blocked, &rdev->flags);
> > @@ -3895,7 +4036,8 @@ static void raid5_activate_delayed(struc
> >  	}
> >  }
> >  
> > -static void activate_bit_delay(struct r5conf *conf)
> > +static void activate_bit_delay(struct r5conf *conf,
> > +	struct list_head *temp_inactive_list)
> >  {
> >  	/* device_lock is held */
> >  	struct list_head head;
> > @@ -3903,9 +4045,11 @@ static void activate_bit_delay(struct r5
> >  	list_del_init(&conf->bitmap_list);
> >  	while (!list_empty(&head)) {
> >  		struct stripe_head *sh = list_entry(head.next, struct stripe_head, lru);
> > +		int hash;
> >  		list_del_init(&sh->lru);
> >  		atomic_inc(&sh->count);
> > -		__release_stripe(conf, sh);
> > +		hash = sh->hash_lock_index;
> > +		__release_stripe(conf, sh, &temp_inactive_list[hash]);
> >  	}
> >  }
> >  
> > @@ -3921,7 +4065,7 @@ int md_raid5_congested(struct mddev *mdd
> >  		return 1;
> >  	if (conf->quiesce)
> >  		return 1;
> > -	if (list_empty_careful(&conf->inactive_list))
> > +	if (atomic_read(&conf->active_stripes) == conf->max_nr_stripes)
> >  		return 1;
> >  
> >  	return 0;
> > @@ -4251,6 +4395,7 @@ static struct stripe_head *__get_priorit
> >  struct raid5_plug_cb {
> >  	struct blk_plug_cb	cb;
> >  	struct list_head	list;
> > +	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
> >  };
> >  
> >  static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
> > @@ -4261,6 +4406,7 @@ static void raid5_unplug(struct blk_plug
> >  	struct mddev *mddev = cb->cb.data;
> >  	struct r5conf *conf = mddev->private;
> >  	int cnt = 0;
> > +	int hash;
> >  
> >  	if (cb->list.next && !list_empty(&cb->list)) {
> >  		spin_lock_irq(&conf->device_lock);
> > @@ -4278,11 +4424,14 @@ static void raid5_unplug(struct blk_plug
> >  			 * STRIPE_ON_RELEASE_LIST could be set here. In that
> >  			 * case, the count is always > 1 here
> >  			 */
> > -			__release_stripe(conf, sh);
> > +			hash = sh->hash_lock_index;
> > +			__release_stripe(conf, sh, &cb->temp_inactive_list[hash]);
> >  			cnt++;
> >  		}
> >  		spin_unlock_irq(&conf->device_lock);
> >  	}
> > +	release_inactive_stripe_list(conf, cb->temp_inactive_list,
> > +		NR_STRIPE_HASH_LOCKS);
> >  	if (mddev->queue)
> >  		trace_block_unplug(mddev->queue, cnt, !from_schedule);
> >  	kfree(cb);
> > @@ -4303,8 +4452,12 @@ static void release_stripe_plug(struct m
> >  
> >  	cb = container_of(blk_cb, struct raid5_plug_cb, cb);
> >  
> > -	if (cb->list.next == NULL)
> > +	if (cb->list.next == NULL) {
> > +		int i;
> >  		INIT_LIST_HEAD(&cb->list);
> > +		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > +			INIT_LIST_HEAD(cb->temp_inactive_list + i);
> > +	}
> >  
> >  	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
> >  		list_add_tail(&sh->lru, &cb->list);
> > @@ -4949,27 +5102,45 @@ static int  retry_aligned_read(struct r5
> >  }
> >  
> >  static int handle_active_stripes(struct r5conf *conf, int group,
> > -				 struct r5worker *worker)
> > +				 struct r5worker *worker,
> > +				 struct list_head *temp_inactive_list)
> >  {
> >  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> > -	int i, batch_size = 0;
> > +	int i, batch_size = 0, hash;
> > +	bool release_inactive = false;
> >  
> >  	while (batch_size < MAX_STRIPE_BATCH &&
> >  			(sh = __get_priority_stripe(conf, group)) != NULL)
> >  		batch[batch_size++] = sh;
> >  
> > -	if (batch_size == 0)
> > -		return batch_size;
> > +	if (batch_size == 0) {
> > +		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > +			if (!list_empty(temp_inactive_list + i))
> > +				break;
> > +		if (i == NR_STRIPE_HASH_LOCKS)
> > +			return batch_size;
> > +		release_inactive = true;
> > +	}
> >  	spin_unlock_irq(&conf->device_lock);
> >  
> > +	release_inactive_stripe_list(conf, temp_inactive_list,
> > +		NR_STRIPE_HASH_LOCKS);
> > +
> > +	if (release_inactive) {
> > +		spin_lock_irq(&conf->device_lock);
> > +		return 0;
> > +	}
> > +
> >  	for (i = 0; i < batch_size; i++)
> >  		handle_stripe(batch[i]);
> >  
> >  	cond_resched();
> >  
> >  	spin_lock_irq(&conf->device_lock);
> > -	for (i = 0; i < batch_size; i++)
> > -		__release_stripe(conf, batch[i]);
> > +	for (i = 0; i < batch_size; i++) {
> > +		hash = batch[i]->hash_lock_index;
> > +		__release_stripe(conf, batch[i], &temp_inactive_list[hash]);
> > +	}
> >  	return batch_size;
> >  }
> >  
> > @@ -4990,9 +5161,10 @@ static void raid5_do_work(struct work_st
> >  	while (1) {
> >  		int batch_size, released;
> >  
> > -		released = release_stripe_list(conf);
> > +		released = release_stripe_list(conf, worker->temp_inactive_list);
> >  
> > -		batch_size = handle_active_stripes(conf, group_id, worker);
> > +		batch_size = handle_active_stripes(conf, group_id, worker,
> > +				worker->temp_inactive_list);
> >  		worker->working = false;
> >  		if (!batch_size && !released)
> >  			break;
> > @@ -5031,7 +5203,7 @@ static void raid5d(struct md_thread *thr
> >  		struct bio *bio;
> >  		int batch_size, released;
> >  
> > -		released = release_stripe_list(conf);
> > +		released = release_stripe_list(conf, conf->temp_inactive_list);
> >  
> >  		if (
> >  		    !list_empty(&conf->bitmap_list)) {
> > @@ -5041,7 +5213,7 @@ static void raid5d(struct md_thread *thr
> >  			bitmap_unplug(mddev->bitmap);
> >  			spin_lock_irq(&conf->device_lock);
> >  			conf->seq_write = conf->seq_flush;
> > -			activate_bit_delay(conf);
> > +			activate_bit_delay(conf, conf->temp_inactive_list);
> >  		}
> >  		raid5_activate_delayed(conf);
> >  
> > @@ -5055,7 +5227,8 @@ static void raid5d(struct md_thread *thr
> >  			handled++;
> >  		}
> >  
> > -		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
> > +		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL,
> > +				conf->temp_inactive_list);
> >  		if (!batch_size && !released)
> >  			break;
> >  		handled += batch_size;
> > @@ -5091,23 +5264,37 @@ raid5_set_cache_size(struct mddev *mddev
> >  {
> >  	struct r5conf *conf = mddev->private;
> >  	int err;
> > +	int hash;
> >  
> >  	if (size <= 16 || size > 32768)
> >  		return -EINVAL;
> > +	size = round_up(size, NR_STRIPE_HASH_LOCKS);
> > +	hash = 0;
> >  	while (size < conf->max_nr_stripes) {
> > -		if (drop_one_stripe(conf))
> > +		if (drop_one_stripe(conf, hash))
> >  			conf->max_nr_stripes--;
> > -		else
> > -			break;
> > +		else /* shouldn't fail here */
> > +			BUG();
> > +		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
> 
> This 'BUG' is wrong.  drop_one_stripe can fail if all of the stripes are
> currently active.  We need to handle that case properly.
> We cannot reliably allocate a new stripe to make up for one we freed
> so we need a slightly different approach.
> 
> We could allow a small difference in the number of stripes allocates for each
> hash. Specifically for hashes less than
>    conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS
> there is an extra stripe allocated.  All others have 
>    conf->max_nr_stripes / NR_STRIPE_HASH_LOCKS
> allocated.
> So when we allocate a stripe_head, it gets a hash value of
>    conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS
> and when we drop a stripe_head we always drop one with the
> hash value
>    (conf->max_nr_stripes - 1) % NR_STRIPE_HASH_LOCKS

Good idea. Will fix this.

Thanks,
Shaohua
