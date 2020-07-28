From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 5/5] raid5: don't duplicate code for different paths in handle_stripe
Date: Tue, 28 Jul 2020 12:01:43 +0200
Message-ID: <20200728100143.17813-6-guoqing.jiang@cloud.ionos.com>
References: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

As we can see, R5_LOCKED is set and s.locked is increased whether
R5_ReWrite is set or not, so move it to common path.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/raid5.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 790d91aa5f40..b06edfaa73b0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4966,14 +4966,11 @@ static void handle_stripe(struct stripe_head *sh)
 				if (!test_bit(R5_ReWrite, &dev->flags)) {
 					set_bit(R5_Wantwrite, &dev->flags);
 					set_bit(R5_ReWrite, &dev->flags);
-					set_bit(R5_LOCKED, &dev->flags);
-					s.locked++;
-				} else {
+				} else
 					/* let's read it back */
 					set_bit(R5_Wantread, &dev->flags);
-					set_bit(R5_LOCKED, &dev->flags);
-					s.locked++;
-				}
+				set_bit(R5_LOCKED, &dev->flags);
+				s.locked++;
 			}
 		}
 
-- 
2.17.1
