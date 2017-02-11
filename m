From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] md/raid5-cache: exclude reclaiming stripes in reclaim check
Date: Fri, 10 Feb 2017 16:18:09 -0800
Message-ID: <c444bb328b45f3b2d6fa7affe899d8d54b86c56c.1486772085.git.shli@fb.com>
References: <a8a29c2eceb8a7d68080b95c7df04f0663b358bd.1486772085.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a8a29c2eceb8a7d68080b95c7df04f0663b358bd.1486772085.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

stripes which are being reclaimed are still accounted into cached
stripes. The reclaim takes time. r5c_do_reclaim isn't aware of the
stripes and does unnecessary stripe reclaim. In practice, I saw one
stripe is reclaimed one time. This will cause bad IO pattern. Fixing
this by excluding the reclaing stripes in the check.

Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 14 ++++++++++++--
 drivers/md/raid5.c       |  2 ++
 drivers/md/raid5.h       |  2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index a01f4da..3f307be 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1327,6 +1327,10 @@ static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
 	atomic_inc(&conf->active_stripes);
 	r5c_make_stripe_write_out(sh);
 
+	if (test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
+		atomic_inc(&conf->r5c_flushing_partial_stripes);
+	else
+		atomic_inc(&conf->r5c_flushing_full_stripes);
 	raid5_release_stripe(sh);
 }
 
@@ -1369,12 +1373,16 @@ static void r5c_do_reclaim(struct r5conf *conf)
 	unsigned long flags;
 	int total_cached;
 	int stripes_to_flush;
+	int flushing_partial, flushing_full;
 
 	if (!r5c_is_writeback(log))
 		return;
 
+	flushing_partial = atomic_read(&conf->r5c_flushing_partial_stripes);
+	flushing_full = atomic_read(&conf->r5c_flushing_full_stripes);
 	total_cached = atomic_read(&conf->r5c_cached_partial_stripes) +
-		atomic_read(&conf->r5c_cached_full_stripes);
+		atomic_read(&conf->r5c_cached_full_stripes) -
+		flushing_full - flushing_partial;
 
 	if (total_cached > conf->min_nr_stripes * 3 / 4 ||
 	    atomic_read(&conf->empty_inactive_list_nr) > 0)
@@ -1384,7 +1392,7 @@ static void r5c_do_reclaim(struct r5conf *conf)
 		 */
 		stripes_to_flush = R5C_RECLAIM_STRIPE_GROUP;
 	else if (total_cached > conf->min_nr_stripes * 1 / 2 ||
-		 atomic_read(&conf->r5c_cached_full_stripes) >
+		 atomic_read(&conf->r5c_cached_full_stripes) - flushing_full >
 		 R5C_FULL_STRIPE_FLUSH_BATCH)
 		/*
 		 * if stripe cache pressure moderate, or if there is many full
@@ -2601,11 +2609,13 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 
 	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
 		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
+		atomic_dec(&conf->r5c_flushing_partial_stripes);
 		atomic_dec(&conf->r5c_cached_partial_stripes);
 	}
 
 	if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
 		BUG_ON(atomic_read(&conf->r5c_cached_full_stripes) == 0);
+		atomic_dec(&conf->r5c_flushing_full_stripes);
 		atomic_dec(&conf->r5c_cached_full_stripes);
 	}
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 467ad4f..5f08ef1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6839,6 +6839,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	INIT_LIST_HEAD(&conf->r5c_full_stripe_list);
 	atomic_set(&conf->r5c_cached_partial_stripes, 0);
 	INIT_LIST_HEAD(&conf->r5c_partial_stripe_list);
+	atomic_set(&conf->r5c_flushing_full_stripes, 0);
+	atomic_set(&conf->r5c_flushing_partial_stripes, 0);
 
 	conf->level = mddev->new_level;
 	conf->chunk_sectors = mddev->new_chunk_sectors;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6a99fb5e..1e2f35c 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -666,6 +666,8 @@ struct r5conf {
 	struct list_head	r5c_full_stripe_list;
 	atomic_t		r5c_cached_partial_stripes;
 	struct list_head	r5c_partial_stripe_list;
+	atomic_t		r5c_flushing_full_stripes;
+	atomic_t		r5c_flushing_partial_stripes;
 
 	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
-- 
2.9.3

