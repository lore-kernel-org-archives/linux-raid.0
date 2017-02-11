From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] md/raid5-cache: stripe reclaim only counts valid stripes
Date: Fri, 10 Feb 2017 16:18:08 -0800
Message-ID: <a8a29c2eceb8a7d68080b95c7df04f0663b358bd.1486772085.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

When log space is tight, we try to reclaim stripes from log head. There
are stripes which can't be reclaimed right now if some conditions are
met. We skip such stripes but accidentally count them, which might cause
no stripes are claimed. Fixing this by only counting valid stripes.

Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index caae853..a01f4da 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1418,9 +1418,9 @@ static void r5c_do_reclaim(struct r5conf *conf)
 			    !test_bit(STRIPE_HANDLE, &sh->state) &&
 			    atomic_read(&sh->count) == 0) {
 				r5c_flush_stripe(conf, sh);
+				if (count++ >= R5C_RECLAIM_STRIPE_GROUP)
+					break;
 			}
-			if (count++ >= R5C_RECLAIM_STRIPE_GROUP)
-				break;
 		}
 		spin_unlock(&conf->device_lock);
 		spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
-- 
2.9.3

