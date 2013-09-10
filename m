From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Tue, 10 Sep 2013 15:37:56 +0800
Message-ID: <20130910073756.GB12038@kernel.org>
References: <20130905162910.179ea808@notabene.brown>
 <20130905091822.GA8401@kernel.org>
 <20130909043318.GA27517@kernel.org>
 <20130910111318.1d19e8d3@notabene.brown>
 <20130910023555.GA17907@kernel.org>
 <20130910140629.702683da@notabene.brown>
 <20130910042438.GA16797@kernel.org>
 <20130910152032.48631492@notabene.brown>
 <20130910065912.GA12038@kernel.org>
 <20130910172836.43e23cbf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130910172836.43e23cbf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, Sep 10, 2013 at 05:28:36PM +1000, NeilBrown wrote:
> On Tue, 10 Sep 2013 14:59:12 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Tue, Sep 10, 2013 at 03:20:32PM +1000, NeilBrown wrote:
> > > On Tue, 10 Sep 2013 12:24:38 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > On Tue, Sep 10, 2013 at 02:06:29PM +1000, NeilBrown wrote:
> > > > > On Tue, 10 Sep 2013 10:35:55 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > > > 
> > > > > > On Tue, Sep 10, 2013 at 11:13:18AM +1000, NeilBrown wrote:
> > > > > > > On Mon, 9 Sep 2013 12:33:18 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > > > > > >  		} else {
> > > > > > > > +			spin_lock(&conf->device_lock);
> > > > > > > > +
> > > > > > > >  			if (atomic_read(&sh->count)) {
> > > > > > > >  				BUG_ON(!list_empty(&sh->lru)
> > > > > > > >  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> > > > > > > > @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
> > > > > > > >  					sh->group = NULL;
> > > > > > > >  				}
> > > > > > > >  			}
> > > > > > > > +			spin_unlock(&conf->device_lock);
> > > > > > > 
> > > > > > > The device_lock is only really needed in the 'else' branch of the if
> > > > > > > statement.  So can we have it only there.  i.e. don't take the lock if
> > > > > > > sh->count is non-zero.
> > > > > > 
> > > > > > This is correct, I assume this isn't worthy optimizing before. Will fix soon.
> > > > > 
> > > > > It isn't really about optimising performance.  It is about making the code
> > > > > easier to understand.  If we keep the region covered by the lock as small as
> > > > > reasonably possible, it makes it more obvious to the reader which values are
> > > > > being protected.
> > > > > 
> > > > >  
> > > > > > > > -	spin_lock_irqsave(&conf->device_lock, flags);
> > > > > > > > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> > > > > > > >  	clear_bit(In_sync, &rdev->flags);
> > > > > > > >  	mddev->degraded = calc_degraded(conf);
> > > > > > > > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > > > > > > > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > > > > > > >  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> > > > > > > 
> > > > > > > Why do you think you need to take all the hash locks here and elsewhere when
> > > > > > > ->degraded is set?
> > > > > > > The lock is only need to ensure that the 'In_sync' flags are consistent with
> > > > > > > the 'degraded' count.
> > > > > > > ->degraded isn't used in get_active_stripe so I cannot see how it is relevant
> > > > > > > to the hash locks.
> > > > > > > 
> > > > > > > We need to lock everything in raid5_quiesce().  I don't think we need to
> > > > > > > anywhere else.
> > > > > > 
> > > > > > init_stripe() accesses some filelds, don't need to protect?
> > > > > 
> > > > > What fields?  Not ->degraded.
> > > > > 
> > > > > I think the fields that it accesses are effectively protected by the new
> > > > > seqlock.
> > > > > If you don't think so, please be explicit.
> > > > 
> > > > Like raid_disks, previous_raid_disks, chunk_sectors, prev_chunk_sectors,
> > > > algorithm and so on. They are used in raid5_compute_sector(), stripe_set_idx()
> > > > and init_stripe(). The former two are called by init_stripe().
> > > 
> > > Yes.  Those are only changed in raid5_start_reshape() and are protected by
> > > conf->gen_lock.
> > 
> > Ok, I thought I misread degraded as max_degraded, so added unnecessary code.
> > The last question, in raid5_start_reshape(), I thought we should use seqlock to
> > protect the '!mddev->sync_thread' case, no?
> 
> We don't need anything there to protect the change to conf->raid_disks as
> make_request can only possibly access previous_raid_disks at that point.
> 
> However conf->reshape_progress is an issue.
> I write request just before this point would use a 'previous' stripe, while
> immediately after it would use a 'next' stripe.  i.e. sh->generation could
> have a different value.
> 
> So I think would should use the seqlock to protect that branch, and should
> decrement conf->generation.
> We should be putting algorithm and chunk back as well.

Then I ignore this part in my patch then. make_discard_request() needs seqlock
too, I thought.

> > 
> > > If they change while init_stripe is running, the read_seqcount_retry() call in
> > > make_request() will notice the inconsistency, release the stripe, and try
> > > again.
> > > 
> > > I guess we probably need an extra check on gen_lock inside init_stripe().
> > > i.e. a
> > >   do {
> > >      seq = read_seqcount_begin(&conf->gen_lock);
> > > 
> > > just after the "remove_hash(sh)", and a
> > > 
> > >   } while (read_seqcount_retry(&conf->gen_lock, seq));
> > > 
> > > just before the "insert_hash(sh)".  That will ensure the stripe inserted into
> > > the hash is consistent.  The read_seqcount_retry() in make_request is still
> > > needed to ensure that the correct stripe_head is used.
> > 
> > Good point. If it's in hash list, the seqcount check could be skiped.
> 
> I'm not sure exactly what you mean but I cannot see a case where you would
> want to skip the seqcount check there...

Never mind, I just explain we need the lock here.
Below is my latest patch.


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
 drivers/md/raid5.c |  306 ++++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.h |   10 +
 2 files changed, 244 insertions(+), 72 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-09-10 10:11:24.247067800 +0800
+++ linux/drivers/md/raid5.c	2013-09-10 15:31:32.621586375 +0800
@@ -86,6 +86,41 @@ static inline struct hlist_head *stripe_
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
+static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
+{
+	int i;
+	local_irq_disable();
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		spin_lock(conf->hash_locks + i);
+	spin_lock(&conf->device_lock);
+}
+
+static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
+{
+	int i;
+	spin_unlock(&conf->device_lock);
+	for (i = NR_STRIPE_HASH_LOCKS; i; i--)
+		spin_unlock(conf->hash_locks + i - 1);
+	local_irq_enable();
+}
+
 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
  * order without overlap.  There may be several bio's per stripe+device, and
  * a bio could span several devices.
@@ -250,7 +285,8 @@ static void raid5_wakeup_stripe_thread(s
 	}
 }
 
-static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
+static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
+	struct list_head *temp_inactive_list)
 {
 	BUG_ON(!list_empty(&sh->lru));
 	BUG_ON(atomic_read(&conf->active_stripes)==0);
@@ -279,19 +315,59 @@ static void do_release_stripe(struct r5c
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
@@ -309,7 +385,8 @@ static struct llist_node *llist_reverse_
 }
 
 /* should hold conf->device_lock already */
-static int release_stripe_list(struct r5conf *conf)
+static int release_stripe_list(struct r5conf *conf,
+	struct list_head *temp_inactive_list)
 {
 	struct stripe_head *sh;
 	int count = 0;
@@ -318,6 +395,8 @@ static int release_stripe_list(struct r5
 	head = llist_del_all(&conf->released_stripes);
 	head = llist_reverse_order(head);
 	while (head) {
+		int hash;
+
 		sh = llist_entry(head, struct stripe_head, release_list);
 		head = llist_next(head);
 		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
@@ -328,7 +407,8 @@ static int release_stripe_list(struct r5
 		 * again, the count is always > 1. This is true for
 		 * STRIPE_ON_UNPLUG_LIST bit too.
 		 */
-		__release_stripe(conf, sh);
+		hash = sh->hash_lock_index;
+		__release_stripe(conf, sh, &temp_inactive_list[hash]);
 		count++;
 	}
 
@@ -339,6 +419,8 @@ static void release_stripe(struct stripe
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
+	struct list_head list;
+	int hash;
 	bool wakeup;
 
 	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
@@ -351,8 +433,11 @@ slow_path:
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
@@ -377,18 +462,19 @@ static inline void insert_hash(struct r5
 
 
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
@@ -431,7 +517,7 @@ static void stripe_set_idx(sector_t stri
 static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 {
 	struct r5conf *conf = sh->raid_conf;
-	int i;
+	int i, seq;
 
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
@@ -441,7 +527,8 @@ static void init_stripe(struct stripe_he
 		(unsigned long long)sh->sector);
 
 	remove_hash(sh);
-
+retry:
+	seq = read_seqcount_begin(&conf->gen_lock);
 	sh->generation = conf->generation - previous;
 	sh->disks = previous ? conf->previous_raid_disks : conf->raid_disks;
 	sh->sector = sector;
@@ -463,6 +550,8 @@ static void init_stripe(struct stripe_he
 		dev->flags = 0;
 		raid5_build_block(sh, i, previous);
 	}
+	if (read_seqcount_retry(&conf->gen_lock, seq))
+		goto retry;
 	insert_hash(conf, sh);
 	sh->cpu = smp_processor_id();
 }
@@ -567,29 +656,30 @@ get_active_stripe(struct r5conf *conf, s
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
 			if (!conf->inactive_blocked)
-				sh = get_free_stripe(conf);
+				sh = get_free_stripe(conf, hash);
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
@@ -600,6 +690,7 @@ get_active_stripe(struct r5conf *conf, s
 				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
 				    && !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
 			} else {
+				spin_lock(&conf->device_lock);
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
 				if (list_empty(&sh->lru) &&
@@ -610,6 +701,7 @@ get_active_stripe(struct r5conf *conf, s
 					sh->group->stripes_cnt--;
 					sh->group = NULL;
 				}
+				spin_unlock(&conf->device_lock);
 			}
 		}
 	} while (sh == NULL);
@@ -617,7 +709,7 @@ get_active_stripe(struct r5conf *conf, s
 	if (sh)
 		atomic_inc(&sh->count);
 
-	spin_unlock_irq(&conf->device_lock);
+	spin_unlock_irq(conf->hash_locks + hash);
 	return sh;
 }
 
@@ -1585,7 +1677,7 @@ static void raid_run_ops(struct stripe_h
 	put_cpu();
 }
 
-static int grow_one_stripe(struct r5conf *conf)
+static int grow_one_stripe(struct r5conf *conf, int hash)
 {
 	struct stripe_head *sh;
 	sh = kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
@@ -1601,6 +1693,7 @@ static int grow_one_stripe(struct r5conf
 		kmem_cache_free(conf->slab_cache, sh);
 		return 0;
 	}
+	sh->hash_lock_index = hash;
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
@@ -1613,6 +1706,7 @@ static int grow_stripes(struct r5conf *c
 {
 	struct kmem_cache *sc;
 	int devs = max(conf->raid_disks, conf->previous_raid_disks);
+	int hash;
 
 	if (conf->mddev->gendisk)
 		sprintf(conf->cache_name[0],
@@ -1630,9 +1724,13 @@ static int grow_stripes(struct r5conf *c
 		return 1;
 	conf->slab_cache = sc;
 	conf->pool_size = devs;
-	while (num--)
-		if (!grow_one_stripe(conf))
+	hash = conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
+	while (num--) {
+		if (!grow_one_stripe(conf, hash))
 			return 1;
+		conf->max_nr_stripes++;
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
+	}
 	return 0;
 }
 
@@ -1690,6 +1788,7 @@ static int resize_stripes(struct r5conf
 	int err;
 	struct kmem_cache *sc;
 	int i;
+	int hash, cnt;
 
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
@@ -1729,19 +1828,29 @@ static int resize_stripes(struct r5conf
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
+		if (cnt >= conf->max_nr_stripes / NR_STRIPE_HASH_LOCKS +
+		    !!((conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS) > hash)) {
+			hash++;
+			cnt = 0;
+		}
 	}
 	kmem_cache_destroy(conf->slab_cache);
 
@@ -1800,13 +1909,13 @@ static int resize_stripes(struct r5conf
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
@@ -1818,8 +1927,10 @@ static int drop_one_stripe(struct r5conf
 
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
@@ -3895,7 +4006,8 @@ static void raid5_activate_delayed(struc
 	}
 }
 
-static void activate_bit_delay(struct r5conf *conf)
+static void activate_bit_delay(struct r5conf *conf,
+	struct list_head *temp_inactive_list)
 {
 	/* device_lock is held */
 	struct list_head head;
@@ -3903,9 +4015,11 @@ static void activate_bit_delay(struct r5
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
 
@@ -3921,7 +4035,7 @@ int md_raid5_congested(struct mddev *mdd
 		return 1;
 	if (conf->quiesce)
 		return 1;
-	if (list_empty_careful(&conf->inactive_list))
+	if (atomic_read(&conf->active_stripes) == conf->max_nr_stripes)
 		return 1;
 
 	return 0;
@@ -4251,6 +4365,7 @@ static struct stripe_head *__get_priorit
 struct raid5_plug_cb {
 	struct blk_plug_cb	cb;
 	struct list_head	list;
+	struct list_head	temp_inactive_list[NR_STRIPE_HASH_LOCKS];
 };
 
 static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
@@ -4261,6 +4376,7 @@ static void raid5_unplug(struct blk_plug
 	struct mddev *mddev = cb->cb.data;
 	struct r5conf *conf = mddev->private;
 	int cnt = 0;
+	int hash;
 
 	if (cb->list.next && !list_empty(&cb->list)) {
 		spin_lock_irq(&conf->device_lock);
@@ -4278,11 +4394,14 @@ static void raid5_unplug(struct blk_plug
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
@@ -4303,8 +4422,12 @@ static void release_stripe_plug(struct m
 
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
@@ -4949,27 +5072,45 @@ static int  retry_aligned_read(struct r5
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
 
@@ -4990,9 +5131,10 @@ static void raid5_do_work(struct work_st
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
@@ -5031,7 +5173,7 @@ static void raid5d(struct md_thread *thr
 		struct bio *bio;
 		int batch_size, released;
 
-		released = release_stripe_list(conf);
+		released = release_stripe_list(conf, conf->temp_inactive_list);
 
 		if (
 		    !list_empty(&conf->bitmap_list)) {
@@ -5041,7 +5183,7 @@ static void raid5d(struct md_thread *thr
 			bitmap_unplug(mddev->bitmap);
 			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = conf->seq_flush;
-			activate_bit_delay(conf);
+			activate_bit_delay(conf, conf->temp_inactive_list);
 		}
 		raid5_activate_delayed(conf);
 
@@ -5055,7 +5197,8 @@ static void raid5d(struct md_thread *thr
 			handled++;
 		}
 
-		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL);
+		batch_size = handle_active_stripes(conf, ANY_GROUP, NULL,
+				conf->temp_inactive_list);
 		if (!batch_size && !released)
 			break;
 		handled += batch_size;
@@ -5091,23 +5234,31 @@ raid5_set_cache_size(struct mddev *mddev
 {
 	struct r5conf *conf = mddev->private;
 	int err;
+	int hash;
 
 	if (size <= 16 || size > 32768)
 		return -EINVAL;
+	hash = (conf->max_nr_stripes - 1) % NR_STRIPE_HASH_LOCKS;
 	while (size < conf->max_nr_stripes) {
-		if (drop_one_stripe(conf))
+		if (drop_one_stripe(conf, hash))
 			conf->max_nr_stripes--;
 		else
 			break;
+		hash--;
+		if (hash < 0)
+			hash = NR_STRIPE_HASH_LOCKS - 1;
 	}
 	err = md_allow_write(mddev);
 	if (err)
 		return err;
+	hash = conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
 	while (size > conf->max_nr_stripes) {
-		if (grow_one_stripe(conf))
+		if (grow_one_stripe(conf, hash))
 			conf->max_nr_stripes++;
 		else break;
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
 	}
+
 	return 0;
 }
 EXPORT_SYMBOL(raid5_set_cache_size);
@@ -5257,7 +5408,7 @@ static struct attribute_group raid5_attr
 
 static int alloc_thread_groups(struct r5conf *conf, int cnt)
 {
-	int i, j;
+	int i, j, k;
 	ssize_t size;
 	struct r5worker *workers;
 
@@ -5287,8 +5438,12 @@ static int alloc_thread_groups(struct r5
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
 
@@ -5439,6 +5594,7 @@ static struct r5conf *setup_conf(struct
 	struct md_rdev *rdev;
 	struct disk_info *disk;
 	char pers_name[6];
+	int i;
 
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
@@ -5483,7 +5639,6 @@ static struct r5conf *setup_conf(struct
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
-	INIT_LIST_HEAD(&conf->inactive_list);
 	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
@@ -5509,6 +5664,15 @@ static struct r5conf *setup_conf(struct
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
@@ -5549,7 +5713,6 @@ static struct r5conf *setup_conf(struct
 	else
 		conf->max_degraded = 1;
 	conf->algorithm = mddev->new_layout;
-	conf->max_nr_stripes = NR_STRIPES;
 	conf->reshape_progress = mddev->reshape_position;
 	if (conf->reshape_progress != MaxSector) {
 		conf->prev_chunk_sectors = mddev->chunk_sectors;
@@ -5558,7 +5721,7 @@ static struct r5conf *setup_conf(struct
 
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
-	if (grow_stripes(conf, conf->max_nr_stripes)) {
+	if (grow_stripes(conf, NR_STRIPES)) {
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate %dkB for buffers\n",
 		       mdname(mddev), memory);
@@ -6457,27 +6620,28 @@ static void raid5_quiesce(struct mddev *
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
--- linux.orig/drivers/md/raid5.h	2013-09-10 10:11:24.247067800 +0800
+++ linux/drivers/md/raid5.h	2013-09-10 10:11:24.243067889 +0800
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
