From: Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH 05/11] md: common schedule_reconstruction for raid5/6
Date: Tue, 9 Dec 2008 00:56:28 +0300
Message-ID: <200812090056.28236.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

To be able to re-use the schedule_reconstruction5() code in RAID-6
case, this should handle Q-parity strip appropriately. This patch
introduces this.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/md/raid5.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index aeec3e5..e31f38b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1885,10 +1885,11 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 }
 
 static void
-schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
+schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 			 int rcw, int expand)
 {
 	int i, pd_idx = sh->pd_idx, disks = sh->disks;
+	int level = sh->raid_conf->level;
 
 	if (rcw) {
 		/* if we are not expanding this is a proper write request, and
@@ -1914,10 +1915,12 @@ schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
 				s->locked++;
 			}
 		}
-		if (s->locked + 1 == disks)
+		if ((level == 5 && s->locked + 1 == disks) ||
+		    (level == 6 && s->locked + 2 == disks))
 			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
 				atomic_inc(&sh->raid_conf->pending_full_writes);
 	} else {
+		BUG_ON(level == 6);
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
 
@@ -1949,6 +1952,13 @@ schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
 	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 	s->locked++;
 
+	if (level == 6) {
+		int qd_idx = raid6_next_disk(pd_idx, disks);
+		set_bit(R5_LOCKED, &sh->dev[qd_idx].flags);
+		clear_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
+		s->locked++;
+	}
+
 	pr_debug("%s: stripe %llu locked: %d ops_request: %lx\n",
 		__func__, (unsigned long long)sh->sector,
 		s->locked, s->ops_request);
@@ -2410,7 +2420,7 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
 	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
-		schedule_reconstruction5(sh, s, rcw == 0, 0);
+		schedule_reconstruction(sh, s, rcw == 0, 0);
 }
 
 static void handle_stripe_dirtying6(raid5_conf_t *conf,
@@ -3003,7 +3013,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
-		schedule_reconstruction5(sh, &s, 1, 1);
+		schedule_reconstruction(sh, &s, 1, 1);
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
-- 
1.5.6.1

