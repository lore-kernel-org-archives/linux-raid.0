From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 04/12] md: common handle_stripe6() infrastructure
Date: Tue, 4 Dec 2007 14:30:38 +0300
Message-ID: <200712041430.38806.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 We utilize get_stripe_work() to find new work to run. This function is shared
with RAID-5. The only RAID-5 specific operation there is PREXOR. Then we call
raid_run_ops() to process the requests pending.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index af77291..2c6fee0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3658,13 +3658,15 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	struct stripe_head_state s;
 	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
+	unsigned long pending = 0;
 
 	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
-	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
-		"pd_idx=%d, qd_idx=%d\n",
-	       (unsigned long long)sh->sector, sh->state,
-	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
 	memset(&s, 0, sizeof(s));
+	pr_debug("handling stripe %llu, state=%#lx, cnt=%d, "
+		"pd_idx=%d, qd_idx=%d "
+		"ops=%lx:%lx:%lx\n", (unsigned long long)sh->sector, sh->state,
+		atomic_read(&sh->count), sq->pd_idx, r6s.qd_idx,
+		sh->ops.pending, sh->ops.ack, sh->ops.complete);
 
 	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
@@ -3845,8 +3847,14 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	if (s.expanding && s.locked == 0)
 		handle_stripe_expansion(conf, sh, &r6s);
 
+	if (sh->ops.count)
+		pending = get_stripe_work(sh);
+
 	spin_unlock(&sq->lock);
 
+	if (pending)
+		raid_run_ops(sh, pending);
+
 	return_io(return_bi);
 
 	for (i=disks; i-- ;) {

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
