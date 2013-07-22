From: Robin Dong <robin.k.dong@gmail.com>
Subject: [PATCH v2] mdadm: add sync-bitmap to only resync WRITTEN data when adding new disk in raid array.
Date: Mon, 22 Jul 2013 14:09:53 +0800
Message-ID: <1374473393-18587-1-git-send-email-robin.k.dong@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

We add a new feature named "MD_FEATURE_SYNCBITMAP" and set all bit to zero for initializing of sync-bitmap.

Signed-off-by: Robin Dong <sanbai@taobao.com>
Cc: NeilBrown <neilb@suse.de>
---
changelog:
v1 --> v2:
 * Encode the presence of sync-bitmap into the version number in superblock of bitmap
   Version great or equal to "5" means it has sync-bitmap.

v1: http://www.spinics.net/lists/raid/msg43569.html

 bitmap.h |    6 ++++--
 super1.c |   20 ++++++++++++++++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/bitmap.h b/bitmap.h
index c8725a3..51894e5 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -7,11 +7,13 @@
 #define BITMAP_H 1
 
 #define BITMAP_MAJOR_LO 3
-/* version 4 insists the bitmap is in little-endian order
+/* version greater or equal to 4 insists the bitmap is in little-endian order
+ * version greater or equal to 5 insists it has sync-bitmap
  * with version 3, it is host-endian which is non-portable
  */
-#define BITMAP_MAJOR_HI 4
+#define BITMAP_MAJOR_HI 6
 #define	BITMAP_MAJOR_HOSTENDIAN 3
+#define	BITMAP_MAJOR_SYNCBITMAP 5
 
 #define BITMAP_MINOR 39
 
diff --git a/super1.c b/super1.c
index 0427205..e227665 100644
--- a/super1.c
+++ b/super1.c
@@ -2235,7 +2235,7 @@ static int write_bitmap1(struct supertype *st, int fd)
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
 	int rv = 0;
 	void *buf;
-	int towrite, n;
+	int towrite, syncbitmap_towrite, n;
 	struct align_fd afd;
 
 	init_afd(&afd, fd);
@@ -2251,7 +2251,8 @@ static int write_bitmap1(struct supertype *st, int fd)
 	towrite = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
 	towrite = (towrite+7) >> 3; /* bits to bytes */
 	towrite += sizeof(bitmap_super_t);
-	towrite = ROUND_UP(towrite, 512);
+	towrite = ROUND_UP(towrite, 4096);
+	syncbitmap_towrite = towrite;
 	while (towrite > 0) {
 		n = towrite;
 		if (n > 4096)
@@ -2263,6 +2264,21 @@ static int write_bitmap1(struct supertype *st, int fd)
 			break;
 		memset(buf, 0xff, 4096);
 	}
+
+	/* write init sync-bitmap */
+	memset(buf, 0x00, 4096);
+	while (syncbitmap_towrite > 0) {
+		n = syncbitmap_towrite;
+		if (n > 4096)
+			n = 4096;
+		n = awrite(&afd, buf, n);
+		if (n > 0)
+			syncbitmap_towrite -= n;
+		else
+			break;
+		memset(buf, 0x00, 4096);
+	}
+
 	fsync(fd);
 	if (towrite)
 		rv = -2;
-- 
1.7.1

