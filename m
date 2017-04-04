From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 2/4] raid5-ppl: move no_mem_stripes to struct ppl_conf
Date: Tue,  4 Apr 2017 13:13:56 +0200
Message-ID: <20170404111358.14829-3-artur.paszkiewicz@intel.com>
References: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Use a single no_mem_stripes list instead of per member device lists for
handling stripes that need retrying in case of failed io_unit
allocation. Because io_units are allocated from a memory pool shared
between all member disks, the no_mem_stripes list should be checked when
an io_unit for any member is freed. This fixes a deadlock that could
happen if there are stripes in more than one no_mem_stripes list.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 42e43467d1e8..0a39a6bbcbde 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -106,6 +106,10 @@ struct ppl_conf {
 	/* used only for recovery */
 	int recovered_entries;
 	int mismatch_count;
+
+	/* stripes to retry if failed to allocate io_unit */
+	struct list_head no_mem_stripes;
+	spinlock_t no_mem_stripes_lock;
 };
 
 struct ppl_log {
@@ -118,8 +122,6 @@ struct ppl_log {
 					 * always at the end of io_list */
 	spinlock_t io_list_lock;
 	struct list_head io_list;	/* all io_units of this log */
-	struct list_head no_mem_stripes;/* stripes to retry if failed to
-					 * allocate io_unit */
 };
 
 #define PPL_IO_INLINE_BVECS 32
@@ -374,9 +376,9 @@ int ppl_write_stripe(struct r5conf *conf, struct stripe_head *sh)
 	atomic_inc(&sh->count);
 
 	if (ppl_log_stripe(log, sh)) {
-		spin_lock_irq(&log->io_list_lock);
-		list_add_tail(&sh->log_list, &log->no_mem_stripes);
-		spin_unlock_irq(&log->io_list_lock);
+		spin_lock_irq(&ppl_conf->no_mem_stripes_lock);
+		list_add_tail(&sh->log_list, &ppl_conf->no_mem_stripes);
+		spin_unlock_irq(&ppl_conf->no_mem_stripes_lock);
 	}
 
 	mutex_unlock(&log->io_mutex);
@@ -517,25 +519,32 @@ void ppl_write_stripe_run(struct r5conf *conf)
 static void ppl_io_unit_finished(struct ppl_io_unit *io)
 {
 	struct ppl_log *log = io->log;
+	struct ppl_conf *ppl_conf = log->ppl_conf;
 	unsigned long flags;
 
 	pr_debug("%s: seq: %llu\n", __func__, io->seq);
 
-	spin_lock_irqsave(&log->io_list_lock, flags);
+	local_irq_save(flags);
 
+	spin_lock(&log->io_list_lock);
 	list_del(&io->log_sibling);
-	mempool_free(io, log->ppl_conf->io_pool);
+	spin_unlock(&log->io_list_lock);
+
+	mempool_free(io, ppl_conf->io_pool);
+
+	spin_lock(&ppl_conf->no_mem_stripes_lock);
+	if (!list_empty(&ppl_conf->no_mem_stripes)) {
+		struct stripe_head *sh;
 
-	if (!list_empty(&log->no_mem_stripes)) {
-		struct stripe_head *sh = list_first_entry(&log->no_mem_stripes,
-							  struct stripe_head,
-							  log_list);
+		sh = list_first_entry(&ppl_conf->no_mem_stripes,
+				      struct stripe_head, log_list);
 		list_del_init(&sh->log_list);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
+	spin_unlock(&ppl_conf->no_mem_stripes_lock);
 
-	spin_unlock_irqrestore(&log->io_list_lock, flags);
+	local_irq_restore(flags);
 }
 
 void ppl_stripe_write_finished(struct stripe_head *sh)
@@ -1154,6 +1163,8 @@ int ppl_init_log(struct r5conf *conf)
 	}
 
 	atomic64_set(&ppl_conf->seq, 0);
+	INIT_LIST_HEAD(&ppl_conf->no_mem_stripes);
+	spin_lock_init(&ppl_conf->no_mem_stripes_lock);
 
 	if (!mddev->external) {
 		ppl_conf->signature = ~crc32c_le(~0, mddev->uuid, sizeof(mddev->uuid));
@@ -1169,7 +1180,6 @@ int ppl_init_log(struct r5conf *conf)
 		mutex_init(&log->io_mutex);
 		spin_lock_init(&log->io_list_lock);
 		INIT_LIST_HEAD(&log->io_list);
-		INIT_LIST_HEAD(&log->no_mem_stripes);
 
 		log->ppl_conf = ppl_conf;
 		log->rdev = rdev;
-- 
2.11.0

