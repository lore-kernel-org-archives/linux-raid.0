From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] super1: make the check for NodeNumUpdate more accurate
Date: Mon,  9 May 2016 10:22:58 +0800
Message-ID: <1462760578-1429-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

We missed to check the version is BITMAP_MAJOR_CLUSTERED
or not, otherwise mdadm can't create array with other 1.x
metadatas (1.0 and 1.1).

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 super1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 972b470..fa93367 100644
--- a/super1.c
+++ b/super1.c
@@ -2389,7 +2389,7 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 		break;
 	case NodeNumUpdate:
 		/* cluster md only supports superblock 1.2 now */
-		if (st->minor_version != 2) {
+		if (st->minor_version != 2 && bms->version == BITMAP_MAJOR_CLUSTERED) {
 			pr_err("Warning: cluster md only works with superblock 1.2\n");
 			return -EINVAL;
 		}
-- 
2.6.2

