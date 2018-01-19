From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] raid10: change the size of resync window for clustered raid
Date: Fri, 19 Jan 2018 11:37:56 +0800
Message-ID: <20180119033756.15340-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

To align with raid1's resync window, we need to
set the resync window of raid10 to 32M as well.

Fixes: 8db87912c9a8 ("md-cluster: Use a small window for raid10 resync")
Reported-by: Zhilong Liu <zlliu@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 99c9207899a7..8d7ddc947d9d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -141,7 +141,7 @@ static void r10bio_pool_free(void *r10_bio, void *data)
 #define RESYNC_WINDOW (1024*1024)
 /* maximum number of concurrent requests, memory permitting */
 #define RESYNC_DEPTH (32*1024*1024/RESYNC_BLOCK_SIZE)
-#define CLUSTER_RESYNC_WINDOW (16 * RESYNC_WINDOW)
+#define CLUSTER_RESYNC_WINDOW (32 * RESYNC_WINDOW)
 #define CLUSTER_RESYNC_WINDOW_SECTORS (CLUSTER_RESYNC_WINDOW >> 9)
 
 /*
-- 
2.13.6

