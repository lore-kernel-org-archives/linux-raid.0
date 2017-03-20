From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/bitmap:fixed typos in comments of bitmap.h
Date: Mon, 20 Mar 2017 18:46:39 +0800
Message-ID: <1490006799-25459-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

bitmap.h: fixed trivial typos in comments

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 bitmap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/bitmap.h b/bitmap.h
index b8fb071..7b1f80f 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -46,7 +46,7 @@
  *
  * The counter counts pending write requests, plus the on-disk bit.
  * When the counter is '1' and the resync bits are clear, the on-disk
- * bit can be cleared aswell, thus setting the counter to 0.
+ * bit can be cleared as well, thus setting the counter to 0.
  * When we set a bit, or in the counter (to start a write), if the fields is
  * 0, we first set the disk bit and set the counter to 1.
  *
@@ -185,7 +185,7 @@ struct bitmap_page {
 	 */
 	char *map;
 	/*
-	 * in emergencies (when map cannot be alloced), hijack the map
+	 * in emergencies (when map cannot be allocated), hijack the map
 	 * pointer and use it as two counters itself
 	 */
 	unsigned int hijacked;
-- 
2.6.6

