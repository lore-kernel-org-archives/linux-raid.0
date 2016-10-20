From: Shaohua Li <shli@fb.com>
Subject: [PATCH] badblocks: badblocks_set/clear update unacked_exist
Date: Thu, 20 Oct 2016 14:40:06 -0700
Message-ID: <39f303dcb7bdf2958b6f82a0646467dfbc8d1abd.1476999400.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Cc: tomasz.majchrzak@intel.com
List-Id: linux-raid.ids

When bandblocks_set acknowledges a range or badblocks_clear a range,
it's possible all badblocks are acknowledged. We should update
unacked_exist if this occurs.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 block/badblocks.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/block/badblocks.c b/block/badblocks.c
index 7be53cb..139115d2 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -133,6 +133,26 @@ int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 }
 EXPORT_SYMBOL_GPL(badblocks_check);
 
+static void badblocks_update_acked(struct badblocks *bb)
+{
+	u64 *p = bb->page;
+	int i;
+	bool unacked = false;
+
+	if (!bb->unacked_exist)
+		return;
+
+	for (i = 0; i < bb->count ; i++) {
+		if (!BB_ACK(p[i])) {
+			unacked = true;
+			break;
+		}
+	}
+
+	if (!unacked)
+		bb->unacked_exist = 0;
+}
+
 /**
  * badblocks_set() - Add a range of bad blocks to the table.
  * @bb:		the badblocks structure that holds all badblock information
@@ -294,6 +314,8 @@ int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	bb->changed = 1;
 	if (!acknowledged)
 		bb->unacked_exist = 1;
+	else
+		badblocks_update_acked(bb);
 	write_sequnlock_irqrestore(&bb->lock, flags);
 
 	return rv;
@@ -399,6 +421,7 @@ int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 		}
 	}
 
+	badblocks_update_acked(bb);
 	bb->changed = 1;
 out:
 	write_sequnlock_irq(&bb->lock);
-- 
2.9.3

