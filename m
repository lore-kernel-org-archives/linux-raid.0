From: Pierre Chevalier <pierrechevalier83@gmail.com>
Subject: [PATCH] drivers: md: md-thin: remove duplication with time_after
Date: Thu,  5 Feb 2015 21:58:47 +0000
Message-ID: <1423173527-15157-1-git-send-email-pierrechevalier83@gmail.com>
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
 drivers/md/dm-thin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 07705ee..c4d319b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -11,6 +11,7 @@
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/dm-kcopyd.h>
+#include <linux/jiffies.h>
 #include <linux/log2.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
@@ -1700,8 +1701,7 @@ static void process_cell_fail(struct thin_c *tc, struct dm_bio_prison_cell *cell
  */
 static int need_commit_due_to_time(struct pool *pool)
 {
-	return jiffies < pool->last_commit_jiffies ||
-	       jiffies > pool->last_commit_jiffies + COMMIT_PERIOD;
+	return time_after(jiffies, pool->last_commit_jiffies + COMMIT_PERIOD);
 }
 
 #define thin_pbd(node) rb_entry((node), struct dm_thin_endio_hook, rb_node)
-- 
2.2.2
