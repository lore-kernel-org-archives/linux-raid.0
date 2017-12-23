From: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Subject: [PATCH] md/raid5: simplify uninitialization of shrinker
Date: Sat, 23 Dec 2017 21:20:31 +0300
Message-ID: <20171223182031.7513-1-akaraliou.dev@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: Aliaksei Karaliou <akaraliou.dev@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Don't use shrinker.nr_deferred to check whether shrinker was
initialized or not. Now this check was integrated into
unregister_shrinker(), so it is safe to call it against
unregistered shrinker.

Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>
---
 drivers/md/raid5.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5a2a29bd02dd..8f985831b832 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6764,9 +6764,7 @@ static void free_conf(struct r5conf *conf)
 
 	log_exit(conf);
 
-	if (conf->shrinker.nr_deferred)
-		unregister_shrinker(&conf->shrinker);
-
+	unregister_shrinker(&conf->shrinker);
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
-- 
2.11.0

