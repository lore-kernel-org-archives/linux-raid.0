From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 005 of 8] Do not set mddev->bitmap until bitmap is fully initialised
Date: Mon, 22 Aug 2005 11:59:13 +1000
Message-ID: <E1E71aj-0001IF-KF@notabene.cse.unsw.edu.au>
References: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When hot-adding a bitmap, bitmap_daemon_work could get called
while the bitmap is being created, so don't set mddev->bitmap
until the bitmap is ready.
This requires freeing the bitmap inside bitmap_create if 
creation failed part-way through.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-22 11:49:43.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-22 11:49:45.000000000 +1000
@@ -1503,17 +1503,14 @@ void bitmap_flush(mddev_t *mddev)
 /*
  * free memory that was allocated
  */
-void bitmap_destroy(mddev_t *mddev)
+static void bitmap_free(struct bitmap *bitmap)
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
-	struct bitmap *bitmap = mddev->bitmap;
 
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	mddev->bitmap = NULL; /* disconnect from the md device */
-
 	/* release the bitmap file and kill the daemon */
 	bitmap_file_put(bitmap);
 
@@ -1531,6 +1528,17 @@ void bitmap_destroy(mddev_t *mddev)
 	kfree(bp);
 	kfree(bitmap);
 }
+void bitmap_destroy(mddev_t *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap) /* there was no bitmap */
+		return;
+
+	mddev->bitmap = NULL; /* disconnect from the md device */
+
+	bitmap_free(bitmap);
+}
 
 /*
  * initialize the bitmap structure
@@ -1561,15 +1569,15 @@ int bitmap_create(mddev_t *mddev)
 
 	spin_lock_init(&bitmap->lock);
 	bitmap->mddev = mddev;
-	mddev->bitmap = bitmap;
 
 	spin_lock_init(&bitmap->write_lock);
 	INIT_LIST_HEAD(&bitmap->complete_pages);
 	init_waitqueue_head(&bitmap->write_wait);
 	bitmap->write_pool = mempool_create(WRITE_POOL_SIZE, write_pool_alloc,
 				write_pool_free, NULL);
+	err = -ENOMEM;
 	if (!bitmap->write_pool)
-		return -ENOMEM;
+		goto error;
 
 	bitmap->file = file;
 	bitmap->offset = mddev->bitmap_offset;
@@ -1577,7 +1585,7 @@ int bitmap_create(mddev_t *mddev)
 	/* read superblock from bitmap file (this sets bitmap->chunksize) */
 	err = bitmap_read_sb(bitmap);
 	if (err)
-		return err;
+		goto error;
 
 	bitmap->chunkshift = find_first_bit(&bitmap->chunksize,
 					sizeof(bitmap->chunksize));
@@ -1601,8 +1609,9 @@ int bitmap_create(mddev_t *mddev)
 #else
 	bitmap->bp = kmalloc(pages * sizeof(*bitmap->bp), GFP_KERNEL);
 #endif
+	err = -ENOMEM;
 	if (!bitmap->bp)
-		return -ENOMEM;
+		goto error;
 	memset(bitmap->bp, 0, pages * sizeof(*bitmap->bp));
 
 	bitmap->flags |= BITMAP_ACTIVE;
@@ -1617,16 +1626,22 @@ int bitmap_create(mddev_t *mddev)
 	err = bitmap_init_from_disk(bitmap, start);
 
 	if (err)
-		return err;
+		goto error;
 
 	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
 		pages, bmname(bitmap));
 
+	mddev->bitmap = bitmap;
+
 	/* kick off the bitmap daemons */
 	err = bitmap_start_daemons(bitmap);
 	if (err)
 		return err;
 	return bitmap_update_sb(bitmap);
+
+ error:
+	bitmap_free(bitmap);
+	return err;
 }
 
 /* the bitmap API -- for raid personalities */
