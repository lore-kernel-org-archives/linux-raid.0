From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 07/10] md: remove obsolete ret in md_start_sync
Date: Fri, 12 Aug 2016 13:42:40 +0800
Message-ID: <1470980563-26062-8-git-send-email-gqjiang@suse.com>
References: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The ret is not needed anymore since we have already
move resync_start into md_do_sync in commit 41a9a0d.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f95e5ed..cceaaf4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8283,16 +8283,14 @@ no_add:
 static void md_start_sync(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
-	int ret = 0;
 
 	mddev->sync_thread = md_register_thread(md_do_sync,
 						mddev,
 						"resync");
 	if (!mddev->sync_thread) {
-		if (!(mddev_is_clustered(mddev) && ret == -EAGAIN))
-			printk(KERN_ERR "%s: could not start resync"
-			       " thread...\n",
-			       mdname(mddev));
+		printk(KERN_ERR "%s: could not start resync"
+		       " thread...\n",
+		       mdname(mddev));
 		/* leave the spares where they are, it shouldn't hurt */
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-- 
2.6.2

