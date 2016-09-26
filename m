From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/6] r5cache: write part of r5cache
Date: Mon, 26 Sep 2016 16:30:45 -0700
Message-ID: <20160926233050.3351081-2-songliubraving@fb.com>
References: <20160926233050.3351081-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160926233050.3351081-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This is the write part of r5cache. The cache is integrated with
stripe cache of raid456. It leverages code of r5l_log to write
data to journal device.

r5cache split current write path into 2 parts: the write path
and the reclaim path. The write path is as following:
1. write data to journal
   (r5c_handle_stripe_dirtying, r5c_cache_data)
2. call bio_endio
   (r5c_handle_data_cached, r5c_return_dev_pending_writes).

Then the reclaim path is as:
1. Freeze the stripe (r5c_freeze_stripe_for_reclaim)
2. Calcualte parity (reconstruct or RMW)
3. Write parity (and maybe some other data) to journal device
4. Write data and parity to RAID disks

Step 3 and 4 of reclaim path is very similar to write path of
raid5 journal.

With r5cache, write operation does not wait for parity calculation
and write out, so the write latency is lower (1 write to journal
device vs. read and then write to raid disks). Also, r5cache will
reduce RAID overhead (multipile IO due to read-modify-write of
parity) and provide more opportunities of full stripe writes.

r5cache adds 4 flags to stripe_head.state:
 - STRIPE_R5C_PARTIAL_STRIPE,
 - STRIPE_R5C_FULL_STRIPE,
 - STRIPE_R5C_FROZEN and
 - STRIPE_R5C_WRITTEN.

The write path runs w/ STRIPE_R5C_FROZEN == 0. Cache writes start
from r5c_handle_stripe_dirtying(), where bit R5_Wantcache is set
for devices with bio in towrite. Then, the data is written to
the journal through r5l_log implementation. Once the data is in
the journal, we set bit R5_InCache, and presue bio_endio for
these writes.

The reclaim path starts by setting STRIPE_R5C_FROZEN. This makes
the stripe into reclaim. If some write operation arrives at this
time, it will be handled as raid5 journal (calculate parity,
write to jorunal, write to disks, bio_endio).

Once frozen, the stripe is sent back to raid5 state machine,
where handle_stripe_dirtying will evaluate the stripe for
reconstruct writes or RMW writes (read data and calculate parity).

For RMW, the code allocates an extra page for each data block
being updated.  This is stored in r5dev->page and the old data
is read into it.  Then the prexor calculation subtracts ->page
from the parity block, and the reconstruct calculation adds the
->orig_page data back into the parity block.

r5cache naturally excludes SkipCopy. With R5_Wantcache bit set,
async_copy_data will not skip copy.

Before writing data to RAID disks, the r5l_log logic stores
parity (and non-overwrite data) to the journal.

Instead of inactive_list, stripes with cached data are tracked in
r5conf->r5c_full_stripe_list and r5conf->r5c_partial_stripe_list.

There are some known limitations of the cache implementation:

1. Write cache only covers full page writes (R5_OVERWRITE). Writes
   of smaller granularity are write through.
2. Only one log io (sh->log_io) for each stripe at anytime. Later
   writes for the same stripe have to wait. This can be improved by
   moving log_io to r5dev.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 292 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.c       | 187 ++++++++++++++++++++++++++----
 drivers/md/raid5.h       |  31 ++++-
 3 files changed, 479 insertions(+), 31 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 1b1ab4a..6b28461 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -34,12 +34,26 @@
 #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
 #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
 
+/* wake up reclaim thread periodically */
+#define R5C_RECLAIM_WAKEUP_INTERVAL (5 * HZ)
+/* start flush with these full stripes */
+#define R5C_FULL_STRIPE_FLUSH_BATCH 8
+/* reclaim stripes in groups */
+#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
+
 /*
  * We only need 2 bios per I/O unit to make progress, but ensure we
  * have a few more available to not get too tight.
  */
 #define R5L_POOL_SIZE	4
 
+enum r5c_state {
+	R5C_STATE_NO_CACHE = 0,
+	R5C_STATE_WRITE_THROUGH = 1,
+	R5C_STATE_WRITE_BACK = 2,
+	R5C_STATE_CACHE_BROKEN = 3,
+};
+
 struct r5l_log {
 	struct md_rdev *rdev;
 
@@ -96,6 +110,9 @@ struct r5l_log {
 	spinlock_t no_space_stripes_lock;
 
 	bool need_cache_flush;
+
+	/* for r5c_cache */
+	enum r5c_state r5c_state;
 };
 
 /*
@@ -168,12 +185,79 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+/*
+ * Freeze the stripe, thus send the stripe into reclaim path.
+ *
+ * This function should only be called from raid5d that handling this stripe,
+ * or when holds conf->device_lock
+ */
+void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+
+	if (!conf->log)
+		return;
+
+	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
+	set_bit(STRIPE_R5C_FROZEN, &sh->state);
+
+	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		atomic_inc(&conf->preread_active_stripes);
+
+	if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
+		BUG_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
+		atomic_dec(&conf->r5c_cached_partial_stripes);
+	}
+
+	if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
+		BUG_ON(atomic_read(&conf->r5c_cached_full_stripes) == 0);
+		atomic_dec(&conf->r5c_cached_full_stripes);
+	}
+}
+
+static void r5c_handle_data_cached(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = sh->disks; i--; )
+		if (test_and_clear_bit(R5_Wantcache, &sh->dev[i].flags)) {
+			set_bit(R5_InCache, &sh->dev[i].flags);
+			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			atomic_inc(&sh->dev_in_cache);
+		}
+}
+
+/*
+ * this journal write must contain full parity,
+ * it may also contain some data pages
+ */
+static void r5c_handle_parity_cached(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = sh->disks; i--; )
+		if (test_bit(R5_InCache, &sh->dev[i].flags))
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+	set_bit(STRIPE_R5C_WRITTEN, &sh->state);
+}
+
+static void r5c_finish_cache_stripe(struct stripe_head *sh)
+{
+	if (test_bit(STRIPE_R5C_FROZEN, &sh->state))
+		r5c_handle_parity_cached(sh);
+	else
+		r5c_handle_data_cached(sh);
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
@@ -402,7 +486,8 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	io = log->current_io;
 
 	for (i = 0; i < sh->disks; i++) {
-		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
+		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
 			continue;
 		if (i == sh->pd_idx || i == sh->qd_idx)
 			continue;
@@ -412,18 +497,19 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
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
@@ -432,7 +518,6 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	return 0;
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 /*
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
@@ -456,11 +541,17 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		return -EAGAIN;
 	}
 
+	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
+
 	for (i = 0; i < sh->disks; i++) {
 		void *addr;
 
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
+
+		if (test_bit(R5_InCache, &sh->dev[i].flags))
+			continue;
+
 		write_disks++;
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
@@ -473,6 +564,9 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
 
+	pr_debug("%s: write %d data_pages and %d parity_pages\n",
+		 __func__, data_pages, parity_pages);
+
 	meta_size =
 		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
 		 * data_pages) +
@@ -735,7 +829,6 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	}
 }
 
-
 static void r5l_do_reclaim(struct r5l_log *log)
 {
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
@@ -798,7 +891,7 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 	r5l_do_reclaim(log);
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
+void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 {
 	unsigned long target;
 	unsigned long new = (unsigned long)space; /* overflow in theory */
@@ -1111,6 +1204,188 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 }
 
+static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
+{
+	list_del_init(&sh->lru);
+	r5c_freeze_stripe_for_reclaim(sh);
+	atomic_inc(&conf->active_stripes);
+	atomic_inc(&sh->count);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	raid5_release_stripe(sh);
+}
+
+/* if num <= 0, flush all stripes
+ * if num > 0, flush at most num stripes
+ */
+int r5c_flush_cache(struct r5conf *conf, int num)
+{
+	int count = 0;
+	struct stripe_head *sh, *next;
+
+	assert_spin_locked(&conf->device_lock);
+	if (!conf->log)
+		return 0;
+	list_for_each_entry_safe(sh, next, &conf->r5c_full_stripe_list, lru) {
+		r5c_flush_stripe(conf, sh);
+		count++;
+		if (num > 0 && count >= num && count >=
+		    R5C_FULL_STRIPE_FLUSH_BATCH)
+			return count;
+	}
+
+	list_for_each_entry_safe(sh, next, &conf->r5c_partial_stripe_list, lru) {
+		r5c_flush_stripe(conf, sh);
+		count++;
+		if (num > 0 && count == num)
+			return count;
+	}
+	return count;
+}
+
+int r5c_handle_stripe_dirtying(struct r5conf *conf,
+			       struct stripe_head *sh,
+			       struct stripe_head_state *s,
+			       int disks) {
+	struct r5l_log *log = conf->log;
+	int i;
+	struct r5dev *dev;
+
+	if (!log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
+		return -EAGAIN;
+
+	if (conf->log->r5c_state == R5C_STATE_WRITE_THROUGH ||
+	    conf->quiesce != 0 || conf->mddev->degraded != 0) {
+		/* write through mode */
+		r5c_freeze_stripe_for_reclaim(sh);
+		return -EAGAIN;
+	}
+
+	s->to_cache = 0;
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		/* if none-overwrite, use the reclaim path (write through) */
+		if (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags) &&
+		    !test_bit(R5_InCache, &dev->flags)) {
+			r5c_freeze_stripe_for_reclaim(sh);
+			return -EAGAIN;
+		}
+	}
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		if (dev->towrite) {
+			set_bit(R5_Wantcache, &dev->flags);
+			set_bit(R5_Wantdrain, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			s->to_cache++;
+		}
+	}
+
+	if (s->to_cache)
+		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+
+	return 0;
+}
+
+void r5c_handle_stripe_written(struct r5conf *conf,
+			       struct stripe_head *sh) {
+	int i;
+	int do_wakeup = 0;
+
+	if (test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state)) {
+		WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
+		clear_bit(STRIPE_R5C_FROZEN, &sh->state);
+
+		for (i = sh->disks; i--; ) {
+			if (test_and_clear_bit(R5_InCache, &sh->dev[i].flags))
+				atomic_dec(&sh->dev_in_cache);
+			clear_bit(R5_UPTODATE, &sh->dev[i].flags);
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				do_wakeup = 1;
+		}
+	}
+
+	if (do_wakeup)
+		wake_up(&conf->wait_for_overlap);
+}
+
+int
+r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
+	       struct stripe_head_state *s)
+{
+	int pages;
+	int meta_size;
+	int reserve;
+	int i;
+	int ret = 0;
+	int page_count = 0;
+
+	BUG_ON(!log);
+	BUG_ON(s->to_cache == 0);
+
+	for (i = 0; i < sh->disks; i++) {
+		void *addr;
+
+		if (!test_bit(R5_Wantcache, &sh->dev[i].flags))
+			continue;
+		addr = kmap_atomic(sh->dev[i].page);
+		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
+						    addr, PAGE_SIZE);
+		kunmap_atomic(addr);
+		page_count++;
+	}
+	WARN_ON(page_count != s->to_cache);
+
+	pages = s->to_cache;
+
+	meta_size =
+		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
+		 * pages);
+	/* Doesn't work with very big raid array */
+	if (meta_size + sizeof(struct r5l_meta_block) > PAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * The stripe must enter state machine again to call endio, so
+	 * don't delay.
+	 */
+	clear_bit(STRIPE_DELAYED, &sh->state);
+	atomic_inc(&sh->count);
+
+	mutex_lock(&log->io_mutex);
+	/* meta + data */
+	reserve = (1 + pages) << (PAGE_SHIFT - 9);
+	if (!r5l_has_free_space(log, reserve)) {
+		spin_lock(&log->no_space_stripes_lock);
+		list_add_tail(&sh->log_list, &log->no_space_stripes);
+		spin_unlock(&log->no_space_stripes_lock);
+
+		r5l_wake_reclaim(log, reserve);
+	} else {
+		ret = r5l_log_stripe(log, sh, pages, 0);
+		if (ret) {
+			spin_lock_irq(&log->io_list_lock);
+			list_add_tail(&sh->log_list, &log->no_mem_stripes);
+			spin_unlock_irq(&log->io_list_lock);
+		}
+	}
+
+	mutex_unlock(&log->io_mutex);
+	return 0;
+}
+
+void r5c_do_reclaim(struct r5conf *conf)
+{
+	struct r5l_log *log = conf->log;
+
+	assert_spin_locked(&conf->device_lock);
+
+	if (!log)
+		return;
+	r5c_flush_cache(conf, 0);
+}
+
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
@@ -1230,6 +1505,9 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
+	/* flush full stripe */
+	log->r5c_state = R5C_STATE_WRITE_BACK;
+
 	if (r5l_load_log(log))
 		goto error;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f94472d..25b411d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -316,8 +316,25 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			    < IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
-		if (!test_bit(STRIPE_EXPANDING, &sh->state))
-			list_add_tail(&sh->lru, temp_inactive_list);
+		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			if (atomic_read(&sh->dev_in_cache) == 0) {
+				list_add_tail(&sh->lru, temp_inactive_list);
+			} else if (atomic_read(&sh->dev_in_cache) ==
+				   conf->raid_disks - conf->max_degraded) {
+				/* full stripe */
+				if (!test_and_set_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
+					atomic_inc(&conf->r5c_cached_full_stripes);
+				if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
+					atomic_dec(&conf->r5c_cached_partial_stripes);
+				list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
+			} else {
+				/* not full stripe */
+				if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
+						      &sh->state))
+					atomic_inc(&conf->r5c_cached_partial_stripes);
+				list_add_tail(&sh->lru, &conf->r5c_partial_stripe_list);
+			}
+		}
 	}
 }
 
@@ -901,6 +918,13 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	if (s->to_cache) {
+		if (r5c_cache_data(conf->log, sh, s) == 0)
+			return;
+		/* array is too big that meta data size > PAGE_SIZE  */
+		r5c_freeze_stripe_for_reclaim(sh);
+	}
+
 	if (r5l_write_stripe(conf->log, sh) == 0)
 		return;
 	for (i = disks; i--; ) {
@@ -1029,6 +1053,7 @@ again:
 
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
+
 			sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
@@ -1115,7 +1140,7 @@ again:
 static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page **page,
 	sector_t sector, struct dma_async_tx_descriptor *tx,
-	struct stripe_head *sh)
+	struct stripe_head *sh, int no_skipcopy)
 {
 	struct bio_vec bvl;
 	struct bvec_iter iter;
@@ -1155,7 +1180,8 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 			if (frombio) {
 				if (sh->raid_conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
-				    clen == STRIPE_SIZE)
+				    clen == STRIPE_SIZE &&
+				    !no_skipcopy)
 					*page = bio_page;
 				else
 					tx = async_memcpy(*page, bio_page, page_offset,
@@ -1237,7 +1263,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, &dev->page,
-					dev->sector, tx, sh);
+						     dev->sector, tx, sh, 0);
 				rbi = r5_next_bio(rbi, dev->sector);
 			}
 		}
@@ -1364,7 +1390,8 @@ static int set_syndrome_sources(struct page **srcs,
 		if (i == sh->qd_idx || i == sh->pd_idx ||
 		    (srctype == SYNDROME_SRC_ALL) ||
 		    (srctype == SYNDROME_SRC_WANT_DRAIN &&
-		     test_bit(R5_Wantdrain, &dev->flags)) ||
+		     (test_bit(R5_Wantdrain, &dev->flags) ||
+		      test_bit(R5_InCache, &dev->flags))) ||
 		    (srctype == SYNDROME_SRC_WRITTEN &&
 		     dev->written))
 			srcs[slot] = sh->dev[i].page;
@@ -1543,9 +1570,18 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
+
+	for (i = sh->disks; i--; )
+		if (sh->dev[i].page != sh->dev[i].orig_page) {
+			struct page *p = sh->dev[i].page;
+
+			sh->dev[i].page = sh->dev[i].orig_page;
+			put_page(p);
+		}
 }
 
 static struct dma_async_tx_descriptor *
@@ -1567,7 +1603,8 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_Wantdrain, &dev->flags))
+		if (test_bit(R5_Wantdrain, &dev->flags) ||
+		    test_bit(R5_InCache, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -1618,6 +1655,10 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 again:
 			dev = &sh->dev[i];
+			if (test_and_clear_bit(R5_InCache, &dev->flags)) {
+				BUG_ON(atomic_read(&sh->dev_in_cache) == 0);
+				atomic_dec(&sh->dev_in_cache);
+			}
 			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
@@ -1625,7 +1666,8 @@ again:
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
 			spin_unlock_irq(&sh->stripe_lock);
-			WARN_ON(dev->page != dev->orig_page);
+			if (!test_bit(R5_Wantcache, &dev->flags))
+				WARN_ON(dev->page != dev->orig_page);
 
 			while (wbi && wbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -1637,8 +1679,10 @@ again:
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
-						dev->sector, tx, sh);
-					if (dev->page != dev->orig_page) {
+							     dev->sector, tx, sh,
+							     test_bit(R5_Wantcache, &dev->flags));
+					if (dev->page != dev->orig_page &&
+					    !test_bit(R5_Wantcache, &dev->flags)) {
 						set_bit(R5_SkipCopy, &dev->flags);
 						clear_bit(R5_UPTODATE, &dev->flags);
 						clear_bit(R5_OVERWRITE, &dev->flags);
@@ -1746,7 +1790,8 @@ again:
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (head_sh->dev[i].written)
+			if (head_sh->dev[i].written ||
+			    test_bit(R5_InCache, &head_sh->dev[i].flags))
 				xor_srcs[count++] = dev->page;
 		}
 	} else {
@@ -2001,6 +2046,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
 		atomic_set(&sh->count, 1);
+		atomic_set(&sh->dev_in_cache, 0);
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
 
@@ -2887,6 +2933,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InCache, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		/* if we are not expanding this is a proper write request, and
@@ -2926,6 +2975,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				set_bit(R5_LOCKED, &dev->flags);
 				clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InCache, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		if (!s->locked)
@@ -3577,6 +3629,9 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	int rmw = 0, rcw = 0, i;
 	sector_t recovery_cp = conf->mddev->recovery_cp;
 
+	if (r5c_handle_stripe_dirtying(conf, sh, s, disks) == 0)
+		return;
+
 	/* Check whether resync is now happening or should start.
 	 * If yes, then the array is dirty (after unclean shutdown or
 	 * initial creation), so parity in some stripes might be inconsistent.
@@ -3597,9 +3652,12 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx ||
+		     test_bit(R5_InCache, &dev->flags)) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		    !((test_bit(R5_UPTODATE, &dev->flags) &&
+		       (!test_bit(R5_InCache, &dev->flags) ||
+			dev->page != dev->orig_page)) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
@@ -3611,13 +3669,15 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 		    i != sh->pd_idx && i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		    test_bit(R5_Wantcompute, &dev->flags))) {
+		      test_bit(R5_InCache, &dev->flags) ||
+		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rcw++;
 			else
 				rcw += 2*disks;
 		}
 	}
+
 	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
 		(unsigned long long)sh->sector, rmw, rcw);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -3629,10 +3689,18 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+			if (test_bit(R5_InCache, &dev->flags) &&
+			    dev->page == dev->orig_page)
+				dev->page = alloc_page(GFP_NOIO);  /* prexor */
+
+			if ((dev->towrite ||
+			     i == sh->pd_idx || i == sh->qd_idx ||
+			     test_bit(R5_InCache, &dev->flags)) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    !((test_bit(R5_UPTODATE, &dev->flags) &&
+			       (!test_bit(R5_InCache, &dev->flags) ||
+				dev->page != dev->orig_page)) ||
+			      test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (test_bit(STRIPE_PREREAD_ACTIVE,
 					     &sh->state)) {
@@ -3658,6 +3726,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			      test_bit(R5_InCache, &dev->flags) ||
 			      test_bit(R5_Wantcompute, &dev->flags))) {
 				rcw++;
 				if (test_bit(R5_Insync, &dev->flags) &&
@@ -3697,7 +3766,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	 */
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
+	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		schedule_reconstruction(sh, s, rcw == 0, 0);
 }
 
@@ -4010,6 +4079,45 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 	async_tx_quiesce(&tx);
 }
 
+static void
+r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
+			      struct bio_list *return_bi)
+{
+	struct bio *wbi, *wbi2;
+
+	wbi = dev->written;
+	dev->written = NULL;
+	while (wbi && wbi->bi_iter.bi_sector <
+	       dev->sector + STRIPE_SECTORS) {
+		wbi2 = r5_next_bio(wbi, dev->sector);
+		if (!raid5_dec_bi_active_stripes(wbi)) {
+			md_write_end(conf->mddev);
+			bio_list_add(return_bi, wbi);
+		}
+		wbi = wbi2;
+	}
+}
+
+static void r5c_handle_cached_data_endio(struct r5conf *conf,
+	  struct stripe_head *sh, int disks, struct bio_list *return_bi)
+{
+	int i;
+
+	for (i = sh->disks; i--; ) {
+		if (test_bit(R5_InCache, &sh->dev[i].flags) &&
+		    sh->dev[i].written) {
+			set_bit(R5_UPTODATE, &sh->dev[i].flags);
+			r5c_return_dev_pending_writes(conf, &sh->dev[i],
+						      return_bi);
+			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+					STRIPE_SECTORS,
+					!test_bit(STRIPE_DEGRADED, &sh->state),
+					0);
+		}
+	}
+	r5l_stripe_write_finished(sh);
+}
+
 /*
  * handle_stripe - do things to a stripe.
  *
@@ -4188,6 +4296,10 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			if (rdev && !test_bit(Faulty, &rdev->flags))
 				do_recovery = 1;
 		}
+		if (test_bit(R5_InCache, &dev->flags) && dev->written)
+			s->just_cached++;
+		if (test_bit(R5_Wantcache, &dev->flags) && dev->written)
+			s->want_cache++;
 	}
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
@@ -4353,6 +4465,16 @@ static void handle_stripe(struct stripe_head *sh)
 
 	analyse_stripe(sh, &s);
 
+	if (s.want_cache) {
+		/* we have finished r5c_handle_stripe_dirtying and
+		 * ops_run_biodrain, but r5c_cache_data didn't finish because
+		 * the journal device didn't have enough space. This time we
+		 * should skip handle_stripe_dirtying and ops_run_biodrain
+		 */
+		s.to_cache = s.want_cache;
+		goto finish;
+	}
+
 	if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 		goto finish;
 
@@ -4416,7 +4538,7 @@ static void handle_stripe(struct stripe_head *sh)
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_LOCKED, &dev->flags) &&
 				(i == sh->pd_idx || i == sh->qd_idx ||
-				 dev->written)) {
+				 dev->written || test_bit(R5_InCache, &dev->flags))) {
 				pr_debug("Writing block %d\n", i);
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
@@ -4456,6 +4578,12 @@ static void handle_stripe(struct stripe_head *sh)
 				 test_bit(R5_Discard, &qdev->flags))))))
 		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
 
+	if (s.just_cached)
+		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
+
+	if (test_bit(STRIPE_R5C_FROZEN, &sh->state))
+		r5l_stripe_write_finished(sh);
+
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
@@ -4467,13 +4595,17 @@ static void handle_stripe(struct stripe_head *sh)
 	    || s.expanding)
 		handle_stripe_fill(sh, &s, disks);
 
-	/* Now to consider new write requests and what else, if anything
-	 * should be read.  We do not handle new writes when:
+	r5c_handle_stripe_written(conf, sh);
+
+	/* Now to consider new write requests, cache write back and what else,
+	 * if anything should be read.  We do not handle new writes when:
 	 * 1/ A 'write' operation (copy+xor) is already in flight.
 	 * 2/ A 'check' operation is in flight, as it may clobber the parity
 	 *    block.
+	 * 3/ A r5c cache log write is in flight.
 	 */
-	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
+	if ((s.to_write || test_bit(STRIPE_R5C_FROZEN, &sh->state)) &&
+	     !sh->reconstruct_state && !sh->check_state && !sh->log_io)
 		handle_stripe_dirtying(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
@@ -5192,7 +5324,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	 * later we might have to read it again in order to reconstruct
 	 * data on failed drives.
 	 */
-	if (rw == READ && mddev->degraded == 0 &&
+	if (rw == READ && mddev->degraded == 0 && conf->log == NULL &&
 	    mddev->reshape_position == MaxSector) {
 		bi = chunk_aligned_read(mddev, bi);
 		if (!bi)
@@ -5917,6 +6049,7 @@ static void raid5d(struct md_thread *thread)
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
 		}
+		r5c_do_reclaim(conf);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
@@ -6583,6 +6716,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
 		INIT_LIST_HEAD(conf->temp_inactive_list + i);
 
+	atomic_set(&conf->r5c_cached_full_stripes, 0);
+	INIT_LIST_HEAD(&conf->r5c_full_stripe_list);
+	atomic_set(&conf->r5c_cached_partial_stripes, 0);
+	INIT_LIST_HEAD(&conf->r5c_partial_stripe_list);
+
 	conf->level = mddev->new_level;
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	if (raid5_alloc_percpu(conf) != 0)
@@ -7662,8 +7800,11 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
 		 */
+		r5c_flush_cache(conf, 0);
 		conf->quiesce = 2;
 		wait_event_cmd(conf->wait_for_quiescent,
+				    atomic_read(&conf->r5c_cached_partial_stripes) == 0 &&
+				    atomic_read(&conf->r5c_cached_full_stripes) == 0 &&
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
 				    unlock_all_device_hash_locks_irq(conf),
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 517d4b6..71e67ba 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -226,6 +226,7 @@ struct stripe_head {
 
 	struct r5l_io_unit	*log_io;
 	struct list_head	log_list;
+	atomic_t		dev_in_cache;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -263,6 +264,7 @@ struct stripe_head_state {
 	 */
 	int syncing, expanding, expanded, replacing;
 	int locked, uptodate, to_read, to_write, failed, written;
+	int to_cache, want_cache, just_cached;
 	int to_fill, compute, req_compute, non_overwrite;
 	int failed_num[2];
 	int p_failed, q_failed;
@@ -313,6 +315,8 @@ enum r5dev_flags {
 			 */
 	R5_Discard,	/* Discard the stripe */
 	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
+	R5_Wantcache,	/* Want write data to write cache */
+	R5_InCache,	/* Data in cache */
 };
 
 /*
@@ -345,7 +349,13 @@ enum {
 	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
 				 * to batch yet.
 				 */
-	STRIPE_LOG_TRAPPED, /* trapped into log */
+	STRIPE_LOG_TRAPPED,	/* trapped into log */
+	STRIPE_R5C_PARTIAL_STRIPE,	/* in r5c cache (to-be/being handled or
+					 * in conf->r5c_partial_stripe_list) */
+	STRIPE_R5C_FULL_STRIPE,	/* in r5c cache (to-be/being handled or
+				 * in conf->r5c_full_stripe_list) */
+	STRIPE_R5C_FROZEN,	/* r5c_cache frozen and being written out */
+	STRIPE_R5C_WRITTEN,	/* ready for r5c_handle_stripe_written() */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -521,6 +531,12 @@ struct r5conf {
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
+
+	atomic_t		r5c_cached_full_stripes;
+	struct list_head	r5c_full_stripe_list;
+	atomic_t		r5c_cached_partial_stripes;
+	struct list_head	r5c_partial_stripe_list;
+
 	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_quiescent;
@@ -635,4 +651,17 @@ extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
+extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
+extern int
+r5c_handle_stripe_dirtying(struct r5conf *conf, struct stripe_head *sh,
+			   struct stripe_head_state *s, int disks);
+extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
+			  struct stripe_head_state *s);
+extern int r5c_cache_parity(struct r5l_log *log, struct stripe_head *sh,
+			    struct stripe_head_state *s);
+extern void
+r5c_handle_stripe_written(struct r5conf *conf, struct stripe_head *sh);
+extern void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh);
+extern void r5c_do_reclaim(struct r5conf *conf);
+extern int r5c_flush_cache(struct r5conf *conf, int num);
 #endif
-- 
2.9.3

