From: allenpeng <allenpeng@synology.com>
Subject: [PATCH 2/2] md/raid5: Allow degraded raid6 to do rmw
Date: Fri, 31 Jul 2020 17:50:31 +0800
Message-ID: <1596189031-3082-1-git-send-email-allenpeng@synology.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, ChangSyun Peng <allenpeng@synology.com>
List-Id: linux-raid.ids

From: ChangSyun Peng <allenpeng@synology.com>

Degraded raid6 always do reconstruct-write now. With raid6 xor supported,
we can do rmw in degraded raid6. This patch can reduce many read IOs to
improve performance.

If the failed disk is P, Q or the disk we want to write to, we may need to
do reconstruct-write in max degraded raid6. In this situation we can not
read enough data from handle_stripe_dirtying() so we have to set force_rcw
in handle_stripe_fill() to read all data.

Reviewed-by: Alex Wu <alexwu@synology.com>
Reviewed-by: BingJing Chang <bingjingc@synology.com>
Reviewed-by: Danny Shih <dannyshih@synology.com>
Signed-off-by: ChangSyun Peng <allenpeng@synology.com>
---
 drivers/md/raid5.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 43eedf7..02760f3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3538,6 +3538,7 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
 	int i;
+	bool force_rcw = (sh->raid_conf->rmw_level == PARITY_DISABLE_RMW);
 
 
 	if (test_bit(R5_LOCKED, &dev->flags) ||
@@ -3596,18 +3597,27 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 			 * devices must be read.
 			 */
 			return 1;
+
+		if (s->failed >= 2 &&
+		    (fdev[i]->towrite ||
+		     s->failed_num[i] == sh->pd_idx ||
+		     s->failed_num[i] == sh->qd_idx) &&
+		    !test_bit(R5_UPTODATE, &fdev[i]->flags))
+			/* In max degraded raid6, If the failed disk is P, Q,
+			 * or we want to read the failed disk, we need to do
+			 * reconstruct-write.
+			 */
+			force_rcw = true;
 	}
 
-	/* If we are forced to do a reconstruct-write, either because
-	 * the current RAID6 implementation only supports that, or
-	 * because parity cannot be trusted and we are currently
-	 * recovering it, there is extra need to be careful.
+	/* If we are forced to do a reconstruct-write, because parity
+	 * cannot be trusted and we are currently recovering it, there
+	 * is extra need to be careful.
 	 * If one of the devices that we would need to read, because
 	 * it is not being overwritten (and maybe not written at all)
 	 * is missing/faulty, then we need to read everything we can.
 	 */
-	if (sh->raid_conf->level != 6 &&
-	    sh->raid_conf->rmw_level != PARITY_DISABLE_RMW &&
+	if (!force_rcw &&
 	    sh->sector < sh->raid_conf->mddev->recovery_cp)
 		/* reconstruct-write isn't being forced */
 		return 0;
-- 
2.7.4
