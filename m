From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 3/3] raid5: remove the meaningless check in raid5_make_request
Date: Tue, 16 Jun 2020 11:25:52 +0200
Message-ID: <20200616092552.1754-3-guoqing.jiang@cloud.ionos.com>
References: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

We can't guarntee the batched stripe to be set with STRIPE_HANDLE since
there are lots of functions could set the flag, such as sync_request,
ops_complete_* and end_{read,write}_request etc.

Also clear_batch_ready called in handle_stripe ensures the batched list
can't continue to be handled by handle_stripe.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 45398b9b0a46..bd010835332a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5738,8 +5738,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 				do_flush = false;
 			}
 
-			if (!sh->batch_head || sh == sh->batch_head)
-				set_bit(STRIPE_HANDLE, &sh->state);
+			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if ((!sh->batch_head || sh == sh->batch_head) &&
 			    (bi->bi_opf & REQ_SYNC) &&
-- 
2.17.1
