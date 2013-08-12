From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Mon, 12 Aug 2013 10:24:37 +0800
Message-ID: <20130812022549.013010221@kernel.org>
References: <20130812022434.507702228@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-get_active_stripe-locking.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

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

If we need lock device_lock and hash lock, we always lock device_lock first.

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
 drivers/md/raid5.c |  220 +++++++++++++++++++++++++++++++++++++++--------------
 drivers/md/raid5.h |    8 +
 2 files changed, 172 insertions(+), 56 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-08-12 10:02:14.780071212 +0800
+++ linux/drivers/md/raid5.c	2013-08-12 10:02:22.419975160 +0800
@@ -86,6 +86,63 @@ static inline struct hlist_head *stripe_
 	return &conf->stripe_hashtbl[hash];
 }
 
+static inline int stripe_hash_locks_hash(sector_t sect)
+{
+	return (sect >> STRIPE_SHIFT) & STRIPE_HASH_LOCKS_MASK;
+}
+
+static inline void lock_device_hash_lock(struct r5conf *conf, int hash)
+{
+	spin_lock_irq(&conf->device_lock);
+	spin_lock(conf->hash_locks + hash);
+}
+
+static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
+{
+	spin_unlock(conf->hash_locks + hash);
+	spin_unlock_irq(&conf->device_lock);
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
+	spin_lock_irq(&conf->device_lock);
+	__lock_all_hash_locks(conf);
+}
+
+static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
+{
+	__unlock_all_hash_locks(conf);
+	spin_unlock_irq(&conf->device_lock);
+}
+
+static inline void lock_all_device_hash_locks_irqsave(struct r5conf *conf,
+	unsigned long *flags)
+{
+	spin_lock_irqsave(&conf->device_lock, *flags);
+	__lock_all_hash_locks(conf);
+}
+
+static inline void unlock_all_device_hash_locks_irqrestore(struct r5conf *conf,
+	unsigned long *flags)
+{
+	__unlock_all_hash_locks(conf);
+	spin_unlock_irqrestore(&conf->device_lock, *flags);
+}
+
 /* bio's attached to a stripe+device for I/O are linked together in bi_sector
  * order without overlap.  There may be several bio's per stripe+device, and
  * a bio could span several devices.
@@ -284,7 +341,10 @@ static void do_release_stripe(struct r5c
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
 		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
-			list_add_tail(&sh->lru, &conf->inactive_list);
+			int hash = sh->hash_lock_index;
+			spin_lock(conf->hash_locks + hash);
+			list_add_tail(&sh->lru, conf->inactive_list + hash);
+			spin_unlock(conf->hash_locks + hash);
 			wake_up(&conf->wait_for_stripe);
 			if (conf->retry_read_aligned)
 				md_wakeup_thread(conf->mddev->thread);
@@ -367,18 +427,19 @@ static inline void insert_hash(struct r5
 
 
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
@@ -557,33 +618,55 @@ get_active_stripe(struct r5conf *conf, s
 		  int previous, int noblock, int noquiesce)
 {
 	struct stripe_head *sh;
+	int hash = stripe_hash_locks_hash(sector);
+	bool global_locked = false;
 
 	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
 
-	spin_lock_irq(&conf->device_lock);
+	spin_lock_irq(conf->hash_locks + hash);
 
 	do {
-		wait_event_lock_irq(conf->wait_for_stripe,
+		if (global_locked)
+			wait_event_cmd(conf->wait_for_stripe,
 				    conf->quiesce == 0 || noquiesce,
-				    conf->device_lock);
+				    unlock_device_hash_lock(conf, hash),
+				    lock_device_hash_lock(conf, hash));
+		else
+			wait_event_lock_irq(conf->wait_for_stripe,
+				    conf->quiesce == 0 || noquiesce,
+				    *(conf->hash_locks + hash));
 		sh = __find_stripe(conf, sector, conf->generation - previous);
 		if (!sh) {
-			if (!conf->inactive_blocked)
-				sh = get_free_stripe(conf);
+			sh = get_free_stripe(conf, hash);
 			if (noblock && sh == NULL)
 				break;
+			if (!sh && !global_locked) {
+				spin_unlock_irq(conf->hash_locks + hash);
+				global_locked = true;
+				lock_device_hash_lock(conf, hash);
+				continue;
+			}
 			if (!sh) {
 				conf->inactive_blocked = 1;
-				wait_event_lock_irq(conf->wait_for_stripe,
-						    !list_empty(&conf->inactive_list) &&
-						    (atomic_read(&conf->active_stripes)
-						     < (conf->max_nr_stripes *3/4)
-						     || !conf->inactive_blocked),
-						    conf->device_lock);
+				wait_event_cmd(conf->wait_for_stripe,
+					!list_empty(conf->inactive_list + hash) &&
+					(atomic_read(&conf->active_stripes)
+					  < (conf->max_nr_stripes * 3 / 4)
+					|| !conf->inactive_blocked),
+					unlock_device_hash_lock(conf, hash),
+					lock_device_hash_lock(conf, hash));
 				conf->inactive_blocked = 0;
 			} else
 				init_stripe(sh, sector, previous);
 		} else {
+			if (!global_locked) {
+				spin_unlock_irq(conf->hash_locks + hash);
+				global_locked = true;
+				lock_device_hash_lock(conf, hash);
+				sh = NULL;
+				continue;
+			}
+
 			if (atomic_read(&sh->count)) {
 				BUG_ON(!list_empty(&sh->lru)
 				    && !test_bit(STRIPE_EXPANDING, &sh->state)
@@ -607,7 +690,10 @@ get_active_stripe(struct r5conf *conf, s
 	if (sh)
 		atomic_inc(&sh->count);
 
-	spin_unlock_irq(&conf->device_lock);
+	if (global_locked)
+		unlock_device_hash_lock(conf, hash);
+	else
+		spin_unlock_irq(conf->hash_locks + hash);
 	return sh;
 }
 
@@ -1575,7 +1661,7 @@ static void raid_run_ops(struct stripe_h
 	put_cpu();
 }
 
-static int grow_one_stripe(struct r5conf *conf)
+static int grow_one_stripe(struct r5conf *conf, int hash)
 {
 	struct stripe_head *sh;
 	sh = kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
@@ -1591,6 +1677,7 @@ static int grow_one_stripe(struct r5conf
 		kmem_cache_free(conf->slab_cache, sh);
 		return 0;
 	}
+	sh->hash_lock_index = hash;
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
@@ -1603,6 +1690,7 @@ static int grow_stripes(struct r5conf *c
 {
 	struct kmem_cache *sc;
 	int devs = max(conf->raid_disks, conf->previous_raid_disks);
+	int hash;
 
 	if (conf->mddev->gendisk)
 		sprintf(conf->cache_name[0],
@@ -1620,9 +1708,12 @@ static int grow_stripes(struct r5conf *c
 		return 1;
 	conf->slab_cache = sc;
 	conf->pool_size = devs;
-	while (num--)
-		if (!grow_one_stripe(conf))
+	hash = 0;
+	while (num--) {
+		if (!grow_one_stripe(conf, hash))
 			return 1;
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
+	}
 	return 0;
 }
 
@@ -1680,6 +1771,7 @@ static int resize_stripes(struct r5conf
 	int err;
 	struct kmem_cache *sc;
 	int i;
+	int hash;
 
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
@@ -1719,19 +1811,23 @@ static int resize_stripes(struct r5conf
 	 * OK, we have enough stripes, start collecting inactive
 	 * stripes and copying them over
 	 */
+	hash = 0;
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
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
 	}
 	kmem_cache_destroy(conf->slab_cache);
 
@@ -1790,13 +1886,13 @@ static int resize_stripes(struct r5conf
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
@@ -1808,8 +1904,9 @@ static int drop_one_stripe(struct r5conf
 
 static void shrink_stripes(struct r5conf *conf)
 {
-	while (drop_one_stripe(conf))
-		;
+	int hash = 0;
+	while (drop_one_stripe(conf, hash))
+		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
 
 	if (conf->slab_cache)
 		kmem_cache_destroy(conf->slab_cache);
@@ -2038,10 +2135,10 @@ static void error(struct mddev *mddev, s
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
@@ -3917,7 +4014,7 @@ int md_raid5_congested(struct mddev *mdd
 		return 1;
 	if (conf->quiesce)
 		return 1;
-	if (list_empty_careful(&conf->inactive_list))
+	if (atomic_read(&conf->active_stripes) == conf->max_nr_stripes)
 		return 1;
 
 	return 0;
@@ -5087,22 +5184,28 @@ raid5_set_cache_size(struct mddev *mddev
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
 		else
 			break;
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
 	return 0;
 }
@@ -5435,6 +5538,7 @@ static struct r5conf *setup_conf(struct
 	struct md_rdev *rdev;
 	struct disk_info *disk;
 	char pers_name[6];
+	int i;
 
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
@@ -5478,7 +5582,6 @@ static struct r5conf *setup_conf(struct
 	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
-	INIT_LIST_HEAD(&conf->inactive_list);
 	init_llist_head(&conf->released_stripes);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
@@ -5504,6 +5607,12 @@ static struct r5conf *setup_conf(struct
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
 
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		spin_lock_init(conf->hash_locks + i);
+
+	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+		INIT_LIST_HEAD(conf->inactive_list + i);
+
 	conf->level = mddev->new_level;
 	if (raid5_alloc_percpu(conf) != 0)
 		goto abort;
@@ -6029,9 +6138,9 @@ static int raid5_spare_active(struct mdd
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
@@ -6283,7 +6392,7 @@ static int raid5_start_reshape(struct md
 	}
 
 	atomic_set(&conf->reshape_stripes, 0);
-	spin_lock_irq(&conf->device_lock);
+	lock_all_device_hash_locks_irq(conf);
 	conf->previous_raid_disks = conf->raid_disks;
 	conf->raid_disks += mddev->delta_disks;
 	conf->prev_chunk_sectors = conf->chunk_sectors;
@@ -6300,7 +6409,7 @@ static int raid5_start_reshape(struct md
 	else
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
-	spin_unlock_irq(&conf->device_lock);
+	unlock_all_device_hash_locks_irq(conf);
 
 	/* Add some new drives, as many as will fit.
 	 * We know there are enough to make the newly sized array work.
@@ -6333,9 +6442,9 @@ static int raid5_start_reshape(struct md
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
@@ -6349,14 +6458,14 @@ static int raid5_start_reshape(struct md
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
@@ -6374,13 +6483,13 @@ static void end_reshape(struct r5conf *c
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
@@ -6411,9 +6520,9 @@ static void raid5_finish_reshape(struct
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
@@ -6443,27 +6552,28 @@ static void raid5_quiesce(struct mddev *
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
--- linux.orig/drivers/md/raid5.h	2013-08-12 10:01:00.321008393 +0800
+++ linux/drivers/md/raid5.h	2013-08-12 10:02:22.419975160 +0800
@@ -205,6 +205,7 @@ struct stripe_head {
 	short			pd_idx;		/* parity disk index */
 	short			qd_idx;		/* 'Q' disk index for raid6 */
 	short			ddf_layout;/* use DDF ordering to calculate Q */
+	short			hash_lock_index;
 	unsigned long		state;		/* state flags */
 	atomic_t		count;	      /* nr of active thread/requests */
 	int			bm_seq;	/* sequence number for bitmap flushes */
@@ -381,8 +382,13 @@ struct r5worker_group {
 	int stripes_cnt;
 };
 
+#define NR_STRIPE_HASH_LOCKS 8
+#define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
+
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
+	/* only protect corresponding hash list and inactive_list */
+	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
 	struct mddev		*mddev;
 	int			chunk_sectors;
 	int			level, algorithm;
@@ -462,7 +468,7 @@ struct r5conf {
 	 * Free stripes pool
 	 */
 	atomic_t		active_stripes;
-	struct list_head	inactive_list;
+	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;

