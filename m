From: maximilian attems <max@stro.at>
Subject: [PATCH] [mdadm] Create.c s/major/major_num/
Date: Fri, 21 Sep 2007 19:32:19 +0200
Message-ID: <11903959391748-git-send-email-max@stro.at>
References: <11903959391007-git-send-email-max@stro.at>
 <11903959393989-git-send-email-max@stro.at>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11903959393989-git-send-email-max@stro.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, maximilian attems <max@stro.at>
List-Id: linux-raid.ids

don't shadow the major() function by int major.

Signed-off-by: maximilian attems <max@stro.at>
---
 Create.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Create.c b/Create.c
index 3e6f1af..31b63b4 100644
--- a/Create.c
+++ b/Create.c
@@ -73,7 +73,7 @@ int Create(struct supertype *st, char *mddev, int mdfd,
 	unsigned long long bitmapsize;
 
 	mdu_array_info_t array;
-	int major = BITMAP_MAJOR_HI;
+	int major_num = BITMAP_MAJOR_HI;
 
 	memset(&array, 0, sizeof(array));
 
@@ -422,7 +422,7 @@ int Create(struct supertype *st, char *mddev, int mdfd,
 		return 1;
 
 	if (bitmap_file && vers < 9003) {
-		major = BITMAP_MAJOR_HOSTENDIAN;
+		major_num = BITMAP_MAJOR_HOSTENDIAN;
 #ifdef __BIG_ENDIAN
 		fprintf(stderr, Name ": Warning - bitmaps created on this kernel are not portable\n"
 			"  between different architectured.  Consider upgrading the Linux kernel.\n");
@@ -436,7 +436,7 @@ int Create(struct supertype *st, char *mddev, int mdfd,
 		}
 		if (!st->ss->add_internal_bitmap(st, super, &bitmap_chunk,
 						 delay, write_behind,
-						 bitmapsize, 1, major)) {
+						 bitmapsize, 1, major_num)) {
 			fprintf(stderr, Name ": Given bitmap chunk size not supported.\n");
 			return 1;
 		}
@@ -466,7 +466,7 @@ int Create(struct supertype *st, char *mddev, int mdfd,
 		if (CreateBitmap(bitmap_file, force, (char*)uuid, bitmap_chunk,
 				 delay, write_behind,
 				 bitmapsize,
-				 major)) {
+				 major_num)) {
 			return 1;
 		}
 		bitmap_fd = open(bitmap_file, O_RDWR);
-- 
1.5.2.4

