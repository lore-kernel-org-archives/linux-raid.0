From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] md: kill file_path wrapper
Date: Fri, 9 May 2008 21:12:44 +0200
Message-ID: <20080509191244.GA8188@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kill the trivial and rather pointless file_path wrapper around d_path.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c	2008-03-12 09:09:23.000000000 +0100
+++ linux-2.6/drivers/md/bitmap.c	2008-05-05 09:29:27.000000000 +0200
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
@@ -721,11 +710,12 @@ static void bitmap_file_kick(struct bitm
 		if (bitmap->file) {
 			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (path)
-				ptr = file_path(bitmap->file, path, PAGE_SIZE);
+				ptr = d_path(&bitmap->file->f_path, path, PAGE_SIZE);
+
 
 			printk(KERN_ALERT
 			      "%s: kicking failed bitmap file %s from array!\n",
-			      bmname(bitmap), ptr ? ptr : "");
+			      bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
 
 			kfree(path);
 		} else
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c	2008-04-30 22:26:54.000000000 +0200
+++ linux-2.6/drivers/md/md.c	2008-05-05 09:29:27.000000000 +0200
@@ -3987,8 +3987,8 @@ static int get_bitmap_file(mddev_t * mdd
 	if (!buf)
 		goto out;
 
-	ptr = file_path(mddev->bitmap->file, buf, sizeof(file->pathname));
-	if (!ptr)
+	ptr = d_path(&mddev->bitmap->file->f_path, buf, sizeof(file->pathname));
+	if (IS_ERR(ptr))
 		goto out;
 
 	strcpy(file->pathname, ptr);
Index: linux-2.6/include/linux/raid/bitmap.h
===================================================================
--- linux-2.6.orig/include/linux/raid/bitmap.h	2008-03-06 09:21:32.000000000 +0100
+++ linux-2.6/include/linux/raid/bitmap.h	2008-05-05 09:29:27.000000000 +0200
@@ -262,7 +262,6 @@ int  bitmap_create(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
 
-char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);
 void bitmap_update_sb(struct bitmap *bitmap);
 
