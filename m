From: Pierre Chevalier <pierrechevalier83@gmail.com>
Subject: [PATCH] drivers: md: remove duplication with time_after
Date: Thu,  5 Feb 2015 21:39:30 +0000
Message-ID: <1423172370-32113-1-git-send-email-pierrechevalier83@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Pierre Chevalier <pierrechevalier83@gmail.com>
List-Id: linux-raid.ids

The logic that was expressed previously was equivalent of calling
time_after.
Remove duplication.

Signed-off-by: Pierre Chevalier <pierrechevalier83@gmail.com>
---
 drivers/md/dm-cache-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index e165053..855e3b3 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
@@ -1562,8 +1563,7 @@ static void process_bio(struct cache *cache, struct prealloc *structs,
 
 static int need_commit_due_to_time(struct cache *cache)
 {
-	return jiffies < cache->last_commit_jiffies ||
-	       jiffies > cache->last_commit_jiffies + COMMIT_PERIOD;
+	return time_after(jiffies, cache->last_commit_jiffies + COMMIT_PERIOD);
 }
 
 static int commit_if_needed(struct cache *cache)
-- 
2.2.2
