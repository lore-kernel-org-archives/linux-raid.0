From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 1/6] md/raid5: drop qd_idx from r6_state
Date: Tue, 24 Mar 2009 19:53:32 +1100
Message-ID: <20090324085331.15383.87055.stgit@notabene.brown>
References: <20090324084629.15383.10271.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090324084629.15383.10271.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We now have this value in stripe_head so we don't need to duplicate
it.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   17 ++++++++---------
 drivers/md/raid5.h |    2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e643fee..3b71f01 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2371,7 +2371,7 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
 		struct r6_state *r6s, int disks)
 {
 	int rcw = 0, must_compute = 0, pd_idx = sh->pd_idx, i;
-	int qd_idx = r6s->qd_idx;
+	int qd_idx = sh->qd_idx;
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Would I have to read this buffer for reconstruct_write */
@@ -2561,7 +2561,7 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 	int update_p = 0, update_q = 0;
 	struct r5dev *dev;
 	int pd_idx = sh->pd_idx;
-	int qd_idx = r6s->qd_idx;
+	int qd_idx = sh->qd_idx;
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 
@@ -2657,7 +2657,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 	struct dma_async_tx_descriptor *tx = NULL;
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
-		if (i != sh->pd_idx && (!r6s || i != r6s->qd_idx)) {
+		if (i != sh->pd_idx && i != sh->qd_idx) {
 			int dd_idx, j;
 			struct stripe_head *sh2;
 
@@ -2984,17 +2984,16 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
 	struct bio *return_bi = NULL;
-	int i, pd_idx = sh->pd_idx;
+	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx;
 	struct stripe_head_state s;
 	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
 	mdk_rdev_t *blocked_rdev = NULL;
 
-	r6s.qd_idx = sh->qd_idx;
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
 		"pd_idx=%d, qd_idx=%d\n",
 	       (unsigned long long)sh->sector, sh->state,
-	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
+	       atomic_read(&sh->count), pd_idx, qd_idx);
 	memset(&s, 0, sizeof(s));
 
 	spin_lock(&sh->lock);
@@ -3105,9 +3104,9 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	pdev = &sh->dev[pd_idx];
 	r6s.p_failed = (s.failed >= 1 && r6s.failed_num[0] == pd_idx)
 		|| (s.failed >= 2 && r6s.failed_num[1] == pd_idx);
-	qdev = &sh->dev[r6s.qd_idx];
-	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == r6s.qd_idx)
-		|| (s.failed >= 2 && r6s.failed_num[1] == r6s.qd_idx);
+	qdev = &sh->dev[qd_idx];
+	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == qd_idx)
+		|| (s.failed >= 2 && r6s.failed_num[1] == qd_idx);
 
 	if ( s.written &&
 	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2934ee0..c2f37f2 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -239,7 +239,7 @@ struct stripe_head_state {
 
 /* r6_state - extra state data only relevant to r6 */
 struct r6_state {
-	int p_failed, q_failed, qd_idx, failed_num[2];
+	int p_failed, q_failed, failed_num[2];
 };
 
 /* Flags */


