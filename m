From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [RFC PATCH 3/4] md: handle IO latency accounting in rqfn mode
Date: Wed,  4 Jun 2014 19:10:01 +0200
Message-ID: <1401901802-16296-4-git-send-email-sebastian.riemer@profitbricks.com>
References: <20140602202050.14903534@notabene.brown>
 <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

From: Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>

Also in the request function mode, the IO latency accounting should
be done. In contrast to the make request mode, it is done per
request.

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>
[spars: changed description, merged commits, fixed checkpatch warnings]
Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |   48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0e5c420..5858af0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -75,6 +75,9 @@ struct md_request_clone {
 	struct mddev	*mdp;
 	struct request	*req;
 	struct bio_list	bios;
+#ifdef BIO_ACCOUNTING_EXTENSION
+	unsigned long	ticks;
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 	atomic_t	cnt;
 	int		err;
 };
@@ -307,18 +310,34 @@ static inline long atomic64_set_if_greater(atomic64_t *v, long val)
 	return old;
 }
 
+static inline void md_account_io_latency(struct mddev *mddev,
+					 unsigned long duration, int rw)
+{
+	struct md_stats *sp = &mddev->stats;
+	unsigned long msecs = jiffies_to_msecs(duration);
+	int idx;
+
+	BUILD_BUG_ON(ARRAY_SIZE(sp->latency_table[0]) != 2);
+	BUILD_BUG_ON(ARRAY_SIZE(sp->max_latency) != 2);
+
+	if (likely(duration > 0) && msecs > 0) {
+		idx = ilog2(msecs) - MD_LATENCY_LOGBASE + 1;
+		idx = clamp(idx, 0, (int)ARRAY_SIZE(sp->latency_table) - 1);
+	} else {
+		idx = 0;
+	}
+	atomic64_set_if_greater(&sp->max_latency[rw], duration);
+	atomic64_inc(&sp->latency_table[idx][rw]);
+}
+
 static void md_bio_endio(struct bio *bio, int err)
 {
 	struct md_bio_private *mbp = bio->bi_private;
 	struct mddev *mddev = mbp->mddev;
-	struct md_stats *sp = &mddev->stats;
 
 	unsigned int sectors = mbp->sectors;
-	int cpu, idx, rw = bio_data_dir(bio);
-	unsigned long ms, ticks;
-
-	BUILD_BUG_ON(ARRAY_SIZE(sp->latency_table[0]) != 2);
-	BUILD_BUG_ON(ARRAY_SIZE(sp->max_latency) != 2);
+	int cpu, rw = bio_data_dir(bio);
+	unsigned long ticks;
 
 	ticks = (long)jiffies - (long)mbp->ticks;
 
@@ -330,15 +349,7 @@ static void md_bio_endio(struct bio *bio, int err)
 	part_round_stats(cpu, &mddev->gendisk->part0);
 	part_stat_unlock();
 
-	ms = jiffies_to_msecs(ticks);
-	if (likely(ticks > 0) && ms > 0) {
-		idx = ilog2(ms) - MD_LATENCY_LOGBASE + 1;
-		idx = clamp(idx, 0, (int)ARRAY_SIZE(sp->latency_table) - 1);
-	} else {
-		idx = 0;
-	}
-	atomic64_set_if_greater(&sp->max_latency[rw], ticks);
-	atomic64_inc(&sp->latency_table[idx][rw]);
+	md_account_io_latency(mddev, ticks, rw);
 
 	bio->bi_private = mbp->orig_bio_private;
 	bio->bi_end_io = mbp->orig_bio_endio;
@@ -463,6 +474,10 @@ static inline void md_make_request_bio(struct mddev *mddev, struct bio *bio)
 static inline void md_request_clone_release(struct md_request_clone *rcl)
 {
 	if (atomic_dec_and_test(&rcl->cnt)) {
+#ifdef BIO_ACCOUNTING_EXTENSION
+		unsigned long diff = (long)jiffies - (long)rcl->ticks;
+		md_account_io_latency(rcl->mdp, diff, rq_data_dir(rcl->req));
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 		blk_end_request_all(rcl->req, rcl->err);
 		kmem_cache_free(md_request_clone_cache, rcl);
 	}
@@ -512,6 +527,9 @@ static inline int md_process_request(struct mddev *mddev, struct request *req)
 	rcl->err = 0;
 	rcl->req = req;
 	rcl->mdp = mddev;
+#ifdef BIO_ACCOUNTING_EXTENSION
+	rcl->ticks = jiffies;
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 	atomic_set(&rcl->cnt, 1);
 	bio_list_init(&rcl->bios);
 	bio = req->bio;
-- 
1.7.9.5

