From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 10] md: kill file_path wrapper
Date: Mon, 19 May 2008 11:10:24 +1000
Message-ID: <1080519011024.7651@suse.de>
References: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids


From: Christoph Hellwig <hch@lst.de>

Kill the trivial and rather pointless file_path wrapper around d_path.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c         |   17 ++++-------------
 ./drivers/md/md.c             |    4 ++--
 ./include/linux/raid/bitmap.h |    1 -
 3 files changed, 6 insertions(+), 16 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2008-05-19 11:02:05.000000000 +1000
+++ ./drivers/md/bitmap.c	2008-05-19 11:02:35.000000000 +1000
@@ -203,17 +203,6 @@ static void bitmap_checkfree(struct bitm
  * bitmap file handling - read and write the bitmap file and its superblock
  */
 
-/* copy the pathname of a file to a buffer */
-char *file_path(struct file *file, char *buf, int count)
-{
-	if (!buf)
-		return NULL;
-
-	buf = d_path(&file->f_path, buf, count);
-
-	return IS_ERR(buf) ? NULL : buf;
-}
-
 /*
  * basic page I/O operations
  */
@@ -721,11 +710,13 @@ static void bitmap_file_kick(struct bitm
 		if (bitmap->file) {
 			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (path)
-				ptr = file_path(bitmap->file, path, PAGE_SIZE);
+				ptr = d_path(&bitmap->file->f_path, path,
+					     PAGE_SIZE);
+
 
 			printk(KERN_ALERT
 			      "%s: kicking failed bitmap file %s from array!\n",
-			      bmname(bitmap), ptr ? ptr : "");
+			      bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
 
 			kfree(path);
 		} else

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-19 11:02:08.000000000 +1000
+++ ./drivers/md/md.c	2008-05-19 11:02:35.000000000 +1000
@@ -3987,8 +3987,8 @@ static int get_bitmap_file(mddev_t * mdd
 	if (!buf)
 		goto out;
 
-	ptr = file_path(mddev->bitmap->file, buf, sizeof(file->pathname));
-	if (!ptr)
+	ptr = d_path(&mddev->bitmap->file->f_path, buf, sizeof(file->pathname));
+	if (IS_ERR(ptr))
 		goto out;
 
 	strcpy(file->pathname, ptr);

diff .prev/include/linux/raid/bitmap.h ./include/linux/raid/bitmap.h
--- .prev/include/linux/raid/bitmap.h	2008-05-19 11:02:05.000000000 +1000
+++ ./include/linux/raid/bitmap.h	2008-05-19 11:02:35.000000000 +1000
@@ -262,7 +262,6 @@ int  bitmap_create(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
 
-char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);
 void bitmap_update_sb(struct bitmap *bitmap);
 
