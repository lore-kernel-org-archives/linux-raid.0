From: JackieLiu <liuyun01@kylinos.cn>
Subject: [PATCH] md/raid5-cache: do not need to set STRIPE_PREREAD_ACTIVE repeatedly
Date: Tue, 29 Nov 2016 11:57:30 +0800
Message-ID: <20161129035730.12822-1-liuyun01@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, JackieLiu <liuyun01@kylinos.cn>
List-Id: linux-raid.ids

R5c_make_stripe_write_out has set this flag, do not need to set again.

Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
---
 drivers/md/raid5-cache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 95bd51e..aa89de0 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1247,8 +1247,6 @@ static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
 	atomic_inc(&conf->active_stripes);
 	r5c_make_stripe_write_out(sh);
 
-	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-		atomic_inc(&conf->preread_active_stripes);
 	raid5_release_stripe(sh);
 }
 
-- 
2.10.2



