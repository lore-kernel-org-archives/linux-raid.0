From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 19/26] md: remove unnecessary 'buf' from get_bitmap_file.
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.31653.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

'buf' is only used because d_path fills from the end of the
buffer instead of from the start.
We don't need a separate buf to handle that, we just need to use
memmove() to move the string to the start.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cbbac7b7238a..01793f24f8de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5502,7 +5502,7 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
 static int get_bitmap_file(struct mddev *mddev, void __user * arg)
 {
 	mdu_bitmap_file_t *file = NULL; /* too big for stack allocation */
-	char *ptr, *buf = NULL;
+	char *ptr;
 	int err = -ENOMEM;
 
 	file = kmalloc(sizeof(*file), GFP_NOIO);
@@ -5516,23 +5516,19 @@ static int get_bitmap_file(struct mddev *mddev, void __user * arg)
 		goto copy_out;
 	}
 
-	buf = kmalloc(sizeof(file->pathname), GFP_KERNEL);
-	if (!buf)
-		goto out;
-
 	ptr = d_path(&mddev->bitmap->storage.file->f_path,
-		     buf, sizeof(file->pathname));
+		     file->pathname, sizeof(file->pathname));
 	if (IS_ERR(ptr))
 		goto out;
 
-	strcpy(file->pathname, ptr);
+	memmove(file->pathname, ptr,
+		sizeof(file->pathname)-(ptr-file->pathname));
 
 copy_out:
 	err = 0;
 	if (copy_to_user(arg, file, sizeof(*file)))
 		err = -EFAULT;
 out:
-	kfree(buf);
 	kfree(file);
 	return err;
 }


