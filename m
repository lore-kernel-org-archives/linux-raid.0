From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 20/26] md: tidy up set_bitmap_file
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.97532.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1/ delay setting mddev->bitmap_info.file until 'f' looks
   usable, so we don't have to unset it.
2/ Don't allow bitmap file to be set if bitmap_info.file
   is already set.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 01793f24f8de..1e32f2e93d1d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5851,22 +5851,24 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 
 	if (fd >= 0) {
 		struct inode *inode;
-		if (mddev->bitmap)
+		struct file *f;
+
+		if (mddev->bitmap || mddev->bitmap_info.file)
 			return -EEXIST; /* cannot add when bitmap is present */
-		mddev->bitmap_info.file = fget(fd);
+		f = fget(fd);
 
-		if (mddev->bitmap_info.file == NULL) {
+		if (f == NULL) {
 			printk(KERN_ERR "%s: error: failed to get bitmap file\n",
 			       mdname(mddev));
 			return -EBADF;
 		}
 
-		inode = mddev->bitmap_info.file->f_mapping->host;
+		inode = f->f_mapping->host;
 		if (!S_ISREG(inode->i_mode)) {
 			printk(KERN_ERR "%s: error: bitmap file must be a regular file\n",
 			       mdname(mddev));
 			err = -EBADF;
-		} else if (!(mddev->bitmap_info.file->f_mode & FMODE_WRITE)) {
+		} else if (!(f->f_mode & FMODE_WRITE)) {
 			printk(KERN_ERR "%s: error: bitmap file must open for write\n",
 			       mdname(mddev));
 			err = -EBADF;
@@ -5876,10 +5878,10 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 			err = -EBUSY;
 		}
 		if (err) {
-			fput(mddev->bitmap_info.file);
-			mddev->bitmap_info.file = NULL;
+			fput(f);
 			return err;
 		}
+		mddev->bitmap_info.file = f;
 		mddev->bitmap_info.offset = 0; /* file overrides offset */
 	} else if (mddev->bitmap == NULL)
 		return -ENOENT; /* cannot remove what isn't there */


