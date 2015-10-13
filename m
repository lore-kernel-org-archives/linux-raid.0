From: rgoldwyn@suse.de
Subject: [PATCH 07/14] md-cluster: Do not printk() every received message
Date: Tue, 13 Oct 2015 09:25:28 -0500
Message-ID: <1444746335-22624-8-git-send-email-rgoldwyn@suse.de>
References: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444746335-22624-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The receive daemon prints kernel messages for every network message
received. This would fill the kernel message log with unnecessary messages.
Remove the pr_info() messages.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 28494e9..85d0a1f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -363,8 +363,6 @@ static void __remove_suspend_info(struct md_cluster_info *cinfo, int slot)
 
 	list_for_each_entry_safe(s, tmp, &cinfo->suspend_list, list)
 		if (slot == s->slot) {
-			pr_info("%s:%d Deleting suspend_info: %d\n",
-					__func__, __LINE__, slot);
 			list_del(&s->list);
 			kfree(s);
 			break;
@@ -462,34 +460,22 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 {
 	switch (msg->type) {
 	case METADATA_UPDATED:
-		pr_info("%s: %d Received message: METADATA_UPDATE from %d\n",
-			__func__, __LINE__, msg->slot);
 		process_metadata_update(mddev, msg);
 		break;
 	case RESYNCING:
-		pr_info("%s: %d Received message: RESYNCING from %d\n",
-			__func__, __LINE__, msg->slot);
 		process_suspend_info(mddev, msg->slot,
 				msg->low, msg->high);
 		break;
 	case NEWDISK:
-		pr_info("%s: %d Received message: NEWDISK from %d\n",
-			__func__, __LINE__, msg->slot);
 		process_add_new_disk(mddev, msg);
 		break;
 	case REMOVE:
-		pr_info("%s: %d Received REMOVE from %d\n",
-			__func__, __LINE__, msg->slot);
 		process_remove_disk(mddev, msg);
 		break;
 	case RE_ADD:
-		pr_info("%s: %d Received RE_ADD from %d\n",
-			__func__, __LINE__, msg->slot);
 		process_readd_disk(mddev, msg);
 		break;
 	case BITMAP_NEEDS_SYNC:
-		pr_info("%s: %d Received BITMAP_NEEDS_SYNC from %d\n",
-			__func__, __LINE__, msg->slot);
 		__recover_slot(mddev, msg->slot);
 		break;
 	default:
-- 
1.8.5.6

