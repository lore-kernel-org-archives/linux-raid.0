From: Andrei Warkentin <andrey.warkentin@gmail.com>
Subject: [PATCH] MD: Bitmap version cleanup.
Date: Sun, 15 Jan 2012 03:09:46 -0500
Message-ID: <1326614986-30166-1-git-send-email-andrey.warkentin@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>
List-Id: linux-raid.ids

bitmap_new_disk_sb() would still create V3 bitmap superblock
with host-endian layout.

Perhaps I'm confused, but shouldn't bitmap_new_disk_sb() be
creating a V4 bitmap superblock instead, that is portable,
as per comment in bitmap.h? BITMAP_MINOR was also unused.

Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
---
 drivers/md/bitmap.c |    3 ---
 drivers/md/bitmap.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 045e086..e786da6 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -568,9 +568,6 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	bitmap->events_cleared = bitmap->mddev->events;
 	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 
-	bitmap->flags |= BITMAP_HOSTENDIAN;
-	sb->version = cpu_to_le32(BITMAP_MAJOR_HOSTENDIAN);
-
 	kunmap_atomic(sb);
 
 	return 0;
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index a15436d..af588ac 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -13,8 +13,6 @@
 #define BITMAP_MAJOR_HI 4
 #define	BITMAP_MAJOR_HOSTENDIAN 3
 
-#define BITMAP_MINOR 39
-
 /*
  * in-memory bitmap:
  *
-- 
1.7.8.3

