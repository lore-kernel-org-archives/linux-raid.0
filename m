From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] super1: add more checks for NodeNumUpdate option
Date: Wed, 11 May 2016 17:31:36 +0800
Message-ID: <1462959096-11272-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

There are some cases which didn't need to check the space
is enough or not for NodeNumUpdate option.

1. for array which does not have clustered bitmap.
2. "--nodes" parameter is 0 (eg, add a disk to clustered raid).
3. if "--nodes" parameter is set to a smaller num than
   current bms->nodes.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 super1.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index fa93367..3d25fae 100644
--- a/super1.c
+++ b/super1.c
@@ -2394,9 +2394,25 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 			return -EINVAL;
 		}
 
-		if (bms->version == BITMAP_MAJOR_CLUSTERED && st->nodes <= 1) {
-			pr_err("Warning: cluster-md at least needs two nodes\n");
-			return -EINVAL;
+		if (bms->version == BITMAP_MAJOR_CLUSTERED) {
+			if (st->nodes == 1) {
+				/* the parameter for nodes is not valid */
+				pr_err("Warning: cluster-md at least needs two nodes\n");
+				return -EINVAL;
+			} else if (st->nodes == 0)
+				/* --nodes is not specified */
+				break;
+			else if (__cpu_to_le32(st->nodes) < bms->nodes) {
+				/* Since the nodes num is not increased, no need to check the space
+				 * is enough or not, just update bms->nodes */
+				bms->nodes = __cpu_to_le32(st->nodes);
+				break;
+			}
+		} else {
+			/* no need to change bms->nodes for other bitmap types */
+			if (st->nodes)
+				pr_err("Warning: --nodes option is only suitable for clustered bitmap\n");
+			break;
 		}
 
 		/* Each node has an independent bitmap, it is necessary to calculate the
-- 
2.6.2

