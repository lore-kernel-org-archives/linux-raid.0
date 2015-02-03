From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 21/26] md: move GET_BITMAP_FILE ioctl out from mddev_lock.
Date: Wed, 04 Feb 2015 08:42:30 +1100
Message-ID: <20150203214230.3448.64544.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It makes more sense to report bitmap_info->file, rather than
bitmap->file (the later is only available once the array is
active).

With that change, use mddev->lock to protect bitmap_info being
set to NULL, and we can call get_bitmap_file() without taking
the mutex.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   58 ++++++++++++++++++++++++++++++-------------------------
 drivers/md/md.h |    1 +
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1e32f2e93d1d..f11aff6bd5e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5292,8 +5292,11 @@ static int do_md_stop(struct mddev *mddev, int mode,
 
 		bitmap_destroy(mddev);
 		if (mddev->bitmap_info.file) {
-			fput(mddev->bitmap_info.file);
+			struct file *f = mddev->bitmap_info.file;
+			spin_lock(&mddev->lock);
 			mddev->bitmap_info.file = NULL;
+			spin_unlock(&mddev->lock);
+			fput(f);
 		}
 		mddev->bitmap_info.offset = 0;
 
@@ -5503,32 +5506,30 @@ static int get_bitmap_file(struct mddev *mddev, void __user * arg)
 {
 	mdu_bitmap_file_t *file = NULL; /* too big for stack allocation */
 	char *ptr;
-	int err = -ENOMEM;
+	int err;
 
 	file = kmalloc(sizeof(*file), GFP_NOIO);
-
 	if (!file)
-		goto out;
+		return -ENOMEM;
 
+	err = 0;
+	spin_lock(&mddev->lock);
 	/* bitmap disabled, zero the first byte and copy out */
-	if (!mddev->bitmap || !mddev->bitmap->storage.file) {
+	if (!mddev->bitmap_info.file)
 		file->pathname[0] = '\0';
-		goto copy_out;
-	}
-
-	ptr = d_path(&mddev->bitmap->storage.file->f_path,
-		     file->pathname, sizeof(file->pathname));
-	if (IS_ERR(ptr))
-		goto out;
-
-	memmove(file->pathname, ptr,
-		sizeof(file->pathname)-(ptr-file->pathname));
+	else if ((ptr = d_path(&mddev->bitmap_info.file->f_path,
+			       file->pathname, sizeof(file->pathname))),
+		 IS_ERR(ptr))
+		err = PTR_ERR(ptr);
+	else
+		memmove(file->pathname, ptr,
+			sizeof(file->pathname)-(ptr-file->pathname));
+	spin_unlock(&mddev->lock);
 
-copy_out:
-	err = 0;
-	if (copy_to_user(arg, file, sizeof(*file)))
+	if (err == 0 &&
+	    copy_to_user(arg, file, sizeof(*file)))
 		err = -EFAULT;
-out:
+
 	kfree(file);
 	return err;
 }
@@ -5900,9 +5901,13 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 		mddev->pers->quiesce(mddev, 0);
 	}
 	if (fd < 0) {
-		if (mddev->bitmap_info.file)
-			fput(mddev->bitmap_info.file);
-		mddev->bitmap_info.file = NULL;
+		struct file *f = mddev->bitmap_info.file;
+		if (f) {
+			spin_lock(&mddev->lock);
+			mddev->bitmap_info.file = NULL;
+			spin_unlock(&mddev->lock);
+			fput(f);
+		}
 	}
 
 	return err;
@@ -6315,6 +6320,11 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	case SET_DISK_FAULTY:
 		err = set_disk_faulty(mddev, new_decode_dev(arg));
 		goto out;
+
+	case GET_BITMAP_FILE:
+		err = get_bitmap_file(mddev, argp);
+		goto out;
+
 	}
 
 	if (cmd == ADD_NEW_DISK)
@@ -6406,10 +6416,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	 * Commands even a read-only array can execute:
 	 */
 	switch (cmd) {
-	case GET_BITMAP_FILE:
-		err = get_bitmap_file(mddev, argp);
-		goto unlock;
-
 	case RESTART_ARRAY_RW:
 		err = restart_array(mddev);
 		goto unlock;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8770308a8052..b4fbd6a63fcf 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -393,6 +393,7 @@ struct mddev {
 	 *   in_sync - and related safemode and MD_CHANGE changes
 	 *   pers (also protected by reconfig_mutex and pending IO).
 	 *   clearing ->bitmap
+	 *   clearing ->bitmap_info.file
 	 */
 	spinlock_t			lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */


