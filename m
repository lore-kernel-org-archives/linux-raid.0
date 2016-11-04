From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 4/4] md/bitmap: Don't write bitmap while earlier writes
 might be in-flight
Date: Fri, 04 Nov 2016 16:46:03 +1100
Message-ID: <147823836359.6764.7855525110697020696.stgit@noble>
References: <147823807607.6764.8460942745584467311.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147823807607.6764.8460942745584467311.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As we don't wait for writes to complete in bitmap_daemon_work, they
could still be in-flight when bitmap_unplug writes again.  Or when
bitmap_daemon_work tries to write again.
This can be confusing and could risk the wrong data being written last.

So make sure we wait for old writes to complete before new writes start.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/bitmap.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 3ceb0c51891e..e224186d767f 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -416,6 +416,21 @@ static int read_page(struct file *file, unsigned long index,
  * bitmap file superblock operations
  */
 
+/*
+ * bitmap_wait_writes() should be called before writing any bitmap
+ * blocks, to ensure previous writes, particularly from
+ * bitmap_daemon_work(), have completed.
+ */
+static void bitmap_wait_writes(struct bitmap *bitmap)
+{
+	if (bitmap->storage.file)
+		wait_event(bitmap->write_wait,
+			   atomic_read(&bitmap->pending_writes)==0);
+	else
+		md_super_wait(bitmap->mddev);
+}
+
+
 /* update the event counter and sync the superblock to disk */
 void bitmap_update_sb(struct bitmap *bitmap)
 {
@@ -978,6 +993,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i;
 	int dirty, need_write;
+	int writing = 0;
 
 	if (!bitmap || !bitmap->storage.filemap ||
 	    test_bit(BITMAP_STALE, &bitmap->flags))
@@ -992,15 +1008,15 @@ void bitmap_unplug(struct bitmap *bitmap)
 		need_write = test_and_clear_page_attr(bitmap, i,
 						      BITMAP_PAGE_NEEDWRITE);
 		if (dirty || need_write) {
+			if (!writing)
+				bitmap_wait_writes(bitmap);
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
 			write_page(bitmap, bitmap->storage.filemap[i], 0);
+			writing = 1;
 		}
 	}
-	if (bitmap->storage.file)
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
-	else
-		md_super_wait(bitmap->mddev);
+	if (writing)
+		bitmap_wait_writes(bitmap);
 
 	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
 		bitmap_file_kick(bitmap);
@@ -1282,6 +1298,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 	}
 	spin_unlock_irq(&counts->lock);
 
+	bitmap_wait_writes(bitmap);
 	/* Now start writeout on any page in NEEDWRITE that isn't DIRTY.
 	 * DIRTY pages need to be written by bitmap_unplug so it can wait
 	 * for them.


