From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 3/4] md/bitmap: add blktrace event for writes to the
 bitmap.
Date: Mon, 14 Nov 2016 16:30:21 +1100
Message-ID: <147910142125.27168.1639109067364223445.stgit@noble>
References: <147910131504.27168.6566119701315109161.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147910131504.27168.6566119701315109161.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We trace wheneven bitmap_unplug() finds that it needs to write
to the bitmap, or when bitmap_daemon_work() find there is work
to do.

This makes it easier to correlate bitmap updates with data writes.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/bitmap.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1a7f402b79ba..cf77cbf9ed22 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/buffer_head.h>
 #include <linux/seq_file.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "bitmap.h"
 
@@ -1008,8 +1009,12 @@ void bitmap_unplug(struct bitmap *bitmap)
 		need_write = test_and_clear_page_attr(bitmap, i,
 						      BITMAP_PAGE_NEEDWRITE);
 		if (dirty || need_write) {
-			if (!writing)
+			if (!writing) {
 				bitmap_wait_writes(bitmap);
+				if (bitmap->mddev->queue)
+					blk_add_trace_msg(bitmap->mddev->queue,
+							  "md bitmap_unplug");
+			}
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
 			write_page(bitmap, bitmap->storage.filemap[i], 0);
 			writing = 1;
@@ -1234,6 +1239,10 @@ void bitmap_daemon_work(struct mddev *mddev)
 	}
 	bitmap->allclean = 1;
 
+	if (bitmap->mddev->queue)
+		blk_add_trace_msg(bitmap->mddev->queue,
+				  "md bitmap_daemon_work");
+
 	/* Any file-page which is PENDING now needs to be written.
 	 * So set NEEDWRITE now, then after we make any last-minute changes
 	 * we will write it.


