From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v1] md/r5cache: improve journal device efficiency
Date: Tue, 24 Jan 2017 14:08:23 -0800
Message-ID: <20170124220823.1481119-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, jsorensen@fb.com
List-Id: linux-raid.ids

It is important to be able to flush all stripes in raid5-cache.
Therefore, we need reserve some space on the journal device for
these flushes. If flush operation includes pending writes to the
stripe, we need to reserve (conf->raid_disk + 1) pages per stripe
for the flush out. This reduces the efficiency of journal space.
If we exclude these pending writes from flush operation, we only
need (conf->max_degraded + 1) pages per stripe.

With this patch, when log space is critical (R5C_LOG_CRITICAL=1),
pending writes will be excluded from stripe flush out. Therefore,
we can reduce reserved space for flush out and thus improve journal
device efficiency.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 36 +++++++++++++++++++++++++-----------
 drivers/md/raid5.c       | 42 +++++++++++++++++++++++++++++++++---------
 2 files changed, 58 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 76c0e50..00fe64b 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -389,17 +389,30 @@ void r5c_check_cached_full_stripe(struct r5conf *conf)
 /*
  * Total log space (in sectors) needed to flush all data in cache
  *
- * Currently, writing-out phase automatically includes all pending writes
- * to the same sector. So the reclaim of each stripe takes up to
- * (conf->raid_disks + 1) pages of log space.
+ * To avoid deadlock due to log space, it is necessary to reserve log
+ * space to flush critical stripes (stripes that occupying log space near
+ * last_checkpoint). This function helps check how much log space is
+ * required to flush all cached stripes.
  *
- * To totally avoid deadlock due to log space, the code reserves
- * (conf->raid_disks + 1) pages for each stripe in cache, which is not
- * necessary in most cases.
+ * To reduce log space requirements, two mechanisms are used to give cache
+ * flush higher priorities:
+ *    1. In handle_stripe_dirtying() and schedule_reconstruction(),
+ *       stripes ALREADY in journal can be flushed w/o pending writes;
+ *    2. In r5l_write_stripe() and r5c_cache_data(), stripes NOT in journal
+ *       can be delayed (r5l_add_no_space_stripe).
  *
- * To improve this, we will need writing-out phase to be able to NOT include
- * pending writes, which will reduce the requirement to
- * (conf->max_degraded + 1) pages per stripe in cache.
+ * In cache flush, the stripe goes through 1 and then 2. For a stripe that
+ * already passed 1, flushing it requires at most (conf->raid_disks + 1)
+ * pages of journal space. For stripes that has not passed 1, flushing it
+ * requires (conf->max_degraded + 1) pages of journal space. There are at
+ * most (conf->group_cnt + 1) stripe that passed 1. So total journal space
+ * required to flush all cached stripes (in pages) is:
+ *
+ *     (stripe_in_journal_count - group_cnt - 1) * (max_degraded + 1) +
+ *     (group_cnt + 1) * (raid_disks + 1)
+ * or
+ *     (stripe_in_journal_count) * (max_degraded + 1) +
+ *     (group_cnt + 1) * (raid_disks - max_degraded)
  */
 static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
 {
@@ -408,8 +421,9 @@ static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
 	if (!r5c_is_writeback(log))
 		return 0;
 
-	return BLOCK_SECTORS * (conf->raid_disks + 1) *
-		atomic_read(&log->stripe_in_journal_count);
+	return BLOCK_SECTORS *
+		((conf->max_degraded + 1) * atomic_read(&log->stripe_in_journal_count) +
+		 (conf->raid_disks - conf->max_degraded) * (conf->group_cnt + 1));
 }
 
 /*
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b62f671..b0d1345 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2951,12 +2951,36 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
  *      like to flush data in journal to RAID disks first, so complex rmw
  *      is handled in the write patch (handle_stripe_dirtying).
  *
+ *   2. when journal space is critical (R5C_LOG_CRITICAL=1)
+ *
+ *      It is important to be able to flush all stripes in raid5-cache.
+ *      Therefore, we need reserve some space on the journal device for
+ *      these flushes. If flush operation includes pending writes to the
+ *      stripe, we need to reserve (conf->raid_disk + 1) pages per stripe
+ *      for the flush out. If we exclude these pending writes from flush
+ *      operation, we only need (conf->max_degraded + 1) pages per stripe.
+ *      Therefore, excluding pending writes in these cases enables more
+ *      efficient use of the journal device.
+ *
+ *      Note: To make sure the stripe makes progress, we only delay
+ *      towrite for stripes with data already in journal (injournal > 0).
+ *      When LOG_CRITICAL, stripes with injournal == 0 will be sent to
+ *      no_space_stripes list.
+ *
  */
-static inline bool delay_towrite(struct r5dev *dev,
-				   struct stripe_head_state *s)
+static inline bool delay_towrite(struct r5conf *conf,
+				 struct r5dev *dev,
+				 struct stripe_head_state *s)
 {
-	return !test_bit(R5_OVERWRITE, &dev->flags) &&
-		!test_bit(R5_Insync, &dev->flags) && s->injournal;
+	/* case 1 above */
+	if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+	    !test_bit(R5_Insync, &dev->flags) && s->injournal)
+		return true;
+	/* case 2 above */
+	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
+	    s->injournal > 0)
+		return true;
+	return false;
 }
 
 static void
@@ -2979,7 +3003,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 
-			if (dev->towrite && !delay_towrite(dev, s)) {
+			if (dev->towrite && !delay_towrite(conf, dev, s)) {
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantdrain, &dev->flags);
 				if (!expand)
@@ -3731,7 +3755,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if (((dev->towrite && !delay_towrite(dev, s)) ||
+		if (((dev->towrite && !delay_towrite(conf, dev, s)) ||
 		     i == sh->pd_idx || i == sh->qd_idx ||
 		     test_bit(R5_InJournal, &dev->flags)) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
@@ -3755,8 +3779,8 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 		}
 	}
 
-	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
-		(unsigned long long)sh->sector, rmw, rcw);
+	pr_debug("for sector %llu state 0x%lx, rmw=%d rcw=%d\n",
+		 (unsigned long long)sh->sector, sh->state, rmw, rcw);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	if ((rmw < rcw || (rmw == rcw && conf->rmw_level == PARITY_PREFER_RMW)) && rmw > 0) {
 		/* prefer read-modify-write, but need to get some data */
@@ -3796,7 +3820,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (((dev->towrite && !delay_towrite(dev, s)) ||
+			if (((dev->towrite && !delay_towrite(conf, dev, s)) ||
 			     i == sh->pd_idx || i == sh->qd_idx ||
 			     test_bit(R5_InJournal, &dev->flags)) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-- 
2.9.3

