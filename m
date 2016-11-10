From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 03/11] md/r5cache: State machine for raid5-cache write back mode
Date: Thu, 10 Nov 2016 12:46:15 -0800
Message-ID: <20161110204623.3484694-4-songliubraving@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This patch adds state machine for raid5-cache. With log device, the
raid456 array could operate in two different modes (r5c_journal_mode):
  - write-back (R5C_MODE_WRITE_BACK)
  - write-through (R5C_MODE_WRITE_THROUGH)

Existing code of raid5-cache only has write-through mode. For write-back
cache, it is necessary to extend the state machine.

With write-back cache, every stripe could operate in two different
modes:
  - caching
  - writing-out

In caching mode, the stripe handles writes as:
  - write to journal
  - return IO

In writing-out mode, the stripe behaviors as a stripe in write through
mode R5C_MODE_WRITE_THROUGH.

STRIPE_R5C_WRITE_OUT is added to sh->state to differentiate caching and
writing-out mode.

When the array is write-through, stripes also go between caching mode
and writing-out mode.

Please note: this is a "no-op" patch for raid5-cache write-through
mode.

The following detailed explanation is copied from the raid5-cache.c:

/*
 * raid5 cache state machine
 *
 * With rhe RAID cache, each stripe works in two modes:
 *      - caching mode
 *      - writing-out mode
 *
 * These two modes are controlled by bit STRIPE_R5C_WRITE_OUT:
 *   if STRIPE_R5C_WRITE_OUT == 0, the stripe is in caching mode
 *   if STRIPE_R5C_WRITE_OUT == 1, the stripe is in writing-out mode

 * r5c_make_stripe_write_out() and r5c_finish_stripe_write_out() handles the
 * transition between caching and writing-out mode.
 *
 * Stripes in caching mode do not write the raid disks. Instead, all writes
 * are committed from the log device. Therefore, a stripe in caching mode
 * handles writes as:
 *      - write to log device
 *      - return IO
 *
 * Stripes in writing-out mode handle writes as:
 *      - calculate parity
 *      - write pending data and parity to journal
 *      - write data and parity to raid disks
 *      - return IO for pending writes
 *
 * All stripes starts with caching mode. If the array is write-through
 * (R5C_JOURNAL_MODE_WRITE_THROUGH), all stripes enter writing-out mode for
 * every write in r5c_handle_stripe_dirtying().
 */

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 142 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c       |  20 ++++++-
 drivers/md/raid5.h       |  12 +++-
 3 files changed, 167 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7ebf665..5876727 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -40,6 +40,47 @@
  */
 #define R5L_POOL_SIZE	4
 
+/*
+ * r5c journal modes of the array: write-back or write-through.
+ * write-through mode has identical behavior as existing log only
+ * implementation.
+ */
+enum r5c_journal_mode {
+	R5C_JOURNAL_MODE_WRITE_THROUGH = 0,
+	R5C_JOURNAL_MODE_WRITE_BACK = 1,
+};
+
+/*
+ * raid5 cache state machine
+ *
+ * With rhe RAID cache, each stripe works in two modes:
+ *	- caching mode
+ *	- writing-out mode
+ *
+ * These two modes are controlled by bit STRIPE_R5C_WRITE_OUT:
+ *   if STRIPE_R5C_WRITE_OUT == 0, the stripe is in caching mode
+ *   if STRIPE_R5C_WRITE_OUT == 1, the stripe is in writing-out mode
+
+ * r5c_make_stripe_write_out() and r5c_finish_stripe_write_out() handles the
+ * transition between caching and writing-out mode.
+ *
+ * Stripes in caching mode do not write the raid disks. Instead, all writes
+ * are committed from the log device. Therefore, a stripe in caching mode
+ * handles writes as:
+ *	- write to log device
+ *	- return IO
+ *
+ * Stripes in writing-out mode handle writes as:
+ *	- calculate parity
+ *	- write pending data and parity to journal
+ *	- write data and parity to raid disks
+ *	- return IO for pending writes
+ *
+ * All stripes starts with caching mode. If the array is write-through
+ * (R5C_JOURNAL_MODE_WRITE_THROUGH), all stripes enter writing-out mode for
+ * every write in r5c_handle_stripe_dirtying().
+ */
+
 struct r5l_log {
 	struct md_rdev *rdev;
 
@@ -96,6 +137,9 @@ struct r5l_log {
 	spinlock_t no_space_stripes_lock;
 
 	bool need_cache_flush;
+
+	/* for r5c_cache */
+	enum r5c_journal_mode r5c_journal_mode;
 };
 
 /*
@@ -133,6 +177,12 @@ enum r5l_io_unit_state {
 	IO_UNIT_STRIPE_END = 3,	/* stripes data finished writing to raid */
 };
 
+bool r5c_is_writeback(struct r5l_log *log)
+{
+	return (log != NULL &&
+		log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_BACK);
+}
+
 static sector_t r5l_ring_add(struct r5l_log *log, sector_t start, sector_t inc)
 {
 	start += inc;
@@ -168,12 +218,54 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+/*
+ * Put the stripe into writing-out mode by setting STRIPE_R5C_WRITE_OUT.
+ *
+ * Note: when the array is in write-through, each stripe still goes through
+ * caching mode and writing-out mode. In such cases, this function is called
+ * in r5c_handle_stripe_dirtying().
+ */
+static void r5c_make_stripe_write_out(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
+
+	if (!log)
+		return;
+	WARN_ON(test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
+	set_bit(STRIPE_R5C_WRITE_OUT, &sh->state);
+}
+
+/*
+ * Setting proper flags after writing (or flushing) data and/or parity to the
+ * log device. This is called from r5l_log_endio() or r5l_log_flush_endio().
+ */
+static void r5c_finish_cache_stripe(struct stripe_head *sh)
+{
+	struct r5l_log *log = sh->raid_conf->log;
+
+	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
+		BUG_ON(!test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
+		/*
+		 * Set R5_InJournal for parity dev[pd_idx]. This means parity
+		 * is in the journal. For RAID 6, it is NOT necessary to set
+		 * the flag for dev[qd_idx], as the two parities are written
+		 * out together.
+		 */
+		set_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags);
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
@@ -412,18 +504,19 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
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
+	} else  /* Just writing data, not parity, in caching mode */
+		BUG_ON(parity_pages != 0);
 
 	list_add_tail(&sh->log_list, &io->stripe_list);
 	atomic_inc(&io->pending_stripe);
@@ -455,6 +548,8 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		return -EAGAIN;
 	}
 
+	WARN_ON(!test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
+
 	for (i = 0; i < sh->disks; i++) {
 		void *addr;
 
@@ -1100,6 +1195,45 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 }
 
+int r5c_handle_stripe_dirtying(struct r5conf *conf,
+			       struct stripe_head *sh,
+			       struct stripe_head_state *s,
+			       int disks)
+{
+	struct r5l_log *log = conf->log;
+
+	if (!log || test_bit(STRIPE_R5C_WRITE_OUT, &sh->state))
+		return -EAGAIN;
+
+	if (conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
+		/* write-through mode */
+		r5c_make_stripe_write_out(sh);
+		return -EAGAIN;
+	}
+	BUG();  /* write back logic in next commit */
+	return 0;
+}
+
+/*
+ * clean up the stripe (clear STRIPE_R5C_WRITE_OUT etc.) after the stripe is
+ * committed to RAID disks.
+ */
+void r5c_finish_stripe_write_out(struct r5conf *conf,
+				 struct stripe_head *sh)
+{
+	if (!test_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags))
+		return;
+
+	WARN_ON(!test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
+	clear_bit(STRIPE_R5C_WRITE_OUT, &sh->state);
+	clear_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags);
+
+	if (conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
+		return;
+	BUG();  /* write-back logic in coming patches */
+}
+
+
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
@@ -1237,6 +1371,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
+	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+
 	if (r5l_load_log(log))
 		goto error;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 34895f3..abb2c58 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3496,6 +3496,9 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	int rmw = 0, rcw = 0, i;
 	sector_t recovery_cp = conf->mddev->recovery_cp;
 
+	if (r5c_handle_stripe_dirtying(conf, sh, s, disks) == 0)
+		return;
+
 	/* Check whether resync is now happening or should start.
 	 * If yes, then the array is dirty (after unclean shutdown or
 	 * initial creation), so parity in some stripes might be inconsistent.
@@ -4386,13 +4389,23 @@ static void handle_stripe(struct stripe_head *sh)
 	    || s.expanding)
 		handle_stripe_fill(sh, &s, disks);
 
-	/* Now to consider new write requests and what else, if anything
-	 * should be read.  We do not handle new writes when:
+	/*
+	 * When the stripe finishes full journal write cycle (write to journal
+	 * and raid disk), this is the clean up procedure so it is ready for
+	 * next operation.
+	 */
+	r5c_finish_stripe_write_out(conf, sh);
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
+	if ((s.to_write || test_bit(STRIPE_R5C_WRITE_OUT, &sh->state)) &&
+	    !sh->reconstruct_state && !sh->check_state && !sh->log_io)
 		handle_stripe_dirtying(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
@@ -5110,6 +5123,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	 * data on failed drives.
 	 */
 	if (rw == READ && mddev->degraded == 0 &&
+	    !r5c_is_writeback(conf->log) &&
 	    mddev->reshape_position == MaxSector) {
 		bi = chunk_aligned_read(mddev, bi);
 		if (!bi)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index ffc13c4..b379496 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -313,6 +313,7 @@ enum r5dev_flags {
 			 */
 	R5_Discard,	/* Discard the stripe */
 	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
+	R5_InJournal,	/* data being written is in the journal device */
 };
 
 /*
@@ -345,7 +346,10 @@ enum {
 	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
 				 * to batch yet.
 				 */
-	STRIPE_LOG_TRAPPED, /* trapped into log */
+	STRIPE_LOG_TRAPPED,	/* trapped into log */
+	STRIPE_R5C_WRITE_OUT,	/* the stripe is in writing-out mode
+				 * see more detail in the raid5-cache.c
+				 */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -710,4 +714,10 @@ extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
+extern bool r5c_is_writeback(struct r5l_log *log);
+extern int
+r5c_handle_stripe_dirtying(struct r5conf *conf, struct stripe_head *sh,
+			   struct stripe_head_state *s, int disks);
+extern void
+r5c_finish_stripe_write_out(struct r5conf *conf, struct stripe_head *sh);
 #endif
-- 
2.9.3

