From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 1/3 v2] badblocks: add function to check for unacked badblocks
Date: Tue, 18 Oct 2016 16:08:45 +0200
Message-ID: <1476799725-6266-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: shli@kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com, mariusz.dabrowski@intel.com, axboe@kernel.dk, dan.j.williams@intel.com, linux-raid@vger.kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Add new function that checks if unacknowledged badblocks exist in a list
and clears ->unacked_exists flag if possible. It is required for storing
badblock information by userspace metadata handlers. Similar function
ack_all_badblocks is of no use in this case as userspace reads badblocks
data from sysfs file so it cannot be sure if the list available in sysfs
at the moment is complete (potential race with other badblocks reported
at the same time).

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 block/badblocks.c         | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/badblocks.h |  1 +
 2 files changed, 37 insertions(+)

diff --git a/block/badblocks.c b/block/badblocks.c
index 7be53cb..1f4a193 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -439,6 +439,42 @@ void ack_all_badblocks(struct badblocks *bb)
 EXPORT_SYMBOL_GPL(ack_all_badblocks);
 
 /**
+ * check_if_badblocks_acked() - Check if all badblocks in list are acknowledged
+ * @bb:		the badblocks structure that holds all badblock information
+ *
+ * It clears ->changed and ->unacked_exist if successful. It is used by
+ * userspace metadata updates
+ *
+ *  Return:
+ *   True if all badblocks are acknowledged, false otherwise
+ */
+int check_if_badblocks_acked(struct badblocks *bb)
+{
+	int acked = 1;
+
+	write_seqlock_irq(&bb->lock);
+	if (bb->unacked_exist) {
+		u64 *p = bb->page;
+		int i;
+
+		for (i = 0; i < bb->count ; i++) {
+			if (!BB_ACK(p[i])) {
+				acked = 0;
+				break;
+			}
+		}
+		if (acked) {
+			bb->unacked_exist = 0;
+			bb->changed = 0;
+		}
+	}
+	write_sequnlock_irq(&bb->lock);
+
+	return acked;
+}
+EXPORT_SYMBOL_GPL(check_if_badblocks_acked);
+
+/**
  * badblocks_show() - sysfs access to bad-blocks list
  * @bb:		the badblocks structure that holds all badblock information
  * @page:	buffer received from sysfs
diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index c3bdf8c..6569d4e 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -46,6 +46,7 @@ int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int acknowledged);
 int badblocks_clear(struct badblocks *bb, sector_t s, int sectors);
 void ack_all_badblocks(struct badblocks *bb);
+int check_if_badblocks_acked(struct badblocks *bb);
 ssize_t badblocks_show(struct badblocks *bb, char *page, int unack);
 ssize_t badblocks_store(struct badblocks *bb, const char *page, size_t len,
 			int unack);
-- 
1.8.3.1

