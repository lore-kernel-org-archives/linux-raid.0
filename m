From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 1/2] super1: make internal bitmap size calculations more consistent
Date: Thu, 10 Nov 2016 11:50:53 +0100
Message-ID: <20161110105054.29869-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Determining internal bitmap size is performed using two different
functions (bitmap_sectors() and calc_bitmap_size()) and in
getinfo_super1() it is calculated in yet another way. Each of these
methods give slightly different results. The most accurate is
calc_bitmap_size() but it also has a rounding issue. So:

- fix the rounding issue in calc_bitmap_size() using bitmap_bits()
- replace usages of bitmap_sectors() and open-coded calculations with
  calc_bitmap_size()
- remove bitmap_sectors()
- move bitmap_bits() to mdadm.h as inline - otherwise mdassemble won't
  compile (it does not use bitmap.c)

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 bitmap.c | 15 ---------------
 mdadm.h  |  9 ++++++++-
 super1.c | 25 +++++++++----------------
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index 6c1b8d8..ccedfd3 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -108,21 +108,6 @@ static int count_dirty_bits(char *buf, int num_bits)
 	return num;
 }
 
-/* calculate the size of the bitmap given the array size and bitmap chunksize */
-static unsigned long long
-bitmap_bits(unsigned long long array_size, unsigned long chunksize)
-{
-	return (array_size * 512 + chunksize - 1) / chunksize;
-}
-
-unsigned long bitmap_sectors(struct bitmap_super_s *bsb)
-{
-	unsigned long long bits = bitmap_bits(__le64_to_cpu(bsb->sync_size),
-					      __le32_to_cpu(bsb->chunksize));
-	int bits_per_sector = 8*512;
-	return (bits + bits_per_sector - 1) / bits_per_sector;
-}
-
 static bitmap_info_t *bitmap_fd_read(int fd, int brief)
 {
 	/* Note: fd might be open O_DIRECT, so we must be
diff --git a/mdadm.h b/mdadm.h
index 0516c82..41a4494 100755
--- a/mdadm.h
+++ b/mdadm.h
@@ -1331,7 +1331,14 @@ extern int CreateBitmap(char *filename, int force, char uuid[16],
 extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
 extern int Write_rules(char *rule_name);
 extern int bitmap_update_uuid(int fd, int *uuid, int swap);
-extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
+
+/* calculate the size of the bitmap given the array size and bitmap chunksize */
+static inline unsigned long long
+bitmap_bits(unsigned long long array_size, unsigned long chunksize)
+{
+	return (array_size * 512 + chunksize - 1) / chunksize;
+}
+
 extern int Dump_metadata(char *dev, char *dir, struct context *c,
 			 struct supertype *st);
 extern int Restore_metadata(char *dev, char *dir, struct context *c,
diff --git a/super1.c b/super1.c
index 4fef378..982d88c 100644
--- a/super1.c
+++ b/super1.c
@@ -162,7 +162,8 @@ static unsigned int calc_bitmap_size(bitmap_super_t *bms, unsigned int boundary)
 {
 	unsigned long long bits, bytes;
 
-	bits = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
+	bits = bitmap_bits(__le64_to_cpu(bms->sync_size),
+			   __le32_to_cpu(bms->chunksize));
 	bytes = (bits+7) >> 3;
 	bytes += sizeof(bitmap_super_t);
 	bytes = ROUND_UP(bytes, boundary);
@@ -973,11 +974,7 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 		earliest = super_offset + (32+4)*2; /* match kernel */
 		if (info->bitmap_offset > 0) {
 			unsigned long long bmend = info->bitmap_offset;
-			unsigned long long size = __le64_to_cpu(bsb->sync_size);
-			size /= __le32_to_cpu(bsb->chunksize) >> 9;
-			size = (size + 7) >> 3;
-			size += sizeof(bitmap_super_t);
-			size = ROUND_UP(size, 4096);
+			unsigned long long size = calc_bitmap_size(bsb, 4096);
 			size /= 512;
 			bmend += size;
 			if (bmend > earliest)
@@ -1219,11 +1216,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	} else if (strcmp(update, "uuid") == 0) {
 		copy_uuid(sb->set_uuid, info->uuid, super1.swapuuid);
 
-		if (__le32_to_cpu(sb->feature_map)&MD_FEATURE_BITMAP_OFFSET) {
-			struct bitmap_super_s *bm;
-			bm = (struct bitmap_super_s*)(st->sb+MAX_SB_SIZE);
-			memcpy(bm->uuid, sb->set_uuid, 16);
-		}
+		if (__le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET)
+			memcpy(bms->uuid, sb->set_uuid, 16);
 	} else if (strcmp(update, "no-bitmap") == 0) {
 		sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
 	} else if (strcmp(update, "bbl") == 0) {
@@ -1232,15 +1226,14 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		 */
 		unsigned long long sb_offset = __le64_to_cpu(sb->super_offset);
 		unsigned long long data_offset = __le64_to_cpu(sb->data_offset);
-		long bitmap_offset = (long)(int32_t)__le32_to_cpu(sb->bitmap_offset);
+		long bitmap_offset = 0;
 		long bm_sectors = 0;
 		long space;
 
 #ifndef MDASSEMBLE
 		if (sb->feature_map & __cpu_to_le32(MD_FEATURE_BITMAP_OFFSET)) {
-			struct bitmap_super_s *bsb;
-			bsb = (struct bitmap_super_s *)(((char*)sb)+MAX_SB_SIZE);
-			bm_sectors = bitmap_sectors(bsb);
+			bitmap_offset = (long)__le32_to_cpu(sb->bitmap_offset);
+			bm_sectors = calc_bitmap_size(bms, 4096) >> 9;
 		}
 #endif
 		if (sb_offset < data_offset) {
@@ -2120,7 +2113,7 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
 		/* hot-add. allow for actual size of bitmap */
 		struct bitmap_super_s *bsb;
 		bsb = (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
-		bmspace = bitmap_sectors(bsb);
+		bmspace = calc_bitmap_size(bsb, 4096) >> 9;
 	}
 #endif
 	/* Allow space for bad block log */
-- 
2.10.1

