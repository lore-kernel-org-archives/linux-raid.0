From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 007 of 8] Allow md to load a superblock with feature-bit '1' set
Date: Mon, 22 Aug 2005 11:59:13 +1000
Message-ID: <E1E71aj-0001IS-Td@notabene.cse.unsw.edu.au>
References: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


As this is used to flag an internal bitmap.

Also, introduce symbolic names for feature bits.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |    6 +++---
 ./include/linux/raid/md_p.h |    5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-22 11:49:47.000000000 +1000
+++ ./drivers/md/md.c	2005-08-22 11:49:49.000000000 +1000
@@ -875,7 +875,7 @@ static int super_1_load(mdk_rdev_t *rdev
 	    sb->major_version != cpu_to_le32(1) ||
 	    le32_to_cpu(sb->max_dev) > (4096-256)/2 ||
 	    le64_to_cpu(sb->super_offset) != (rdev->sb_offset<<1) ||
-	    sb->feature_map != 0)
+	    (le32_to_cpu(sb->feature_map) & ~MD_FEATURE_ALL) != 0)
 		return -EINVAL;
 
 	if (calc_sb_1_csum(sb) != sb->sb_csum) {
@@ -954,7 +954,7 @@ static int super_1_validate(mddev_t *mdd
 
 		mddev->max_disks =  (4096-256)/2;
 
-		if ((le32_to_cpu(sb->feature_map) & 1) &&
+		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
 		    mddev->bitmap_file == NULL ) {
 			if (mddev->level != 1) {
 				printk(KERN_WARNING "md: bitmaps only supported for raid1\n");
@@ -1029,7 +1029,7 @@ static void super_1_sync(mddev_t *mddev,
 
 	if (mddev->bitmap && mddev->bitmap_file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_offset);
-		sb->feature_map = cpu_to_le32(1);
+		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
 	}
 
 	max_dev = 0;

diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
--- ./include/linux/raid/md_p.h~current~	2005-08-22 11:48:18.000000000 +1000
+++ ./include/linux/raid/md_p.h	2005-08-22 11:49:49.000000000 +1000
@@ -238,5 +238,10 @@ struct mdp_superblock_1 {
 	__u16	dev_roles[0];	/* role in array, or 0xffff for a spare, or 0xfffe for faulty */
 };
 
+/* feature_map bits */
+#define MD_FEATURE_BITMAP_OFFSET	1
+
+#define	MD_FEATURE_ALL			1
+
 #endif 
 
