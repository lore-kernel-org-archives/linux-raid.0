From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/8] md/raid5: factor out mark_uptodate from
	ops_complete_compute5
Date: Wed, 03 Jun 2009 18:29:03 -0700
Message-ID: <20090604012903.11507.39866.stgit@dwillia2-linux.ch.intel.com>
References: <20090604012709.11507.15528.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090604012709.11507.15528.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, yur@emcraft.com
List-Id: linux-raid.ids

ops_complete_compute5 can be reused in the raid6 path if it is updated to
generically handle a second target.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 48aa114..45eeefd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -651,18 +651,29 @@ static void ops_run_biofill(struct stripe_head *sh)
 	async_trigger_callback(&submit);
 }
 
+static void mark_target_uptodate(struct stripe_head *sh, int target)
+{
+	struct r5dev *tgt;
+
+	if (target < 0)
+		return;
+
+	tgt = &sh->dev[target];
+	set_bit(R5_UPTODATE, &tgt->flags);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+	clear_bit(R5_Wantcompute, &tgt->flags);
+}
+
 static void ops_complete_compute5(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int target = sh->ops.target;
-	struct r5dev *tgt = &sh->dev[target];
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	set_bit(R5_UPTODATE, &tgt->flags);
-	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
-	clear_bit(R5_Wantcompute, &tgt->flags);
+	/* mark the computed target as uptodate */
+	mark_target_uptodate(sh, sh->ops.target);
+
 	clear_bit(STRIPE_COMPUTE_RUN, &sh->state);
 	if (sh->check_state == check_state_compute_run)
 		sh->check_state = check_state_compute_result;

