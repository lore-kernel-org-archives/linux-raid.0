From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 2/2] super1: fix setting bad block log offset in write_init_super1()
Date: Thu, 10 Nov 2016 11:50:54 +0100
Message-ID: <20161110105054.29869-2-artur.paszkiewicz@intel.com>
References: <20161110105054.29869-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110105054.29869-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Commit f79bbf4f6904 ("super1: don't put the bblog at the end of the free
space.") changed the location of the bad block log to be after the
write-intent bitmap, but a fixed offset was used and it can make bbl
overlap with the bitmap, especially when using a small bitmap chunk.
This patch changes it to use the actual offset and size of the bitmap.
It also joins the cases for v1.1 and v1.2 superblock because the code
was very similar.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super1.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/super1.c b/super1.c
index 982d88c..1d03a0a 100644
--- a/super1.c
+++ b/super1.c
@@ -1693,6 +1693,7 @@ static int write_init_super1(struct supertype *st)
 	unsigned long long dsize, array_size;
 	unsigned long long sb_offset;
 	unsigned long long data_offset;
+	long bm_offset;
 
 	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_JOURNAL))
@@ -1760,15 +1761,25 @@ static int write_init_super1(struct supertype *st)
 		 * data_offset has already been set.
 		 */
 		array_size = __le64_to_cpu(sb->size);
-		/* work out how much space we left for a bitmap,
-		 * Add 8 sectors for bad block log */
-		bm_space = choose_bm_space(array_size) + 8;
+
+		/* work out how much space we left for a bitmap */
+		if (sb->feature_map & __cpu_to_le32(MD_FEATURE_BITMAP_OFFSET)) {
+			bitmap_super_t *bms = (bitmap_super_t *)
+					(((char *)sb) + MAX_SB_SIZE);
+			bm_space = calc_bitmap_size(bms, 4096) >> 9;
+			bm_offset = (long)__le32_to_cpu(sb->bitmap_offset);
+		} else {
+			bm_space = choose_bm_space(array_size);
+			bm_offset = 8;
+		}
 
 		data_offset = di->data_offset;
 		if (data_offset == INVALID_SECTORS)
 			data_offset = st->data_offset;
 		switch(st->minor_version) {
 		case 0:
+			/* Add 8 sectors for bad block log */
+			bm_space += 8;
 			if (data_offset == INVALID_SECTORS)
 				data_offset = 0;
 			sb_offset = dsize;
@@ -1785,38 +1796,26 @@ static int write_init_super1(struct supertype *st)
 			}
 			break;
 		case 1:
-			sb->super_offset = __cpu_to_le64(0);
-			if (data_offset == INVALID_SECTORS)
-				data_offset = 16;
-
-			sb->data_offset = __cpu_to_le64(data_offset);
-			sb->data_size = __cpu_to_le64(dsize - data_offset);
-			if (data_offset >= 8 + 32*2 + 8) {
-				sb->bblog_size = __cpu_to_le16(8);
-				sb->bblog_offset = __cpu_to_le32(8 + 32*2);
-			} else if (data_offset >= 16) {
-				sb->bblog_size = __cpu_to_le16(8);
-				sb->bblog_offset = __cpu_to_le32(data_offset-8);
-			}
-			break;
 		case 2:
-			sb_offset = 4*2;
+			sb_offset = st->minor_version == 2 ? 8 : 0;
 			sb->super_offset = __cpu_to_le64(sb_offset);
 			if (data_offset == INVALID_SECTORS)
-				data_offset = 24;
+				data_offset = sb_offset + 16;
 
 			sb->data_offset = __cpu_to_le64(data_offset);
 			sb->data_size = __cpu_to_le64(dsize - data_offset);
-			if (data_offset >= 16 + 32*2 + 8) {
+			if (data_offset >= sb_offset+bm_offset+bm_space+8) {
 				sb->bblog_size = __cpu_to_le16(8);
-				sb->bblog_offset = __cpu_to_le32(8 + 32*2);
-			} else if (data_offset >= 16+16) {
+				sb->bblog_offset = __cpu_to_le32(bm_offset +
+								 bm_space);
+			} else if (data_offset >= sb_offset + 16) {
 				sb->bblog_size = __cpu_to_le16(8);
-				/* '8' sectors for the bblog, and another '8'
+				/* '8' sectors for the bblog, and 'sb_offset'
 				 * because we want offset from superblock, not
 				 * start of device.
 				 */
-				sb->bblog_offset = __cpu_to_le32(data_offset-8-8);
+				sb->bblog_offset = __cpu_to_le32(data_offset -
+								 8 - sb_offset);
 			}
 			break;
 		default:
-- 
2.10.1

