From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 3/9] md/raid5, 6: common schedule_reconstruction for raid5/6
Date: Mon, 31 Aug 2009 09:41:19 -0700
Message-ID: <20090831164119.1696.22546.stgit@dwillia2-linux.ch.intel.com>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

From: Yuri Tikhonov <yur@emcraft.com>

Extend schedule_reconstruction5 for reuse by the raid6 path.  Add
support for generating Q and BUG() if a request is made to perform
'prexor'.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e68616e..a1245cf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2175,10 +2175,12 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 }
 
 static void
-schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
+schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			 int rcw, int expand)
 {
 	int i, pd_idx = sh->pd_idx, disks = sh->disks;
+	raid5_conf_t *conf = sh->raid_conf;
+	int level = conf->level;
 
 	if (rcw) {
 		/* if we are not expanding this is a proper write request, and
@@ -2204,10 +2206,11 @@ schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
 				s->locked++;
 			}
 		}
-		if (s->locked + 1 == disks)
+		if (s->locked + conf->max_degraded == disks)
 			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
-				atomic_inc(&sh->raid_conf->pending_full_writes);
+				atomic_inc(&conf->pending_full_writes);
 	} else {
+		BUG_ON(level == 6);
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
 
@@ -2232,13 +2235,22 @@ schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
 		}
 	}
 
-	/* keep the parity disk locked while asynchronous operations
+	/* keep the parity disk(s) locked while asynchronous operations
 	 * are in flight
 	 */
 	set_bit(R5_LOCKED, &sh->dev[pd_idx].flags);
 	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 	s->locked++;
 
+	if (level == 6) {
+		int qd_idx = sh->qd_idx;
+		struct r5dev *dev = &sh->dev[qd_idx];
+
+		set_bit(R5_LOCKED, &dev->flags);
+		clear_bit(R5_UPTODATE, &dev->flags);
+		s->locked++;
+	}
+
 	pr_debug("%s: stripe %llu locked: %d ops_request: %lx\n",
 		__func__, (unsigned long long)sh->sector,
 		s->locked, s->ops_request);
@@ -2704,7 +2716,7 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
 	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
-		schedule_reconstruction5(sh, s, rcw == 0, 0);
+		schedule_reconstruction(sh, s, rcw == 0, 0);
 }
 
 static void handle_stripe_dirtying6(raid5_conf_t *conf,
@@ -3309,7 +3321,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
 		stripe_set_idx(sh->sector, conf, 0, sh);
-		schedule_reconstruction5(sh, &s, 1, 1);
+		schedule_reconstruction(sh, &s, 1, 1);
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);

