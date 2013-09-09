From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Mon, 9 Sep 2013 12:33:18 +0800
Message-ID: <20130909043318.GA27517@kernel.org>
References: <20130827131752.4d5ba375@notabene.brown>
 <20130827085330.GA30133@kernel.org>
 <20130828143252.1d48b04b@notabene.brown>
 <20130828063953.GD17163@kernel.org>
 <20130903160858.2175a41b@notabene.brown>
 <20130903070228.GA25041@kernel.org>
 <20130904164132.177701e0@notabene.brown>
 <20130905054035.GA30216@kernel.org>
 <20130905162910.179ea808@notabene.brown>
 <20130905091822.GA8401@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130905091822.GA8401@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

On Thu, Sep 05, 2013 at 05:18:22PM +0800, Shaohua Li wrote:
> On Thu, Sep 05, 2013 at 04:29:10PM +1000, NeilBrown wrote:
> > On Thu, 5 Sep 2013 13:40:35 +0800 Shaohua Li <shli@kernel.org> wrote:
> > 
> > > On Wed, Sep 04, 2013 at 04:41:32PM +1000, NeilBrown wrote:
> > > > On Tue, 3 Sep 2013 15:02:28 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > > 
> > > > > On Tue, Sep 03, 2013 at 04:08:58PM +1000, NeilBrown wrote:
> > > > > > On Wed, 28 Aug 2013 14:39:53 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > > > > 
> > > > > > > On Wed, Aug 28, 2013 at 02:32:52PM +1000, NeilBrown wrote:
> > > > > > > > On Tue, 27 Aug 2013 16:53:30 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > > > > > > 
> > > > > > > > > On Tue, Aug 27, 2013 at 01:17:52PM +1000, NeilBrown wrote:
> > > > > > > > 
> > > > > > > > > 
> > > > > > > > > > Then get_active_stripe wouldn't need to worry about device_lock at all and
> > > > > > > > > > would only need to get the hash lock for the particular sector.  That should
> > > > > > > > > > make it a lot simpler.
> > > > > > > > > 
> > > > > > > > > did you mean get_active_stripe() doesn't need device_lock for any code path?
> > > > > > > > > How could it be safe? device_lock still protects something like handle_list,
> > > > > > > > > delayed_list, which release_stripe() will use while a get_active_stripe can run
> > > > > > > > > concurrently.
> > > > > > > > 
> > > > > > > > Yes you will still need device_lock to protect list_del_init(&sh->lru),
> > > > > > > > as well as the hash lock.
> > > > > > > > Do you need device_lock anywhere else in there?
> > > > > > > 
> > > > > > > That's what I mean. So I need get both device_lock and hash_lock. To not
> > > > > > > deadlock, I need release hash_lock and relock device_lock/hash_lock. Since I
> > > > > > > release lock, I need recheck if I can find the stripe in hash again. So the
> > > > > > > seqcount locking doesn't simplify things here. I thought the seqlock only fixes
> > > > > > > one race. Did I miss anything?
> > > > > > 
> > > > > > Can you order the locks so that you take the hash_lock first, then the
> > > > > > device_lock?  That would be a lot simpler.
> > > > > 
> > > > > Looks impossible. For example, in handle_active_stripes() we release several
> > > > > stripes, we can't take hash_lock first.
> > > > 
> > > > "impossible" just takes a little longer :-)
> > > > 
> > > > do_release_stripe gets called with only device_lock held.  It gets passed an
> > > > (initially) empty list_head too.
> > > > If it wants to add the stripe to an inactive list it puts it on the given
> > > > list_head instead.
> > > > 
> > > > release_stripe(), after calling do_release_stripe() calls some function to
> > > > grab the appropriate hash_lock for each stripe in the list_head and add it
> > > > to that inactive list.
> > > > 
> > > > release_stripe_list() might collect some stripes from from __release_stripe
> > > > that need to go on an inactive list.  It arranges for them to be put on the
> > > > right list, with the right lock, next time device_lock is dropped.  That
> > > > might be in handle_active_stripes()
> > > > 
> > > > activate_bit_delay might similarly collect stripes, which are handled the
> > > > same way as those collected by release_stripe_list.
> > > > etc.
> > > > 
> > > > i.e. the hash_locks protect the various inactive lists.  device_lock protects
> > > > all the others.  If we need to add something to an inactive list while
> > > > holding device_lock we delay until device_lock can be dropped.
> > > 
> > > Alright, this option works, but we need allocate some spaces, which isn't very
> > > good for unplug cb. Below is the patch I tested.
> > > 
> > > Thanks,
> > > Shaohua
> > > 
> > > Subject: raid5: relieve lock contention in get_active_stripe()
> > > 
> > > get_active_stripe() is the last place we have lock contention. It has two
> > > paths. One is stripe isn't found and new stripe is allocated, the other is
> > > stripe is found.
> > > 
> > > The first path basically calls __find_stripe and init_stripe. It accesses
> > > conf->generation, conf->previous_raid_disks, conf->raid_disks,
> > > conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
> > > conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. Except
> > > stripe_hashtbl and inactive_list, other fields are changed very rarely.
> > > 
> > > With this patch, we split inactive_list and add new hash locks. Each free
> > > stripe belongs to a specific inactive list. Which inactive list is determined
> > > by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, it has a
> > > lock_hash assigned. Stripe's inactive list is protected by a hash lock, which
> > > is determined by it's lock_hash too. The lock_hash is derivied from current
> > > stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be assigned
> > > to a specific lock_hash, so we can use new hash lock to protect stripe_hashtbl
> > > list too. The goal of the new hash locks introduced is we can only use the new
> > > locks in the first path of get_active_stripe(). Since we have several hash
> > > locks, lock contention is relieved significantly.
> > > 
> > > The first path of get_active_stripe() accesses other fields, since they are
> > > changed rarely, changing them now need take conf->device_lock and all hash
> > > locks. For a slow path, this isn't a problem.
> > > 
> > > If we need lock device_lock and hash lock, we always lock hash lock first. The
> > > tricky part is release_stripe and friends. We need take device_lock first.
> > > Neil's suggestion is we put inactive stripes to a temporary list and readd it
> > > to inactive_list after device_lock is released. In this way, we add stripes to
> > > temporary list with device_lock hold and remove stripes from the list with hash
> > > lock hold. So we don't allow concurrent access to the temporary list, which
> > > means we need allocate temporary list for all participants of release_stripe.
> > > 
> > > One downside is free stripes are maintained in their inactive list, they can't
> > > across between the lists. By default, we have total 256 stripes and 8 lists, so
> > > each list will have 32 stripes. It's possible one list has free stripe but
> > > other list hasn't. The chance should be rare because stripes allocation are
> > > even distributed. And we can always allocate more stripes for cache, several
> > > mega bytes memory isn't a big deal.
> > > 
> > > This completely removes the lock contention of the first path of
> > > get_active_stripe(). It slows down the second code path a little bit though
> > > because we now need takes two locks, but since the hash lock isn't contended,
> > > the overhead should be quite small (several atomic instructions). The second
> > > path of get_active_stripe() (basically sequential write or big request size
> > > randwrite) still has lock contentions.
> > > 
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > ---
> > >  drivers/md/raid5.c |  346 ++++++++++++++++++++++++++++++++++++++++-------------
> > >  drivers/md/raid5.h |   11 +
> > >  2 files changed, 276 insertions(+), 81 deletions(-)
> > > 
> > > Index: linux/drivers/md/raid5.c
> > > ===================================================================
> > > --- linux.orig/drivers/md/raid5.c	2013-09-05 08:23:42.187851834 +0800
> > > +++ linux/drivers/md/raid5.c	2013-09-05 12:52:47.581235145 +0800
> > > @@ -86,6 +86,67 @@ static inline struct hlist_head *stripe_
> > >  	return &conf->stripe_hashtbl[hash];
> > >  }
> > >  
> > > +static inline int stripe_hash_locks_hash(sector_t sect)
> > > +{
> > > +	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
> > > +}
> > > +
> > > +static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
> > > +{
> > > +	spin_lock_irq(conf->hash_locks + hash);
> > > +	spin_lock(&conf->device_lock);
> > > +}
> > > +
> > > +static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
> > > +{
> > > +	spin_unlock(&conf->device_lock);
> > > +	spin_unlock_irq(conf->hash_locks + hash);
> > > +}
> > > +
> > > +static void __lock_all_hash_locks(struct r5conf *conf)
> > > +{
> > > +	int i;
> > > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +		spin_lock(conf->hash_locks + i);
> > > +}
> > > +
> > > +static void __unlock_all_hash_locks(struct r5conf *conf)
> > > +{
> > > +	int i;
> > > +	for (i = NR_STRIPE_HASH_LOCKS; i; i--)
> > > +		spin_unlock(conf->hash_locks + i - 1);
> > > +}
> > > +
> > > +static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
> > > +{
> > > +	local_irq_disable();
> > > +	__lock_all_hash_locks(conf);
> > > +	spin_lock(&conf->device_lock);
> > > +}
> > > +
> > > +static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
> > > +{
> > > +	spin_unlock(&conf->device_lock);
> > > +	__unlock_all_hash_locks(conf);
> > > +	local_irq_enable();
> > > +}
> > > +
> > > +static inline void lock_all_device_hash_locks_irqsave(struct r5conf *conf,
> > > +	unsigned long *flags)
> > > +{
> > > +	local_irq_save(*flags);
> > > +	__lock_all_hash_locks(conf);
> > > +	spin_lock(&conf->device_lock);
> > > +}
> > > +
> > > +static inline void unlock_all_device_hash_locks_irqrestore(struct r5conf *conf,
> > > +	unsigned long *flags)
> > > +{
> > > +	spin_unlock(&conf->device_lock);
> > > +	__unlock_all_hash_locks(conf);
> > > +	local_irq_restore(*flags);
> > > +}
> > > +
> > >  /* bio's attached to a stripe+device for I/O are linked together in bi_sector
> > >   * order without overlap.  There may be several bio's per stripe+device, and
> > >   * a bio could span several devices.
> > > @@ -250,7 +311,8 @@ static void raid5_wakeup_stripe_thread(s
> > >  	}
> > >  }
> > >  
> > > -static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
> > > +static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
> > > +	struct list_head *temp_inactive_list)
> > >  {
> > >  	BUG_ON(!list_empty(&sh->lru));
> > >  	BUG_ON(atomic_read(&conf->active_stripes)==0);
> > > @@ -279,19 +341,59 @@ static void do_release_stripe(struct r5c
> > >  			    < IO_THRESHOLD)
> > >  				md_wakeup_thread(conf->mddev->thread);
> > >  		atomic_dec(&conf->active_stripes);
> > > -		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> > > -			list_add_tail(&sh->lru, &conf->inactive_list);
> > > -			wake_up(&conf->wait_for_stripe);
> > > -			if (conf->retry_read_aligned)
> > > -				md_wakeup_thread(conf->mddev->thread);
> > > -		}
> > > +		if (!test_bit(STRIPE_EXPANDING, &sh->state))
> > > +			list_add_tail(&sh->lru, temp_inactive_list);
> > >  	}
> > >  }
> > >  
> > > -static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
> > > +static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
> > > +	struct list_head *temp_inactive_list)
> > >  {
> > >  	if (atomic_dec_and_test(&sh->count))
> > > -		do_release_stripe(conf, sh);
> > > +		do_release_stripe(conf, sh, temp_inactive_list);
> > > +}
> > > +
> > > +/*
> > > + * @hash could be NR_STRIPE_HASH_LOCKS, then we have a list of inactive_list
> > > + *
> > > + * Be careful: Only one task can add/delete stripes from temp_inactive_list at
> > > + * given time. Adding stripes only takes device lock, while deleting stripes
> > > + * only takes hash lock.
> > > + */
> > > +static void release_inactive_stripe_list(struct r5conf *conf,
> > > +	struct list_head *temp_inactive_list, int hash)
> > > +{
> > > +	int size;
> > > +	bool do_wakeup = false;
> > > +	unsigned long flags;
> > > +
> > > +	if (hash == NR_STRIPE_HASH_LOCKS) {
> > > +		size = NR_STRIPE_HASH_LOCKS;
> > > +		hash = NR_STRIPE_HASH_LOCKS - 1;
> > > +	} else
> > > +		size = 1;
> > > +	while (size) {
> > > +		struct list_head *list = &temp_inactive_list[size - 1];
> > > +
> > > +		/*
> > > +		 * We don't hold any lock here yet, get_active_stripe() might
> > > +		 * remove stripes from the list
> > > +		 */
> > > +		if (!list_empty_careful(list)) {
> > > +			spin_lock_irqsave(conf->hash_locks + hash, flags);
> > > +			list_splice_tail_init(list, conf->inactive_list + hash);
> > > +			do_wakeup = true;
> > > +			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
> > > +		}
> > > +		size--;
> > > +		hash--;
> > > +	}
> > > +
> > > +	if (do_wakeup) {
> > > +		wake_up(&conf->wait_for_stripe);
> > > +		if (conf->retry_read_aligned)
> > > +			md_wakeup_thread(conf->mddev->thread);
> > > +	}
> > >  }
> > >  
> > >  static struct llist_node *llist_reverse_order(struct llist_node *head)
> > > @@ -309,7 +411,8 @@ static struct llist_node *llist_reverse_
> > >  }
> > >  
> > >  /* should hold conf->device_lock already */
> > > -static int release_stripe_list(struct r5conf *conf)
> > > +static int release_stripe_list(struct r5conf *conf,
> > > +	struct list_head *temp_inactive_list)
> > >  {
> > >  	struct stripe_head *sh;
> > >  	int count = 0;
> > > @@ -318,6 +421,8 @@ static int release_stripe_list(struct r5
> > >  	head = llist_del_all(&conf->released_stripes);
> > >  	head = llist_reverse_order(head);
> > >  	while (head) {
> > > +		int hash;
> > > +
> > >  		sh = llist_entry(head, struct stripe_head, release_list);
> > >  		head = llist_next(head);
> > >  		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
> > > @@ -328,7 +433,8 @@ static int release_stripe_list(struct r5
> > >  		 * again, the count is always > 1. This is true for
> > >  		 * STRIPE_ON_UNPLUG_LIST bit too.
> > >  		 */
> > > -		__release_stripe(conf, sh);
> > > +		hash = sh->hash_lock_index;
> > > +		__release_stripe(conf, sh, &temp_inactive_list[hash]);
> > >  		count++;
> > >  	}
> > >  
> > > @@ -339,6 +445,8 @@ static void release_stripe(struct stripe
> > >  {
> > >  	struct r5conf *conf = sh->raid_conf;
> > >  	unsigned long flags;
> > > +	struct list_head list;
> > > +	int hash;
> > >  	bool wakeup;
> > >  
> > >  	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
> > > @@ -351,8 +459,11 @@ slow_path:
> > >  	local_irq_save(flags);
> > >  	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
> > >  	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
> > > -		do_release_stripe(conf, sh);
> > > +		INIT_LIST_HEAD(&list);
> > > +		hash = sh->hash_lock_index;
> > > +		do_release_stripe(conf, sh, &list);
> > >  		spin_unlock(&conf->device_lock);
> > > +		release_inactive_stripe_list(conf, &list, hash);
> > >  	}
> > >  	local_irq_restore(flags);
> > >  }
> > > @@ -377,18 +488,19 @@ static inline void insert_hash(struct r5
> > >  
> > >  
> > >  /* find an idle stripe, make sure it is unhashed, and return it. */
> > > -static struct stripe_head *get_free_stripe(struct r5conf *conf)
> > > +static struct stripe_head *get_free_stripe(struct r5conf *conf, int hash)
> > >  {
> > >  	struct stripe_head *sh = NULL;
> > >  	struct list_head *first;
> > >  
> > > -	if (list_empty(&conf->inactive_list))
> > > +	if (list_empty(conf->inactive_list + hash))
> > >  		goto out;
> > > -	first = conf->inactive_list.next;
> > > +	first = (conf->inactive_list + hash)->next;
> > >  	sh = list_entry(first, struct stripe_head, lru);
> > >  	list_del_init(first);
> > >  	remove_hash(sh);
> > >  	atomic_inc(&conf->active_stripes);
> > > +	BUG_ON(hash != sh->hash_lock_index);
> > >  out:
> > >  	return sh;
> > >  }
> > > @@ -567,33 +679,35 @@ get_active_stripe(struct r5conf *conf, s
> > >  		  int previous, int noblock, int noquiesce)
> > >  {
> > >  	struct stripe_head *sh;
> > > +	int hash = stripe_hash_locks_hash(sector);
> > >  
> > >  	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
> > >  
> > > -	spin_lock_irq(&conf->device_lock);
> > > +	spin_lock_irq(conf->hash_locks + hash);
> > >  
> > >  	do {
> > >  		wait_event_lock_irq(conf->wait_for_stripe,
> > >  				    conf->quiesce == 0 || noquiesce,
> > > -				    conf->device_lock);
> > > +				    *(conf->hash_locks + hash));
> > >  		sh = __find_stripe(conf, sector, conf->generation - previous);
> > >  		if (!sh) {
> > > -			if (!conf->inactive_blocked)
> > > -				sh = get_free_stripe(conf);
> > > +			sh = get_free_stripe(conf, hash);
> > >  			if (noblock && sh == NULL)
> > >  				break;
> > >  			if (!sh) {
> > >  				conf->inactive_blocked = 1;
> > >  				wait_event_lock_irq(conf->wait_for_stripe,
> > > -						    !list_empty(&conf->inactive_list) &&
> > > -						    (atomic_read(&conf->active_stripes)
> > > -						     < (conf->max_nr_stripes *3/4)
> > > -						     || !conf->inactive_blocked),
> > > -						    conf->device_lock);
> > > +					!list_empty(conf->inactive_list + hash) &&
> > > +					(atomic_read(&conf->active_stripes)
> > > +					  < (conf->max_nr_stripes * 3 / 4)
> > > +					|| !conf->inactive_blocked),
> > > +					*(conf->hash_locks + hash));
> > >  				conf->inactive_blocked = 0;
> > >  			} else
> > >  				init_stripe(sh, sector, previous);
> > >  		} else {
> > > +			spin_lock(&conf->device_lock);
> > > +
> > >  			if (atomic_read(&sh->count)) {
> > >  				BUG_ON(!list_empty(&sh->lru)
> > >  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> > > @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
> > >  					sh->group = NULL;
> > >  				}
> > >  			}
> > > +			spin_unlock(&conf->device_lock);
> > >  		}
> > >  	} while (sh == NULL);
> > >  
> > >  	if (sh)
> > >  		atomic_inc(&sh->count);
> > >  
> > > -	spin_unlock_irq(&conf->device_lock);
> > > +	spin_unlock_irq(conf->hash_locks + hash);
> > >  	return sh;
> > >  }
> > >  
> > > @@ -1585,7 +1700,7 @@ static void raid_run_ops(struct stripe_h
> > >  	put_cpu();
> > >  }
> > >  
> > > -static int grow_one_stripe(struct r5conf *conf)
> > > +static int grow_one_stripe(struct r5conf *conf, int hash)
> > >  {
> > >  	struct stripe_head *sh;
> > >  	sh = kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
> > > @@ -1601,11 +1716,13 @@ static int grow_one_stripe(struct r5conf
> > >  		kmem_cache_free(conf->slab_cache, sh);
> > >  		return 0;
> > >  	}
> > > +	sh->hash_lock_index = hash;
> > >  	/* we just created an active stripe so... */
> > >  	atomic_set(&sh->count, 1);
> > >  	atomic_inc(&conf->active_stripes);
> > >  	INIT_LIST_HEAD(&sh->lru);
> > >  	release_stripe(sh);
> > > +	conf->max_hash_nr_stripes[hash]++;
> > >  	return 1;
> > >  }
> > >  
> > > @@ -1613,6 +1730,7 @@ static int grow_stripes(struct r5conf *c
> > >  {
> > >  	struct kmem_cache *sc;
> > >  	int devs = max(conf->raid_disks, conf->previous_raid_disks);
> > > +	int hash;
> > >  
> > >  	if (conf->mddev->gendisk)
> > >  		sprintf(conf->cache_name[0],
> > > @@ -1630,9 +1748,12 @@ static int grow_stripes(struct r5conf *c
> > >  		return 1;
> > >  	conf->slab_cache = sc;
> > >  	conf->pool_size = devs;
> > > -	while (num--)
> > > -		if (!grow_one_stripe(conf))
> > > +	hash = 0;
> > > +	while (num--) {
> > > +		if (!grow_one_stripe(conf, hash))
> > >  			return 1;
> > > +		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
> > > +	}
> > >  	return 0;
> > >  }
> > >  
> > > @@ -1690,6 +1811,7 @@ static int resize_stripes(struct r5conf
> > >  	int err;
> > >  	struct kmem_cache *sc;
> > >  	int i;
> > > +	int hash, cnt;
> > >  
> > >  	if (newsize <= conf->pool_size)
> > >  		return 0; /* never bother to shrink */
> > > @@ -1729,19 +1851,28 @@ static int resize_stripes(struct r5conf
> > >  	 * OK, we have enough stripes, start collecting inactive
> > >  	 * stripes and copying them over
> > >  	 */
> > > +	hash = 0;
> > > +	cnt = 0;
> > >  	list_for_each_entry(nsh, &newstripes, lru) {
> > > -		spin_lock_irq(&conf->device_lock);
> > > -		wait_event_lock_irq(conf->wait_for_stripe,
> > > -				    !list_empty(&conf->inactive_list),
> > > -				    conf->device_lock);
> > > -		osh = get_free_stripe(conf);
> > > -		spin_unlock_irq(&conf->device_lock);
> > > +		lock_device_hash_lock(conf, hash);
> > > +		wait_event_cmd(conf->wait_for_stripe,
> > > +				    !list_empty(conf->inactive_list + hash),
> > > +				    unlock_device_hash_lock(conf, hash),
> > > +				    lock_device_hash_lock(conf, hash));
> > > +		osh = get_free_stripe(conf, hash);
> > > +		unlock_device_hash_lock(conf, hash);
> > >  		atomic_set(&nsh->count, 1);
> > >  		for(i=0; i<conf->pool_size; i++)
> > >  			nsh->dev[i].page = osh->dev[i].page;
> > >  		for( ; i<newsize; i++)
> > >  			nsh->dev[i].page = NULL;
> > > +		nsh->hash_lock_index = hash;
> > >  		kmem_cache_free(conf->slab_cache, osh);
> > > +		cnt++;
> > > +		if (cnt >= conf->max_hash_nr_stripes[hash]) {
> > > +			hash++;
> > > +			cnt = 0;
> > > +		}
> > >  	}
> > >  	kmem_cache_destroy(conf->slab_cache);
> > >  
> > > @@ -1800,13 +1931,14 @@ static int resize_stripes(struct r5conf
> > >  	return err;
> > >  }
> > >  
> > > -static int drop_one_stripe(struct r5conf *conf)
> > > +static int drop_one_stripe(struct r5conf *conf, int hash)
> > >  {
> > >  	struct stripe_head *sh;
> > >  
> > > -	spin_lock_irq(&conf->device_lock);
> > > -	sh = get_free_stripe(conf);
> > > -	spin_unlock_irq(&conf->device_lock);
> > > +	spin_lock_irq(conf->hash_locks + hash);
> > > +	sh = get_free_stripe(conf, hash);
> > > +	conf->max_hash_nr_stripes[hash]--;
> > > +	spin_unlock_irq(conf->hash_locks + hash);
> > >  	if (!sh)
> > >  		return 0;
> > >  	BUG_ON(atomic_read(&sh->count));
> > > @@ -1818,8 +1950,10 @@ static int drop_one_stripe(struct r5conf
> > >  
> > >  static void shrink_stripes(struct r5conf *conf)
> > >  {
> > > -	while (drop_one_stripe(conf))
> > > -		;
> > > +	int hash;
> > > +	for (hash = 0; hash < NR_STRIPE_HASH_LOCKS; hash++)
> > > +		while (drop_one_stripe(conf, hash))
> > > +			;
> > >  
> > >  	if (conf->slab_cache)
> > >  		kmem_cache_destroy(conf->slab_cache);
> > > @@ -2048,10 +2182,10 @@ static void error(struct mddev *mddev, s
> > >  	unsigned long flags;
> > >  	pr_debug("raid456: error called\n");
> > >  
> > > -	spin_lock_irqsave(&conf->device_lock, flags);
> > > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> > >  	clear_bit(In_sync, &rdev->flags);
> > >  	mddev->degraded = calc_degraded(conf);
> > > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > >  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> > >  
> > >  	set_bit(Blocked, &rdev->flags);
> > > @@ -3895,7 +4029,8 @@ static void raid5_activate_delayed(struc
> > >  	}
> > >  }
> > >  
> > > -static void activate_bit_delay(struct r5conf *conf)
> > > +static void activate_bit_delay(struct r5conf *conf,
> > > +	struct list_head *temp_inactive_list)
> > >  {
> > >  	/* device_lock is held */
> > >  	struct list_head head;
> > > @@ -3903,9 +4038,11 @@ static void activate_bit_delay(struct r5
> > >  	list_del_init(&conf->bitmap_list);
> > >  	while (!list_empty(&head)) {
> > >  		struct stripe_head *sh = list_entry(head.next, struct stripe_head, lru);
> > > +		int hash;
> > >  		list_del_init(&sh->lru);
> > >  		atomic_inc(&sh->count);
> > > -		__release_stripe(conf, sh);
> > > +		hash = sh->hash_lock_index;
> > > +		__release_stripe(conf, sh, &temp_inactive_list[hash]);
> > >  	}
> > >  }
> > >  
> > > @@ -3921,7 +4058,7 @@ int md_raid5_congested(struct mddev *mdd
> > >  		return 1;
> > >  	if (conf->quiesce)
> > >  		return 1;
> > > -	if (list_empty_careful(&conf->inactive_list))
> > > +	if (atomic_read(&conf->active_stripes) == conf->max_nr_stripes)
> > >  		return 1;
> > >  
> > >  	return 0;
> > > @@ -4251,6 +4388,7 @@ static struct stripe_head *__get_priorit
> > >  struct raid5_plug_cb {
> > >  	struct blk_plug_cb	cb;
> > >  	struct list_head	list;
> > > +	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
> > >  };
> > >  
> > >  static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
> > > @@ -4261,6 +4399,7 @@ static void raid5_unplug(struct blk_plug
> > >  	struct mddev *mddev = cb->cb.data;
> > >  	struct r5conf *conf = mddev->private;
> > >  	int cnt = 0;
> > > +	int hash;
> > >  
> > >  	if (cb->list.next && !list_empty(&cb->list)) {
> > >  		spin_lock_irq(&conf->device_lock);
> > > @@ -4278,11 +4417,14 @@ static void raid5_unplug(struct blk_plug
> > >  			 * STRIPE_ON_RELEASE_LIST could be set here. In that
> > >  			 * case, the count is always > 1 here
> > >  			 */
> > > -			__release_stripe(conf, sh);
> > > +			hash = sh->hash_lock_index;
> > > +			__release_stripe(conf, sh, &cb->temp_inactive_list[hash]);
> > >  			cnt++;
> > >  		}
> > >  		spin_unlock_irq(&conf->device_lock);
> > >  	}
> > > +	release_inactive_stripe_list(conf, cb->temp_inactive_list,
> > > +		NR_STRIPE_HASH_LOCKS);
> > >  	if (mddev->queue)
> > >  		trace_block_unplug(mddev->queue, cnt, !from_schedule);
> > >  	kfree(cb);
> > > @@ -4303,8 +4445,12 @@ static void release_stripe_plug(struct m
> > >  
> > >  	cb = container_of(blk_cb, struct raid5_plug_cb, cb);
> > >  
> > > -	if (cb->list.next == NULL)
> > > +	if (cb->list.next == NULL) {
> > > +		int i;
> > >  		INIT_LIST_HEAD(&cb->list);
> > > +		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +			INIT_LIST_HEAD(cb->temp_inactive_list + i);
> > > +	}
> > >  
> > >  	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
> > >  		list_add_tail(&sh->lru, &cb->list);
> > > @@ -4949,27 +5095,45 @@ static int  retry_aligned_read(struct r5
> > >  }
> > >  
> > >  static int handle_active_stripes(struct r5conf *conf, int group,
> > > -				 struct r5worker *worker)
> > > +				 struct r5worker *worker,
> > > +				 struct list_head *temp_inactive_list)
> > >  {
> > >  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> > > -	int i, batch_size = 0;
> > > +	int i, batch_size = 0, hash;
> > > +	bool release_inactive = false;
> > >  
> > >  	while (batch_size < MAX_STRIPE_BATCH &&
> > >  			(sh = __get_priority_stripe(conf, group)) != NULL)
> > >  		batch[batch_size++] = sh;
> > >  
> > > -	if (batch_size == 0)
> > > -		return batch_size;
> > > +	if (batch_size == 0) {
> > > +		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +			if (!list_empty(temp_inactive_list + i))
> > > +				break;
> > > +		if (i == NR_STRIPE_HASH_LOCKS)
> > > +			return batch_size;
> > > +		release_inactive = true;
> > > +	}
> > >  	spin_unlock_irq(&conf->device_lock);
> > >  
> > > +	release_inactive_stripe_list(conf, temp_inactive_list,
> > > +		NR_STRIPE_HASH_LOCKS);
> > > +
> > > +	if (release_inactive) {
> > > +		spin_lock_irq(&conf->device_lock);
> > > +		return 0;
> > > +	}
> > > +
> > >  	for (i = 0; i < batch_size; i++)
> > >  		handle_stripe(batch[i]);
> > >  
> > >  	cond_resched();
> > >  
> > >  	spin_lock_irq(&conf->device_lock);
> > > -	for (i = 0; i < batch_size; i++)
> > > -		__release_stripe(conf, batch[i]);
> > > +	for (i = 0; i < batch_size; i++) {
> > > +		hash = batch[i]->hash_lock_index;
> > > +		__release_stripe(conf, batch[i], &temp_inactive_list[hash]);
> > > +	}
> > >  	return batch_size;
> > >  }
> > >  
> > > @@ -4990,9 +5154,10 @@ static void raid5_do_work(struct work_st
> > >  	while (1) {
> > >  		int batch_size, released;
> > >  
> > > -		released = release_stripe_list(conf);
> > > +		released = release_stripe_list(conf, worker->temp_inactive_list);
> > >  
> > > -		batch_size = handle_active_stripes(conf, group_id, worker);
> > > +		batch_size = handle_active_stripes(conf, group_id, worker,
> > > +				worker->temp_inactive_list);
> > >  		worker->working = false;
> > >  		if (!batch_size && !released)
> > >  			break;
> > > @@ -5031,7 +5196,7 @@ static void raid5d(struct md_thread *thr
> > >  		struct bio *bio;
> > >  		int batch_size, released;
> > >  
> > > -		released = release_stripe_list(conf);
> > > +		released = release_stripe_list(conf, conf->temp_inactive_list);
> > >  
> > >  		if (
> > >  		    !list_empty(&conf->bitmap_list)) {
> > > @@ -5041,7 +5206,7 @@ static void raid5d(struct md_thread *thr
> > >  			bitmap_unplug(mddev->bitmap);
> > >  			spin_lock_irq(&conf->device_lock);
> > >  			conf->seq_write = conf->seq_flush;
> > > -			activate_bit_delay(conf);
> > > +			activate_bit_delay(conf, conf->temp_inactive_list);
> > >  		}
> > >  		raid5_activate_delayed(conf);
> > >  
> > > @@ -5055,7 +5220,8 @@ static void raid5d(struct md_thread *thr
> > >  			handled++;
> > >  		}
> > >  
> > > -		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
> > > +		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL,
> > > +				conf->temp_inactive_list);
> > >  		if (!batch_size && !released)
> > >  			break;
> > >  		handled += batch_size;
> > > @@ -5091,22 +5257,28 @@ raid5_set_cache_size(struct mddev *mddev
> > >  {
> > >  	struct r5conf *conf = mddev->private;
> > >  	int err;
> > > +	int hash;
> > >  
> > >  	if (size <= 16 || size > 32768)
> > >  		return -EINVAL;
> > > +	size = round_up(size, NR_STRIPE_HASH_LOCKS);
> > > +	hash = 0;
> > >  	while (size < conf->max_nr_stripes) {
> > > -		if (drop_one_stripe(conf))
> > > +		if (drop_one_stripe(conf, hash))
> > >  			conf->max_nr_stripes--;
> > >  		else
> > >  			break;
> > > +		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
> > >  	}
> > >  	err = md_allow_write(mddev);
> > >  	if (err)
> > >  		return err;
> > > +	hash = 0;
> > >  	while (size > conf->max_nr_stripes) {
> > > -		if (grow_one_stripe(conf))
> > > +		if (grow_one_stripe(conf, hash))
> > >  			conf->max_nr_stripes++;
> > >  		else break;
> > > +		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
> > >  	}
> > >  	return 0;
> > >  }
> > > @@ -5257,7 +5429,7 @@ static struct attribute_group raid5_attr
> > >  
> > >  static int alloc_thread_groups(struct r5conf *conf, int cnt)
> > >  {
> > > -	int i, j;
> > > +	int i, j, k;
> > >  	ssize_t size;
> > >  	struct r5worker *workers;
> > >  
> > > @@ -5287,8 +5459,12 @@ static int alloc_thread_groups(struct r5
> > >  		group->workers = workers + i * cnt;
> > >  
> > >  		for (j = 0; j < cnt; j++) {
> > > -			group->workers[j].group = group;
> > > -			INIT_WORK(&group->workers[j].work, raid5_do_work);
> > > +			struct r5worker *worker = group->workers + j;
> > > +			worker->group = group;
> > > +			INIT_WORK(&worker->work, raid5_do_work);
> > > +
> > > +			for (k = 0; k < NR_STRIPE_HASH_LOCKS; k++)
> > > +				INIT_LIST_HEAD(worker->temp_inactive_list + k);
> > >  		}
> > >  	}
> > >  
> > > @@ -5439,6 +5615,7 @@ static struct r5conf *setup_conf(struct
> > >  	struct md_rdev *rdev;
> > >  	struct disk_info *disk;
> > >  	char pers_name[6];
> > > +	int i;
> > >  
> > >  	if (mddev->new_level != 5
> > >  	    && mddev->new_level != 4
> > > @@ -5483,7 +5660,6 @@ static struct r5conf *setup_conf(struct
> > >  	INIT_LIST_HEAD(&conf->hold_list);
> > >  	INIT_LIST_HEAD(&conf->delayed_list);
> > >  	INIT_LIST_HEAD(&conf->bitmap_list);
> > > -	INIT_LIST_HEAD(&conf->inactive_list);
> > >  	init_llist_head(&conf->released_stripes);
> > >  	atomic_set(&conf->active_stripes, 0);
> > >  	atomic_set(&conf->preread_active_stripes, 0);
> > > @@ -5509,6 +5685,15 @@ static struct r5conf *setup_conf(struct
> > >  	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
> > >  		goto abort;
> > >  
> > > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +		spin_lock_init(conf->hash_locks + i);
> > > +
> > > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +		INIT_LIST_HEAD(conf->inactive_list + i);
> > > +
> > > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
> > > +		INIT_LIST_HEAD(conf->temp_inactive_list + i);
> > > +
> > >  	conf->level = mddev->new_level;
> > >  	if (raid5_alloc_percpu(conf) != 0)
> > >  		goto abort;
> > > @@ -6034,9 +6219,9 @@ static int raid5_spare_active(struct mdd
> > >  			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
> > >  		}
> > >  	}
> > > -	spin_lock_irqsave(&conf->device_lock, flags);
> > > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> > >  	mddev->degraded = calc_degraded(conf);
> > > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > >  	print_raid5_conf(conf);
> > >  	return count;
> > >  }
> > > @@ -6347,9 +6532,9 @@ static int raid5_start_reshape(struct md
> > >  		 * ->degraded is measured against the larger of the
> > >  		 * pre and post number of devices.
> > >  		 */
> > > -		spin_lock_irqsave(&conf->device_lock, flags);
> > > +		lock_all_device_hash_locks_irqsave(conf, &flags);
> > >  		mddev->degraded = calc_degraded(conf);
> > > -		spin_unlock_irqrestore(&conf->device_lock, flags);
> > > +		unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > >  	}
> > >  	mddev->raid_disks = conf->raid_disks;
> > >  	mddev->reshape_position = conf->reshape_progress;
> > > @@ -6363,14 +6548,14 @@ static int raid5_start_reshape(struct md
> > >  						"reshape");
> > >  	if (!mddev->sync_thread) {
> > >  		mddev->recovery = 0;
> > > -		spin_lock_irq(&conf->device_lock);
> > > +		lock_all_device_hash_locks_irq(conf);
> > >  		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
> > >  		rdev_for_each(rdev, mddev)
> > >  			rdev->new_data_offset = rdev->data_offset;
> > >  		smp_wmb();
> > >  		conf->reshape_progress = MaxSector;
> > >  		mddev->reshape_position = MaxSector;
> > > -		spin_unlock_irq(&conf->device_lock);
> > > +		unlock_all_device_hash_locks_irq(conf);
> > >  		return -EAGAIN;
> > >  	}
> > >  	conf->reshape_checkpoint = jiffies;
> > > @@ -6388,13 +6573,13 @@ static void end_reshape(struct r5conf *c
> > >  	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
> > >  		struct md_rdev *rdev;
> > >  
> > > -		spin_lock_irq(&conf->device_lock);
> > > +		lock_all_device_hash_locks_irq(conf);
> > >  		conf->previous_raid_disks = conf->raid_disks;
> > >  		rdev_for_each(rdev, conf->mddev)
> > >  			rdev->data_offset = rdev->new_data_offset;
> > >  		smp_wmb();
> > >  		conf->reshape_progress = MaxSector;
> > > -		spin_unlock_irq(&conf->device_lock);
> > > +		unlock_all_device_hash_locks_irq(conf);
> > >  		wake_up(&conf->wait_for_overlap);
> > >  
> > >  		/* read-ahead size must cover two whole stripes, which is
> > > @@ -6425,9 +6610,9 @@ static void raid5_finish_reshape(struct
> > >  			revalidate_disk(mddev->gendisk);
> > >  		} else {
> > >  			int d;
> > > -			spin_lock_irq(&conf->device_lock);
> > > +			lock_all_device_hash_locks_irq(conf);
> > >  			mddev->degraded = calc_degraded(conf);
> > > -			spin_unlock_irq(&conf->device_lock);
> > > +			unlock_all_device_hash_locks_irq(conf);
> > >  			for (d = conf->raid_disks ;
> > >  			     d < conf->raid_disks - mddev->delta_disks;
> > >  			     d++) {
> > > @@ -6457,27 +6642,28 @@ static void raid5_quiesce(struct mddev *
> > >  		break;
> > >  
> > >  	case 1: /* stop all writes */
> > > -		spin_lock_irq(&conf->device_lock);
> > > +		lock_all_device_hash_locks_irq(conf);
> > >  		/* '2' tells resync/reshape to pause so that all
> > >  		 * active stripes can drain
> > >  		 */
> > >  		conf->quiesce = 2;
> > > -		wait_event_lock_irq(conf->wait_for_stripe,
> > > +		wait_event_cmd(conf->wait_for_stripe,
> > >  				    atomic_read(&conf->active_stripes) == 0 &&
> > >  				    atomic_read(&conf->active_aligned_reads) == 0,
> > > -				    conf->device_lock);
> > > +				    unlock_all_device_hash_locks_irq(conf),
> > > +				    lock_all_device_hash_locks_irq(conf));
> > >  		conf->quiesce = 1;
> > > -		spin_unlock_irq(&conf->device_lock);
> > > +		unlock_all_device_hash_locks_irq(conf);
> > >  		/* allow reshape to continue */
> > >  		wake_up(&conf->wait_for_overlap);
> > >  		break;
> > >  
> > >  	case 0: /* re-enable writes */
> > > -		spin_lock_irq(&conf->device_lock);
> > > +		lock_all_device_hash_locks_irq(conf);
> > >  		conf->quiesce = 0;
> > >  		wake_up(&conf->wait_for_stripe);
> > >  		wake_up(&conf->wait_for_overlap);
> > > -		spin_unlock_irq(&conf->device_lock);
> > > +		unlock_all_device_hash_locks_irq(conf);
> > >  		break;
> > >  	}
> > >  }
> > > Index: linux/drivers/md/raid5.h
> > > ===================================================================
> > > --- linux.orig/drivers/md/raid5.h	2013-09-05 08:23:42.187851834 +0800
> > > +++ linux/drivers/md/raid5.h	2013-09-05 08:30:49.090484930 +0800
> > > @@ -205,6 +205,7 @@ struct stripe_head {
> > >  	short			pd_idx;		/* parity disk index */
> > >  	short			qd_idx;		/* 'Q' disk index for raid6 */
> > >  	short			ddf_layout;/* use DDF ordering to calculate Q */
> > > +	short			hash_lock_index;
> > >  	unsigned long		state;		/* state flags */
> > >  	atomic_t		count;	      /* nr of active thread/requests */
> > >  	int			bm_seq;	/* sequence number for bitmap flushes */
> > > @@ -367,9 +368,13 @@ struct disk_info {
> > >  	struct md_rdev	*rdev, *replacement;
> > >  };
> > >  
> > > +#define NR_STRIPE_HASH_LOCKS 8
> > > +#define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
> > > +
> > >  struct r5worker {
> > >  	struct work_struct work;
> > >  	struct r5worker_group *group;
> > > +	struct list_head temp_inactive_list[NR_STRIPE_HASH_LOCKS];
> > >  	bool working;
> > >  };
> > >  
> > > @@ -382,6 +387,8 @@ struct r5worker_group {
> > >  
> > >  struct r5conf {
> > >  	struct hlist_head	*stripe_hashtbl;
> > > +	/* only protect corresponding hash list and inactive_list */
> > > +	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
> > >  	struct mddev		*mddev;
> > >  	int			chunk_sectors;
> > >  	int			level, algorithm;
> > > @@ -462,7 +469,8 @@ struct r5conf {
> > >  	 * Free stripes pool
> > >  	 */
> > >  	atomic_t		active_stripes;
> > > -	struct list_head	inactive_list;
> > > +	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
> > > +	int			max_hash_nr_stripes[NR_STRIPE_HASH_LOCKS];
> > >  	struct llist_head	released_stripes;
> > >  	wait_queue_head_t	wait_for_stripe;
> > >  	wait_queue_head_t	wait_for_overlap;
> > > @@ -477,6 +485,7 @@ struct r5conf {
> > >  	 * the new thread here until we fully activate the array.
> > >  	 */
> > >  	struct md_thread	*thread;
> > > +	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
> > >  	struct r5worker_group	*worker_groups;
> > >  	int			group_cnt;
> > >  	int			worker_cnt_per_group;
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > Hi,
> >  thanks for this.  It is looking quite good.
> > 
> >  I don't really like max_hash_nr_stripes though.
> >  I note that you round up the cache_size to a multiple of
> >  NR_STRIPE_HASH_LOCKS.
> >  I think that is a good idea and should allow us to ensure that every hash
> >  value always has the same number of stripe_heads.
> >  If we get a failure when allocating, we would need to free some to bring it
> >  back to a uniform number.
> 
> ok, I can do this.
>  
> >  I'm in two minds about the temp_inactive_list.
> >  An alternative would be to have a single list and use list_sort() to sort it
> >  by hash_lock_index before moving the stripe_heads to the relevant lists,
> >  taking one lock at a time.
> >  This save some memory and costs some cpu time.  On the whole I think it
> >  gains in elegance but I'm not sure.  What do you think?
> 
> I thought it doesn't work. For example, we lock hash 0 lock.
> get_active_stripe() finds a stripe of hash 1, and delete it from lru, while the
> stripe is in temp_inactive_list. We are locking different hash locks, so the
> list could corrupt. Alternative is we hold device_lock again and move one
> hash's temp_active_list to another list, then unlock device_lock. then do
> releae for the new temporary list. But in this way, we need take device_lock
> several times, which isn't good too.

Here is the latest patch which fixes the max_hash_nr_stripes issue.


Subject: raid5: relieve lock contention in get_active_stripe()

get_active_stripe() is the last place we have lock contention. It has two
paths. One is stripe isn't found and new stripe is allocated, the other is
stripe is found.

The first path basically calls __find_stripe and init_stripe. It accesses
conf->generation, conf->previous_raid_disks, conf->raid_disks,
conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. Except
stripe_hashtbl and inactive_list, other fields are changed very rarely.

With this patch, we split inactive_list and add new hash locks. Each free
stripe belongs to a specific inactive list. Which inactive list is determined
by stripe's lock_hash. Note, even a stripe hasn't a sector assigned, it has a
lock_hash assigned. Stripe's inactive list is protected by a hash lock, which
is determined by it's lock_hash too. The lock_hash is derivied from current
stripe_hashtbl hash, which guarantees any stripe_hashtbl list will be assigned
to a specific lock_hash, so we can use new hash lock to protect stripe_hashtbl
list too. The goal of the new hash locks introduced is we can only use the new
locks in the first path of get_active_stripe(). Since we have several hash
locks, lock contention is relieved significantly.

The first path of get_active_stripe() accesses other fields, since they are
changed rarely, changing them now need take conf->device_lock and all hash
locks. For a slow path, this isn't a problem.

If we need lock device_lock and hash lock, we always lock hash lock first. The
tricky part is release_stripe and friends. We need take device_lock first.
Neil's suggestion is we put inactive stripes to a temporary list and readd it
to inactive_list after device_lock is released. In this way, we add stripes to
temporary list with device_lock hold and remove stripes from the list with hash
lock hold. So we don't allow concurrent access to the temporary list, which
means we need allocate temporary list for all participants of release_stripe.

One downside is free stripes are maintained in their inactive list, they can't
across between the lists. By default, we have total 256 stripes and 8 lists, so
each list will have 32 stripes. It's possible one list has free stripe but
other list hasn't. The chance should be rare because stripes allocation are
even distributed. And we can always allocate more stripes for cache, several
mega bytes memory isn't a big deal.

This completely removes the lock contention of the first path of
get_active_stripe(). It slows down the second code path a little bit though
because we now need takes two locks, but since the hash lock isn't contended,
the overhead should be quite small (several atomic instructions). The second
path of get_active_stripe() (basically sequential write or big request size
randwrite) still has lock contentions.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |  370 ++++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.h |   10 +
 2 files changed, 294 insertions(+), 86 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-09-05 22:10:18.426462400 +0800
+++ linux/drivers/md/raid5.c	2013-09-05 22:34:05.828512112 +0800
@@ -86,6 +86,67 @@ static inline struct hlist_head *stripe_
 	return &conf->stripe_hashtbl[hash];
 }
 
+static inline int stripe_hash_locks_hash(sector_t sect)
+{
+	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
+}
+
+static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
+{
+	spin_lock_irq(conf->hash_locks + hash);
+	spin_lock(&conf->device_lock);
+}
+
+static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
+{
+	spin_unlock(&conf->device_lock);
+	spin_unlock_irq(conf->hash_locks + hash);
+}
+
+static void __lock_all_hash_locks(struct r5conf *conf)
+{
+	int i;
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		spin_lock(conf->hash_locks + i);
+}
+
+static void __unlock_all_hash_locks(struct r5conf *conf)
+{
+	int i;
+	for (i = NR_STRIPE_HASH_LOCKS; i; i--)
+		spin_unlock(conf->hash_locks + i - 1);
+}
+
+static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
+{
+	local_irq_disable();
+	__lock_all_hash_locks(conf);
+	spin_lock(&conf->device_lock);
+}
+
+static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
+{
+	spin_unlock(&conf->device_lock);
+	__unlock_all_hash_locks(conf);
+	local_irq_enable();
+}
+
+static inline void lock_all_device_hash_locks_irqsave(struct r5conf *conf,
+	unsigned long *flags)
+{
+	local_irq_save(*flags);
+	__lock_all_hash_locks(conf);
+	spin_lock(&conf->device_lock);
+}
+
+static inline void unlock_all_device_hash_locks_irqrestore(struct r5conf *conf,
+	unsigned long *flags)
+{
+	spin_unlock(&conf->device_lock);
+	__unlock_all_hash_locks(conf);
+	local_irq_restore(*flags);
+}
+
 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
  * order without overlap.  There may be several bio's per stripe+device, and
  * a bio could span several devices.
@@ -250,7 +311,8 @@ static void raid5_wakeup_stripe_thread(s
 	}
 }
 
-static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
+static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
+	struct list_head *temp_inactive_list)
 {
 	BUG_ON(!list_empty(&sh->lru));
 	BUG_ON(atomic_read(&conf->active_stripes)==0);
@@ -279,19 +341,59 @@ static void do_release_stripe(struct r5c
 			    < IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
-		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
-			list_add_tail(&sh->lru, &conf->inactive_list);
-			wake_up(&conf->wait_for_stripe);
-			if (conf->retry_read_aligned)
-				md_wakeup_thread(conf->mddev->thread);
-		}
+		if (!test_bit(STRIPE_EXPANDING, &sh->state))
+			list_add_tail(&sh->lru, temp_inactive_list);
 	}
 }
 
-static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
+static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
+	struct list_head *temp_inactive_list)
 {
 	if (atomic_dec_and_test(&sh->count))
-		do_release_stripe(conf, sh);
+		do_release_stripe(conf, sh, temp_inactive_list);
+}
+
+/*
+ * @hash could be NR_STRIPE_HASH_LOCKS, then we have a list of inactive_list
+ *
+ * Be careful: Only one task can add/delete stripes from temp_inactive_list at
+ * given time. Adding stripes only takes device lock, while deleting stripes
+ * only takes hash lock.
+ */
+static void release_inactive_stripe_list(struct r5conf *conf,
+	struct list_head *temp_inactive_list, int hash)
+{
+	int size;
+	bool do_wakeup = false;
+	unsigned long flags;
+
+	if (hash == NR_STRIPE_HASH_LOCKS) {
+		size = NR_STRIPE_HASH_LOCKS;
+		hash = NR_STRIPE_HASH_LOCKS - 1;
+	} else
+		size = 1;
+	while (size) {
+		struct list_head *list = &temp_inactive_list[size - 1];
+
+		/*
+		 * We don't hold any lock here yet, get_active_stripe() might
+		 * remove stripes from the list
+		 */
+		if (!list_empty_careful(list)) {
+			spin_lock_irqsave(conf->hash_locks + hash, flags);
+			list_splice_tail_init(list, conf->inactive_list + hash);
+			do_wakeup = true;
+			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
+		}
+		size--;
+		hash--;
+	}
+
+	if (do_wakeup) {
+		wake_up(&conf->wait_for_stripe);
+		if (conf->retry_read_aligned)
+			md_wakeup_thread(conf->mddev->thread);
+	}
 }
 
 static struct llist_node *llist_reverse_order(struct llist_node *head)
@@ -309,7 +411,8 @@ static struct llist_node *llist_reverse_
 }
 
 /* should hold conf->device_lock already */
-static int release_stripe_list(struct r5conf *conf)
+static int release_stripe_list(struct r5conf *conf,
+	struct list_head *temp_inactive_list)
 {
 	struct stripe_head *sh;
 	int count = 0;
@@ -318,6 +421,8 @@ static int release_stripe_list(struct r5
 	head = llist_del_all(&conf->released_stripes);
 	head = llist_reverse_order(head);
 	while (head) {
+		int hash;
+
 		sh = llist_entry(head, struct stripe_head, release_list);
 		head = llist_next(head);
 		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
@@ -328,7 +433,8 @@ static int release_stripe_list(struct r5
 		 * again, the count is always > 1. This is true for
 		 * STRIPE_ON_UNPLUG_LIST bit too.
 		 */
-		__release_stripe(conf, sh);
+		hash = sh->hash_lock_index;
+		__release_stripe(conf, sh, &temp_inactive_list[hash]);
 		count++;
 	}
 
@@ -339,6 +445,8 @@ static void release_stripe(struct stripe
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
+	struct list_head list;
+	int hash;
 	bool wakeup;
 
 	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
@@ -351,8 +459,11 @@ slow_path:
 	local_irq_save(flags);
 	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
 	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
-		do_release_stripe(conf, sh);
+		INIT_LIST_HEAD(&list);
+		hash = sh->hash_lock_index;
+		do_release_stripe(conf, sh, &list);
 		spin_unlock(&conf->device_lock);
+		release_inactive_stripe_list(conf, &list, hash);
 	}
 	local_irq_restore(flags);
 }
@@ -377,18 +488,19 @@ static inline void insert_hash(struct r5
 
 
 /* find an idle stripe, make sure it is unhashed, and return it. */
-static struct stripe_head *get_free_stripe(struct r5conf *conf)
+static struct stripe_head *get_free_stripe(struct r5conf *conf, int hash)
 {
 	struct stripe_head *sh = NULL;
 	struct list_head *first;
 
-	if (list_empty(&conf->inactive_list))
+	if (list_empty(conf->inactive_list + hash))
 		goto out;
-	first = conf->inactive_list.next;
+	first = (conf->inactive_list + hash)->next;
 	sh = list_entry(first, struct stripe_head, lru);
 	list_del_init(first);
 	remove_hash(sh);
 	atomic_inc(&conf->active_stripes);
+	BUG_ON(hash != sh->hash_lock_index);
 out:
 	return sh;
 }
@@ -567,33 +679,35 @@ get_active_stripe(struct r5conf *conf, s
 		  int previous, int noblock, int noquiesce)
 {
 	struct stripe_head *sh;
+	int hash = stripe_hash_locks_hash(sector);
 
 	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(conf->hash_locks + hash);
 
 	do {
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0 || noquiesce,
-				    conf->device_lock);
+				    *(conf->hash_locks + hash));
 		sh = __find_stripe(conf, sector, conf->generation - previous);
 		if (!sh) {
-			if (!conf->inactive_blocked)
-				sh = get_free_stripe(conf);
+			sh = get_free_stripe(conf, hash);
 			if (noblock && sh == NULL)
 				break;
 			if (!sh) {
 				conf->inactive_blocked = 1;
 				wait_event_lock_irq(conf->wait_for_stripe,
-						    !list_empty(&conf->inactive_list) &&
-						    (atomic_read(&conf->active_stripes)
-						     < (conf->max_nr_stripes *3/4)
-						     || !conf->inactive_blocked),
-						    conf->device_lock);
+					!list_empty(conf->inactive_list + hash) &&
+					(atomic_read(&conf->active_stripes)
+					  < (conf->max_nr_stripes * 3 / 4)
+					|| !conf->inactive_blocked),
+					*(conf->hash_locks + hash));
 				conf->inactive_blocked = 0;
 			} else
 				init_stripe(sh, sector, previous);
 		} else {
+			spin_lock(&conf->device_lock);
+
 			if (atomic_read(&sh->count)) {
 				BUG_ON(!list_empty(&sh->lru)
 				    && !test_bit(STRIPE_EXPANDING, &sh->state)
@@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
 					sh->group = NULL;
 				}
 			}
+			spin_unlock(&conf->device_lock);
 		}
 	} while (sh == NULL);
 
 	if (sh)
 		atomic_inc(&sh->count);
 
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(conf->hash_locks + hash);
 	return sh;
 }
 
@@ -1585,7 +1700,7 @@ static void raid_run_ops(struct stripe_h
 	put_cpu();
 }
 
-static int grow_one_stripe(struct r5conf *conf)
+static int grow_one_stripe(struct r5conf *conf, int hash)
 {
 	struct stripe_head *sh;
 	sh = kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
@@ -1601,6 +1716,7 @@ static int grow_one_stripe(struct r5conf
 		kmem_cache_free(conf->slab_cache, sh);
 		return 0;
 	}
+	sh->hash_lock_index = hash;
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
@@ -1609,10 +1725,12 @@ static int grow_one_stripe(struct r5conf
 	return 1;
 }
 
+static int drop_one_stripe(struct r5conf *conf, int hash);
 static int grow_stripes(struct r5conf *conf, int num)
 {
 	struct kmem_cache *sc;
 	int devs = max(conf->raid_disks, conf->previous_raid_disks);
+	int hash;
 
 	if (conf->mddev->gendisk)
 		sprintf(conf->cache_name[0],
@@ -1630,10 +1748,21 @@ static int grow_stripes(struct r5conf *c
 		return 1;
 	conf->slab_cache = sc;
 	conf->pool_size = devs;
-	while (num--)
-		if (!grow_one_stripe(conf))
-			return 1;
+	hash = 0;
+	while (num--) {
+		if (!grow_one_stripe(conf, hash))
+			goto error;
+		conf->max_nr_stripes++;
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
+	}
 	return 0;
+error:
+	while (hash > 0) {
+		drop_one_stripe(conf, hash - 1);
+		conf->max_nr_stripes--;
+		hash--;
+	}
+	return 1;
 }
 
 /**
@@ -1690,6 +1819,7 @@ static int resize_stripes(struct r5conf
 	int err;
 	struct kmem_cache *sc;
 	int i;
+	int hash, cnt;
 
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
@@ -1729,19 +1859,28 @@ static int resize_stripes(struct r5conf
 	 * OK, we have enough stripes, start collecting inactive
 	 * stripes and copying them over
 	 */
+	hash = 0;
+	cnt = 0;
 	list_for_each_entry(nsh, &newstripes, lru) {
-		spin_lock_irq(&conf->device_lock);
-		wait_event_lock_irq(conf->wait_for_stripe,
-				    !list_empty(&conf->inactive_list),
-				    conf->device_lock);
-		osh = get_free_stripe(conf);
-		spin_unlock_irq(&conf->device_lock);
+		lock_device_hash_lock(conf, hash);
+		wait_event_cmd(conf->wait_for_stripe,
+				    !list_empty(conf->inactive_list + hash),
+				    unlock_device_hash_lock(conf, hash),
+				    lock_device_hash_lock(conf, hash));
+		osh = get_free_stripe(conf, hash);
+		unlock_device_hash_lock(conf, hash);
 		atomic_set(&nsh->count, 1);
 		for(i=0; i<conf->pool_size; i++)
 			nsh->dev[i].page = osh->dev[i].page;
 		for( ; i<newsize; i++)
 			nsh->dev[i].page = NULL;
+		nsh->hash_lock_index = hash;
 		kmem_cache_free(conf->slab_cache, osh);
+		cnt++;
+		if (cnt >= conf->max_nr_stripes / NR_STRIPE_HASH_LOCKS) {
+			hash++;
+			cnt = 0;
+		}
 	}
 	kmem_cache_destroy(conf->slab_cache);
 
@@ -1800,13 +1939,13 @@ static int resize_stripes(struct r5conf
 	return err;
 }
 
-static int drop_one_stripe(struct r5conf *conf)
+static int drop_one_stripe(struct r5conf *conf, int hash)
 {
 	struct stripe_head *sh;
 
-	spin_lock_irq(&conf->device_lock);
-	sh = get_free_stripe(conf);
-	spin_unlock_irq(&conf->device_lock);
+	spin_lock_irq(conf->hash_locks + hash);
+	sh = get_free_stripe(conf, hash);
+	spin_unlock_irq(conf->hash_locks + hash);
 	if (!sh)
 		return 0;
 	BUG_ON(atomic_read(&sh->count));
@@ -1818,8 +1957,10 @@ static int drop_one_stripe(struct r5conf
 
 static void shrink_stripes(struct r5conf *conf)
 {
-	while (drop_one_stripe(conf))
-		;
+	int hash;
+	for (hash = 0; hash < NR_STRIPE_HASH_LOCKS; hash++)
+		while (drop_one_stripe(conf, hash))
+			;
 
 	if (conf->slab_cache)
 		kmem_cache_destroy(conf->slab_cache);
@@ -2048,10 +2189,10 @@ static void error(struct mddev *mddev, s
 	unsigned long flags;
 	pr_debug("raid456: error called\n");
 
-	spin_lock_irqsave(&conf->device_lock, flags);
+	lock_all_device_hash_locks_irqsave(conf, &flags);
 	clear_bit(In_sync, &rdev->flags);
 	mddev->degraded = calc_degraded(conf);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	unlock_all_device_hash_locks_irqrestore(conf, &flags);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 
 	set_bit(Blocked, &rdev->flags);
@@ -3895,7 +4036,8 @@ static void raid5_activate_delayed(struc
 	}
 }
 
-static void activate_bit_delay(struct r5conf *conf)
+static void activate_bit_delay(struct r5conf *conf,
+	struct list_head *temp_inactive_list)
 {
 	/* device_lock is held */
 	struct list_head head;
@@ -3903,9 +4045,11 @@ static void activate_bit_delay(struct r5
 	list_del_init(&conf->bitmap_list);
 	while (!list_empty(&head)) {
 		struct stripe_head *sh = list_entry(head.next, struct stripe_head, lru);
+		int hash;
 		list_del_init(&sh->lru);
 		atomic_inc(&sh->count);
-		__release_stripe(conf, sh);
+		hash = sh->hash_lock_index;
+		__release_stripe(conf, sh, &temp_inactive_list[hash]);
 	}
 }
 
@@ -3921,7 +4065,7 @@ int md_raid5_congested(struct mddev *mdd
 		return 1;
 	if (conf->quiesce)
 		return 1;
-	if (list_empty_careful(&conf->inactive_list))
+	if (atomic_read(&conf->active_stripes) == conf->max_nr_stripes)
 		return 1;
 
 	return 0;
@@ -4251,6 +4395,7 @@ static struct stripe_head *__get_priorit
 struct raid5_plug_cb {
 	struct blk_plug_cb	cb;
 	struct list_head	list;
+	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
 };
 
 static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
@@ -4261,6 +4406,7 @@ static void raid5_unplug(struct blk_plug
 	struct mddev *mddev = cb->cb.data;
 	struct r5conf *conf = mddev->private;
 	int cnt = 0;
+	int hash;
 
 	if (cb->list.next && !list_empty(&cb->list)) {
 		spin_lock_irq(&conf->device_lock);
@@ -4278,11 +4424,14 @@ static void raid5_unplug(struct blk_plug
 			 * STRIPE_ON_RELEASE_LIST could be set here. In that
 			 * case, the count is always > 1 here
 			 */
-			__release_stripe(conf, sh);
+			hash = sh->hash_lock_index;
+			__release_stripe(conf, sh, &cb->temp_inactive_list[hash]);
 			cnt++;
 		}
 		spin_unlock_irq(&conf->device_lock);
 	}
+	release_inactive_stripe_list(conf, cb->temp_inactive_list,
+		NR_STRIPE_HASH_LOCKS);
 	if (mddev->queue)
 		trace_block_unplug(mddev->queue, cnt, !from_schedule);
 	kfree(cb);
@@ -4303,8 +4452,12 @@ static void release_stripe_plug(struct m
 
 	cb = container_of(blk_cb, struct raid5_plug_cb, cb);
 
-	if (cb->list.next == NULL)
+	if (cb->list.next == NULL) {
+		int i;
 		INIT_LIST_HEAD(&cb->list);
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+			INIT_LIST_HEAD(cb->temp_inactive_list + i);
+	}
 
 	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
 		list_add_tail(&sh->lru, &cb->list);
@@ -4949,27 +5102,45 @@ static int  retry_aligned_read(struct r5
 }
 
 static int handle_active_stripes(struct r5conf *conf, int group,
-				 struct r5worker *worker)
+				 struct r5worker *worker,
+				 struct list_head *temp_inactive_list)
 {
 	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
-	int i, batch_size = 0;
+	int i, batch_size = 0, hash;
+	bool release_inactive = false;
 
 	while (batch_size < MAX_STRIPE_BATCH &&
 			(sh = __get_priority_stripe(conf, group)) != NULL)
 		batch[batch_size++] = sh;
 
-	if (batch_size == 0)
-		return batch_size;
+	if (batch_size == 0) {
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+			if (!list_empty(temp_inactive_list + i))
+				break;
+		if (i == NR_STRIPE_HASH_LOCKS)
+			return batch_size;
+		release_inactive = true;
+	}
 	spin_unlock_irq(&conf->device_lock);
 
+	release_inactive_stripe_list(conf, temp_inactive_list,
+		NR_STRIPE_HASH_LOCKS);
+
+	if (release_inactive) {
+		spin_lock_irq(&conf->device_lock);
+		return 0;
+	}
+
 	for (i = 0; i < batch_size; i++)
 		handle_stripe(batch[i]);
 
 	cond_resched();
 
 	spin_lock_irq(&conf->device_lock);
-	for (i = 0; i < batch_size; i++)
-		__release_stripe(conf, batch[i]);
+	for (i = 0; i < batch_size; i++) {
+		hash = batch[i]->hash_lock_index;
+		__release_stripe(conf, batch[i], &temp_inactive_list[hash]);
+	}
 	return batch_size;
 }
 
@@ -4990,9 +5161,10 @@ static void raid5_do_work(struct work_st
 	while (1) {
 		int batch_size, released;
 
-		released = release_stripe_list(conf);
+		released = release_stripe_list(conf, worker->temp_inactive_list);
 
-		batch_size = handle_active_stripes(conf, group_id, worker);
+		batch_size = handle_active_stripes(conf, group_id, worker,
+				worker->temp_inactive_list);
 		worker->working = false;
 		if (!batch_size && !released)
 			break;
@@ -5031,7 +5203,7 @@ static void raid5d(struct md_thread *thr
 		struct bio *bio;
 		int batch_size, released;
 
-		released = release_stripe_list(conf);
+		released = release_stripe_list(conf, conf->temp_inactive_list);
 
 		if (
 		    !list_empty(&conf->bitmap_list)) {
@@ -5041,7 +5213,7 @@ static void raid5d(struct md_thread *thr
 			bitmap_unplug(mddev->bitmap);
 			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = conf->seq_flush;
-			activate_bit_delay(conf);
+			activate_bit_delay(conf, conf->temp_inactive_list);
 		}
 		raid5_activate_delayed(conf);
 
@@ -5055,7 +5227,8 @@ static void raid5d(struct md_thread *thr
 			handled++;
 		}
 
-		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
+		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL,
+				conf->temp_inactive_list);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
@@ -5091,23 +5264,37 @@ raid5_set_cache_size(struct mddev *mddev
 {
 	struct r5conf *conf = mddev->private;
 	int err;
+	int hash;
 
 	if (size <= 16 || size > 32768)
 		return -EINVAL;
+	size = round_up(size, NR_STRIPE_HASH_LOCKS);
+	hash = 0;
 	while (size < conf->max_nr_stripes) {
-		if (drop_one_stripe(conf))
+		if (drop_one_stripe(conf, hash))
 			conf->max_nr_stripes--;
-		else
-			break;
+		else /* shouldn't fail here */
+			BUG();
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
 	}
 	err = md_allow_write(mddev);
 	if (err)
 		return err;
+	hash = 0;
 	while (size > conf->max_nr_stripes) {
-		if (grow_one_stripe(conf))
+		if (grow_one_stripe(conf, hash))
 			conf->max_nr_stripes++;
 		else break;
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
 	}
+
+	/* if grow_one_stripe fails, otherwise hash == 0 */
+	while (hash > 0) {
+		drop_one_stripe(conf, hash - 1);
+		conf->max_nr_stripes--;
+		hash--;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(raid5_set_cache_size);
@@ -5257,7 +5444,7 @@ static struct attribute_group raid5_attr
 
 static int alloc_thread_groups(struct r5conf *conf, int cnt)
 {
-	int i, j;
+	int i, j, k;
 	ssize_t size;
 	struct r5worker *workers;
 
@@ -5287,8 +5474,12 @@ static int alloc_thread_groups(struct r5
 		group->workers = workers + i * cnt;
 
 		for (j = 0; j < cnt; j++) {
-			group->workers[j].group = group;
-			INIT_WORK(&group->workers[j].work, raid5_do_work);
+			struct r5worker *worker = group->workers + j;
+			worker->group = group;
+			INIT_WORK(&worker->work, raid5_do_work);
+
+			for (k = 0; k < NR_STRIPE_HASH_LOCKS; k++)
+				INIT_LIST_HEAD(worker->temp_inactive_list + k);
 		}
 	}
 
@@ -5439,6 +5630,7 @@ static struct r5conf *setup_conf(struct
 	struct md_rdev *rdev;
 	struct disk_info *disk;
 	char pers_name[6];
+	int i;
 
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
@@ -5483,7 +5675,6 @@ static struct r5conf *setup_conf(struct
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
-	INIT_LIST_HEAD(&conf->inactive_list);
 	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
@@ -5509,6 +5700,15 @@ static struct r5conf *setup_conf(struct
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
 
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		spin_lock_init(conf->hash_locks + i);
+
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		INIT_LIST_HEAD(conf->inactive_list + i);
+
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		INIT_LIST_HEAD(conf->temp_inactive_list + i);
+
 	conf->level = mddev->new_level;
 	if (raid5_alloc_percpu(conf) != 0)
 		goto abort;
@@ -5549,7 +5749,6 @@ static struct r5conf *setup_conf(struct
 	else
 		conf->max_degraded = 1;
 	conf->algorithm = mddev->new_layout;
-	conf->max_nr_stripes = NR_STRIPES;
 	conf->reshape_progress = mddev->reshape_position;
 	if (conf->reshape_progress != MaxSector) {
 		conf->prev_chunk_sectors = mddev->chunk_sectors;
@@ -5558,7 +5757,7 @@ static struct r5conf *setup_conf(struct
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
-	if (grow_stripes(conf, conf->max_nr_stripes)) {
+	if (grow_stripes(conf, NR_STRIPES)) {
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate %dkB for buffers\n",
 		       mdname(mddev), memory);
@@ -6034,9 +6233,9 @@ static int raid5_spare_active(struct mdd
 			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
 		}
 	}
-	spin_lock_irqsave(&conf->device_lock, flags);
+	lock_all_device_hash_locks_irqsave(conf, &flags);
 	mddev->degraded = calc_degraded(conf);
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+	unlock_all_device_hash_locks_irqrestore(conf, &flags);
 	print_raid5_conf(conf);
 	return count;
 }
@@ -6347,9 +6546,9 @@ static int raid5_start_reshape(struct md
 		 * ->degraded is measured against the larger of the
 		 * pre and post number of devices.
 		 */
-		spin_lock_irqsave(&conf->device_lock, flags);
+		lock_all_device_hash_locks_irqsave(conf, &flags);
 		mddev->degraded = calc_degraded(conf);
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		unlock_all_device_hash_locks_irqrestore(conf, &flags);
 	}
 	mddev->raid_disks = conf->raid_disks;
 	mddev->reshape_position = conf->reshape_progress;
@@ -6363,14 +6562,14 @@ static int raid5_start_reshape(struct md
 						"reshape");
 	if (!mddev->sync_thread) {
 		mddev->recovery = 0;
-		spin_lock_irq(&conf->device_lock);
+		lock_all_device_hash_locks_irq(conf);
 		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
 		rdev_for_each(rdev, mddev)
 			rdev->new_data_offset = rdev->data_offset;
 		smp_wmb();
 		conf->reshape_progress = MaxSector;
 		mddev->reshape_position = MaxSector;
-		spin_unlock_irq(&conf->device_lock);
+		unlock_all_device_hash_locks_irq(conf);
 		return -EAGAIN;
 	}
 	conf->reshape_checkpoint = jiffies;
@@ -6388,13 +6587,13 @@ static void end_reshape(struct r5conf *c
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
 		struct md_rdev *rdev;
 
-		spin_lock_irq(&conf->device_lock);
+		lock_all_device_hash_locks_irq(conf);
 		conf->previous_raid_disks = conf->raid_disks;
 		rdev_for_each(rdev, conf->mddev)
 			rdev->data_offset = rdev->new_data_offset;
 		smp_wmb();
 		conf->reshape_progress = MaxSector;
-		spin_unlock_irq(&conf->device_lock);
+		unlock_all_device_hash_locks_irq(conf);
 		wake_up(&conf->wait_for_overlap);
 
 		/* read-ahead size must cover two whole stripes, which is
@@ -6425,9 +6624,9 @@ static void raid5_finish_reshape(struct
 			revalidate_disk(mddev->gendisk);
 		} else {
 			int d;
-			spin_lock_irq(&conf->device_lock);
+			lock_all_device_hash_locks_irq(conf);
 			mddev->degraded = calc_degraded(conf);
-			spin_unlock_irq(&conf->device_lock);
+			unlock_all_device_hash_locks_irq(conf);
 			for (d = conf->raid_disks ;
 			     d < conf->raid_disks - mddev->delta_disks;
 			     d++) {
@@ -6457,27 +6656,28 @@ static void raid5_quiesce(struct mddev *
 		break;
 
 	case 1: /* stop all writes */
-		spin_lock_irq(&conf->device_lock);
+		lock_all_device_hash_locks_irq(conf);
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
 		 */
 		conf->quiesce = 2;
-		wait_event_lock_irq(conf->wait_for_stripe,
+		wait_event_cmd(conf->wait_for_stripe,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
-				    conf->device_lock);
+				    unlock_all_device_hash_locks_irq(conf),
+				    lock_all_device_hash_locks_irq(conf));
 		conf->quiesce = 1;
-		spin_unlock_irq(&conf->device_lock);
+		unlock_all_device_hash_locks_irq(conf);
 		/* allow reshape to continue */
 		wake_up(&conf->wait_for_overlap);
 		break;
 
 	case 0: /* re-enable writes */
-		spin_lock_irq(&conf->device_lock);
+		lock_all_device_hash_locks_irq(conf);
 		conf->quiesce = 0;
 		wake_up(&conf->wait_for_stripe);
 		wake_up(&conf->wait_for_overlap);
-		spin_unlock_irq(&conf->device_lock);
+		unlock_all_device_hash_locks_irq(conf);
 		break;
 	}
 }
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2013-09-05 22:10:18.426462400 +0800
+++ linux/drivers/md/raid5.h	2013-09-05 22:10:47.434098049 +0800
@@ -205,6 +205,7 @@ struct stripe_head {
 	short			pd_idx;		/* parity disk index */
 	short			qd_idx;		/* 'Q' disk index for raid6 */
 	short			ddf_layout;/* use DDF ordering to calculate Q */
+	short			hash_lock_index;
 	unsigned long		state;		/* state flags */
 	atomic_t		count;	      /* nr of active thread/requests */
 	int			bm_seq;	/* sequence number for bitmap flushes */
@@ -367,9 +368,13 @@ struct disk_info {
 	struct md_rdev	*rdev, *replacement;
 };
 
+#define NR_STRIPE_HASH_LOCKS 8
+#define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
+
 struct r5worker {
 	struct work_struct work;
 	struct r5worker_group *group;
+	struct list_head temp_inactive_list[NR_STRIPE_HASH_LOCKS];
 	bool working;
 };
 
@@ -382,6 +387,8 @@ struct r5worker_group {
 
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
+	/* only protect corresponding hash list and inactive_list */
+	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
 	struct mddev		*mddev;
 	int			chunk_sectors;
 	int			level, algorithm;
@@ -462,7 +469,7 @@ struct r5conf {
 	 * Free stripes pool
 	 */
 	atomic_t		active_stripes;
-	struct list_head	inactive_list;
+	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
@@ -477,6 +484,7 @@ struct r5conf {
 	 * the new thread here until we fully activate the array.
 	 */
 	struct md_thread	*thread;
+	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
 	struct r5worker_group	*worker_groups;
 	int			group_cnt;
 	int			worker_cnt_per_group;
