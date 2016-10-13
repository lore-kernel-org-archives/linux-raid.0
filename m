From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 3/8] md/r5cache: State machine for raid5-cache write back mode
Date: Wed, 12 Oct 2016 22:49:39 -0700
Message-ID: <20161013054944.1038806-4-songliubraving@fb.com>
References: <20161013054944.1038806-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161013054944.1038806-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

The raid5-cache write back mode as 2 states for each stripe: write state
and reclaim state. This patch adds bare state machine for these two
states.

2 flags are added to sh->state for raid5-cache states:
 - STRIPE_R5C_FROZEN
 - STRIPE_R5C_WRITTEN

STRIPE_R5C_FROZEN is the key flag to differentiate write state
and reclaim state.

STRIPE_R5C_WRITTEN is a helper flag to bring the stripe back from
reclaim state back to write state.

In write through mode, every stripe also goes between write state
and reclaim state (in r5c_handle_stripe_dirtying() and
r5c_handle_stripe_written()).

Please note: this is a "no-op" patch for raid5-cache write through
mode.

The following detailed explanation is copied from the raid5-cache.c:

/*
 * raid5 cache state machine
 *
 * The RAID cache works in two major states for each stripe: write state
 * and reclaim state. These states are controlled by flags STRIPE_R5C_FROZEN
 * and STRIPE_R5C_WRITTEN
 *
 * STRIPE_R5C_FROZEN is the key flag to differentiate write state and reclaim
 * state. The write state runs w/ STRIPE_R5C_FROZEN == 0. While the reclaim
 * state runs w/ STRIPE_R5C_FROZEN == 1.
 *
 * STRIPE_R5C_WRITTEN is a helper flag to bring the stripe back from reclaim
 * state to write state. Specifically, STRIPE_R5C_WRITTEN triggers clean up
 * process in r5c_handle_stripe_written. STRIPE_R5C_WRITTEN is set when data
 * and parity of a stripe is all in journal device; and cleared when the data
 * and parity are all in RAID disks.
 *
 * The following is another way to show how STRIPE_R5C_FROZEN and
 * STRIPE_R5C_WRITTEN work:
 *
 * write state: STRIPE_R5C_FROZEN = 0 STRIPE_R5C_WRITTEN = 0
 * reclaim state: STRIPE_R5C_FROZEN = 1
 *
 * write => reclaim: set STRIPE_R5C_FROZEN in r5c_freeze_stripe_for_reclaim
 * reclaim => write:
 * 1. write parity to journal, when finished, set STRIPE_R5C_WRITTEN
 * 2. write data/parity to raid disks, when finished, clear both
 *    STRIPE_R5C_FROZEN and STRIPE_R5C_WRITTEN
 *
 * In write through mode (journal only) the stripe still goes through these
 * state change, except that STRIPE_R5C_FROZEN is set on write in
 * r5c_handle_stripe_dirtying().
 */

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 125 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.c       |  20 ++++++--
 drivers/md/raid5.h       |  10 +++-
 3 files changed, 148 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7557791b..9e05850 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -40,6 +40,47 @@
  */
 #define R5L_POOL_SIZE	4
 
+enum r5c_state {
+	R5C_STATE_NO_CACHE = 0,
+	R5C_STATE_WRITE_THROUGH = 1,
+	R5C_STATE_WRITE_BACK = 2,
+	R5C_STATE_CACHE_BROKEN = 3,
+};
+
+/*
+ * raid5 cache state machine
+ *
+ * The RAID cache works in two major states for each stripe: write state and
+ * reclaim state. These states are controlled by flags STRIPE_R5C_FROZEN and
+ * STRIPE_R5C_WRITTEN
+ *
+ * STRIPE_R5C_FROZEN is the key flag to differentiate write state and reclaim
+ * state. The write state runs w/ STRIPE_R5C_FROZEN == 0. While the reclaim
+ * state runs w/ STRIPE_R5C_FROZEN == 1.
+ *
+ * STRIPE_R5C_WRITTEN is a helper flag to bring the stripe back from reclaim
+ * state to write state. Specifically, STRIPE_R5C_WRITTEN triggers clean up
+ * process in r5c_handle_stripe_written. STRIPE_R5C_WRITTEN is set when data
+ * and parity of a stripe is all in journal device; and cleared when the data
+ * and parity are all in RAID disks.
+ *
+ * The following is another way to show how STRIPE_R5C_FROZEN and
+ * STRIPE_R5C_WRITTEN work:
+ *
+ * write state: STRIPE_R5C_FROZEN = 0 STRIPE_R5C_WRITTEN = 0
+ * reclaim state: STRIPE_R5C_FROZEN = 1
+ *
+ * write => reclaim: set STRIPE_R5C_FROZEN in r5c_freeze_stripe_for_reclaim
+ * reclaim => write:
+ * 1. write parity to journal, when finished, set STRIPE_R5C_WRITTEN
+ * 2. write data/parity to raid disks, when finished, clear both
+ *    STRIPE_R5C_FROZEN and STRIPE_R5C_WRITTEN
+ *
+ * In write through mode (journal only) the stripe also goes through these
+ * state change, except that STRIPE_R5C_FROZEN is set on write in
+ * r5c_handle_stripe_dirtying().
+ */
+
 struct r5l_log {
 	struct md_rdev *rdev;
 
@@ -96,6 +137,9 @@ struct r5l_log {
 	spinlock_t no_space_stripes_lock;
 
 	bool need_cache_flush;
+
+	/* for r5c_cache */
+	enum r5c_state r5c_state;
 };
 
 /*
@@ -133,6 +177,11 @@ enum r5l_io_unit_state {
 	IO_UNIT_STRIPE_END = 3,	/* stripes data finished writing to raid */
 };
 
+bool r5c_is_writeback(struct r5l_log *log)
+{
+	return (log != NULL && log->r5c_state == R5C_STATE_WRITE_BACK);
+}
+
 static sector_t r5l_ring_add(struct r5l_log *log, sector_t start, sector_t inc)
 {
 	start += inc;
@@ -168,12 +217,44 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+/*
+ * Freeze the stripe, thus send the stripe into reclaim path.
+ *
+ * In current implementation, STRIPE_R5C_FROZEN is also set in write through
+ * mode (in r5c_handle_stripe_dirtying). This does not change the behavior of
+ * for write through mode.
+ */
+void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
+
+	if (!log)
+		return;
+	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
+	set_bit(STRIPE_R5C_FROZEN, &sh->state);
+}
+
+static void r5c_finish_cache_stripe(struct stripe_head *sh)
+{
+	struct r5l_log *log = sh->raid_conf->log;
+
+	if (log->r5c_state == R5C_STATE_WRITE_THROUGH) {
+		BUG_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
+		set_bit(STRIPE_R5C_WRITTEN, &sh->state);
+	} else
+		BUG(); /* write back logic in next patch */
+}
+
 static void r5l_io_run_stripes(struct r5l_io_unit *io)
 {
 	struct stripe_head *sh, *next;
 
 	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
 		list_del_init(&sh->log_list);
+
+		r5c_finish_cache_stripe(sh);
+
 		set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
@@ -412,18 +493,19 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 		r5l_append_payload_page(log, sh->dev[i].page);
 	}
 
-	if (sh->qd_idx >= 0) {
+	if (parity_pages == 2) {
 		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
 					sh->sector, sh->dev[sh->pd_idx].log_checksum,
 					sh->dev[sh->qd_idx].log_checksum, true);
 		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
 		r5l_append_payload_page(log, sh->dev[sh->qd_idx].page);
-	} else {
+	} else if (parity_pages == 1) {
 		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
 					sh->sector, sh->dev[sh->pd_idx].log_checksum,
 					0, false);
 		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
-	}
+	} else
+		BUG_ON(parity_pages != 0);
 
 	list_add_tail(&sh->log_list, &io->stripe_list);
 	atomic_inc(&io->pending_stripe);
@@ -455,6 +537,8 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		return -EAGAIN;
 	}
 
+	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
+
 	for (i = 0; i < sh->disks; i++) {
 		void *addr;
 
@@ -1101,6 +1185,39 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 }
 
+int r5c_handle_stripe_dirtying(struct r5conf *conf,
+			       struct stripe_head *sh,
+			       struct stripe_head_state *s,
+			       int disks)
+{
+	struct r5l_log *log = conf->log;
+
+	if (!log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
+		return -EAGAIN;
+
+	if (conf->log->r5c_state == R5C_STATE_WRITE_THROUGH ||
+	    conf->mddev->degraded != 0) {
+		/* write through mode */
+		r5c_freeze_stripe_for_reclaim(sh);
+		return -EAGAIN;
+	}
+	BUG();  /* write back logic in next commit */
+	return 0;
+}
+
+/*
+ * clean up the stripe (clear STRIPE_R5C_FROZEN etc.) after the stripe is
+ * committed to RAID disks
+*/
+void r5c_handle_stripe_written(struct r5conf *conf,
+			       struct stripe_head *sh)
+{
+	if (!test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state))
+		return;
+	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
+	clear_bit(STRIPE_R5C_FROZEN, &sh->state);
+}
+
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
@@ -1236,6 +1353,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
+	log->r5c_state = R5C_STATE_WRITE_THROUGH;
+
 	if (r5l_load_log(log))
 		goto error;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 67d4f49..2e3e61a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3506,6 +3506,9 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	int rmw = 0, rcw = 0, i;
 	sector_t recovery_cp = conf->mddev->recovery_cp;
 
+	if (r5c_handle_stripe_dirtying(conf, sh, s, disks) == 0)
+		return;
+
 	/* Check whether resync is now happening or should start.
 	 * If yes, then the array is dirty (after unclean shutdown or
 	 * initial creation), so parity in some stripes might be inconsistent.
@@ -4396,13 +4399,23 @@ static void handle_stripe(struct stripe_head *sh)
 	    || s.expanding)
 		handle_stripe_fill(sh, &s, disks);
 
-	/* Now to consider new write requests and what else, if anything
-	 * should be read.  We do not handle new writes when:
+	/*
+	 * When the stripe finishes full journal write cycle (write to journal
+	 * and raid disk), this is the clean up procedure so it is ready for
+	 * next operation.
+	 */
+	r5c_handle_stripe_written(conf, sh);
+
+	/*
+	 * Now to consider new write requests, cache write back and what else,
+	 * if anything should be read.  We do not handle new writes when:
 	 * 1/ A 'write' operation (copy+xor) is already in flight.
 	 * 2/ A 'check' operation is in flight, as it may clobber the parity
 	 *    block.
+	 * 3/ A r5c cache log write is in flight.
 	 */
-	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
+	if ((s.to_write || test_bit(STRIPE_R5C_FROZEN, &sh->state)) &&
+	    !sh->reconstruct_state && !sh->check_state && !sh->log_io)
 		handle_stripe_dirtying(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
@@ -5122,6 +5135,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	 * data on failed drives.
 	 */
 	if (rw == READ && mddev->degraded == 0 &&
+	    !r5c_is_writeback(conf->log) &&
 	    mddev->reshape_position == MaxSector) {
 		bi = chunk_aligned_read(mddev, bi);
 		if (!bi)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 46cfe93..8bae64b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -345,7 +345,9 @@ enum {
 	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
 				 * to batch yet.
 				 */
-	STRIPE_LOG_TRAPPED, /* trapped into log */
+	STRIPE_LOG_TRAPPED,	/* trapped into log */
+	STRIPE_R5C_FROZEN,	/* r5c_cache frozen and being written out */
+	STRIPE_R5C_WRITTEN,	/* ready for r5c_handle_stripe_written() */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -712,4 +714,10 @@ extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
+extern bool r5c_is_writeback(struct r5l_log *log);
+extern int
+r5c_handle_stripe_dirtying(struct r5conf *conf, struct stripe_head *sh,
+			   struct stripe_head_state *s, int disks);
+extern void
+r5c_handle_stripe_written(struct r5conf *conf, struct stripe_head *sh);
 #endif
-- 
2.9.3

