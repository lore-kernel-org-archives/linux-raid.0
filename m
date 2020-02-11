From: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Subject: [PATCH v2 1/2] block: reintroduce polling on bio level
Date: Tue, 11 Feb 2020 12:17:28 -0700
Message-ID: <20200211191729.4745-2-andrzej.jakowski@linux.intel.com>
References: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, song@kernel.org
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@linux.intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

In current implementation it is possible to perform IO polling if
underlying device is block-mq device. It is not possible however to do
polled IO on stackable block devices like MD.

This patch does following:
 - reintroduces polling on bio level that was removed some time ago.
   Implementation for that has been pulled from commit
   529262d56dbe ("block: remove ->poll_fn").

 - modifies blk_poll() to introduce fastpath access for blk_mq_poll().
   In other words bio_poll() calls poll_fn() for stackable block
   devices supporting polling, otherwise it invokes blk_mq_poll()
   directly.

We managed to collect performance data on RAID-0 volume built on top of
2xP4800X devices with polling on and off. Here are results for pvsync2:

Polling      QD       Latency         IOPS
----------------------------------------------
off           1       12.20us         78400
on            1        8.80us        111000

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 block/blk-core.c       | 28 ++++++++++++++++++++++++++++
 block/blk-mq.c         | 23 ++---------------------
 block/blk-mq.h         |  2 ++
 include/linux/blkdev.h |  2 ++
 4 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 089e890ab208..48001538de92 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1201,6 +1201,34 @@ blk_qc_t submit_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
+/**
+ * blk_poll - poll for IO completions
+ * @q:  the queue
+ * @cookie: cookie passed back at IO submission time
+ * @spin: whether to spin for completions
+ *
+ * Description:
+ *    Poll for completions on the passed in queue. Returns number of
+ *    completed entries found. If @spin is true, then blk_poll will continue
+ *    looping until at least one completion is found, unless the task is
+ *    otherwise marked running (or we need to reschedule).
+ */
+int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+{
+	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags) ||
+	    !blk_qc_t_valid(cookie))
+		return 0;
+
+	if (current->plug)
+		blk_flush_plug_list(current->plug, false);
+
+	if (q->poll_fn)
+		return q->poll_fn(q, cookie, spin);
+
+	return blk_mq_poll(q, cookie, spin);
+}
+EXPORT_SYMBOL_GPL(blk_poll);
+
 /**
  * blk_cloned_rq_check_limits - Helper function to check a cloned request
  *                              for new the queue limits
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a12b1763508d..868aab100692 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3509,30 +3509,11 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
 	return blk_mq_poll_hybrid_sleep(q, hctx, rq);
 }
 
-/**
- * blk_poll - poll for IO completions
- * @q:  the queue
- * @cookie: cookie passed back at IO submission time
- * @spin: whether to spin for completions
- *
- * Description:
- *    Poll for completions on the passed in queue. Returns number of
- *    completed entries found. If @spin is true, then blk_poll will continue
- *    looping until at least one completion is found, unless the task is
- *    otherwise marked running (or we need to reschedule).
- */
-int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 {
 	struct blk_mq_hw_ctx *hctx;
 	long state;
 
-	if (!blk_qc_t_valid(cookie) ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
-		return 0;
-
-	if (current->plug)
-		blk_flush_plug_list(current->plug, false);
-
 	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
 	/*
@@ -3573,7 +3554,7 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	__set_current_state(TASK_RUNNING);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(blk_poll);
+EXPORT_SYMBOL_GPL(blk_mq_poll);
 
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
diff --git a/block/blk-mq.h b/block/blk-mq.h
index eaaca8fc1c28..def2f85926b2 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -75,6 +75,8 @@ blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last);
 void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 				    struct list_head *list);
 
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
+
 /*
  * CPU -> queue mappings
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 053ea4b51988..ab703d655be0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -288,6 +288,7 @@ static inline unsigned short req_get_ioprio(struct request *req)
 struct blk_queue_ctx;
 
 typedef blk_qc_t (make_request_fn) (struct request_queue *q, struct bio *bio);
+typedef int (poll_q_fn) (struct request_queue *q, blk_qc_t, bool spin);
 
 struct bio_vec;
 typedef int (dma_drain_needed_fn)(struct request *);
@@ -399,6 +400,7 @@ struct request_queue {
 	struct rq_qos		*rq_qos;
 
 	make_request_fn		*make_request_fn;
+	poll_q_fn		*poll_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 
 	const struct blk_mq_ops	*mq_ops;
-- 
2.20.1
