From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 2/5] md/raid5: remove the redundant setting of STRIPE_HANDLE
Date: Tue, 28 Jul 2020 12:01:40 +0200
Message-ID: <20200728100143.17813-3-guoqing.jiang@cloud.ionos.com>
References: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200728100143.17813-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

The flag is already set before compare rcw with rmw, so it is
not necessary to do it again.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/raid5.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a6ff6e1e039b..790d91aa5f40 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3995,10 +3995,8 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
-				} else {
+				} else
 					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
 			}
 		}
 	}
@@ -4023,10 +4021,8 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
 					qread++;
-				} else {
+				} else
 					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
 			}
 		}
 		if (rcw && conf->mddev->queue)
-- 
2.17.1
