From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/r5cache: print more info of log recovery
Date: Tue, 19 Dec 2017 11:43:07 -0800
Message-ID: <20171219194307.2219234-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Log recovery is critical for raid5 journal/cache. Printing information
about each recovery by default will help the system admin monitor the
status of the array.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index f259a5f..0ee5d58 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2490,10 +2490,10 @@ static int r5l_recovery_log(struct r5l_log *log)
 	ctx->seq += 10000;
 
 	if ((ctx->data_only_stripes == 0) && (ctx->data_parity_stripes == 0))
-		pr_debug("md/raid:%s: starting from clean shutdown\n",
+		pr_info("md/raid:%s: starting from clean shutdown\n",
 			mdname(mddev));
 	else
-		pr_debug("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
+		pr_info("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
 			mdname(mddev), ctx->data_only_stripes,
 			ctx->data_parity_stripes);
 
-- 
2.9.5

