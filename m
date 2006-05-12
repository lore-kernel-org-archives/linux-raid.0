From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 8] md/bitmap: Fix online removal of file-backed bitmaps
Date: Fri, 12 May 2006 16:07:31 +1000
Message-ID: <1060512060731.7994@suse.de>
References: <20060512160121.7872.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Clements <paul.clements@steeleye.com>
List-Id: linux-raid.ids


When "mdadm --grow /dev/mdX --bitmap=none" is used to remove
a filebacked bitmap, the bitmap was disconnected from the array,
but the file wasn't closed (until the array was stopped).

The file also wasn't closed if adding the bitmap file failed.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-05-12 15:49:10.000000000 +1000
+++ ./drivers/md/md.c	2006-05-12 15:54:48.000000000 +1000
@@ -3588,10 +3588,13 @@ static int set_bitmap_file(mddev_t *mdde
 		mddev->pers->quiesce(mddev, 1);
 		if (fd >= 0)
 			err = bitmap_create(mddev);
-		if (fd < 0 || err)
+		if (fd < 0 || err) {
 			bitmap_destroy(mddev);
+			fd = -1; /* make sure to put the file */
+		}
 		mddev->pers->quiesce(mddev, 0);
-	} else if (fd < 0) {
+	}
+	if (fd < 0) {
 		if (mddev->bitmap_file)
 			fput(mddev->bitmap_file);
 		mddev->bitmap_file = NULL;
