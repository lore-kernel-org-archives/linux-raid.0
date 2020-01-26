From: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Subject: [PATCH 1/2] block: introduce polling on bio level
Date: Sat, 25 Jan 2020 21:41:37 -0700
Message-ID: <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, song@kernel.org
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@linux.intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

In current implementation it is possible to perform IO polling if
underlying device is block-mq device. Is is not possible however to do
polled IO on stackable block devices like MD.

We have explored two paths for enabling IO polling on bio devices. First
idea revolved around rewriting MD to block-mq interface but it proved to
be complex. In the second idea we have built a prototype which
introduced new operation on request_queue - bio_poll_fn. bio_poll_fn if
provided by stackable block driver is called when user polls for IO
completion. bio_poll_fn approach was initially discussed and confirmed
with Jens.

We managed to collect performance data on RAID-0 volume built on top of
2xP4800X devices with polling on and off. Here are the results:
Polling      QD       Latency         IOPS
----------------------------------------------
off           1       12.03us         78800
off           2       13.27us        144000
off           4       15.83us        245000
off           8       31.14us        253000
off          16       63.03us        252000
off          32      128.89us        247000
off          64      259.10us        246000
off         128      517.27us        247000
on            1        9.00us        108000
on            2        9.07us        214000
on            4       12.00us        327000
on            8       21.43us        369000
on           16       43.18us        369000
on           32       85.75us        372000
on           64      169.87us        376000
on          128      346.15us        370000

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 block/blk-core.c       |  3 ++-
 block/blk-mq.c         | 26 ++++++++++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e0a094fddee5..5d8706dfebe0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -889,7 +889,8 @@ generic_make_request_checks(struct bio *bio)
 	 * if queue is not a request based queue.
 	 */
 	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
-		goto not_supported;
+		if (!(bio->bi_opf & REQ_HIPRI))
+			goto not_supported;
 
 	if (should_fail_bio(bio))
 		goto end_io;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a12b1763508d..ebbb88a336a7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3533,6 +3533,32 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	if (current->plug)
 		blk_flush_plug_list(current->plug, false);
 
+	if (q->bio_poll_fn != NULL) {
+		state = current->state;
+		do {
+			int ret;
+
+			ret = q->bio_poll_fn(q, cookie);
+			if (ret > 0) {
+				__set_current_state(TASK_RUNNING);
+				return ret;
+			}
+
+			if (signal_pending_state(state, current))
+				__set_current_state(TASK_RUNNING);
+
+			if (current->state == TASK_RUNNING)
+				return 1;
+			if (ret < 0 || !spin)
+				break;
+			cpu_relax();
+		} while (!need_resched());
+
+		__set_current_state(TASK_RUNNING);
+
+		return 0;
+	}
+
 	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 47eb22a3b7f9..1c21c3ff3ad1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -287,6 +287,7 @@ static inline unsigned short req_get_ioprio(struct request *req)
 
 struct blk_queue_ctx;
 
+typedef int (bio_poll_fn) (struct request_queue *q, blk_qc_t cookie);
 typedef blk_qc_t (make_request_fn) (struct request_queue *q, struct bio *bio);
 
 struct bio_vec;
@@ -398,6 +399,7 @@ struct request_queue {
 	struct blk_queue_stats	*stats;
 	struct rq_qos		*rq_qos;
 
+	bio_poll_fn		*bio_poll_fn;
 	make_request_fn		*make_request_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 
-- 
2.20.1
