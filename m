From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 14/24] Initiate recovery on node failure
Date: Thu, 18 Dec 2014 10:17:44 -0600
Message-ID: <20141218161744.GA29632@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The DLM informs us in case of node failure with the DLM slot number.
cluster_info->recovery_map sets the bit corresponding to the slot number
and wakes up the recovery thread.

The recovery thread:
1. Derives the slot number from the recovery_map
2. Locks the bitmap corresponding to the slot
3. Copies the set bits to the node-local bitmap

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md-cluster.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 7d57f3f..4f1ea5f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -16,6 +16,7 @@
 #include <linux/dlm.h>
 #include <linux/sched.h>
 #include "md.h"
+#include "bitmap.h"
 #include "md-cluster.h"
 
 #define LVB_SIZE	64
@@ -52,6 +53,8 @@ struct md_cluster_info {
 	struct dlm_lock_resource *bitmap_lockres;
 	struct list_head suspend_list;
 	spinlock_t suspend_lock;
+	struct md_thread *recovery_thread;
+	unsigned long recovery_map;
 };
 
 static void sync_ast(void *arg)
@@ -187,6 +190,51 @@ out:
 	return s;
 }
 
+void recover_bitmaps(struct md_thread *thread)
+{
+	struct mddev *mddev = thread->mddev;
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	struct dlm_lock_resource *bm_lockres;
+	char str[64];
+	int slot, ret;
+	struct suspend_info *s, *tmp;
+	sector_t lo, hi;
+
+	while (cinfo->recovery_map) {
+		slot = fls64((u64)cinfo->recovery_map) - 1;
+
+		/* Clear suspend_area associated with the bitmap */
+		spin_lock_irq(&cinfo->suspend_lock);
+		list_for_each_entry_safe(s, tmp, &cinfo->suspend_list, list)
+			if (slot == s->slot) {
+				list_del(&s->list);
+				kfree(s);
+			}
+		spin_unlock_irq(&cinfo->suspend_lock);
+
+		snprintf(str, 64, "bitmap%04d", slot);
+		bm_lockres = lockres_init(mddev, str, NULL, 1);
+		if (!bm_lockres) {
+			pr_err("md-cluster: Cannot initialize bitmaps\n");
+			goto clear_bit;
+		}
+
+		ret = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
+		if (ret) {
+			pr_err("md-cluster: Could not DLM lock %s: %d\n",
+					str, ret);
+			goto clear_bit;
+		}
+		ret = bitmap_copy_from_slot(mddev, slot, &lo, &hi);
+		if (ret)
+			pr_err("md-cluster: Could not copy data "
+					"from bitmap %d\n", slot);
+		dlm_unlock_sync(bm_lockres);
+clear_bit:
+		clear_bit(slot, &cinfo->recovery_map);
+	}
+}
+
 static void recover_prep(void *arg)
 {
 }
@@ -200,6 +248,16 @@ static void recover_slot(void *arg, struct dlm_slot *slot)
 			mddev->bitmap_info.cluster_name,
 			slot->nodeid, slot->slot,
 			cinfo->slot_number);
+	set_bit(slot->slot - 1, &cinfo->recovery_map);
+	if (!cinfo->recovery_thread) {
+		cinfo->recovery_thread = md_register_thread(recover_bitmaps,
+				mddev, "recover");
+		if (!cinfo->recovery_thread) {
+			printk("md-cluster: Could not create recovery thread\n");
+			return;
+		}
+	}
+	md_wakeup_thread(cinfo->recovery_thread);
 }
 
 static void recover_done(void *arg, struct dlm_slot *slots,
@@ -342,6 +400,7 @@ static int leave(struct mddev *mddev)
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	if (!cinfo)
 		return 0;
+	md_unregister_thread(&cinfo->recovery_thread);
 	lockres_free(cinfo->sb_lock);
 	lockres_free(cinfo->bitmap_lockres);
 	dlm_release_lockspace(cinfo->lockspace, 2);
-- 
2.1.2

