From: NeilBrown <neilb@suse.com>
Subject: [PATCH 2/4] md: don't call bitmap_create() while array is quiesced.
Date: Tue, 12 Sep 2017 11:49:12 +1000
Message-ID: <150518095216.32691.363289363807213421.stgit@noble>
References: <150518076229.32691.13542756562323866921.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150518076229.32691.13542756562323866921.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bitmap_create() allocates memory with GFP_KERNEL and
so can wait for IO.
If called while the array is quiesced, it could wait indefinitely
for write out to the array - deadlock.
So call bitmap_create() before quiescing the array.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 675c9e6495e4..d6d491243411 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6591,22 +6591,26 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 		return -ENOENT; /* cannot remove what isn't there */
 	err = 0;
 	if (mddev->pers) {
-		mddev->pers->quiesce(mddev, 1);
 		if (fd >= 0) {
 			struct bitmap *bitmap;
 
 			bitmap = bitmap_create(mddev, -1);
+			mddev->pers->quiesce(mddev, 1);
 			if (!IS_ERR(bitmap)) {
 				mddev->bitmap = bitmap;
 				err = bitmap_load(mddev);
 			} else
 				err = PTR_ERR(bitmap);
-		}
-		if (fd < 0 || err) {
+			if (err) {
+				bitmap_destroy(mddev);
+				fd = -1;
+			}
+			mddev->pers->quiesce(mddev, 0);
+		} else if (fd < 0) {
+			mddev->pers->quiesce(mddev, 1);
 			bitmap_destroy(mddev);
-			fd = -1; /* make sure to put the file */
+			mddev->pers->quiesce(mddev, 0);
 		}
-		mddev->pers->quiesce(mddev, 0);
 	}
 	if (fd < 0) {
 		struct file *f = mddev->bitmap_info.file;
@@ -6890,8 +6894,8 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			mddev->pers->quiesce(mddev, 1);
 			bitmap = bitmap_create(mddev, -1);
+			mddev->pers->quiesce(mddev, 1);
 			if (!IS_ERR(bitmap)) {
 				mddev->bitmap = bitmap;
 				rv = bitmap_load(mddev);


