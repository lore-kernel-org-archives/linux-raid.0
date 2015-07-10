From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 02/12] md-cluster: split recover_slot for future code reuse
Date: Fri, 10 Jul 2015 16:54:03 +0800
Message-ID: <1436518453-12660-3-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Make recover_slot as a wraper to __recover_slot, since the
logic of __recover_slot could be reuse for the condition
when other nodes need to take over the resync job.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 85ef5c5..24caabe 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -269,16 +269,11 @@ static void recover_prep(void *arg)
 	set_bit(MD_CLUSTER_SUSPEND_READ_BALANCING, &cinfo->state);
 }
 
-static void recover_slot(void *arg, struct dlm_slot *slot)
+static void __recover_slot(struct mddev *mddev, int slot)
 {
-	struct mddev *mddev = arg;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
-	pr_info("md-cluster: %s Node %d/%d down. My slot: %d. Initiating recovery.\n",
-			mddev->bitmap_info.cluster_name,
-			slot->nodeid, slot->slot,
-			cinfo->slot_number);
-	set_bit(slot->slot - 1, &cinfo->recovery_map);
+	set_bit(slot, &cinfo->recovery_map);
 	if (!cinfo->recovery_thread) {
 		cinfo->recovery_thread = md_register_thread(recover_bitmaps,
 				mddev, "recover");
@@ -290,6 +285,20 @@ static void recover_slot(void *arg, struct dlm_slot *slot)
 	md_wakeup_thread(cinfo->recovery_thread);
 }
 
+static void recover_slot(void *arg, struct dlm_slot *slot)
+{
+	struct mddev *mddev = arg;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+
+	pr_info("md-cluster: %s Node %d/%d down. My slot: %d. Initiating recovery.\n",
+			mddev->bitmap_info.cluster_name,
+			slot->nodeid, slot->slot,
+			cinfo->slot_number);
+	/* deduct one since dlm slot starts from one while the num of
+	 * cluster-md begins with 0 */
+	__recover_slot(mddev, slot->slot - 1);
+}
+
 static void recover_done(void *arg, struct dlm_slot *slots,
 		int num_slots, int our_slot,
 		uint32_t generation)
-- 
1.7.12.4

