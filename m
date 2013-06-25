From: Robin Dong <robin.k.dong@gmail.com>
Subject: [PATCH v1] mdadm: add sync-bitmap to only resync WRITTEN data when adding new disk in raid array.
Date: Tue, 25 Jun 2013 16:51:37 +0800
Message-ID: <1372150297-31271-2-git-send-email-robin.k.dong@gmail.com>
References: <1372150297-31271-1-git-send-email-robin.k.dong@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372150297-31271-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robin Dong <robin.k.dong@gmail.com>, Robin Dong <sanbai@taobao.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

We add a new feature named "MD_FEATURE_SYNCBITMAP" and set all bit to zero for initializing of sync-bitmap.

Signed-off-by: Robin Dong<sanbai@taobao.com>
Cc: NeilBrown <neilb@suse.de>
---
 Grow.c   |    1 -
 super1.c |   24 +++++++++++++++++++++---
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 948fc8d..44772bf 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1541,7 +1541,6 @@ int Grow_reshape(char *devname, int fd,
 	struct mdinfo info;
 	struct mdinfo *sra;
 
-
 	if (ioctl(fd, GET_ARRAY_INFO, &array) < 0) {
 		fprintf(stderr, Name ": %s is not an active md array - aborting\n",
 			devname);
diff --git a/super1.c b/super1.c
index d0f1d5f..6240aac 100644
--- a/super1.c
+++ b/super1.c
@@ -124,6 +124,7 @@ struct misc_dev_info {
 					    * backwards anyway.
 					    */
 #define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
+#define	MD_FEATURE_SYNCBITMAP		128
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
@@ -131,6 +132,7 @@ struct misc_dev_info {
 					|MD_FEATURE_REPLACEMENT		\
 					|MD_FEATURE_RESHAPE_BACKWARDS	\
 					|MD_FEATURE_NEW_OFFSET		\
+					|MD_FEATURE_SYNCBITMAP		\
 					)
 
 #ifndef offsetof
@@ -1961,7 +1963,7 @@ add_internal_bitmap1(struct supertype *st,
 	sb->bitmap_offset = (int32_t)__cpu_to_le32(offset);
 
 	sb->feature_map = __cpu_to_le32(__le32_to_cpu(sb->feature_map)
-					| MD_FEATURE_BITMAP_OFFSET);
+					| MD_FEATURE_BITMAP_OFFSET | MD_FEATURE_SYNCBITMAP);
 	memset(bms, 0, sizeof(*bms));
 	bms->magic = __cpu_to_le32(BITMAP_MAGIC);
 	bms->version = __cpu_to_le32(major);
@@ -2002,7 +2004,7 @@ static int write_bitmap1(struct supertype *st, int fd)
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
 	int rv = 0;
 	void *buf;
-	int towrite, n;
+	int towrite, syncbitmap_towrite, n;
 	struct align_fd afd;
 
 	init_afd(&afd, fd);
@@ -2018,7 +2020,8 @@ static int write_bitmap1(struct supertype *st, int fd)
 	towrite = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
 	towrite = (towrite+7) >> 3; /* bits to bytes */
 	towrite += sizeof(bitmap_super_t);
-	towrite = ROUND_UP(towrite, 512);
+	towrite = ROUND_UP(towrite, 4096);
+	syncbitmap_towrite = towrite;
 	while (towrite > 0) {
 		n = towrite;
 		if (n > 4096)
@@ -2030,6 +2033,21 @@ static int write_bitmap1(struct supertype *st, int fd)
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

