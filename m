From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 2/3] raid5: put the comment of clear_batch_ready to the right place
Date: Tue, 16 Jun 2020 11:25:51 +0200
Message-ID: <20200616092552.1754-2-guoqing.jiang@cloud.ionos.com>
References: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

To make people understand the function well, let's put the comment to
the right place.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/raid5.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a35332364f07..45398b9b0a46 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4573,12 +4573,12 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 	rcu_read_unlock();
 }
 
+/*
+ * Return '1' if this is a member of batch, or '0' if it is a lone stripe or
+ * a head which can now be handled.
+ */
 static int clear_batch_ready(struct stripe_head *sh)
 {
-	/* Return '1' if this is a member of batch, or
-	 * '0' if it is a lone stripe or a head which can now be
-	 * handled.
-	 */
 	struct stripe_head *tmp;
 	if (!test_and_clear_bit(STRIPE_BATCH_READY, &sh->state))
 		return (sh->batch_head && sh->batch_head != sh);
-- 
2.17.1
