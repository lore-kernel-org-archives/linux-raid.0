From: James Clarke <jrtc27@jrtc27.com>
Subject: [PATCH] Fix bus error when accessing MBR partition records
Date: Thu, 29 Sep 2016 13:28:38 +0100
Message-ID: <20160929122838.66975-1-jrtc27@jrtc27.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: James Clarke <jrtc27@jrtc27.com>
List-Id: linux-raid.ids

Since the MBR layout only has partition records as 2-byte aligned, the 32-bit
fields in them are not aligned. Thus, they cannot be accessed on some
architectures (such as SPARC) by using a "struct MBR_part_record *" pointer,
as the compiler can assume that the pointer is properly aligned. Instead, the
records must be accessed by going through the MBR struct itself every time.

Signed-off-by: James Clarke <jrtc27@jrtc27.com>
---
 super-mbr.c |  6 ++++++
 util.c      | 14 +++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/super-mbr.c b/super-mbr.c
index 62b3f03..303dde4 100644
--- a/super-mbr.c
+++ b/super-mbr.c
@@ -57,6 +57,9 @@ static void examine_mbr(struct supertype *st, char *homehost)
 
 	printf("   MBR Magic : %04x\n", sb->magic);
 	for (i = 0; i < MBR_PARTITIONS; i++)
+		/* Have to make every access through sb rather than using a pointer to
+		 * the partition table (or an entry), since the entries are not
+		 * properly aligned. */
 		if (sb->parts[i].blocks_num)
 			printf("Partition[%d] : %12lu sectors at %12lu (type %02x)\n",
 			       i,
@@ -151,6 +154,9 @@ static void getinfo_mbr(struct supertype *st, struct mdinfo *info, char *map)
 	info->component_size = 0;
 
 	for (i = 0; i < MBR_PARTITIONS ; i++)
+		/* Have to make every access through sb rather than using a pointer to
+		 * the partition table (or an entry), since the entries are not
+		 * properly aligned. */
 		if (sb->parts[i].blocks_num) {
 			unsigned long last =
 				(unsigned long)__le32_to_cpu(sb->parts[i].blocks_num)
diff --git a/util.c b/util.c
index a238a21..08adbd5 100644
--- a/util.c
+++ b/util.c
@@ -1412,7 +1412,6 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
 static int get_last_partition_end(int fd, unsigned long long *endofpart)
 {
 	struct MBR boot_sect;
-	struct MBR_part_record *part;
 	unsigned long long curr_part_end;
 	unsigned part_nr;
 	int retval = 0;
@@ -1429,21 +1428,22 @@ static int get_last_partition_end(int fd, unsigned long long *endofpart)
 	if (boot_sect.magic == MBR_SIGNATURE_MAGIC) {
 		retval = 1;
 		/* found the correct signature */
-		part = boot_sect.parts;
 
 		for (part_nr = 0; part_nr < MBR_PARTITIONS; part_nr++) {
+			/* Have to make every access through boot_sect rather than using a
+			 * pointer to the partition table (or an entry), since the entries
+			 * are not properly aligned. */
+
 			/* check for GPT type */
-			if (part->part_type == MBR_GPT_PARTITION_TYPE) {
+			if (boot_sect.parts[part_nr].part_type == MBR_GPT_PARTITION_TYPE) {
 				retval = get_gpt_last_partition_end(fd, endofpart);
 				break;
 			}
 			/* check the last used lba for the current partition  */
-			curr_part_end = __le32_to_cpu(part->first_sect_lba) +
-				__le32_to_cpu(part->blocks_num);
+			curr_part_end = __le32_to_cpu(boot_sect.parts[part_nr].first_sect_lba) +
+				__le32_to_cpu(boot_sect.parts[part_nr].blocks_num);
 			if (curr_part_end > *endofpart)
 				*endofpart = curr_part_end;
-
-			part++;
 		}
 	} else {
 		/* Unknown partition table */
-- 
2.10.0

