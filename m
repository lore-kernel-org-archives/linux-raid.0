From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 8] md/bitmap: Tidy up i_writecount handling in md/bitmap
Date: Fri, 12 May 2006 16:08:04 +1000
Message-ID: <1060512060804.8079@suse.de>
References: <20060512160121.7872.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Clements <paul.clements@steeleye.com>
List-Id: linux-raid.ids


md/bitmap modifies i_writecount of a bitmap file to make sure
that no-one else writes to it.  
The reverting of the change is sometimes done twice, and there
is one error path where it is omitted.

This patch tidies that up.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    8 +-------
 ./drivers/md/md.c     |   49 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 31 insertions(+), 26 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2006-05-12 15:59:53.000000000 +1000
+++ ./drivers/md/bitmap.c	2006-05-12 16:00:03.000000000 +1000
@@ -625,7 +625,6 @@ static void drain_write_queues(struct bi
 static void bitmap_file_put(struct bitmap *bitmap)
 {
 	struct file *file;
-	struct inode *inode;
 	unsigned long flags;
 
 	spin_lock_irqsave(&bitmap->lock, flags);
@@ -637,13 +636,8 @@ static void bitmap_file_put(struct bitma
 
 	bitmap_file_unmap(bitmap);
 
-	if (file) {
-		inode = file->f_mapping->host;
-		spin_lock(&inode->i_lock);
-		atomic_set(&inode->i_writecount, 1); /* allow writes again */
-		spin_unlock(&inode->i_lock);
+	if (file)
 		fput(file);
-	}
 }
 
 

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-05-12 15:54:48.000000000 +1000
+++ ./drivers/md/md.c	2006-05-12 16:00:03.000000000 +1000
@@ -2864,6 +2864,32 @@ out:
 	return err;
 }
 
+/* similar to deny_write_access, but accounts for our holding a reference
+ * to the file ourselves */
+static int deny_bitmap_write_access(struct file * file)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	spin_lock(&inode->i_lock);
+	if (atomic_read(&inode->i_writecount) > 1) {
+		spin_unlock(&inode->i_lock);
+		return -ETXTBSY;
+	}
+	atomic_set(&inode->i_writecount, -1);
+	spin_unlock(&inode->i_lock);
+
+	return 0;
+}
+
+static void restore_bitmap_write_access(struct file *file)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	spin_lock(&inode->i_lock);
+	atomic_set(&inode->i_writecount, 1);
+	spin_unlock(&inode->i_lock);
+}
+
 static int do_md_stop(mddev_t * mddev, int ro)
 {
 	int err = 0;
@@ -2927,7 +2953,7 @@ static int do_md_stop(mddev_t * mddev, i
 
 		bitmap_destroy(mddev);
 		if (mddev->bitmap_file) {
-			atomic_set(&mddev->bitmap_file->f_dentry->d_inode->i_writecount, 1);
+			restore_bitmap_write_access(mddev->bitmap_file);
 			fput(mddev->bitmap_file);
 			mddev->bitmap_file = NULL;
 		}
@@ -3531,23 +3557,6 @@ abort_export:
 	return err;
 }
 
-/* similar to deny_write_access, but accounts for our holding a reference
- * to the file ourselves */
-static int deny_bitmap_write_access(struct file * file)
-{
-	struct inode *inode = file->f_mapping->host;
-
-	spin_lock(&inode->i_lock);
-	if (atomic_read(&inode->i_writecount) > 1) {
-		spin_unlock(&inode->i_lock);
-		return -ETXTBSY;
-	}
-	atomic_set(&inode->i_writecount, -1);
-	spin_unlock(&inode->i_lock);
-
-	return 0;
-}
-
 static int set_bitmap_file(mddev_t *mddev, int fd)
 {
 	int err;
@@ -3595,8 +3604,10 @@ static int set_bitmap_file(mddev_t *mdde
 		mddev->pers->quiesce(mddev, 0);
 	}
 	if (fd < 0) {
-		if (mddev->bitmap_file)
+		if (mddev->bitmap_file) {
+			restore_bitmap_write_access(mddev->bitmap_file);
 			fput(mddev->bitmap_file);
+		}
 		mddev->bitmap_file = NULL;
 	}
 
