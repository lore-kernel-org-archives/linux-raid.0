From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 007 of 7] Make sure md bitmap updates are flushed when array is stopped.
Date: Tue, 02 Aug 2005 19:53:42 +1000
Message-ID: <E1DztSw-0004Vi-57@notabene.cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The recent change to never ignore the bitmap, revealed that the bitmap
isn't begin flushed properly when an array is stopped.

We call bitmap_daemon_work three times as there is a three-stage pipeline
for flushing updates to the bitmap file.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c         |   23 +++++++++++++++++++++++
 ./drivers/md/md.c             |    2 ++
 ./include/linux/raid/bitmap.h |    1 +
 3 files changed, 26 insertions(+)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-02 19:34:08.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-02 19:34:58.000000000 +1000
@@ -1450,6 +1450,29 @@ static void bitmap_set_memory_bits(struc
 }
 
 /*
+ * flush out any pending updates
+ */
+void bitmap_flush(mddev_t *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+	int sleep;
+
+	if (!bitmap) /* there was no bitmap */
+		return;
+
+	/* run the daemon_work three time to ensure everything is flushed 
+	 * that can be
+	 */
+	sleep = bitmap->daemon_sleep;
+	bitmap->daemon_sleep = 0;
+	bitmap_daemon_work(bitmap);
+	bitmap_daemon_work(bitmap);
+	bitmap_daemon_work(bitmap);
+	bitmap->daemon_sleep = sleep;
+	bitmap_update_sb(bitmap);
+}
+
+/*
  * free memory that was allocated
  */
 void bitmap_destroy(mddev_t *mddev)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-02 15:22:22.000000000 +1000
+++ ./drivers/md/md.c	2005-08-02 19:34:28.000000000 +1000
@@ -1798,6 +1798,8 @@ static int do_md_stop(mddev_t * mddev, i
 				goto out;
 			mddev->ro = 1;
 		} else {
+			bitmap_flush(mddev);
+			wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
 			if (mddev->ro)
 				set_disk_ro(disk, 0);
 			blk_queue_make_request(mddev->queue, md_fail_request);

diff ./include/linux/raid/bitmap.h~current~ ./include/linux/raid/bitmap.h
--- ./include/linux/raid/bitmap.h~current~	2005-08-02 19:34:28.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2005-08-02 19:34:28.000000000 +1000
@@ -248,6 +248,7 @@ struct bitmap {
 
 /* these are used only by md/bitmap */
 int  bitmap_create(mddev_t *mddev);
+void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
 int  bitmap_active(struct bitmap *bitmap);
 
