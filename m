From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 3 of 27 - Get multipath to use mempool
Date: Thu, 18 Jul 2002 23:32:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133227.4769@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Get multipath to use mempool

... rather than maintaining it's own mempool



 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |  110 ++++++---------------------------------
 ./include/linux/raid/multipath.h |   11 ---
 2 files changed, 19 insertions(+), 102 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 11:58:06	1.3
+++ ./drivers/md/multipath.c	2002/07/18 11:59:52	1.4
@@ -58,87 +58,20 @@ struct multipath_bh *multipath_retry_lis
 static int multipath_spare_write(mddev_t *, int);
 static int multipath_spare_active(mddev_t *mddev, mdp_disk_t **d);
 
-static struct multipath_bh *multipath_alloc_mpbh(multipath_conf_t *conf)
+static void *mp_pool_alloc(int gfp_flags, void *data)
 {
-	struct multipath_bh *mp_bh = NULL;
-
-	do {
-		spin_lock_irq(&conf->device_lock);
-		if (!conf->freer1_blocked && conf->freer1) {
-			mp_bh = conf->freer1;
-			conf->freer1 = mp_bh->next_mp;
-			conf->freer1_cnt--;
-			mp_bh->next_mp = NULL;
-			mp_bh->state = (1 << MPBH_PreAlloc);
-		}
-		spin_unlock_irq(&conf->device_lock);
-		if (mp_bh)
-			return mp_bh;
-		mp_bh = (struct multipath_bh *) kmalloc(sizeof(struct multipath_bh),
-					GFP_NOIO);
-		if (mp_bh) {
-			memset(mp_bh, 0, sizeof(*mp_bh));
-			return mp_bh;
-		}
-		conf->freer1_blocked = 1;
-		wait_disk_event(conf->wait_buffer,
-				!conf->freer1_blocked ||
-				conf->freer1_cnt > NR_RESERVED_BUFS/2
-		    );
-		conf->freer1_blocked = 0;
-	} while (1);
-}
-
-static inline void multipath_free_mpbh(struct multipath_bh *mp_bh)
-{
-	multipath_conf_t *conf = mddev_to_conf(mp_bh->mddev);
-
-	if (test_bit(MPBH_PreAlloc, &mp_bh->state)) {
-		unsigned long flags;
-		mp_bh->bio = NULL;
-		spin_lock_irqsave(&conf->device_lock, flags);
-		mp_bh->next_mp = conf->freer1;
-		conf->freer1 = mp_bh;
-		conf->freer1_cnt++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		wake_up(&conf->wait_buffer);
-	} else {
-		kfree(mp_bh);
-	}
-}
-
-static int multipath_grow_mpbh (multipath_conf_t *conf, int cnt)
-{
-	int i = 0;
-
-	while (i < cnt) {
-		struct multipath_bh *mp_bh;
-		mp_bh = (struct multipath_bh*)kmalloc(sizeof(*mp_bh), GFP_KERNEL);
-		if (!mp_bh)
-			break;
-		memset(mp_bh, 0, sizeof(*mp_bh));
-		set_bit(MPBH_PreAlloc, &mp_bh->state);
-		mp_bh->mddev = conf->mddev;	       
-
-		multipath_free_mpbh(mp_bh);
-		i++;
-	}
-	return i;
+	struct multipath_bh *mpb;
+	mpb = kmalloc(sizeof(*mpb), gfp_flags);
+	if (mpb) 
+		memset(mpb, 0, sizeof(*mpb));
+	return mpb;
 }
 
-static void multipath_shrink_mpbh(multipath_conf_t *conf)
+static void mp_pool_free(void *mpb, void *data)
 {
-	spin_lock_irq(&conf->device_lock);
-	while (conf->freer1) {
-		struct multipath_bh *mp_bh = conf->freer1;
-		conf->freer1 = mp_bh->next_mp;
-		conf->freer1_cnt--;
-		kfree(mp_bh);
-	}
-	spin_unlock_irq(&conf->device_lock);
+	kfree(mpb);
 }
 
-
 static int multipath_map (mddev_t *mddev, struct block_device **bdev)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
@@ -185,10 +118,11 @@ static void multipath_reschedule_retry (
 static void multipath_end_bh_io (struct multipath_bh *mp_bh, int uptodate)
 {
 	struct bio *bio = mp_bh->master_bio;
+	multipath_conf_t *conf = mddev_to_conf(mp_bh->mddev);
 
 	bio_endio(bio, uptodate);
 	bio_put(mp_bh->bio);
-	multipath_free_mpbh(mp_bh);
+	mempool_free(mp_bh, conf->pool);
 }
 
 void multipath_end_request(struct bio *bio)
@@ -251,7 +185,7 @@ static int multipath_make_request (reque
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 
-	mp_bh = multipath_alloc_mpbh (conf);
+	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
@@ -864,24 +798,15 @@ static int multipath_run (mddev_t *mddev
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
 
-	init_waitqueue_head(&conf->wait_buffer);
-
 	if (!conf->working_disks) {
 		printk(NONE_OPERATIONAL, mdidx(mddev));
 		goto out_free_conf;
 	}
 
-
-	/* pre-allocate some buffer_head structures.
-	 * As a minimum, 1 mpbh and raid_disks buffer_heads
-	 * would probably get us by in tight memory situations,
-	 * but a few more is probably a good idea.
-	 * For now, try NR_RESERVED_BUFS mpbh and
-	 * NR_RESERVED_BUFS*raid_disks bufferheads
-	 * This will allow at least NR_RESERVED_BUFS concurrent
-	 * reads or writes even if kmalloc starts failing
-	 */
-	if (multipath_grow_mpbh(conf, NR_RESERVED_BUFS) < NR_RESERVED_BUFS) {
+	conf->pool = mempool_create(NR_RESERVED_BUFS,
+				    mp_pool_alloc, mp_pool_free,
+				    NULL);
+	if (conf->pool == NULL) {
 		printk(MEM_ERROR, mdidx(mddev));
 		goto out_free_conf;
 	}
@@ -916,7 +841,8 @@ static int multipath_run (mddev_t *mddev
 	return 0;
 
 out_free_conf:
-	multipath_shrink_mpbh(conf);
+	if (conf->pool)
+		mempool_destroy(conf->pool);
 	kfree(conf);
 	mddev->private = NULL;
 out:
@@ -941,7 +867,7 @@ static int multipath_stop (mddev_t *mdde
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 
 	md_unregister_thread(conf->thread);
-	multipath_shrink_mpbh(conf);
+	mempool_destroy(conf->pool);
 	kfree(conf);
 	mddev->private = NULL;
 	MOD_DEC_USE_COUNT;
--- ./include/linux/raid/multipath.h	2002/07/18 11:59:50	1.1
+++ ./include/linux/raid/multipath.h	2002/07/18 11:59:52	1.2
@@ -27,16 +27,7 @@ struct multipath_private_data {
 	struct multipath_info	*spare;
 	spinlock_t		device_lock;
 
-	/* buffer pool */
-	/* buffer_heads that we have pre-allocated have b_pprev -> &freebh
-	 * and are linked into a stack using b_next
-	 * multipath_bh that are pre-allocated have MPBH_PreAlloc set.
-	 * All these variable are protected by device_lock
-	 */
-	struct multipath_bh	*freer1;
-	int			freer1_blocked;
-	int			freer1_cnt;
-	wait_queue_head_t	wait_buffer;
+	mempool_t		*pool;
 };
 
 typedef struct multipath_private_data multipath_conf_t;
