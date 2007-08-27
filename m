From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] bitmap.h: remove dead artefacts
Date: Mon, 27 Aug 2007 23:28:48 +0200
Message-ID: <20070827212848.GA26410@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

bitmap_active() no longer exists and BITMAP_ACTIVE is no longer used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/raid/bitmap.h |    2 --
 1 file changed, 2 deletions(-)

f2c10857c60e13e63c67c656713b50b18f2bc1e4 
diff --git a/include/linux/raid/bitmap.h b/include/linux/raid/bitmap.h
index 75e17a0..306a1d1 100644
--- a/include/linux/raid/bitmap.h
+++ b/include/linux/raid/bitmap.h
@@ -138,7 +138,6 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
 	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 0x004, /* A write error has occurred */
 	BITMAP_HOSTENDIAN = 0x8000,
@@ -258,7 +257,6 @@ struct bitmap {
 int  bitmap_create(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
-int  bitmap_active(struct bitmap *bitmap);
 
 char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);

