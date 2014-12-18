From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 21/24] Resync start/Finish actions
Date: Thu, 18 Dec 2014 10:18:45 -0600
Message-ID: <20141218161845.GA29663@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a RESYNC_START message arrives, the node removes the entry
with the current slot number and adds the range to the
suspend_list.

Simlarly, when a RESYNC_FINISHED message is received, node clears
entry with respect to the bitmap number.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index fff40a0..6f156a8 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -316,6 +316,50 @@ static void ack_bast(void *arg, int mode)
 		md_wakeup_thread(cinfo->recv_thread);
 }
 
+static void __remove_suspend_info(struct md_cluster_info *cinfo, int slot)
+{
+	struct suspend_info *s, *tmp;
+	list_for_each_entry_safe(s, tmp, &cinfo->suspend_list, list)
+		if (slot == s->slot) {
+			printk("%s:%d Deleting suspend_info: %d\n",
+					__func__, __LINE__, slot);
+			list_del(&s->list);
+			kfree(s);
+			break;
+		}
+}
+
+static void remove_suspend_info(struct md_cluster_info *cinfo, int slot)
+{
+	spin_lock_irq(&cinfo->suspend_lock);
+	__remove_suspend_info(cinfo, slot);
+	spin_unlock_irq(&cinfo->suspend_lock);
+}
+
+
+static void process_suspend_info(struct md_cluster_info *cinfo, 
+		int slot, sector_t lo, sector_t hi)
+{
+	struct suspend_info *s;
+	if (!hi) {
+		remove_suspend_info(cinfo, slot);
+		return;
+	}
+	s = kzalloc(sizeof(struct suspend_info), GFP_KERNEL);
+	if (!s) {
+		pr_err("md-cluster: Could not allocate suspend_area\n");
+		return;
+	}
+	s->slot = slot;
+	s->lo = lo;
+	s->hi = hi;
+	spin_lock_irq(&cinfo->suspend_lock);
+	/* Remove existing entry (if exists) before adding */
+	__remove_suspend_info(cinfo, slot);
+	list_add(&s->list, &cinfo->suspend_list);
+	spin_unlock_irq(&cinfo->suspend_lock);
+}
+
 static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 {
 	switch (msg->type) {
@@ -327,6 +371,8 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		case RESYNCING:
 			pr_info("%s: %d Received message: RESYNCING from %d\n",
 					__func__, __LINE__, msg->slot);
+			process_suspend_info(mddev->cluster_info, msg->slot,
+					msg->low, msg->high);
 			break;
 	};
 }
-- 
2.1.2

