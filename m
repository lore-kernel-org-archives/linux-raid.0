From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 10/11] Reuse calc_bitmap_size to reduce code size
Date: Wed, 20 May 2015 11:20:42 +0800
Message-ID: <1432092043-24220-11-git-send-email-gqjiang@suse.com>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

We can use the new added calc_bitmap_size func to
remove some redundant lines.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 super1.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/super1.c b/super1.c
index fe12e81..b36b702 100644
--- a/super1.c
+++ b/super1.c
@@ -695,12 +695,8 @@ static int copy_metadata1(struct supertype *st, int from, int to)
 				/* have the header, can calculate
 				 * correct bitmap bytes */
 				bitmap_super_t *bms;
-				int bits;
 				bms = (void*)buf;
-				bits = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
-				bytes = (bits+7) >> 3;
-				bytes += sizeof(bitmap_super_t);
-				bytes = ROUND_UP(bytes, 512);
+				bytes = calc_bitmap_size(bms, 512);
 				if (n > bytes)
 					n =  bytes;
 			}
@@ -2276,11 +2272,7 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 			memset(buf, 0xff, 4096);
 		memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
 
-		towrite = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
-		towrite = (towrite+7) >> 3; /* bits to bytes */
-		towrite += sizeof(bitmap_super_t);
-		/* we need the bitmaps to be at 4k boundary */
-		towrite = ROUND_UP(towrite, 4096);
+		towrite = calc_bitmap_size(bms, 4096);
 		while (towrite > 0) {
 			n = towrite;
 			if (n > 4096)
-- 
1.7.12.4

