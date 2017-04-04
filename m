From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 3/4] raid5-ppl: use resize_stripes() when enabling or disabling ppl
Date: Tue,  4 Apr 2017 13:13:57 +0200
Message-ID: <20170404111358.14829-4-artur.paszkiewicz@intel.com>
References: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Use resize_stripes() instead of raid5_reset_stripe_cache() to allocate
or free sh->ppl_page at runtime for all stripes in the stripe cache.
raid5_reset_stripe_cache() required suspending the mddev and could
deadlock because of GFP_KERNEL allocations.

Move the 'newsize' check to check_reshape() to allow reallocating the
stripes with the same number of disks. Allocate sh->ppl_page in
alloc_stripe() instead of grow_buffers(). Pass 'struct r5conf *conf' as
a parameter to alloc_stripe() because it is needed to check whether to
allocate ppl_page. Add free_stripe() and use it to free stripes rather
than directly call kmem_cache_free(). Also free sh->ppl_page in
free_stripe().

Set MD_HAS_PPL at the end of ppl_init_log() instead of explicitly
setting it in advance and add another parameter to log_init() to allow
calling ppl_init_log() without the bit set. Don't try to calculate
partial parity or add a stripe to log if it does not have ppl_page set.

Enabling ppl can now be performed without suspending the mddev, because
the log won't be used until new stripes are allocated with ppl_page.
Calling mddev_suspend/resume is still necessary when disabling ppl,
because we want all stripes to finish before stopping the log, but
resize_stripes() can be called after mddev_resume() when ppl is no
longer active.

Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-log.h |  5 +--
 drivers/md/raid5-ppl.c |  3 +-
 drivers/md/raid5.c     | 88 ++++++++++++++++++++++----------------------------
 3 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
index 738930ff5d17..27097101ccca 100644
--- a/drivers/md/raid5-log.h
+++ b/drivers/md/raid5-log.h
@@ -93,11 +93,12 @@ static inline void log_exit(struct r5conf *conf)
 		ppl_exit_log(conf);
 }
 
-static inline int log_init(struct r5conf *conf, struct md_rdev *journal_dev)
+static inline int log_init(struct r5conf *conf, struct md_rdev *journal_dev,
+			   bool ppl)
 {
 	if (journal_dev)
 		return r5l_init_log(conf, journal_dev);
-	else if (raid5_has_ppl(conf))
+	else if (ppl)
 		return ppl_init_log(conf);
 
 	return 0;
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 0a39a6bbcbde..e938669810c4 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -355,7 +355,7 @@ int ppl_write_stripe(struct r5conf *conf, struct stripe_head *sh)
 	struct ppl_io_unit *io = sh->ppl_io;
 	struct ppl_log *log;
 
-	if (io || test_bit(STRIPE_SYNCING, &sh->state) ||
+	if (io || test_bit(STRIPE_SYNCING, &sh->state) || !sh->ppl_page ||
 	    !test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
 	    !test_bit(R5_Insync, &sh->dev[sh->pd_idx].flags)) {
 		clear_bit(STRIPE_LOG_TRAPPED, &sh->state);
@@ -1223,6 +1223,7 @@ int ppl_init_log(struct r5conf *conf)
 	}
 
 	conf->log_private = ppl_conf;
+	set_bit(MD_HAS_PPL, &ppl_conf->mddev->flags);
 
 	return 0;
 err:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6036d5e41ddd..9cab2fe078c2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -471,11 +471,6 @@ static void shrink_buffers(struct stripe_head *sh)
 		sh->dev[i].page = NULL;
 		put_page(p);
 	}
-
-	if (sh->ppl_page) {
-		put_page(sh->ppl_page);
-		sh->ppl_page = NULL;
-	}
 }
 
 static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
@@ -493,12 +488,6 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 		sh->dev[i].orig_page = page;
 	}
 
-	if (raid5_has_ppl(sh->raid_conf)) {
-		sh->ppl_page = alloc_page(gfp);
-		if (!sh->ppl_page)
-			return 1;
-	}
-
 	return 0;
 }
 
@@ -2132,8 +2121,15 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	put_cpu();
 }
 
+static void free_stripe(struct kmem_cache *sc, struct stripe_head *sh)
+{
+	if (sh->ppl_page)
+		__free_page(sh->ppl_page);
+	kmem_cache_free(sc, sh);
+}
+
 static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
-	int disks)
+	int disks, struct r5conf *conf)
 {
 	struct stripe_head *sh;
 	int i;
@@ -2147,6 +2143,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		INIT_LIST_HEAD(&sh->r5c);
 		INIT_LIST_HEAD(&sh->log_list);
 		atomic_set(&sh->count, 1);
+		sh->raid_conf = conf;
 		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
@@ -2154,6 +2151,14 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 			bio_init(&dev->req, &dev->vec, 1);
 			bio_init(&dev->rreq, &dev->rvec, 1);
 		}
+
+		if (raid5_has_ppl(conf)) {
+			sh->ppl_page = alloc_page(gfp);
+			if (!sh->ppl_page) {
+				free_stripe(sc, sh);
+				sh = NULL;
+			}
+		}
 	}
 	return sh;
 }
@@ -2161,15 +2166,13 @@ static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
 {
 	struct stripe_head *sh;
 
-	sh = alloc_stripe(conf->slab_cache, gfp, conf->pool_size);
+	sh = alloc_stripe(conf->slab_cache, gfp, conf->pool_size, conf);
 	if (!sh)
 		return 0;
 
-	sh->raid_conf = conf;
-
 	if (grow_buffers(sh, gfp)) {
 		shrink_buffers(sh);
-		kmem_cache_free(conf->slab_cache, sh);
+		free_stripe(conf->slab_cache, sh);
 		return 0;
 	}
 	sh->hash_lock_index =
@@ -2314,9 +2317,6 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	int i;
 	int hash, cnt;
 
-	if (newsize <= conf->pool_size)
-		return 0; /* never bother to shrink */
-
 	err = md_allow_write(conf->mddev);
 	if (err)
 		return err;
@@ -2332,11 +2332,10 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	mutex_lock(&conf->cache_size_mutex);
 
 	for (i = conf->max_nr_stripes; i; i--) {
-		nsh = alloc_stripe(sc, GFP_KERNEL, newsize);
+		nsh = alloc_stripe(sc, GFP_KERNEL, newsize, conf);
 		if (!nsh)
 			break;
 
-		nsh->raid_conf = conf;
 		list_add(&nsh->lru, &newstripes);
 	}
 	if (i) {
@@ -2344,7 +2343,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		while (!list_empty(&newstripes)) {
 			nsh = list_entry(newstripes.next, struct stripe_head, lru);
 			list_del(&nsh->lru);
-			kmem_cache_free(sc, nsh);
+			free_stripe(sc, nsh);
 		}
 		kmem_cache_destroy(sc);
 		mutex_unlock(&conf->cache_size_mutex);
@@ -2370,7 +2369,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 			nsh->dev[i].orig_page = osh->dev[i].page;
 		}
 		nsh->hash_lock_index = hash;
-		kmem_cache_free(conf->slab_cache, osh);
+		free_stripe(conf->slab_cache, osh);
 		cnt++;
 		if (cnt >= conf->max_nr_stripes / NR_STRIPE_HASH_LOCKS +
 		    !!((conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS) > hash)) {
@@ -2445,7 +2444,7 @@ static int drop_one_stripe(struct r5conf *conf)
 		return 0;
 	BUG_ON(atomic_read(&sh->count));
 	shrink_buffers(sh);
-	kmem_cache_free(conf->slab_cache, sh);
+	free_stripe(conf->slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
 	conf->max_nr_stripes--;
 	return 1;
@@ -3168,7 +3167,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 		s->locked++;
 	}
 
-	if (raid5_has_ppl(sh->raid_conf) &&
+	if (raid5_has_ppl(sh->raid_conf) && sh->ppl_page &&
 	    test_bit(STRIPE_OP_BIODRAIN, &s->ops_request) &&
 	    !test_bit(STRIPE_FULL_WRITE, &sh->state) &&
 	    test_bit(R5_Insync, &sh->dev[pd_idx].flags))
@@ -7414,7 +7413,7 @@ static int raid5_run(struct mddev *mddev)
 		blk_queue_max_hw_sectors(mddev->queue, UINT_MAX);
 	}
 
-	if (log_init(conf, journal_dev))
+	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
 		goto abort;
 
 	return 0;
@@ -7623,7 +7622,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * The array is in readonly mode if journal is missing, so no
 		 * write requests running. We should be safe
 		 */
-		log_init(conf, rdev);
+		log_init(conf, rdev, false);
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
@@ -7773,6 +7772,9 @@ static int check_reshape(struct mddev *mddev)
 				      mddev->chunk_sectors)
 			    ) < 0)
 			return -ENOMEM;
+
+	if (conf->previous_raid_disks + mddev->delta_disks <= conf->pool_size)
+		return 0; /* never bother to shrink */
 	return resize_stripes(conf, (conf->previous_raid_disks
 				     + mddev->delta_disks));
 }
@@ -8263,20 +8265,6 @@ static void *raid6_takeover(struct mddev *mddev)
 	return setup_conf(mddev);
 }
 
-static void raid5_reset_stripe_cache(struct mddev *mddev)
-{
-	struct r5conf *conf = mddev->private;
-
-	mutex_lock(&conf->cache_size_mutex);
-	while (conf->max_nr_stripes &&
-	       drop_one_stripe(conf))
-		;
-	while (conf->min_nr_stripes > conf->max_nr_stripes &&
-	       grow_one_stripe(conf, GFP_KERNEL))
-		;
-	mutex_unlock(&conf->cache_size_mutex);
-}
-
 static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 {
 	struct r5conf *conf;
@@ -8291,23 +8279,23 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 		return -ENODEV;
 	}
 
-	if (strncmp(buf, "ppl", 3) == 0 && !raid5_has_ppl(conf)) {
+	if (strncmp(buf, "ppl", 3) == 0) {
 		/* ppl only works with RAID 5 */
-		if (conf->level == 5) {
-			mddev_suspend(mddev);
-			set_bit(MD_HAS_PPL, &mddev->flags);
-			err = log_init(conf, NULL);
-			if (!err)
-				raid5_reset_stripe_cache(mddev);
-			mddev_resume(mddev);
+		if (!raid5_has_ppl(conf) && conf->level == 5) {
+			err = log_init(conf, NULL, true);
+			if (!err) {
+				err = resize_stripes(conf, conf->pool_size);
+				if (err)
+					log_exit(conf);
+			}
 		} else
 			err = -EINVAL;
 	} else if (strncmp(buf, "resync", 6) == 0) {
 		if (raid5_has_ppl(conf)) {
 			mddev_suspend(mddev);
 			log_exit(conf);
-			raid5_reset_stripe_cache(mddev);
 			mddev_resume(mddev);
+			err = resize_stripes(conf, conf->pool_size);
 		} else if (test_bit(MD_HAS_JOURNAL, &conf->mddev->flags) &&
 			   r5l_log_disk_error(conf)) {
 			bool journal_dev_exists = false;
-- 
2.11.0

